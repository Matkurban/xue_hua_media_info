package com.xuehua.xue_hua_media_info_android

import android.content.Context
import android.graphics.BitmapFactory
import android.media.MediaDataSource
import android.media.MediaMetadataRetriever
import android.os.Build
import androidx.exifinterface.media.ExifInterface
import io.flutter.embedding.engine.plugins.FlutterPlugin
import java.io.ByteArrayInputStream
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.charset.Charset

/**
 * Android implementation: ExifInterface for still images, MediaMetadataRetriever
 * for audio/video containers.
 *
 * Android 实现：图片走 ExifInterface，音视频容器走 MediaMetadataRetriever。
 */
class XueHuaMediaInfoAndroidPlugin :
    FlutterPlugin,
    MediaInfoHostApi {
    private lateinit var context: Context
    private lateinit var flutterAssets: FlutterPlugin.FlutterAssets

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        flutterAssets = binding.flutterAssets
        MediaInfoHostApi.setUp(binding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        MediaInfoHostApi.setUp(binding.binaryMessenger, null)
    }

    override fun read(
        source: MediaSourceMessage,
        callback: (Result<MediaMetadataMessage>) -> Unit,
    ) {
        callback(runMedia {
            val bytes = loadPrefix(source, HEADER_BYTES)
            when (sniffKind(bytes, source)) {
                MediaKindMessage.IMAGE -> {
                    val image = readImageInternal(source)
                    MediaMetadataMessage(
                        kind = MediaKindMessage.IMAGE,
                        image = image,
                    )
                }
                MediaKindMessage.VIDEO,
                MediaKindMessage.AUDIO,
                -> readAvInternal(source)
            }
        })
    }

    override fun readImage(
        source: MediaSourceMessage,
        callback: (Result<ImageMetadataMessage>) -> Unit,
    ) {
        callback(runMedia { readImageInternal(source) })
    }

    override fun readAv(
        source: MediaSourceMessage,
        callback: (Result<MediaMetadataMessage>) -> Unit,
    ) {
        callback(runMedia { readAvInternal(source) })
    }

    override fun probe(
        source: MediaSourceMessage,
        callback: (Result<MediaKindMessage>) -> Unit,
    ) {
        callback(runMedia {
            sniffKind(loadPrefix(source, HEADER_BYTES), source)
        })
    }

    override fun readMotionPhoto(
        source: MediaSourceMessage,
        callback: (Result<VideoMetadataMessage>) -> Unit,
    ) {
        callback(runMedia {
            val data = loadAll(source)
            val offset = motionPhotoOffset(data)
                ?: throw FlutterError("trackNotFound", "No embedded Motion Photo video.", null)
            val embedded = data.copyOfRange(offset, data.size)
            readAvFromBytes(embedded).video
                ?: throw FlutterError("trackNotFound", "Embedded trailer is not a video.", null)
        })
    }

    private fun readImageInternal(source: MediaSourceMessage): ImageMetadataMessage {
        val kind = sniffKind(loadPrefix(source, HEADER_BYTES), source)
        if (kind != MediaKindMessage.IMAGE) {
            throw FlutterError("wrongKind", "Source is not an image.", null)
        }
        val exif = openExif(source)
        val latLong = FloatArray(2)
        val gps =
            if (exif.getLatLong(latLong)) {
                val alt = exif.getAltitude(Double.NaN)
                GpsLocationMessage(
                    latitude = latLong[0].toDouble(),
                    longitude = latLong[1].toDouble(),
                    altitudeMeters = if (alt.isNaN()) null else alt,
                )
            } else {
                null
            }
        val width = exif.getAttributeInt(ExifInterface.TAG_IMAGE_WIDTH, -1)
        val height = exif.getAttributeInt(ExifInterface.TAG_IMAGE_LENGTH, -1)
        val size =
            if (width > 0 && height > 0) {
                PixelSizeMessage(width = width.toLong(), height = height.toLong())
            } else {
                decodeBitmapSize(source)
            }
        val orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, 0)
        val data = runCatching { loadAll(source) }.getOrNull()
        val pngText = if (data != null) parsePngText(data) else emptyList()
        val hasMotion = data != null && motionPhotoOffset(data) != null
        return ImageMetadataMessage(
            make = exif.getAttribute(ExifInterface.TAG_MAKE),
            model = exif.getAttribute(ExifInterface.TAG_MODEL),
            software = exif.getAttribute(ExifInterface.TAG_SOFTWARE),
            size = size,
            orientation = if (orientation == 0) null else orientation.toLong(),
            dateTimeOriginal = exif.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL),
            dateTimeDigitized = exif.getAttribute(ExifInterface.TAG_DATETIME_DIGITIZED),
            dateTimeModified = exif.getAttribute(ExifInterface.TAG_DATETIME),
            gps = gps,
            hasMotionPhoto = hasMotion,
            pngText = pngText,
            extraTags = emptyList(),
        )
    }

    private fun readAvInternal(source: MediaSourceMessage): MediaMetadataMessage {
        val kind = sniffKind(loadPrefix(source, HEADER_BYTES), source)
        if (kind == MediaKindMessage.IMAGE) {
            throw FlutterError("wrongKind", "Source is an image, not an AV container.", null)
        }
        val retriever = MediaMetadataRetriever()
        try {
            applyRetrieverSource(retriever, source)
            return metadataFromRetriever(retriever)
        } catch (error: FlutterError) {
            throw error
        } catch (error: Exception) {
            throw FlutterError("unsupportedFormat", error.message ?: "Unable to read container.", null)
        } finally {
            retriever.release()
        }
    }

    private fun readAvFromBytes(data: ByteArray): MediaMetadataMessage {
        val retriever = MediaMetadataRetriever()
        try {
            retriever.setDataSource(ByteArrayMediaDataSource(data))
            return metadataFromRetriever(retriever)
        } finally {
            retriever.release()
        }
    }

    private fun metadataFromRetriever(retriever: MediaMetadataRetriever): MediaMetadataMessage {
        val durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull()
        val encodedWidth = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)?.toLongOrNull()
        val encodedHeight = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)?.toLongOrNull()
        val bitrate = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_BITRATE)?.toLongOrNull()
        val rotation = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)?.toLongOrNull()
        val mime = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE)
        val hasVideo = encodedWidth != null && encodedHeight != null && encodedWidth > 0 && encodedHeight > 0
        val gps = parseIso6709(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_LOCATION))
        val sampleRate =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_SAMPLERATE)
                    ?.toLongOrNull()
            } else {
                null
            }
        if (hasVideo) {
            val display = displaySize(encodedWidth, encodedHeight, rotation)
            val video = VideoMetadataMessage(
                durationMs = durationMs,
                size = display,
                bitrate = bitrate,
                rotationDegrees = rotation,
                make = null,
                model = null,
                gps = gps,
                extraTags = emptyList(),
            )
            return MediaMetadataMessage(kind = MediaKindMessage.VIDEO, video = video)
        }
        val hasAudio =
            (durationMs != null && durationMs > 0) ||
                sampleRate != null ||
                mime?.startsWith("audio") == true
        if (!hasAudio) {
            throw FlutterError("trackNotFound", "No video or audio track.", null)
        }
        val audio = AudioMetadataMessage(
            durationMs = durationMs,
            bitrate = bitrate,
            sampleRate = sampleRate,
            channelCount = null,
            make = null,
            model = null,
            gps = gps,
            extraTags = emptyList(),
        )
        return MediaMetadataMessage(kind = MediaKindMessage.AUDIO, audio = audio)
    }

    private fun openExif(source: MediaSourceMessage): ExifInterface {
        return when (source.kind) {
            SourceKindMessage.FILE -> ExifInterface(source.uri ?: throw missingPath())
            SourceKindMessage.BYTES ->
                ExifInterface(ByteArrayInputStream(source.bytes ?: throw missingBytes()))
            SourceKindMessage.ASSET -> {
                val assetPath = flutterAssets.getAssetFilePathByName(source.uri ?: throw missingPath())
                ExifInterface(context.assets.open(assetPath))
            }
        }
    }

    private fun applyRetrieverSource(
        retriever: MediaMetadataRetriever,
        source: MediaSourceMessage,
    ) {
        when (source.kind) {
            SourceKindMessage.FILE -> retriever.setDataSource(source.uri ?: throw missingPath())
            SourceKindMessage.BYTES ->
                retriever.setDataSource(ByteArrayMediaDataSource(source.bytes ?: throw missingBytes()))
            SourceKindMessage.ASSET -> {
                val assetPath = flutterAssets.getAssetFilePathByName(source.uri ?: throw missingPath())
                try {
                    context.assets.openFd(assetPath).use { fd ->
                        retriever.setDataSource(fd.fileDescriptor, fd.startOffset, fd.length)
                    }
                } catch (_: IOException) {
                    // Compressed APK assets cannot be opened as FDs; stream via bytes.
                    retriever.setDataSource(ByteArrayMediaDataSource(loadAll(source)))
                }
            }
        }
    }

    private fun loadPrefix(source: MediaSourceMessage, count: Int): ByteArray {
        return when (source.kind) {
            SourceKindMessage.BYTES -> {
                val data = source.bytes ?: throw missingBytes()
                data.copyOfRange(0, minOf(count, data.size))
            }
            SourceKindMessage.FILE -> {
                FileInputStream(File(source.uri ?: throw missingPath())).use { input ->
                    val buffer = ByteArray(count)
                    val read = input.read(buffer)
                    if (read <= 0) buffer else buffer.copyOf(read)
                }
            }
            SourceKindMessage.ASSET -> {
                val assetPath = flutterAssets.getAssetFilePathByName(source.uri ?: throw missingPath())
                context.assets.open(assetPath).use { input ->
                    val buffer = ByteArray(count)
                    val read = input.read(buffer)
                    if (read <= 0) buffer else buffer.copyOf(read)
                }
            }
        }
    }

    private fun loadAll(source: MediaSourceMessage): ByteArray {
        return when (source.kind) {
            SourceKindMessage.BYTES -> source.bytes ?: throw missingBytes()
            SourceKindMessage.FILE -> File(source.uri ?: throw missingPath()).readBytes()
            SourceKindMessage.ASSET -> {
                val assetPath = flutterAssets.getAssetFilePathByName(source.uri ?: throw missingPath())
                context.assets.open(assetPath).use { it.readBytes() }
            }
        }
    }

    private fun decodeBitmapSize(source: MediaSourceMessage): PixelSizeMessage? {
        val options = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        when (source.kind) {
            SourceKindMessage.FILE ->
                BitmapFactory.decodeFile(source.uri ?: return null, options)
            SourceKindMessage.BYTES -> {
                val data = source.bytes ?: return null
                BitmapFactory.decodeByteArray(data, 0, data.size, options)
            }
            SourceKindMessage.ASSET -> {
                val assetPath = flutterAssets.getAssetFilePathByName(source.uri ?: return null)
                context.assets.open(assetPath).use { BitmapFactory.decodeStream(it, null, options) }
            }
        }
        if (options.outWidth <= 0 || options.outHeight <= 0) {
            return null
        }
        return PixelSizeMessage(
            width = options.outWidth.toLong(),
            height = options.outHeight.toLong(),
        )
    }

    private fun missingPath(): FlutterError = FlutterError("notFound", "Missing path or asset key.", null)

    private fun missingBytes(): FlutterError = FlutterError("notFound", "Missing byte payload.", null)

    companion object {
        internal const val HEADER_BYTES = 256
    }
}

