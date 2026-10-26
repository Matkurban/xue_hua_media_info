import AVFoundation
import CoreGraphics
import CoreMedia
import Foundation
import ImageIO

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#endif

/// iOS / macOS implementation: ImageIO for still images, AVFoundation for AV.
/// iOS / macOS 实现：图片走 ImageIO，音视频走 AVFoundation。
public class XueHuaMediaInfoDarwinPlugin: NSObject, FlutterPlugin, MediaInfoHostApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
      let messenger = registrar.messenger()
    #else
      let messenger = registrar.messenger
    #endif
    let plugin = XueHuaMediaInfoDarwinPlugin(registrar: registrar)
    MediaInfoHostApiSetup.setUp(binaryMessenger: messenger, api: plugin)
  }

  private let registrar: FlutterPluginRegistrar

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
  }

  func read(source: MediaSourceMessage) async throws -> MediaMetadataMessage {
    try await readOffMain {
      let prefix = try self.loadPrefix(source, count: headerBytes)
      switch try sniffKind(prefix, uri: source.uri) {
      case .image:
        let data = try self.loadData(source)
        let image = try self.readImage(from: data)
        return MediaMetadataMessage(kind: .image, image: image, video: nil, audio: nil)
      case .video, .audio:
        let data = source.kind == .bytes ? try self.loadData(source) : Data()
        return try self.readAv(source: source, data: data)
      }
    }
  }

  func readImage(source: MediaSourceMessage) async throws -> ImageMetadataMessage {
    try await readOffMain {
      let prefix = try self.loadPrefix(source, count: headerBytes)
      let kind = try sniffKind(prefix, uri: source.uri)
      guard kind == .image else {
        throw fail("wrongKind", "Source is not an image.")
      }
      return try self.readImage(from: try self.loadData(source))
    }
  }

  func readAv(source: MediaSourceMessage) async throws -> MediaMetadataMessage {
    try await readOffMain {
      let prefix = try self.loadPrefix(source, count: headerBytes)
      let kind = try sniffKind(prefix, uri: source.uri)
      guard kind != .image else {
        throw fail("wrongKind", "Source is an image, not an AV container.")
      }
      let data = source.kind == .bytes ? try self.loadData(source) : Data()
      return try self.readAv(source: source, data: data)
    }
  }

  func probe(source: MediaSourceMessage) async throws -> MediaKindMessage {
    try await readOffMain {
      let data = try self.loadPrefix(source, count: headerBytes)
      return try sniffKind(data, uri: source.uri)
    }
  }

  func readMotionPhoto(source: MediaSourceMessage) async throws -> VideoMetadataMessage {
    try await readOffMain {
      let data = try self.loadData(source)
      guard let offset = motionPhotoOffset(data), offset < data.count else {
        throw fail("trackNotFound", "No embedded Motion Photo video.")
      }
      let embedded = data.subdata(in: offset..<data.count)
      let result = try self.readAv(
        source: MediaSourceMessage(kind: .bytes, uri: nil, bytes: FlutterStandardTypedData(bytes: embedded)),
        data: embedded)
      guard let video = result.video else {
        throw fail("trackNotFound", "Embedded trailer is not a video.")
      }
      return video
    }
  }

  /// Runs synchronous media reads off the main actor. Pigeon awaits these methods on `@MainActor`.
  /// 把同步媒体读取放到主线程之外。Pigeon 在 `@MainActor` 上等待这些方法。
  private func readOffMain<T>(_ body: @escaping () throws -> T) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
      DispatchQueue.global(qos: .userInitiated).async {
        continuation.resume(with: Result(catching: body))
      }
    }
  }

  // MARK: - ImageIO

  private func readImage(from data: Data) throws -> ImageMetadataMessage {
    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
      throw fail("unsupportedFormat", "ImageIO could not open the image.")
    }
    let props =
      CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] ?? [:]
    let tiff = props[kCGImagePropertyTIFFDictionary] as? [CFString: Any] ?? [:]
    let exif = props[kCGImagePropertyExifDictionary] as? [CFString: Any] ?? [:]
    let gpsDict = props[kCGImagePropertyGPSDictionary] as? [CFString: Any] ?? [:]

    let width = (props[kCGImagePropertyPixelWidth] as? NSNumber)?.int64Value
    let height = (props[kCGImagePropertyPixelHeight] as? NSNumber)?.int64Value
    let size: PixelSizeMessage? =
      if let width, let height, width > 0, height > 0 {
        PixelSizeMessage(width: width, height: height)
      } else {
        nil
      }

    let orientation = (props[kCGImagePropertyOrientation] as? NSNumber)?.int64Value
    return ImageMetadataMessage(
      make: tiff[kCGImagePropertyTIFFMake] as? String,
      model: tiff[kCGImagePropertyTIFFModel] as? String,
      software: tiff[kCGImagePropertyTIFFSoftware] as? String,
      size: size,
      orientation: orientation,
      dateTimeOriginal: exif[kCGImagePropertyExifDateTimeOriginal] as? String,
      dateTimeDigitized: exif[kCGImagePropertyExifDateTimeDigitized] as? String,
      dateTimeModified: tiff[kCGImagePropertyTIFFDateTime] as? String,
      gps: parseGps(gpsDict),
      hasMotionPhoto: motionPhotoOffset(data) != nil,
      pngText: parsePngText(data),
      extraTags: []
    )
  }

  private func parseGps(_ gps: [CFString: Any]) -> GpsLocationMessage? {
    guard var lat = (gps[kCGImagePropertyGPSLatitude] as? NSNumber)?.doubleValue,
      var lng = (gps[kCGImagePropertyGPSLongitude] as? NSNumber)?.doubleValue
    else {
      return nil
    }
    if (gps[kCGImagePropertyGPSLatitudeRef] as? String) == "S" {
      lat = -lat
    }
    if (gps[kCGImagePropertyGPSLongitudeRef] as? String) == "W" {
      lng = -lng
    }
    var altitude = (gps[kCGImagePropertyGPSAltitude] as? NSNumber)?.doubleValue
    if let current = altitude,
      (gps[kCGImagePropertyGPSAltitudeRef] as? NSNumber)?.intValue == 1
    {
      altitude = -current
    }
    return GpsLocationMessage(latitude: lat, longitude: lng, altitudeMeters: altitude)
  }

  // MARK: - AVFoundation

  private func readAv(source: MediaSourceMessage, data: Data) throws -> MediaMetadataMessage {
    let url = try fileURL(for: source, data: data)
    defer {
      if source.kind == .bytes {
        try? FileManager.default.removeItem(at: url)
      }
    }
    let asset = AVURLAsset(url: url)
    // Synchronous property access is often empty until keys are loaded (WAV/m4a).
    // 同步读属性在加载 key 前经常为空（WAV/m4a）。
    try loadAssetKeys(asset, keys: ["duration", "tracks", "commonMetadata"])

    let durationSeconds = CMTimeGetSeconds(asset.duration)
    var durationMs: Int64? =
      durationSeconds.isFinite && durationSeconds > 0
      ? Int64((durationSeconds * 1000).rounded()) : nil
    // WAVE fallback when AVFoundation still withholds duration.
    // AVFoundation 仍拿不到时长时，回退解析 WAVE 头。
    if durationMs == nil, let wav = parseWavFormat(data.count >= 12 ? data : (try? Data(contentsOf: url)) ?? Data()) {
      durationMs = wav.durationMs
    }

    let make = firstMetadataString(asset, identifier: .quickTimeMetadataMake)
    let model = firstMetadataString(asset, identifier: .quickTimeMetadataModel)
    let gps = parseIso6709(
      firstMetadataString(asset, identifier: .quickTimeMetadataLocationISO6709))

    if let video = asset.tracks(withMediaType: .video).first {
      let transformed = video.naturalSize.applying(video.preferredTransform)
      let width = Int64(abs(transformed.width).rounded())
      let height = Int64(abs(transformed.height).rounded())
      let rotation = rotationDegrees(from: video.preferredTransform)
      let bitrate = Int64(video.estimatedDataRate.rounded())
      let message = VideoMetadataMessage(
        durationMs: durationMs,
        size: width > 0 && height > 0 ? PixelSizeMessage(width: width, height: height) : nil,
        bitrate: bitrate > 0 ? bitrate : nil,
        rotationDegrees: rotation,
        make: make,
        model: model,
        gps: gps,
        extraTags: []
      )
      return MediaMetadataMessage(kind: .video, image: nil, video: message, audio: nil)
    }

    guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
      throw fail("trackNotFound", "No video or audio track.")
    }
    var sampleRate: Int64?
    var channelCount: Int64?
    if let desc = audioTrack.formatDescriptions.first {
      let cm = desc as! CMFormatDescription
      if let asbd = CMAudioFormatDescriptionGetStreamBasicDescription(cm)?.pointee {
        if asbd.mSampleRate > 0 {
          sampleRate = Int64(asbd.mSampleRate.rounded())
        }
        if asbd.mChannelsPerFrame > 0 {
          channelCount = Int64(asbd.mChannelsPerFrame)
        }
      }
    }
    if sampleRate == nil || channelCount == nil,
      let wav = parseWavFormat(data.count >= 12 ? data : (try? Data(contentsOf: url)) ?? Data())
    {
      if sampleRate == nil { sampleRate = wav.sampleRate }
      if channelCount == nil { channelCount = wav.channelCount }
      if durationMs == nil { durationMs = wav.durationMs }
    }
    if sampleRate == nil {
      let rate = audioTrack.naturalTimeScale
      if rate > 0 { sampleRate = Int64(rate) }
    }
    let bitrate = Int64(audioTrack.estimatedDataRate.rounded())
    let message = AudioMetadataMessage(
      durationMs: durationMs,
      bitrate: bitrate > 0 ? bitrate : nil,
      sampleRate: sampleRate,
      channelCount: channelCount,
      make: make,
      model: model,
      gps: gps,
      extraTags: []
    )
    return MediaMetadataMessage(kind: .audio, image: nil, video: nil, audio: message)
  }

  private func loadAssetKeys(_ asset: AVAsset, keys: [String]) throws {
    let group = DispatchGroup()
    group.enter()
    asset.loadValuesAsynchronously(forKeys: keys) { group.leave() }
    _ = group.wait(timeout: .now() + 10)
    for key in keys {
      var error: NSError?
      let status = asset.statusOfValue(forKey: key, error: &error)
      if status == .failed {
        throw fail("unsupportedFormat", error?.localizedDescription ?? "AVAsset failed to load \(key).")
      }
    }
  }

  private func firstMetadataString(_ asset: AVAsset, identifier: AVMetadataIdentifier) -> String? {
    AVMetadataItem.metadataItems(from: asset.metadata, filteredByIdentifier: identifier).first?
      .stringValue
  }

  private func rotationDegrees(from transform: CGAffineTransform) -> Int64 {
    let angle = atan2(transform.b, transform.a) * 180 / .pi
    let normalized = ((Int(angle.rounded()) % 360) + 360) % 360
    switch normalized {
    case 45..<135: return 90
    case 135..<225: return 180
    case 225..<315: return 270
    default: return 0
    }
  }

  // MARK: - Sources

  private func loadData(_ source: MediaSourceMessage) throws -> Data {
    switch source.kind {
    case .file:
      guard let uri = source.uri else { throw fail("notFound", "Missing path.") }
      do {
        return try Data(contentsOf: URL(fileURLWithPath: uri))
      } catch {
        throw mapIOError(error, path: uri)
      }
    case .bytes:
      guard let bytes = source.bytes else { throw fail("notFound", "Missing byte payload.") }
      return bytes.data
    case .asset:
      return try Data(contentsOf: resolveAsset(source))
    }
  }

  private func loadPrefix(_ source: MediaSourceMessage, count: Int) throws -> Data {
    switch source.kind {
    case .file:
      guard let uri = source.uri else { throw fail("notFound", "Missing path.") }
      do {
        return try readPrefix(from: URL(fileURLWithPath: uri), count: count)
      } catch let error as PigeonError {
        throw error
      } catch {
        throw mapIOError(error, path: uri)
      }
    case .bytes:
      guard let bytes = source.bytes else { throw fail("notFound", "Missing byte payload.") }
      let data = bytes.data
      return data.count <= count ? data : Data(data.prefix(count))
    case .asset:
      return try readPrefix(from: resolveAsset(source), count: count)
    }
  }

  private func readPrefix(from url: URL, count: Int) throws -> Data {
    let handle = try FileHandle(forReadingFrom: url)
    defer { try? handle.close() }
    return handle.readData(ofLength: count)
  }

  private func resolveAsset(_ source: MediaSourceMessage) throws -> URL {
    guard let key = source.uri else { throw fail("notFound", "Missing asset key.") }
    // lookupKey is relative to the app bundle root (inside App.framework on macOS).
    // Do not use Bundle.main.path(forResource:), which only searches Contents/Resources.
    let lookup = registrar.lookupKey(forAsset: key)
    let path = (Bundle.main.bundlePath as NSString).appendingPathComponent(lookup)
    guard FileManager.default.fileExists(atPath: path) else {
      throw fail("notFound", "Asset not found: \(key)")
    }
    return URL(fileURLWithPath: path)
  }

  private func fileURL(for source: MediaSourceMessage, data: Data) throws -> URL {
    switch source.kind {
    case .file:
      guard let uri = source.uri else { throw fail("notFound", "Missing path.") }
      return URL(fileURLWithPath: uri)
    case .asset:
      return try resolveAsset(source)
    case .bytes:
      let url = FileManager.default.temporaryDirectory.appendingPathComponent(
        UUID().uuidString + tempSuffix(for: data))
      try data.write(to: url)
      return url
    }
  }
}

