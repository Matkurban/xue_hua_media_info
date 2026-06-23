use nom_exif::{read_exif, read_exif_iter, read_metadata, read_track, MediaSource};

use super::types::*;
use crate::convert::{
    from_exif_iter, map_error, to_full_image_metadata, to_image_exif, to_media_kind,
    to_media_metadata, to_video_track,
};

#[flutter_rust_bridge::frb(sync)]
pub fn read_media_metadata_from_file(path: String) -> Result<MediaMetadata, MediaInfoError> {
    read_metadata(path)
        .map(to_media_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_media_metadata_from_bytes(data: Vec<u8>) -> Result<MediaMetadata, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    let mut parser = nom_exif::MediaParser::new();
    let metadata = match source.kind() {
        nom_exif::MediaKind::Image => parser
            .parse_exif(source)
            .map(|iter| nom_exif::Metadata::Exif(iter.into()))
            .map_err(map_error)?,
        nom_exif::MediaKind::Track => parser
            .parse_track(source)
            .map(nom_exif::Metadata::Track)
            .map_err(map_error)?,
    };
    Ok(to_media_metadata(metadata))
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_from_file(path: String) -> Result<ImageExif, MediaInfoError> {
    read_exif(path)
        .map(|exif| to_image_exif(&exif))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_from_bytes(data: Vec<u8>) -> Result<ImageExif, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_exif(source)
        .map(|iter| to_image_exif(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_lazy_from_file(path: String) -> Result<ImageExif, MediaInfoError> {
    read_exif_iter(path).map(from_exif_iter).map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_lazy_from_bytes(data: Vec<u8>) -> Result<ImageExif, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_exif(source)
        .map(from_exif_iter)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_video_metadata_from_file(path: String) -> Result<VideoTrack, MediaInfoError> {
    read_track(path)
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_video_metadata_from_bytes(data: Vec<u8>) -> Result<VideoTrack, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_track(source)
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_full_image_metadata_from_file(
    path: String,
) -> Result<FullImageMetadata, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .parse_image_metadata(source)
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_full_image_metadata_from_bytes(
    data: Vec<u8>,
) -> Result<FullImageMetadata, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_image_metadata(source)
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn detect_media_kind_from_file(path: String) -> Result<MediaKind, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    Ok(to_media_kind(source.kind()))
}

#[flutter_rust_bridge::frb(sync)]
pub fn detect_media_kind_from_bytes(data: Vec<u8>) -> Result<MediaKind, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    Ok(to_media_kind(source.kind()))
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_embedded_video_from_file(path: String) -> Result<VideoTrack, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .parse_track(source)
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_embedded_video_from_bytes(data: Vec<u8>) -> Result<VideoTrack, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_track(source)
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}
