use nom_exif::AsyncMediaSource;

use super::parser::MediaMetadataParser;
use super::types::*;
use crate::convert::{map_error, to_full_image_metadata, to_image_exif, to_video_track};

#[flutter_rust_bridge::frb]
pub async fn parse_image_exif_from_file_async(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<ImageExif, MediaInfoError> {
    let source = AsyncMediaSource::open(path).await.map_err(map_error)?;
    parser
        .inner
        .parse_exif_async(source)
        .await
        .map(|iter| to_image_exif(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn parse_image_exif_from_bytes_async(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<ImageExif, MediaInfoError> {
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_exif_async(source)
        .await
        .map(|iter| to_image_exif(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn parse_video_metadata_from_file_async(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<VideoTrack, MediaInfoError> {
    let source = AsyncMediaSource::open(path).await.map_err(map_error)?;
    parser
        .inner
        .parse_track_async(source)
        .await
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn parse_video_metadata_from_bytes_async(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<VideoTrack, MediaInfoError> {
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_track_async(source)
        .await
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn parse_full_image_metadata_from_file_async(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<FullImageMetadata, MediaInfoError> {
    let source = AsyncMediaSource::open(path).await.map_err(map_error)?;
    parser
        .inner
        .parse_image_metadata_async(source)
        .await
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn parse_full_image_metadata_from_bytes_async(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<FullImageMetadata, MediaInfoError> {
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_image_metadata_async(source)
        .await
        .map(to_full_image_metadata)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn parse_embedded_video_from_file_async(
    parser: &mut MediaMetadataParser,
    path: String,
) -> Result<VideoTrack, MediaInfoError> {
    let source = AsyncMediaSource::open(path).await.map_err(map_error)?;
    parser
        .inner
        .parse_track_async(source)
        .await
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb]
pub async fn parse_embedded_video_from_bytes_async(
    parser: &mut MediaMetadataParser,
    data: Vec<u8>,
) -> Result<VideoTrack, MediaInfoError> {
    let source = AsyncMediaSource::from_memory(data).map_err(map_error)?;
    parser
        .inner
        .parse_track_async(source)
        .await
        .map(|track| to_video_track(&track))
        .map_err(map_error)
}