private let headerBytes = 256

private func fail(_ code: String, _ message: String) -> PigeonError {
  PigeonError(code: code, message: message, details: nil)
}

private func sniffKind(_ data: Data, uri: String?) throws -> MediaKindMessage {
  let name = uri?.lowercased() ?? ""
  if name.hasSuffix(".raf") || name.hasSuffix(".cr3") || name.hasSuffix(".iiq") {
    throw fail("unsupportedFormat", "RAW formats are not supported.")
  }
  let bytes = [UInt8](data.prefix(headerBytes))
  if bytes.count >= 15 {
    let sig = String(bytes[0..<15].map { Character(UnicodeScalar($0)) })
    if sig == "FUJIFILMCCD-RAW" {
      throw fail("unsupportedFormat", "Fujifilm RAF is not supported.")
    }
  }
  if bytes.count >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 {
    return .image
  }
  if bytes.count >= 8 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47
  {
    return .image
  }
  if bytes.count >= 4 && ((bytes[0] == 0x49 && bytes[1] == 0x49) || (bytes[0] == 0x4D && bytes[1] == 0x4D))
  {
    let ascii = String(bytes.map { Character(UnicodeScalar($0)) })
    if ascii.contains("IIQ") || ascii.contains("Phase One") {
      throw fail("unsupportedFormat", "Phase One IIQ is not supported.")
    }
    return .image
  }
  if bytes.count >= 12 {
    let type = String(bytes[4..<8].map { Character(UnicodeScalar($0)) })
    if type == "ftyp" {
      let brand = String(bytes[8..<12].map { Character(UnicodeScalar($0)) })
      if brand.hasPrefix("crx") {
        throw fail("unsupportedFormat", "Canon CR3 is not supported.")
      }
      let imageBrands: Set<String> = ["heic", "heif", "mif1", "msf1", "avif", "avis"]
      return imageBrands.contains(brand) ? .image : .video
    }
  }
  if bytes.count >= 4 && bytes[0] == 0x1A && bytes[1] == 0x45 && bytes[2] == 0xDF && bytes[3] == 0xA3
  {
    return .video
  }
  // Magic-byte audio (BytesSource has no extension) — parity with Linux/Windows/Web.
  // 按魔数识别音频（BytesSource 无扩展名）— 与 Linux/Windows/Web 对齐。
  if bytes.count >= 12 {
    let riff = String(bytes[0..<4].map { Character(UnicodeScalar($0)) })
    let wave = String(bytes[8..<12].map { Character(UnicodeScalar($0)) })
    if riff == "RIFF" && wave == "WAVE" {
      return .audio
    }
  }
  if bytes.count >= 3
    && ((bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33)
      || (bytes[0] == 0xFF && (bytes[1] & 0xE0) == 0xE0))
  {
    return .audio
  }
  if name.hasSuffix(".m4a") || name.hasSuffix(".aac") || name.hasSuffix(".mp3")
    || name.hasSuffix(".wav") || name.hasSuffix(".flac") || name.hasSuffix(".ogg")
  {
    return .audio
  }
  throw fail("unsupportedFormat", "Unrecognized media header.")
}