internal fun displaySize(width: Long, height: Long, rotation: Long?): PixelSizeMessage {
    val quarterTurns = ((rotation ?: 0) % 360 + 360) % 360
    return if (quarterTurns == 90L || quarterTurns == 270L) {
        PixelSizeMessage(width = height, height = width)
    } else {
        PixelSizeMessage(width = width, height = height)
    }
}

private inline fun <T> runMedia(block: () -> T): Result<T> {
    return try {
        Result.success(block())
    } catch (error: FlutterError) {
        Result.failure(error)
    } catch (error: FileNotFoundException) {
        Result.failure(FlutterError("notFound", error.message ?: "File not found.", null))
    } catch (error: IOException) {
        Result.failure(FlutterError("io", error.message ?: "I/O failed.", null))
    } catch (error: Exception) {
        Result.failure(FlutterError("malformed", error.message ?: "Unable to read media.", null))
    }
}

private class ByteArrayMediaDataSource(
    private val data: ByteArray,
) : MediaDataSource() {
    override fun readAt(position: Long, buffer: ByteArray, offset: Int, size: Int): Int {
        if (position >= data.size) {
            return -1
        }
        val length = minOf(size, data.size - position.toInt())
        System.arraycopy(data, position.toInt(), buffer, offset, length)
        return length
    }

    override fun getSize(): Long = data.size.toLong()

    override fun close() {}
}

