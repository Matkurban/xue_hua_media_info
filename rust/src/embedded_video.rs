use std::io::Cursor;

use nom_exif::{MediaParser, MediaSource, TrackInfo};

use crate::api::types::{MediaInfoError, MediaInfoErrorCode};
use crate::convert::map_error;

/// Extract embedded MP4 track metadata from a Motion Photo file path.
///
/// Uses nom-exif streaming mode so JPEG Motion Photo trailers are located.
pub fn parse_embedded_video_from_file(path: String) -> Result<TrackInfo, MediaInfoError> {
    let mut parser = MediaParser::new();
    parse_embedded_video_from_file_with_parser(&mut parser, path)
}

/// Extract embedded MP4 track metadata from Motion Photo bytes.
///
/// `MediaSource::from_memory` rejects image MIME in `parse_track`; a seekable
/// in-memory cursor uses streaming mode and triggers Motion Photo trailer parsing.
pub fn parse_embedded_video_from_bytes(data: Vec<u8>) -> Result<TrackInfo, MediaInfoError> {
    let mut parser = MediaParser::new();
    parse_embedded_video_from_bytes_with_parser(&mut parser, data)
}

pub fn parse_embedded_video_from_file_with_parser(
    parser: &mut MediaParser,
    path: String,
) -> Result<TrackInfo, MediaInfoError> {
    let source = MediaSource::open(path).map_err(map_error)?;
    parser.parse_track(source).map_err(map_error)
}

pub fn parse_embedded_video_from_bytes_with_parser(
    parser: &mut MediaParser,
    data: Vec<u8>,
) -> Result<TrackInfo, MediaInfoError> {
    let cursor = Cursor::new(data);
    let source = MediaSource::seekable(cursor).map_err(map_error)?;
    parser.parse_track(source).map_err(map_error)
}

pub async fn parse_embedded_video_from_file_async(
    path: String,
) -> Result<TrackInfo, MediaInfoError> {
    tokio::task::spawn_blocking(move || parse_embedded_video_from_file(path))
        .await
        .map_err(join_error)?
}

pub async fn parse_embedded_video_from_bytes_async(
    data: Vec<u8>,
) -> Result<TrackInfo, MediaInfoError> {
    tokio::task::spawn_blocking(move || parse_embedded_video_from_bytes(data))
        .await
        .map_err(join_error)?
}

fn join_error(err: tokio::task::JoinError) -> MediaInfoError {
    MediaInfoError {
        code: MediaInfoErrorCode::Other,
        message: format!("embedded video task failed: {err}"),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn fixture_path(name: &str) -> String {
        format!("../example/assets/testdata/{name}")
    }

    #[test]
    fn extracts_motion_photo_trailer_from_bytes() {
        let data = std::fs::read(fixture_path("motion_photo_pixel_synth.jpg"))
            .expect("motion photo fixture should exist");
        let track = parse_embedded_video_from_bytes(data).expect("bytes path should parse trailer");
        assert!(
            !track.iter().collect::<Vec<_>>().is_empty(),
            "trailer should yield track metadata entries"
        );
    }

    #[test]
    fn extracts_motion_photo_trailer_from_file() {
        let path = fixture_path("motion_photo_pixel_synth.jpg");
        let track = parse_embedded_video_from_file(path).expect("file path should parse trailer");
        assert!(!track.iter().collect::<Vec<_>>().is_empty());
    }

    #[test]
    fn plain_jpeg_bytes_returns_track_not_found() {
        let data = std::fs::read(fixture_path("exif.jpg")).expect("exif.jpg fixture should exist");
        let err = parse_embedded_video_from_bytes(data).unwrap_err();
        assert!(
            matches!(err.code, MediaInfoErrorCode::TrackNotFound),
            "expected TrackNotFound, got {:?}",
            err
        );
    }
}
