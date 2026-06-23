use nom_exif::{read_exif, read_exif_iter, read_metadata, read_track, ExifIter, MediaSource};

use crate::convert::{
    exif_iter_to_dto, exif_to_dto, image_format_metadata_to_png, map_error, media_kind_to_dto,
    metadata_to_dto, track_to_dto,
};
use super::types::*;

#[flutter_rust_bridge::frb(sync)]
pub fn read_media_metadata_from_file(path: String) -> Result<MediaMetadataDto, MediaInfoError> {
    read_metadata(path).map(metadata_to_dto).map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_media_metadata_from_bytes(data: Vec<u8>) -> Result<MediaMetadataDto, MediaInfoError> {
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
    Ok(metadata_to_dto(metadata))
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_from_file(path: String) -> Result<ImageExifDto, MediaInfoError> {
    read_exif(path).map(|exif| exif_to_dto(&exif)).map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_from_bytes(data: Vec<u8>) -> Result<ImageExifDto, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_exif(source)
        .map(|iter| exif_to_dto(&iter.into()))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_lazy_from_file(path: String) -> Result<ImageExifDto, MediaInfoError> {
    read_exif_iter(path)
        .map(exif_iter_to_dto)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_image_exif_lazy_from_bytes(data: Vec<u8>) -> Result<ImageExifDto, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_exif(source)
        .map(exif_iter_to_dto)
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_video_metadata_from_file(path: String) -> Result<VideoTrackDto, MediaInfoError> {
    read_track(path)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_video_metadata_from_bytes(data: Vec<u8>) -> Result<VideoTrackDto, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_track(source)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_full_image_metadata_from_file(
    path: String,
) -> Result<FullImageMetadataDto, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::open(path).map_err(map_error)?;
    let image_metadata = parser
        .parse_image_metadata(source)
        .map_err(map_error)?;
    Ok(full_image_metadata_to_dto(image_metadata))
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_full_image_metadata_from_bytes(
    data: Vec<u8>,
) -> Result<FullImageMetadataDto, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    let image_metadata = parser
        .parse_image_metadata(source)
        .map_err(map_error)?;
    Ok(full_image_metadata_to_dto(image_metadata))
}

#[flutter_rust_bridge::frb(sync)]
pub fn detect_media_kind_from_file(path: String) -> Result<MediaKindDto, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    Ok(media_kind_to_dto(source.kind()))
}

#[flutter_rust_bridge::frb(sync)]
pub fn detect_media_kind_from_bytes(data: Vec<u8>) -> Result<MediaKindDto, MediaInfoError> {
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    Ok(media_kind_to_dto(source.kind()))
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_embedded_video_from_file(path: String) -> Result<VideoTrackDto, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::open(path).map_err(map_error)?;
    parser
        .parse_track(source)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_embedded_video_from_bytes(data: Vec<u8>) -> Result<VideoTrackDto, MediaInfoError> {
    let mut parser = nom_exif::MediaParser::new();
    let source = MediaSource::from_memory(data).map_err(map_error)?;
    parser
        .parse_track(source)
        .map(|track| track_to_dto(&track))
        .map_err(map_error)
}

fn full_image_metadata_to_dto(
    image_metadata: nom_exif::ImageMetadata<ExifIter>,
) -> FullImageMetadataDto {
    FullImageMetadataDto {
        exif: image_metadata
            .exif
            .map(|exif| exif_to_dto(&exif.into())),
        png_text_chunks: image_format_metadata_to_png(image_metadata.format),
    }
}
