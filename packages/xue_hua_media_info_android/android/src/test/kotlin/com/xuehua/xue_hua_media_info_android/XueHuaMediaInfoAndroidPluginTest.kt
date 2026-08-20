package com.xuehua.xue_hua_media_info_android

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

internal class XueHuaMediaInfoAndroidPluginTest {
    @Test
    fun sniffKind_jpegIsImage() {
        val jpeg = byteArrayOf(0xFF.toByte(), 0xD8.toByte(), 0xFF.toByte())
        val source = MediaSourceMessage(kind = SourceKindMessage.FILE, uri = "a.jpg")
        assertEquals(MediaKindMessage.IMAGE, sniffKind(jpeg, source))
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
}