private func parsePngText(_ data: Data) -> [PngTextChunkMessage] {
  let bytes = [UInt8](data)
  guard bytes.count >= 8, bytes[0] == 0x89, bytes[1] == 0x50 else { return [] }
  var chunks: [PngTextChunkMessage] = []
  var offset = 8
  while offset + 12 <= bytes.count {
    let length = Int(
      UInt32(bytes[offset]) << 24 | UInt32(bytes[offset + 1]) << 16
        | UInt32(bytes[offset + 2]) << 8 | UInt32(bytes[offset + 3]))
    if length < 0 || offset + 12 + length > bytes.count { break }
    let type = String(bytes[(offset + 4)..<(offset + 8)].map { Character(UnicodeScalar($0)) })
    if type == "tEXt" {
      let payload = bytes[(offset + 8)..<(offset + 8 + length)]
      if let split = payload.firstIndex(of: 0), split > payload.startIndex {
        let key = String(payload[payload.startIndex..<split].map { Character(UnicodeScalar($0)) })
        let value = String(payload[payload.index(after: split)...].map { Character(UnicodeScalar($0)) })
        chunks.append(PngTextChunkMessage(key: key, value: value))
      }
    }
    if type == "IEND" { break }
    offset += 12 + length
  }
  return chunks
}

