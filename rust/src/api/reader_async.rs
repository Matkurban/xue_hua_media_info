use nom_exif::{
    AsyncMediaSource, read_exif_async, read_exif_iter_async, read_metadata_async, read_track_async,
};

use super::types::*;
use crate::convert::{
    from_exif_iter, map_error, to_full_image_metadata, to_image_exif, to_media_kind,
    to_media_metadata, to_video_track,
};

#[flutter_rust_bridge::frb]
pub async fn read_media_metadata_from_file_async(
    path: String,
) -> Result<MediaMetadata, MediaInfoError> {
    read_metadata_async(path)
        .await
        .map(to_media_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_media_metadata_from_bytes_async(
    data: Vec<u8>,
) -> Result<MediaMetadata, MediaInfoError> {
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    let mut parser = nom_exif::MediaParser::new();
    let metadata = match source.kind() {
        nom_exif::MediaKind::Image => parser
            .parse_exif_async(source)
            .await
            .map(|iter| nom_exif::Metadata::Exif(iter.into()))
            .map_err(map_error)?,
        nom_exif::MediaKind::Track => parser
            .parse_track_async(source)
            .await
            .map(nom_exif::Metadata::Track)
            .map_err(map_error)?,
    };
    Ok(to_media_metadata(metadata))
}

#[flutter_rust_bridge::frb]
pub async fn read_image_exif_from_file_async(path: String) -> Result<ImageExif, MediaInfoError> {
    read_exif_async(path)
        .await
        .map(|exif| to_image_exif(&exif))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_image_exif_from_bytes_async(data: Vec<u8>) -> Result<ImageExif, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_exif_async(source)
        .await
        .map(|iter| to_image_exif(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_image_exif_lazy_from_file_async(
    path: String,
) -> Result<ImageExif, MediaInfoError> {
    read_exif_iter_async(path)
        .await
        .map(from_exif_iter)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_image_exif_lazy_from_bytes_async(
    data: Vec<u8>,
) -> Result<ImageExif, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_exif_async(source)
        .await
        .map(from_exif_iter)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_video_metadata_from_file_async(
    path: String,
) -> Result<VideoTrack, MediaInfoError> {
    read_track_async(path)
        .await
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_video_metadata_from_bytes_async(
    data: Vec<u8>,
) -> Result<VideoTrack, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_track_async(source)
        .await
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_full_image_metadata_from_file_async(
    path: String,
) -> Result<FullImageMetadata, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = AsyncMediaSource::open(path).await.map_err(map_error)?;
    parser
        .parse_image_metadata_async(source)
        .await
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn read_full_image_metadata_from_bytes_async(
    data: Vec<u8>,
) -> Result<FullImageMetadata, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_image_metadata_async(source)
        .await
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn detect_media_kind_from_file_async(path: String) -> Result<MediaKind, MediaInfoError> {
    let source = AsyncMediaSource::open(path).await.map_err(map_error)?;
    Ok(to_media_kind(source.kind()))
}

#[flutter_rust_bridge::frb]
pub async fn detect_media_kind_from_bytes_async(
    data: Vec<u8>,
) -> Result<MediaKind, MediaInfoError> {
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    Ok(to_media_kind(source.kind()))
}

#[flutter_rust_bridge::frb]
pub async fn read_embedded_video_from_file_async(
    path: String,
) -> Result<VideoTrack, MediaInfoError> {
    crate::embedded_video::parse_embedded_video_from_file_async(path)
        .await
        .map(|track| to_video_track(&track))
}

#[flutter_rust_bridge::frb]
pub async fn read_embedded_video_from_bytes_async(
    data: Vec<u8>,
) -> Result<VideoTrack, MediaInfoError> {
    crate::embedded_video::parse_embedded_video_from_bytes_async(data)
        .await
        .map(|track| to_video_track(&track))
}
