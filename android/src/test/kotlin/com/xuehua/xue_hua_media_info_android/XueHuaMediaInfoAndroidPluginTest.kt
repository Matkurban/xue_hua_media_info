package com.xuehua.xue_hua_media_info_android

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull
import kotlin.test.assertTrue

internal class XueHuaMediaInfoAndroidPluginTest {
    @Test
    fun sniffKind_jpegIsImage() {
        val jpeg = byteArrayOf(0xFF.toByte(), 0xD8.toByte(), 0xFF.toByte())
        val source = MediaSourceMessage(kind = SourceKindMessage.FILE, uri = "a.jpg")
        assertEquals(MediaKindMessage.IMAGE, sniffKind(jpeg, source))
    }

    @Test
    fun sniffKind_riffWaveIsAudioEvenWithoutExtension() {
        val wav = ByteArray(12)
        "RIFF".toByteArray(Charsets.US_ASCII).copyInto(wav, 0)
        "WAVE".toByteArray(Charsets.US_ASCII).copyInto(wav, 8)
        val source = MediaSourceMessage(kind = SourceKindMessage.BYTES, uri = null)
        assertEquals(MediaKindMessage.AUDIO, sniffKind(wav, source))
    }

    @Test
    fun sniffKind_id3IsAudio() {
        val id3 = byteArrayOf(0x49, 0x44, 0x33, 0x03, 0x00, 0x00)
        val source = MediaSourceMessage(kind = SourceKindMessage.BYTES, uri = null)
        assertEquals(MediaKindMessage.AUDIO, sniffKind(id3, source))
    }

    @Test
    fun sniffKind_mpegFrameSyncIsAudio() {
        val mp3 = byteArrayOf(0xFF.toByte(), 0xFB.toByte(), 0x90.toByte(), 0x00)
        val source = MediaSourceMessage(kind = SourceKindMessage.BYTES, uri = null)
        assertEquals(MediaKindMessage.AUDIO, sniffKind(mp3, source))
    }

    @Test
    fun parsePngText_readsTExtChunk() {
        // Minimal PNG: signature + tEXt + IEND (CRC values are ignored by the parser).
        val png = byteArrayOf(
            0x89.toByte(), 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
            0x00, 0x00, 0x00, 0x08, // length 8
            0x74, 0x45, 0x58, 0x74, // tEXt
            0x41, 0x00, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, // A\0BCDEFG
            0x00, 0x00, 0x00, 0x00, // crc
            0x00, 0x00, 0x00, 0x00,
            0x49, 0x45, 0x4E, 0x44,
            0x00, 0x00, 0x00, 0x00,
        )
        val chunks = parsePngText(png)
        assertTrue(chunks.isNotEmpty())
        assertEquals("A", chunks.first().key)
    }

    @Test
    fun motionPhotoOffset_readsGCameraMotionPhotoOffset() {
        val trailer = ByteArray(64) { 0x11 }
        val xmp = """
            <x:xmpmeta xmlns:x="adobe:ns:meta/">
              <rdf:Description xmlns:GCamera="http://ns.google.com/photos/1.0/camera/"
                GCamera:MotionPhoto="1"
                GCamera:MotionPhotoOffset="${trailer.size}" />
            </x:xmpmeta>
        """.trimIndent()
        val jpegPrefix = byteArrayOf(0xFF.toByte(), 0xD8.toByte(), 0xFF.toByte(), 0xE1.toByte())
        val data = jpegPrefix + xmp.toByteArray(Charsets.UTF_8) + trailer
        val offset = motionPhotoOffset(data)
        assertNotNull(offset)
        assertEquals(data.size - trailer.size, offset)
    }

    @Test
    fun motionPhotoOffset_readsMicroVideoOffset() {
        val trailer = ByteArray(32) { 0x22 }
        val xmp = """
            <x:xmpmeta xmlns:x="adobe:ns:meta/">
              <rdf:Description GCamera:MicroVideoOffset="${trailer.size}" />
            </x:xmpmeta>
        """.trimIndent()
        val data = byteArrayOf(0xFF.toByte(), 0xD8.toByte()) + xmp.toByteArray(Charsets.UTF_8) + trailer
        val offset = motionPhotoOffset(data)
        assertNotNull(offset)
        assertEquals(data.size - trailer.size, offset)
    }

    @Test
    fun motionPhotoOffset_returnsNullWithoutXmp() {
        assertNull(motionPhotoOffset(byteArrayOf(0xFF.toByte(), 0xD8.toByte(), 0xFF.toByte())))
    }

    @Test
    fun parseWaveAudio_readsFmtAndData() {
        // Minimal PCM WAVE: 1s mono 8000Hz 16-bit => 16000 data bytes, duration 1000ms.
        val dataSize = 16000
        val fmt = byteArrayOf(
            0x01, 0x00, // PCM
            0x01, 0x00, // 1 channel
            0x40, 0x1F, 0x00, 0x00, // 8000
            0x80, 0x3E, 0x00, 0x00, // byteRate 16000
            0x02, 0x00, // blockAlign
            0x10, 0x00, // 16-bit
        )
        fun le32(v: Int) = byteArrayOf(
            (v and 0xff).toByte(), ((v shr 8) and 0xff).toByte(),
            ((v shr 16) and 0xff).toByte(), ((v shr 24) and 0xff).toByte(),
        )
        val riffSize = 4 + (8 + fmt.size) + (8 + dataSize)
        val wav = byteArrayOf(
            *("RIFF".toByteArray()), *le32(riffSize), *("WAVE".toByteArray()),
            *("fmt ".toByteArray()), *le32(fmt.size), *fmt,
            *("data".toByteArray()), *le32(dataSize), *ByteArray(dataSize),
        )
        val meta = parseWaveAudio(wav)
        assertNotNull(meta)
        assertEquals(MediaKindMessage.AUDIO, meta!!.kind)
        assertEquals(1000L, meta.audio!!.durationMs)
        assertEquals(8000L, meta.audio!!.sampleRate)
        assertEquals(1L, meta.audio!!.channelCount)
    }

}