internal fun sniffKind(prefix: ByteArray, source: MediaSourceMessage): MediaKindMessage {
    val name = source.uri?.lowercase() ?: ""
    if (name.endsWith(".raf") || name.endsWith(".cr3") || name.endsWith(".iiq")) {
        throw FlutterError("unsupportedFormat", "RAW formats are not supported.", null)
    }
    if (prefix.size >= 15 && String(prefix, 0, 15, Charsets.US_ASCII) == "FUJIFILMCCD-RAW") {
        throw FlutterError("unsupportedFormat", "Fujifilm RAF is not supported.", null)
    }
    if (prefix.size >= 3 && prefix[0] == 0xFF.toByte() && prefix[1] == 0xD8.toByte()) {
        return MediaKindMessage.IMAGE
    }
    if (prefix.size >= 8 &&
        prefix[0] == 0x89.toByte() &&
        prefix[1] == 0x50.toByte() &&
        prefix[2] == 0x4E.toByte() &&
        prefix[3] == 0x47.toByte()
    ) {
        return MediaKindMessage.IMAGE
    }
    if (prefix.size >= 4 &&
        (
            (prefix[0] == 0x49.toByte() && prefix[1] == 0x49.toByte()) ||
                (prefix[0] == 0x4D.toByte() && prefix[1] == 0x4D.toByte())
        )
    ) {
        val ascii = String(prefix, Charsets.ISO_8859_1)
        if (ascii.contains("IIQ") || ascii.contains("Phase One")) {
            throw FlutterError("unsupportedFormat", "Phase One IIQ is not supported.", null)
        }
        return MediaKindMessage.IMAGE
    }
    if (prefix.size >= 12 &&
        prefix.copyOfRange(4, 8).toString(Charsets.US_ASCII) == "ftyp"
    ) {
        val brand = prefix.copyOfRange(8, minOf(12, prefix.size)).toString(Charsets.US_ASCII)
        if (brand.startsWith("crx")) {
            throw FlutterError("unsupportedFormat", "Canon CR3 is not supported.", null)
        }
        val imageBrands = setOf("heic", "heif", "mif1", "msf1", "avif", "avis")
        if (imageBrands.contains(brand)) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
                throw FlutterError("unsupportedFormat", "HEIC/HEIF requires Android API 28+.", null)
            }
            return MediaKindMessage.IMAGE
        }
        return MediaKindMessage.VIDEO
    }
    if (prefix.size >= 4 &&
        prefix[0] == 0x1A.toByte() &&
        prefix[1] == 0x45.toByte() &&
        prefix[2] == 0xDF.toByte() &&
        prefix[3] == 0xA3.toByte()
    ) {
        return MediaKindMessage.VIDEO
    }
    if (name.endsWith(".m4a") || name.endsWith(".aac") || name.endsWith(".mp3") || name.endsWith(".wav")) {
        return MediaKindMessage.AUDIO
    }
    throw FlutterError("unsupportedFormat", "Unrecognized media header.", null)
}

