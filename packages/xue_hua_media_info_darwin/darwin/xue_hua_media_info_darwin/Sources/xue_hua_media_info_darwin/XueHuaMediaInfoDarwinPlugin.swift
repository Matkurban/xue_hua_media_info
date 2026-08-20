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

  func read(
    source: MediaSourceMessage, completion: @escaping (Result<MediaMetadataMessage, Error>) -> Void
  ) {
    completion(
      Result {
        let data = try loadData(source)
        switch try sniffKind(data, uri: source.uri) {
        case .image:
          let image = try readImage(from: data)
          return MediaMetadataMessage(kind: .image, image: image, video: nil, audio: nil)
        case .video, .audio:
          return try readAv(source: source, data: data)
        }
      })
  }

  func readImage(
    source: MediaSourceMessage, completion: @escaping (Result<ImageMetadataMessage, Error>) -> Void
  ) {
    completion(
      Result {
        let data = try loadData(source)
        let kind = try sniffKind(data, uri: source.uri)
        guard kind == .image else {
          throw fail("wrongKind", "Source is not an image.")
        }
        return try readImage(from: data)
      })
  }

  func readAv(
    source: MediaSourceMessage, completion: @escaping (Result<MediaMetadataMessage, Error>) -> Void
  ) {
    completion(
      Result {
        let data = try loadData(source)
        let kind = try sniffKind(data, uri: source.uri)
        guard kind != .image else {
          throw fail("wrongKind", "Source is an image, not an AV container.")
        }
        return try readAv(source: source, data: data)
      })
  }

  func probe(
    source: MediaSourceMessage, completion: @escaping (Result<MediaKindMessage, Error>) -> Void
  ) {
    completion(
      Result {
        let data = try loadPrefix(source, count: 64)
        return try sniffKind(data, uri: source.uri)
      })
  }

  func readMotionPhoto(
    source: MediaSourceMessage, completion: @escaping (Result<VideoMetadataMessage, Error>) -> Void
  ) {
    completion(
      Result {
        let data = try loadData(source)
        guard let offset = motionPhotoOffset(data), offset < data.count else {
          throw fail("trackNotFound", "No embedded Motion Photo video.")
        }
        let embedded = data.subdata(in: offset..<data.count)
        let result = try readAv(source: MediaSourceMessage(kind: .bytes, uri: nil, bytes: FlutterStandardTypedData(bytes: embedded)), data: embedded)
        guard let video = result.video else {
          throw fail("trackNotFound", "Embedded trailer is not a video.")
        }
        return video
      })
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
    let durationSeconds = CMTimeGetSeconds(asset.duration)
    let durationMs: Int64? =
      durationSeconds.isFinite && durationSeconds > 0
      ? Int64((durationSeconds * 1000).rounded()) : nil

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

    let audioTrack = asset.tracks(withMediaType: .audio).first
    let sampleRate = audioTrack.flatMap { track -> Int64? in
      let rate = track.naturalTimeScale
      return rate > 0 ? Int64(rate) : nil
    }
    let message = AudioMetadataMessage(
      durationMs: durationMs,
      bitrate: audioTrack.map { Int64($0.estimatedDataRate.rounded()) },
      sampleRate: sampleRate,
      channelCount: nil,
      make: make,
      model: model,
      gps: gps,
      extraTags: []
    )
    return MediaMetadataMessage(kind: .audio, image: nil, video: nil, audio: message)
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
      return try Data(contentsOf: URL(fileURLWithPath: uri))
    case .bytes:
      guard let bytes = source.bytes else { throw fail("notFound", "Missing byte payload.") }
      return bytes.data
    case .asset:
      return try Data(contentsOf: resolveAsset(source))
    }
  }

  private func loadPrefix(_ source: MediaSourceMessage, count: Int) throws -> Data {
    let data = try loadData(source)
    if data.count <= count {
      return data
    }
    return data.prefix(count)
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
        UUID().uuidString + ".media")
      try data.write(to: url)
      return url
    }
  }
}

private func fail(_ code: String, _ message: String) -> PigeonError {
  PigeonError(code: code, message: message, details: nil)
}

private func sniffKind(_ data: Data, uri: String?) throws -> MediaKindMessage {
  let name = uri?.lowercased() ?? ""
  if name.hasSuffix(".raf") || name.hasSuffix(".cr3") || name.hasSuffix(".iiq") {
    throw fail("unsupportedFormat", "RAW formats are not supported.")
  }
  let bytes = [UInt8](data.prefix(16))
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
  if name.hasSuffix(".m4a") || name.hasSuffix(".aac") || name.hasSuffix(".mp3")
    || name.hasSuffix(".wav")
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
  guard let asString = String(data: data, encoding: .isoLatin1) else { return nil }
  if let match = asString.range(
    of: #"GCamera:MicroVideoOffset\s*=\s*"(\d+)""#, options: .regularExpression)
  {
    let raw = String(asString[match])
    if let digits = raw.split(whereSeparator: { !$0.isNumber }).last,
      let fromEnd = Int(digits)
    {
      let start = data.count - fromEnd
      if start > 0 && start < data.count { return start }
    }
  }
  if let range = asString.range(of: "ftyp") {
    let index = asString.distance(from: asString.startIndex, to: range.lowerBound)
    if index >= 4 { return index - 4 }
  }
  return nil
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
