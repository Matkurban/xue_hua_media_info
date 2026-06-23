use nom_exif::{
    Altitude, EntryError, EntryValue, Error, Exif, ExifEntry, ExifIter, GPSInfo, IfdIndex,
    ImageFormatMetadata, LatRef, LonRef, MediaKind, Metadata, PngTextChunks, TagOrCode, TrackInfo,
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

pub fn media_kind_to_dto(kind: MediaKind) -> MediaKindDto {
    match kind {
        MediaKind::Image => MediaKindDto::Image,
        MediaKind::Track => MediaKindDto::VideoOrAudio,
    }
}

pub fn metadata_to_dto(metadata: Metadata) -> MediaMetadataDto {
    match metadata {
        Metadata::Exif(exif) => MediaMetadataDto::ImageExif(exif_to_dto(&exif)),
        Metadata::Track(track) => MediaMetadataDto::VideoTrack(track_to_dto(&track)),
    }
}

pub fn exif_to_dto(exif: &Exif) -> ImageExifDto {
    let entries = exif.iter().map(exif_entry_to_dto).collect();
    let parse_errors = exif
        .errors()
        .iter()
        .map(|(ifd, tag, err)| parse_error_from_parts(*ifd, *tag, err))
        .collect();

    ImageExifDto {
        entries,
        gps: exif.gps_info().map(gps_to_dto),
        has_embedded_video: exif.has_embedded_track(),
        parse_errors,
    }
}

pub fn exif_iter_to_dto(iter: ExifIter) -> ImageExifDto {
    let has_embedded_video = iter.has_embedded_track();
    let gps = iter.parse_gps().ok().flatten().as_ref().map(gps_to_dto);

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

    ImageExifDto {
        entries,
        gps,
        has_embedded_video,
        parse_errors,
    }
}

pub fn track_to_dto(track: &TrackInfo) -> VideoTrackDto {
    let entries = track
        .iter()
        .map(|(tag, value)| track_entry_to_dto(tag, value))
        .collect();

    VideoTrackDto {
        entries,
        gps: track.gps_info().map(gps_to_dto),
        parse_errors: Vec::new(),
    }
}

pub fn png_text_to_dto(chunks: &PngTextChunks) -> Vec<PngTextMetadataDto> {
    chunks
        .iter()
        .map(|(key, value)| PngTextMetadataDto {
            key: key.to_string(),
            value: value.to_string(),
        })
        .collect()
}

pub fn image_format_metadata_to_png(
    format: Option<ImageFormatMetadata>,
) -> Vec<PngTextMetadataDto> {
    match format {
        Some(ImageFormatMetadata::Png(chunks)) => png_text_to_dto(&chunks),
        None | Some(_) => Vec::new(),
    }
}

fn exif_entry_to_dto(entry: ExifEntry<'_>) -> MetadataEntryDto {
    metadata_entry_from_parts(entry.ifd, entry.tag, entry.value)
}

fn track_entry_to_dto(tag: TrackInfoTag, value: &EntryValue) -> MetadataEntryDto {
    MetadataEntryDto {
        tag_name: tag.name().to_string(),
        tag_code: 0,
        ifd_index: 0,
        value_kind: entry_value_kind(value),
        display_value: value.to_string(),
        raw_value: Some(entry_value_to_dto(value)),
    }
}

fn metadata_entry_from_parts(
    ifd: IfdIndex,
    tag: TagOrCode,
    value: &EntryValue,
) -> MetadataEntryDto {
    MetadataEntryDto {
        tag_name: tag_name(&tag),
        tag_code: tag.code() as i32,
        ifd_index: ifd.as_usize() as i32,
        value_kind: entry_value_kind(value),
        display_value: value.to_string(),
        raw_value: Some(entry_value_to_dto(value)),
    }
}

fn parse_error_from_parts(ifd: IfdIndex, tag: TagOrCode, err: &EntryError) -> ParseErrorDto {
    ParseErrorDto {
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
        EntryValue::U8(_) | EntryValue::I8(_) | EntryValue::U16(_) | EntryValue::I16(_)
        | EntryValue::U32(_) | EntryValue::I32(_) | EntryValue::U64(_) | EntryValue::I64(_) => {
            MetadataValueKind::Integer
        }
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

fn entry_value_to_dto(value: &EntryValue) -> MetadataValueDto {
    match value {
        EntryValue::Text(text) => MetadataValueDto::Text(text.clone()),
        EntryValue::URational(rational) => MetadataValueDto::Rational(urational_to_dto(*rational)),
        EntryValue::IRational(rational) => {
            MetadataValueDto::SignedRational(irational_to_dto(*rational))
        }
        EntryValue::U8(v) => MetadataValueDto::Integer(*v as i64),
        EntryValue::U16(v) => MetadataValueDto::Integer(*v as i64),
        EntryValue::U32(v) => MetadataValueDto::Integer(*v as i64),
        EntryValue::U64(v) => MetadataValueDto::Integer(*v as i64),
        EntryValue::I8(v) => MetadataValueDto::Integer(*v as i64),
        EntryValue::I16(v) => MetadataValueDto::Integer(*v as i64),
        EntryValue::I32(v) => MetadataValueDto::Integer(*v as i64),
        EntryValue::I64(v) => MetadataValueDto::Integer(*v),
        EntryValue::F32(v) => MetadataValueDto::Float(*v as f64),
        EntryValue::F64(v) => MetadataValueDto::Float(*v),
        EntryValue::DateTime(dt) => MetadataValueDto::DateTime(dt.to_rfc3339()),
        EntryValue::NaiveDateTime(dt) => {
            MetadataValueDto::NaiveDateTime(dt.format("%Y-%m-%dT%H:%M:%S").to_string())
        }
        EntryValue::Undefined(bytes) => MetadataValueDto::Bytes(
            bytes.iter().map(|b| format!("{b:02x}")).collect(),
        ),
        EntryValue::URationalArray(values) => MetadataValueDto::RationalArray(
            values.iter().copied().map(urational_to_dto).collect(),
        ),
        EntryValue::IRationalArray(values) => MetadataValueDto::SignedRationalArray(
            values.iter().copied().map(irational_to_dto).collect(),
        ),
        EntryValue::U8Array(values) => MetadataValueDto::U8Array(values.clone()),
        EntryValue::U16Array(values) => MetadataValueDto::U16Array(
            values.iter().map(|v| *v as i32).collect(),
        ),
        EntryValue::U32Array(values) => MetadataValueDto::U32Array(
            values.iter().map(|v| *v as i64).collect(),
        ),
        _ => MetadataValueDto::Text(value.to_string()),
    }
}

fn urational_to_dto(rational: URational) -> RationalDto {
    RationalDto {
        numerator: rational.numerator() as i64,
        denominator: rational.denominator() as i64,
    }
}

fn irational_to_dto(rational: nom_exif::IRational) -> RationalDto {
    RationalDto {
        numerator: rational.numerator() as i64,
        denominator: rational.denominator() as i64,
    }
}

fn gps_to_dto(gps: &GPSInfo) -> GpsLocationDto {
    GpsLocationDto {
        latitude: gps.latitude_decimal(),
        longitude: gps.longitude_decimal(),
        altitude_meters: gps.altitude_meters(),
        latitude_ref: match gps.latitude_ref {
            LatRef::North => LatitudeRefDto::North,
            LatRef::South => LatitudeRefDto::South,
        },
        longitude_ref: match gps.longitude_ref {
            LonRef::East => LongitudeRefDto::East,
            LonRef::West => LongitudeRefDto::West,
        },
        altitude_ref: match gps.altitude {
            Altitude::Unknown => AltitudeRefDto::Unknown,
            Altitude::AboveSeaLevel(_) => AltitudeRefDto::AboveSeaLevel,
            Altitude::BelowSeaLevel(_) => AltitudeRefDto::BelowSeaLevel,
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
        let dto = exif_to_dto(&exif);
        assert!(!dto.entries.is_empty());
        assert!(dto
            .entries
            .iter()
            .any(|entry| entry.tag_name == "Make" || entry.display_value.contains("vivo")));
    }

    #[test]
    fn converts_track_from_sample_mov() {
        let track = read_track(fixture_path("meta.mov")).expect("sample mov should parse");
        let dto = track_to_dto(&track);
        assert!(!dto.entries.is_empty());
    }
}