internal fun parseIso6709(raw: String?): GpsLocationMessage? {
    if (raw.isNullOrEmpty()) {
        return null
    }
    val match = Regex("""([+-]\d+\.?\d*)([+-]\d+\.?\d*)([+-]\d+\.?\d*)?/?""").find(raw) ?: return null
    val lat = match.groupValues[1].toDoubleOrNull() ?: return null
    val lng = match.groupValues[2].toDoubleOrNull() ?: return null
    val alt = match.groupValues.getOrNull(3)?.toDoubleOrNull()
    return GpsLocationMessage(latitude = lat, longitude = lng, altitudeMeters = alt)
}

internal fun parsePngText(data: ByteArray): List<PngTextChunkMessage> {
    if (data.size < 8 || data[0] != 0x89.toByte() || data[1] != 0x50.toByte()) {
        return emptyList()
    }
    val chunks = mutableListOf<PngTextChunkMessage>()
    var offset = 8
    while (offset + 12 <= data.size) {
        val length = ByteBuffer.wrap(data, offset, 4).order(ByteOrder.BIG_ENDIAN).int
        if (length < 0 || offset + 12 + length > data.size) {
            break
        }
        val type = data.copyOfRange(offset + 4, offset + 8).toString(Charsets.US_ASCII)
        if (type == "tEXt") {
            val payload = data.copyOfRange(offset + 8, offset + 8 + length)
            val split = payload.indexOf(0)
            if (split > 0) {
                val key = payload.copyOfRange(0, split).toString(Charsets.ISO_8859_1)
                val value = payload.copyOfRange(split + 1, payload.size).toString(Charsets.ISO_8859_1)
                chunks.add(PngTextChunkMessage(key = key, value = value))
            }
        }
        if (type == "IEND") {
            break
        }
        offset += 12 + length
    }
    return chunks
}

