use nom_exif::{MediaParser, MediaSource};

use super::types::*;
use crate::convert::{map_error, to_full_image_metadata, to_image_exif, to_video_track};

#[flutter_rust_bridge::frb(opaque)]
pub struct MediaMetadataParser {
    pub(crate) inner: MediaParser,
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
) -> Result<ImageExif, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .inner
        .parse_exif(source)
        .map(|iter| to_image_exif(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_image_exif_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<ImageExif, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_exif(source)
        .map(|iter| to_image_exif(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_video_metadata_from_file(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<VideoTrack, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .inner
        .parse_track(source)
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_video_metadata_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<VideoTrack, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_track(source)
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_full_image_metadata_from_file(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<FullImageMetadata, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .inner
        .parse_image_metadata(source)
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_full_image_metadata_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<FullImageMetadata, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_image_metadata(source)
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_embedded_video_from_file(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<VideoTrack, MediaInfoError> {
    crate::embedded_video::parse_embedded_video_from_file_with_parser(&mut parser.inner, path)
        .map(|track| to_video_track(&track))
}

#[flutter_rust_bridge::frb(sync)]
pub fn parse_embedded_video_from_bytes(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<VideoTrack, MediaInfoError> {
    crate::embedded_video::parse_embedded_video_from_bytes_with_parser(&mut parser.inner, data)
        .map(|track| to_video_track(&track))
}
