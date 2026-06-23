#[derive(Debug, Clone)]
pub enum MediaKindDto {
    Image,
    VideoOrAudio,
}

#[derive(Debug, Clone)]
pub enum MediaMetadataDto {
    ImageExif(ImageExifDto),
    VideoTrack(VideoTrackDto),
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
pub struct RationalDto {
    pub numerator: i64,
    pub denominator: i64,
}

#[derive(Debug, Clone)]
pub enum MetadataValueDto {
    Text(String),
    Integer(i64),
    Float(f64),
    Rational(RationalDto),
    SignedRational(RationalDto),
    DateTime(String),
    NaiveDateTime(String),
    Bytes(String),
    RationalArray(Vec<RationalDto>),
    SignedRationalArray(Vec<RationalDto>),
    U8Array(Vec<u8>),
    U16Array(Vec<i32>),
    U32Array(Vec<i64>),
}

#[derive(Debug, Clone)]
pub enum LatitudeRefDto {
    North,
    South,
}

#[derive(Debug, Clone)]
pub enum LongitudeRefDto {
    East,
    West,
}

#[derive(Debug, Clone)]
pub enum AltitudeRefDto {
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
pub struct MetadataEntryDto {
    pub tag_name: String,
    pub tag_code: i32,
    pub ifd_index: i32,
    pub value_kind: MetadataValueKind,
    pub display_value: String,
    pub raw_value: Option<MetadataValueDto>,
}

#[derive(Debug, Clone)]
pub struct ParseErrorDto {
    pub ifd_index: i32,
    pub tag_name: String,
    pub tag_code: i32,
    pub message: String,
}

#[derive(Debug, Clone)]
pub struct GpsLocationDto {
    pub latitude: Option<f64>,
    pub longitude: Option<f64>,
    pub altitude_meters: Option<f64>,
    pub latitude_ref: LatitudeRefDto,
    pub longitude_ref: LongitudeRefDto,
    pub altitude_ref: AltitudeRefDto,
    pub iso6709: String,
}

#[derive(Debug, Clone)]
pub struct ImageExifDto {
    pub entries: Vec<MetadataEntryDto>,
    pub gps: Option<GpsLocationDto>,
    pub has_embedded_video: bool,
    pub parse_errors: Vec<ParseErrorDto>,
}

#[derive(Debug, Clone)]
pub struct VideoTrackDto {
    pub entries: Vec<MetadataEntryDto>,
    pub gps: Option<GpsLocationDto>,
    pub parse_errors: Vec<ParseErrorDto>,
}

#[derive(Debug, Clone)]
pub struct PngTextMetadataDto {
    pub key: String,
    pub value: String,
}

#[derive(Debug, Clone)]
pub struct FullImageMetadataDto {
    pub exif: Option<ImageExifDto>,
    pub png_text_chunks: Vec<PngTextMetadataDto>,
}