private func motionPhotoOffset(_ data: Data) -> Int? {
  guard let xmp = extractXmp(data) else { return nil }
  let patterns = [
    #"GCamera:MicroVideoOffset\s*=\s*"(\d+)""#,
    #"MicroVideoOffset>\s*(\d+)"#,
    #"GCamera:MotionPhotoOffset\s*=\s*"(\d+)""#,
    #"MotionPhotoOffset\s*=\s*"(\d+)""#,
    #"MotionPhotoOffset>\s*(\d+)"#,
  ]
  for pattern in patterns {
    if let match = xmp.range(of: pattern, options: .regularExpression) {
      if let start = offsetFromEnd(dataCount: data.count, matched: String(xmp[match])) {
        return start
      }
    }
  }
  let isMotion = xmp.contains("MotionPhoto") || xmp.contains("MicroVideo")
  if isMotion,
    let match = xmp.range(of: #"Item:Length(?:="|>)\s*(\d+)"#, options: .regularExpression)
  {
    // Use the last Item:Length — typically the embedded MP4.
    var last = match
    var search = match.upperBound..<xmp.endIndex
    while let next = xmp.range(
      of: #"Item:Length(?:="|>)\s*(\d+)"#, options: .regularExpression, range: search)
    {
      last = next
      search = next.upperBound..<xmp.endIndex
    }
    if let start = offsetFromEnd(dataCount: data.count, matched: String(xmp[last])) {
      return start
    }
  }
  return nil
}

private func offsetFromEnd(dataCount: Int, matched: String) -> Int? {
  guard let digits = matched.split(whereSeparator: { !$0.isNumber }).last,
    let fromEnd = Int(digits)
  else {
    return nil
  }
  let start = dataCount - fromEnd
  if start > 0 && start < dataCount { return start }
  return nil
}

private func mapIOError(_ error: Error, path: String) -> PigeonError {
  let ns = error as NSError
  if ns.domain == NSCocoaErrorDomain
    && (ns.code == NSFileNoSuchFileError || ns.code == NSFileReadNoSuchFileError)
  {
    return fail("notFound", "File not found: \(path)")
  }
  if ns.domain == NSPOSIXErrorDomain && ns.code == Int(ENOENT) {
    return fail("notFound", "File not found: \(path)")
  }
  if !FileManager.default.fileExists(atPath: path) {
    return fail("notFound", "File not found: \(path)")
  }
  return fail("io", ns.localizedDescription)
}

private func tempSuffix(for data: Data) -> String {
  let bytes = [UInt8](data.prefix(16))
  if bytes.count >= 12 {
    let riff = String(bytes[0..<4].map { Character(UnicodeScalar($0)) })
    let wave = String(bytes[8..<12].map { Character(UnicodeScalar($0)) })
    if riff == "RIFF" && wave == "WAVE" { return ".wav" }
  }
  if bytes.count >= 12 {
    let type = String(bytes[4..<8].map { Character(UnicodeScalar($0)) })
    if type == "ftyp" { return ".mp4" }
  }
  if bytes.count >= 3 && bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33 {
    return ".mp3"
  }
  if bytes.count >= 4 && bytes[0] == 0x1A && bytes[1] == 0x45 && bytes[2] == 0xDF && bytes[3] == 0xA3 {
    return ".mkv"
  }
  if bytes.count >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 { return ".jpg" }
  return ".mp4"
}

private struct WavFormat {
  let sampleRate: Int64
  let channelCount: Int64
  let durationMs: Int64
}

private func parseWavFormat(_ data: Data) -> WavFormat? {
  let bytes = [UInt8](data)
  guard bytes.count >= 44 else { return nil }
  let riff = String(bytes[0..<4].map { Character(UnicodeScalar($0)) })
  let wave = String(bytes[8..<12].map { Character(UnicodeScalar($0)) })
  guard riff == "RIFF", wave == "WAVE" else { return nil }
  var offset = 12
  var sampleRate: Int64?
  var channels: Int64?
  var byteRate: Int64?
  var dataSize: Int64?
  while offset + 8 <= bytes.count {
    let type = String(bytes[offset..<(offset + 4)].map { Character(UnicodeScalar($0)) })
    let size =
      Int(bytes[offset + 4])
      | (Int(bytes[offset + 5]) << 8)
      | (Int(bytes[offset + 6]) << 16)
      | (Int(bytes[offset + 7]) << 24)
    if size < 0 || offset + 8 + size > bytes.count { break }
    if type == "fmt ", size >= 16 {
      channels = Int64(Int(bytes[offset + 10]) | (Int(bytes[offset + 11]) << 8))
      sampleRate = Int64(
        Int(bytes[offset + 12])
          | (Int(bytes[offset + 13]) << 8)
          | (Int(bytes[offset + 14]) << 16)
          | (Int(bytes[offset + 15]) << 24))
      byteRate = Int64(
        Int(bytes[offset + 16])
          | (Int(bytes[offset + 17]) << 8)
          | (Int(bytes[offset + 18]) << 16)
          | (Int(bytes[offset + 19]) << 24))
    } else if type == "data" {
      dataSize = Int64(size)
      break
    }
    offset += 8 + size
  }
  guard let sampleRate, sampleRate > 0, let channels, channels > 0 else { return nil }
  var durationMs: Int64 = 0
  if let dataSize, let byteRate, byteRate > 0 {
    durationMs = dataSize * 1000 / byteRate
  }
  return WavFormat(sampleRate: sampleRate, channelCount: channels, durationMs: durationMs)
}

private func extractXmp(_ data: Data) -> String? {
  guard let start = data.range(of: Data("<x:xmpmeta".utf8)),
    let end = data.range(
      of: Data("</x:xmpmeta>".utf8), options: [], in: start.lowerBound..<data.endIndex)
  else {
    return nil
  }
  let xmp = data[start.lowerBound..<end.upperBound]
  return String(data: xmp, encoding: .utf8) ?? String(data: xmp, encoding: .isoLatin1)
}

private func parseIso6709(_ raw: String?) -> GpsLocationMessage? {
  guard let raw, !raw.isEmpty else { return nil }
  guard
    let regex = try? NSRegularExpression(
      pattern: #"([+-]\d+\.?\d*)([+-]\d+\.?\d*)([+-]\d+\.?\d*)?/"#),
    let match = regex.firstMatch(in: raw, range: NSRange(raw.startIndex..., in: raw))
  else { return nil }
  func group(_ i: Int) -> Double? {
    let range = match.range(at: i)
    guard range.location != NSNotFound, let swift = Range(range, in: raw) else { return nil }
    return Double(raw[swift])
  }
  guard let lat = group(1), let lng = group(2) else { return nil }
  return GpsLocationMessage(latitude: lat, longitude: lng, altitudeMeters: group(3))
}
