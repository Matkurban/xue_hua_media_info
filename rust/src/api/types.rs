#[derive(Debug, Clone)]
pub enum MediaKind {
    Image,
    VideoOrAudio,
}

#[derive(Debug, Clone)]
pub enum MediaMetadata {
    ImageExif(ImageExif),
    VideoTrack(VideoTrack),
}

#[derive(Debug, Clone)]
pub enum MetadataValueKind {
    Text,
    Integer,
    Float,
    Rational,
    SignedRational,
    DateTime,
    NaiveDateTime,
    Bytes,
    RationalArray,
    SignedRationalArray,
    U8Array,
    U16Array,
    U32Array,
}

#[derive(Debug, Clone)]
pub struct Rational {
    pub numerator: i64,
    pub denominator: i64,
}

#[derive(Debug, Clone)]
pub enum MetadataValue {
    Text(String),
    Integer(i64),
    Float(f64),
    Rational(Rational),
    SignedRational(Rational),
    DateTime(String),
    NaiveDateTime(String),
    Bytes(String),
    RationalArray(Vec<Rational>),
    SignedRationalArray(Vec<Rational>),
    U8Array(Vec<u8>),
    U16Array(Vec<i32>),
    U32Array(Vec<i64>),
}

#[derive(Debug, Clone)]
pub enum LatitudeRef {
    North,
    South,
}

#[derive(Debug, Clone)]
pub enum LongitudeRef {
    East,
    West,
}

#[derive(Debug, Clone)]
pub enum AltitudeRef {
    Unknown,
    AboveSeaLevel,
    BelowSeaLevel,
}

#[derive(Debug, Clone)]
pub enum MediaInfoErrorCode {
    Io,
    UnsupportedFormat,
    ExifNotFound,
    TrackNotFound,
    Malformed,
    UnexpectedEof,
    Other,
}

#[derive(Debug, Clone)]
pub struct MediaInfoError {
    pub code: MediaInfoErrorCode,
    pub message: String,
}

#[derive(Debug, Clone)]
pub struct MetadataEntry {
    pub tag_name: String,
    pub tag_code: i32,
    pub ifd_index: i32,
    pub value_kind: MetadataValueKind,
    pub display_value: String,
    pub raw_value: Option<MetadataValue>,
}

#[derive(Debug, Clone)]
pub struct ParseError {
    pub ifd_index: i32,
    pub tag_name: String,
    pub tag_code: i32,
    pub message: String,
}

#[derive(Debug, Clone)]
pub struct GpsLocation {
    pub latitude: Option<f64>,
    pub longitude: Option<f64>,
    pub altitude_meters: Option<f64>,
    pub latitude_ref: LatitudeRef,
    pub longitude_ref: LongitudeRef,
    pub altitude_ref: AltitudeRef,
    pub iso6709: String,
}

#[derive(Debug, Clone)]
pub struct ImageExif {
    pub entries: Vec<MetadataEntry>,
    pub gps: Option<GpsLocation>,
    pub has_embedded_video: bool,
    pub parse_errors: Vec<ParseError>,
}

#[derive(Debug, Clone)]
pub struct VideoTrack {
    pub entries: Vec<MetadataEntry>,
    pub gps: Option<GpsLocation>,
    pub parse_errors: Vec<ParseError>,
}

#[derive(Debug, Clone)]
pub struct PngTextMetadata {
    pub key: String,
    pub value: String,
}

#[derive(Debug, Clone)]
pub struct FullImageMetadata {
    pub exif: Option<ImageExif>,
    pub png_text_chunks: Vec<PngTextMetadata>,
}
