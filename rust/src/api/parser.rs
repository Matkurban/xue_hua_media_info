use nom_exif::{MediaParser, MediaSource};

use crate::convert::{
    exif_iter_to_dto, exif_to_dto, image_format_metadata_to_png, map_error, track_to_dto,
};
use super::types::*;

#[flutter_rust_bridge::frb(opaque)]
pub struct MediaMetadataParser {
    inner: MediaParser,
}

#[flutter_rust_bridge::frb(sync)]
pub fn create_media_metadata_parser() -> MediaMetadataParser {
    MediaMetadataParser {
        inner: MediaParser::new(),
    }
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_image_exif_from_file(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<ImageExifDto, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .inner
        .parse_exif(source)
        .map(|iter| exif_to_dto(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_image_exif_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<ImageExifDto, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_exif(source)
        .map(|iter| exif_to_dto(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_video_metadata_from_file(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<VideoTrackDto, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .inner
        .parse_track(source)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_video_metadata_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<VideoTrackDto, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_track(source)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_full_image_metadata_from_file(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<FullImageMetadataDto, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .inner
        .parse_image_metadata(source)
        .map(|image_metadata| FullImageMetadataDto {
            exif: image_metadata.exif.map(|exif| exif_to_dto(&exif.into())),
            png_text_chunks: image_format_metadata_to_png(image_metadata.format),
        })
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_full_image_metadata_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<FullImageMetadataDto, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_image_metadata(source)
        .map(|image_metadata| FullImageMetadataDto {
            exif: image_metadata.exif.map(|exif| exif_iter_to_dto(exif)),
            png_text_chunks: image_format_metadata_to_png(image_metadata.format),
        })
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_embedded_video_from_file(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<VideoTrackDto, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .inner
        .parse_track(source)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_embedded_video_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<VideoTrackDto, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_track(source)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}