internal fun motionPhotoOffset(data: ByteArray): Int? {
    val xmp = extractXmp(data) ?: return null
    val micro = Regex("""GCamera:MicroVideoOffset\s*=\s*"(\d+)"""").find(xmp)
        ?: Regex("""MicroVideoOffset>\s*(\d+)""").find(xmp)
    if (micro != null) {
        val fromEnd = micro.groupValues[1].toIntOrNull() ?: return null
        val start = data.size - fromEnd
        return if (start in 1 until data.size) start else null
    }
    if (!xmp.contains("MotionPhoto") && !xmp.contains("MicroVideo")) {
        return null
    }
    val itemLength = Regex("""Item:Length(?:="|>)\s*(\d+)""").findAll(xmp).lastOrNull()
    if (itemLength != null) {
        val fromEnd = itemLength.groupValues[1].toIntOrNull() ?: return null
        val start = data.size - fromEnd
        return if (start in 1 until data.size) start else null
    }
    return null
}

private fun extractXmp(data: ByteArray): String? {
    val start = indexOfAscii(data, "<x:xmpmeta", 0) ?: return null
    val end = indexOfAscii(data, "</x:xmpmeta>", start) ?: return null
    return String(data, start, end + 12 - start, Charset.forName("UTF-8"))
}

private fun indexOfAscii(data: ByteArray, needle: String, from: Int): Int? {
    val bytes = needle.toByteArray(Charsets.US_ASCII)
    outer@ for (i in from..(data.size - bytes.size)) {
        for (j in bytes.indices) {
            if (data[i + j] != bytes[j]) {
                continue@outer
            }
        }
        return i
    }
    return null
}
