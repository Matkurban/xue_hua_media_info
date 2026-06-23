use nom_exif::{
    Altitude, EntryError, EntryValue, Error, Exif, ExifEntry, ExifIter, GPSInfo, IfdIndex,
    ImageFormatMetadata, LatRef, LonRef, Metadata, PngTextChunks, TagOrCode, TrackInfo,
    TrackInfoTag, URational,
};

use crate::api::types::*;

pub fn map_error(err: Error) -> MediaInfoError {
    MediaInfoError {
        code: match &err {
            Error::Io(_) => MediaInfoErrorCode::Io,
            Error::UnsupportedFormat => MediaInfoErrorCode::UnsupportedFormat,
            Error::ExifNotFound => MediaInfoErrorCode::ExifNotFound,
            Error::TrackNotFound => MediaInfoErrorCode::TrackNotFound,
            Error::Malformed { .. } => MediaInfoErrorCode::Malformed,
            Error::UnexpectedEof { .. } => MediaInfoErrorCode::UnexpectedEof,
            _ => MediaInfoErrorCode::Other,
        },
        message: err.to_string(),
    }
}

pub fn to_media_kind(kind: nom_exif::MediaKind) -> MediaKind {
    match kind {
        nom_exif::MediaKind::Image => MediaKind::Image,
        nom_exif::MediaKind::Track => MediaKind::VideoOrAudio,
    }
}

pub fn to_media_metadata(metadata: Metadata) -> MediaMetadata {
    match metadata {
        Metadata::Exif(exif) => MediaMetadata::ImageExif(to_image_exif(&exif)),
        Metadata::Track(track) => MediaMetadata::VideoTrack(to_video_track(&track)),
    }
}

pub fn to_image_exif(exif: &Exif) -> ImageExif {
    let entries = exif.iter().map(exif_entry_to_metadata_entry).collect();
    let parse_errors = exif
        .errors()
        .iter()
        .map(|(ifd, tag, err)| parse_error_from_parts(*ifd, *tag, err))
        .collect();

    ImageExif {
        entries,
        gps: exif.gps_info().map(to_gps_location),
        has_embedded_video: exif.has_embedded_track(),
        parse_errors,
    }
}

pub fn from_exif_iter(iter: ExifIter) -> ImageExif {
    let has_embedded_video = iter.has_embedded_track();
    let gps = iter
        .parse_gps()
        .ok()
        .flatten()
        .as_ref()
        .map(to_gps_location);

    let mut entries = Vec::new();
    let mut parse_errors = Vec::new();

    for entry in iter {
        let ifd = entry.ifd();
        let tag = entry.tag();
        match entry.into_result() {
            Ok(value) => entries.push(metadata_entry_from_parts(ifd, tag, &value)),
            Err(err) => parse_errors.push(parse_error_from_parts(ifd, tag, &err)),
        }
    }

    ImageExif {
        entries,
        gps,
        has_embedded_video,
        parse_errors,
    }
}

pub fn to_video_track(track: &TrackInfo) -> VideoTrack {
    let entries = track
        .iter()
        .map(|(tag, value)| track_entry_to_metadata_entry(tag, value))
        .collect();

    VideoTrack {
        entries,
        gps: track.gps_info().map(to_gps_location),
        parse_errors: Vec::new(),
    }
}

pub fn to_png_text_list(chunks: &PngTextChunks) -> Vec<PngTextMetadata> {
    chunks
        .iter()
        .map(|(key, value)| PngTextMetadata {
            key: key.to_string(),
            value: value.to_string(),
        })
        .collect()
}

pub fn image_format_metadata_to_png(format: Option<ImageFormatMetadata>) -> Vec<PngTextMetadata> {
    match format {
        Some(ImageFormatMetadata::Png(chunks)) => to_png_text_list(&chunks),
        None | Some(_) => Vec::new(),
    }
}

pub fn to_full_image_metadata(
    image_metadata: nom_exif::ImageMetadata<ExifIter>,
) -> FullImageMetadata {
    FullImageMetadata {
        exif: image_metadata.exif.map(|exif| to_image_exif(&exif.into())),
        png_text_chunks: image_format_metadata_to_png(image_metadata.format),
    }
}

fn exif_entry_to_metadata_entry(entry: ExifEntry<'_>) -> MetadataEntry {
    metadata_entry_from_parts(entry.ifd, entry.tag, entry.value)
}

fn track_entry_to_metadata_entry(tag: TrackInfoTag, value: &EntryValue) -> MetadataEntry {
    MetadataEntry {
        tag_name: tag.name().to_string(),
        tag_code: 0,
        ifd_index: 0,
        value_kind: entry_value_kind(value),
        display_value: value.to_string(),
        raw_value: Some(to_metadata_value(value)),
    }
}

fn metadata_entry_from_parts(ifd: IfdIndex, tag: TagOrCode, value: &EntryValue) -> MetadataEntry {
    MetadataEntry {
        tag_name: tag_name(&tag),
        tag_code: tag.code() as i32,
        ifd_index: ifd.as_usize() as i32,
        value_kind: entry_value_kind(value),
        display_value: value.to_string(),
        raw_value: Some(to_metadata_value(value)),
    }
}

fn parse_error_from_parts(ifd: IfdIndex, tag: TagOrCode, err: &EntryError) -> ParseError {
    ParseError {
        ifd_index: ifd.as_usize() as i32,
        tag_name: tag_name(&tag),
        tag_code: tag.code() as i32,
        message: err.to_string(),
    }
}

fn tag_name(tag: &TagOrCode) -> String {
    match tag {
        TagOrCode::Tag(exif_tag) => exif_tag.to_string(),
        TagOrCode::Unknown(code) => format!("Unknown({code})"),
    }
}

fn entry_value_kind(value: &EntryValue) -> MetadataValueKind {
    match value {
        EntryValue::Text(_) => MetadataValueKind::Text,
        EntryValue::URational(_) => MetadataValueKind::Rational,
        EntryValue::IRational(_) => MetadataValueKind::SignedRational,
        EntryValue::U8(_)
        | EntryValue::I8(_)
        | EntryValue::U16(_)
        | EntryValue::I16(_)
        | EntryValue::U32(_)
        | EntryValue::I32(_)
        | EntryValue::U64(_)
        | EntryValue::I64(_) => MetadataValueKind::Integer,
        EntryValue::F32(_) | EntryValue::F64(_) => MetadataValueKind::Float,
        EntryValue::DateTime(_) => MetadataValueKind::DateTime,
        EntryValue::NaiveDateTime(_) => MetadataValueKind::NaiveDateTime,
        EntryValue::Undefined(_) => MetadataValueKind::Bytes,
        EntryValue::URationalArray(_) => MetadataValueKind::RationalArray,
        EntryValue::IRationalArray(_) => MetadataValueKind::SignedRationalArray,
        EntryValue::U8Array(_) => MetadataValueKind::U8Array,
        EntryValue::U16Array(_) => MetadataValueKind::U16Array,
        EntryValue::U32Array(_) => MetadataValueKind::U32Array,
        _ => MetadataValueKind::Text,
    }
}

fn to_metadata_value(value: &EntryValue) -> MetadataValue {
    match value {
        EntryValue::Text(text) => MetadataValue::Text(text.clone()),
        EntryValue::URational(rational) => MetadataValue::Rational(to_rational(*rational)),
        EntryValue::IRational(rational) => {
            MetadataValue::SignedRational(to_signed_rational(*rational))
        }
        EntryValue::U8(v) => MetadataValue::Integer(*v as i64),
        EntryValue::U16(v) => MetadataValue::Integer(*v as i64),
        EntryValue::U32(v) => MetadataValue::Integer(*v as i64),
        EntryValue::U64(v) => MetadataValue::Integer(*v as i64),
        EntryValue::I8(v) => MetadataValue::Integer(*v as i64),
        EntryValue::I16(v) => MetadataValue::Integer(*v as i64),
        EntryValue::I32(v) => MetadataValue::Integer(*v as i64),
        EntryValue::I64(v) => MetadataValue::Integer(*v),
        EntryValue::F32(v) => MetadataValue::Float(*v as f64),
        EntryValue::F64(v) => MetadataValue::Float(*v),
        EntryValue::DateTime(dt) => MetadataValue::DateTime(dt.to_rfc3339()),
        EntryValue::NaiveDateTime(dt) => {
            MetadataValue::NaiveDateTime(dt.format("%Y-%m-%dT%H:%M:%S").to_string())
        }
        EntryValue::Undefined(bytes) => {
            MetadataValue::Bytes(bytes.iter().map(|b| format!("{b:02x}")).collect())
        }
        EntryValue::URationalArray(values) => {
            MetadataValue::RationalArray(values.iter().copied().map(to_rational).collect())
        }
        EntryValue::IRationalArray(values) => MetadataValue::SignedRationalArray(
            values.iter().copied().map(to_signed_rational).collect(),
        ),
        EntryValue::U8Array(values) => MetadataValue::U8Array(values.clone()),
        EntryValue::U16Array(values) => {
            MetadataValue::U16Array(values.iter().map(|v| *v as i32).collect())
        }
        EntryValue::U32Array(values) => {
            MetadataValue::U32Array(values.iter().map(|v| *v as i64).collect())
        }
        _ => MetadataValue::Text(value.to_string()),
    }
}

fn to_rational(rational: URational) -> Rational {
    Rational {
        numerator: rational.numerator() as i64,
        denominator: rational.denominator() as i64,
    }
}

fn to_signed_rational(rational: nom_exif::IRational) -> Rational {
    Rational {
        numerator: rational.numerator() as i64,
        denominator: rational.denominator() as i64,
    }
}

fn to_gps_location(gps: &GPSInfo) -> GpsLocation {
    GpsLocation {
        latitude: gps.latitude_decimal(),
        longitude: gps.longitude_decimal(),
        altitude_meters: gps.altitude_meters(),
        latitude_ref: match gps.latitude_ref {
            LatRef::North => LatitudeRef::North,
            LatRef::South => LatitudeRef::South,
        },
        longitude_ref: match gps.longitude_ref {
            LonRef::East => LongitudeRef::East,
            LonRef::West => LongitudeRef::West,
        },
        altitude_ref: match gps.altitude {
            Altitude::Unknown => AltitudeRef::Unknown,
            Altitude::AboveSeaLevel(_) => AltitudeRef::AboveSeaLevel,
            Altitude::BelowSeaLevel(_) => AltitudeRef::BelowSeaLevel,
        },
        iso6709: gps.to_iso6709(),
    }
}

#[cfg(test)]
mod tests {
    use nom_exif::{read_exif, read_track};

    use super::*;

    fn fixture_path(name: &str) -> String {
        format!("../example/assets/testdata/{name}")
    }

    #[test]
    fn converts_exif_from_sample_jpeg() {
        let exif = read_exif(fixture_path("exif.jpg")).expect("sample jpeg should parse");
        let result = to_image_exif(&exif);
        assert!(!result.entries.is_empty());
        assert!(result
            .entries
            .iter()
            .any(|entry| entry.tag_name == "Make" || entry.display_value.contains("vivo")));
    }

    #[test]
    fn converts_track_from_sample_mov() {
        let track = read_track(fixture_path("meta.mov")).expect("sample mov should parse");
        let result = to_video_track(&track);
        assert!(!result.entries.is_empty());
    }
}
