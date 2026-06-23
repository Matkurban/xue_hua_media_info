// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MediaMetadataDto {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageExifDto field0) imageExif,
    required TResult Function(VideoTrackDto field0) videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageExifDto field0)? imageExif,
    TResult? Function(VideoTrackDto field0)? videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageExifDto field0)? imageExif,
    TResult Function(VideoTrackDto field0)? videoTrack,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MediaMetadataDto_ImageExif value) imageExif,
    required TResult Function(MediaMetadataDto_VideoTrack value) videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MediaMetadataDto_ImageExif value)? imageExif,
    TResult? Function(MediaMetadataDto_VideoTrack value)? videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MediaMetadataDto_ImageExif value)? imageExif,
    TResult Function(MediaMetadataDto_VideoTrack value)? videoTrack,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaMetadataDtoCopyWith<$Res> {
  factory $MediaMetadataDtoCopyWith(
    MediaMetadataDto value,
    $Res Function(MediaMetadataDto) then,
  ) = _$MediaMetadataDtoCopyWithImpl<$Res, MediaMetadataDto>;
}

/// @nodoc
class _$MediaMetadataDtoCopyWithImpl<$Res, $Val extends MediaMetadataDto>
    implements $MediaMetadataDtoCopyWith<$Res> {
  _$MediaMetadataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaMetadataDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MediaMetadataDto_ImageExifImplCopyWith<$Res> {
  factory _$$MediaMetadataDto_ImageExifImplCopyWith(
    _$MediaMetadataDto_ImageExifImpl value,
    $Res Function(_$MediaMetadataDto_ImageExifImpl) then,
  ) = __$$MediaMetadataDto_ImageExifImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ImageExifDto field0});
}

/// @nodoc
class __$$MediaMetadataDto_ImageExifImplCopyWithImpl<$Res>
    extends
        _$MediaMetadataDtoCopyWithImpl<$Res, _$MediaMetadataDto_ImageExifImpl>
    implements _$$MediaMetadataDto_ImageExifImplCopyWith<$Res> {
  __$$MediaMetadataDto_ImageExifImplCopyWithImpl(
    _$MediaMetadataDto_ImageExifImpl _value,
    $Res Function(_$MediaMetadataDto_ImageExifImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MediaMetadataDto_ImageExifImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as ImageExifDto,
      ),
    );
  }
}

/// @nodoc

class _$MediaMetadataDto_ImageExifImpl extends MediaMetadataDto_ImageExif {
  const _$MediaMetadataDto_ImageExifImpl(this.field0) : super._();

  @override
  final ImageExifDto field0;

  @override
  String toString() {
    return 'MediaMetadataDto.imageExif(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaMetadataDto_ImageExifImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MediaMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaMetadataDto_ImageExifImplCopyWith<_$MediaMetadataDto_ImageExifImpl>
  get copyWith =>
      __$$MediaMetadataDto_ImageExifImplCopyWithImpl<
        _$MediaMetadataDto_ImageExifImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageExifDto field0) imageExif,
    required TResult Function(VideoTrackDto field0) videoTrack,
  }) {
    return imageExif(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageExifDto field0)? imageExif,
    TResult? Function(VideoTrackDto field0)? videoTrack,
  }) {
    return imageExif?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageExifDto field0)? imageExif,
    TResult Function(VideoTrackDto field0)? videoTrack,
    required TResult orElse(),
  }) {
    if (imageExif != null) {
      return imageExif(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MediaMetadataDto_ImageExif value) imageExif,
    required TResult Function(MediaMetadataDto_VideoTrack value) videoTrack,
  }) {
    return imageExif(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MediaMetadataDto_ImageExif value)? imageExif,
    TResult? Function(MediaMetadataDto_VideoTrack value)? videoTrack,
  }) {
    return imageExif?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MediaMetadataDto_ImageExif value)? imageExif,
    TResult Function(MediaMetadataDto_VideoTrack value)? videoTrack,
    required TResult orElse(),
  }) {
    if (imageExif != null) {
      return imageExif(this);
    }
    return orElse();
  }
}

abstract class MediaMetadataDto_ImageExif extends MediaMetadataDto {
  const factory MediaMetadataDto_ImageExif(final ImageExifDto field0) =
      _$MediaMetadataDto_ImageExifImpl;
  const MediaMetadataDto_ImageExif._() : super._();

  @override
  ImageExifDto get field0;

  /// Create a copy of MediaMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaMetadataDto_ImageExifImplCopyWith<_$MediaMetadataDto_ImageExifImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MediaMetadataDto_VideoTrackImplCopyWith<$Res> {
  factory _$$MediaMetadataDto_VideoTrackImplCopyWith(
    _$MediaMetadataDto_VideoTrackImpl value,
    $Res Function(_$MediaMetadataDto_VideoTrackImpl) then,
  ) = __$$MediaMetadataDto_VideoTrackImplCopyWithImpl<$Res>;
  @useResult
  $Res call({VideoTrackDto field0});
}

/// @nodoc
class __$$MediaMetadataDto_VideoTrackImplCopyWithImpl<$Res>
    extends
        _$MediaMetadataDtoCopyWithImpl<$Res, _$MediaMetadataDto_VideoTrackImpl>
    implements _$$MediaMetadataDto_VideoTrackImplCopyWith<$Res> {
  __$$MediaMetadataDto_VideoTrackImplCopyWithImpl(
    _$MediaMetadataDto_VideoTrackImpl _value,
    $Res Function(_$MediaMetadataDto_VideoTrackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MediaMetadataDto_VideoTrackImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as VideoTrackDto,
      ),
    );
  }
}

/// @nodoc

class _$MediaMetadataDto_VideoTrackImpl extends MediaMetadataDto_VideoTrack {
  const _$MediaMetadataDto_VideoTrackImpl(this.field0) : super._();

  @override
  final VideoTrackDto field0;

  @override
  String toString() {
    return 'MediaMetadataDto.videoTrack(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaMetadataDto_VideoTrackImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MediaMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaMetadataDto_VideoTrackImplCopyWith<_$MediaMetadataDto_VideoTrackImpl>
  get copyWith =>
      __$$MediaMetadataDto_VideoTrackImplCopyWithImpl<
        _$MediaMetadataDto_VideoTrackImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageExifDto field0) imageExif,
    required TResult Function(VideoTrackDto field0) videoTrack,
  }) {
    return videoTrack(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageExifDto field0)? imageExif,
    TResult? Function(VideoTrackDto field0)? videoTrack,
  }) {
    return videoTrack?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageExifDto field0)? imageExif,
    TResult Function(VideoTrackDto field0)? videoTrack,
    required TResult orElse(),
  }) {
    if (videoTrack != null) {
      return videoTrack(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MediaMetadataDto_ImageExif value) imageExif,
    required TResult Function(MediaMetadataDto_VideoTrack value) videoTrack,
  }) {
    return videoTrack(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MediaMetadataDto_ImageExif value)? imageExif,
    TResult? Function(MediaMetadataDto_VideoTrack value)? videoTrack,
  }) {
    return videoTrack?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MediaMetadataDto_ImageExif value)? imageExif,
    TResult Function(MediaMetadataDto_VideoTrack value)? videoTrack,
    required TResult orElse(),
  }) {
    if (videoTrack != null) {
      return videoTrack(this);
    }
    return orElse();
  }
}

abstract class MediaMetadataDto_VideoTrack extends MediaMetadataDto {
  const factory MediaMetadataDto_VideoTrack(final VideoTrackDto field0) =
      _$MediaMetadataDto_VideoTrackImpl;
  const MediaMetadataDto_VideoTrack._() : super._();

  @override
  VideoTrackDto get field0;

  /// Create a copy of MediaMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaMetadataDto_VideoTrackImplCopyWith<_$MediaMetadataDto_VideoTrackImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MetadataValueDto {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataValueDtoCopyWith<$Res> {
  factory $MetadataValueDtoCopyWith(
    MetadataValueDto value,
    $Res Function(MetadataValueDto) then,
  ) = _$MetadataValueDtoCopyWithImpl<$Res, MetadataValueDto>;
}

/// @nodoc
class _$MetadataValueDtoCopyWithImpl<$Res, $Val extends MetadataValueDto>
    implements $MetadataValueDtoCopyWith<$Res> {
  _$MetadataValueDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MetadataValueDto_TextImplCopyWith<$Res> {
  factory _$$MetadataValueDto_TextImplCopyWith(
    _$MetadataValueDto_TextImpl value,
    $Res Function(_$MetadataValueDto_TextImpl) then,
  ) = __$$MetadataValueDto_TextImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValueDto_TextImplCopyWithImpl<$Res>
    extends _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_TextImpl>
    implements _$$MetadataValueDto_TextImplCopyWith<$Res> {
  __$$MetadataValueDto_TextImplCopyWithImpl(
    _$MetadataValueDto_TextImpl _value,
    $Res Function(_$MetadataValueDto_TextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_TextImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_TextImpl extends MetadataValueDto_Text {
  const _$MetadataValueDto_TextImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValueDto.text(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_TextImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_TextImplCopyWith<_$MetadataValueDto_TextImpl>
  get copyWith =>
      __$$MetadataValueDto_TextImplCopyWithImpl<_$MetadataValueDto_TextImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return text(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return text?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_Text extends MetadataValueDto {
  const factory MetadataValueDto_Text(final String field0) =
      _$MetadataValueDto_TextImpl;
  const MetadataValueDto_Text._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_TextImplCopyWith<_$MetadataValueDto_TextImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_IntegerImplCopyWith<$Res> {
  factory _$$MetadataValueDto_IntegerImplCopyWith(
    _$MetadataValueDto_IntegerImpl value,
    $Res Function(_$MetadataValueDto_IntegerImpl) then,
  ) = __$$MetadataValueDto_IntegerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$MetadataValueDto_IntegerImplCopyWithImpl<$Res>
    extends _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_IntegerImpl>
    implements _$$MetadataValueDto_IntegerImplCopyWith<$Res> {
  __$$MetadataValueDto_IntegerImplCopyWithImpl(
    _$MetadataValueDto_IntegerImpl _value,
    $Res Function(_$MetadataValueDto_IntegerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_IntegerImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_IntegerImpl extends MetadataValueDto_Integer {
  const _$MetadataValueDto_IntegerImpl(this.field0) : super._();

  @override
  final int field0;

  @override
  String toString() {
    return 'MetadataValueDto.integer(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_IntegerImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_IntegerImplCopyWith<_$MetadataValueDto_IntegerImpl>
  get copyWith =>
      __$$MetadataValueDto_IntegerImplCopyWithImpl<
        _$MetadataValueDto_IntegerImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return integer(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return integer?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return integer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return integer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_Integer extends MetadataValueDto {
  const factory MetadataValueDto_Integer(final int field0) =
      _$MetadataValueDto_IntegerImpl;
  const MetadataValueDto_Integer._() : super._();

  @override
  int get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_IntegerImplCopyWith<_$MetadataValueDto_IntegerImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_FloatImplCopyWith<$Res> {
  factory _$$MetadataValueDto_FloatImplCopyWith(
    _$MetadataValueDto_FloatImpl value,
    $Res Function(_$MetadataValueDto_FloatImpl) then,
  ) = __$$MetadataValueDto_FloatImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$MetadataValueDto_FloatImplCopyWithImpl<$Res>
    extends _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_FloatImpl>
    implements _$$MetadataValueDto_FloatImplCopyWith<$Res> {
  __$$MetadataValueDto_FloatImplCopyWithImpl(
    _$MetadataValueDto_FloatImpl _value,
    $Res Function(_$MetadataValueDto_FloatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_FloatImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_FloatImpl extends MetadataValueDto_Float {
  const _$MetadataValueDto_FloatImpl(this.field0) : super._();

  @override
  final double field0;

  @override
  String toString() {
    return 'MetadataValueDto.float(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_FloatImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_FloatImplCopyWith<_$MetadataValueDto_FloatImpl>
  get copyWith =>
      __$$MetadataValueDto_FloatImplCopyWithImpl<_$MetadataValueDto_FloatImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return float(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return float?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (float != null) {
      return float(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return float(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return float?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (float != null) {
      return float(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_Float extends MetadataValueDto {
  const factory MetadataValueDto_Float(final double field0) =
      _$MetadataValueDto_FloatImpl;
  const MetadataValueDto_Float._() : super._();

  @override
  double get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_FloatImplCopyWith<_$MetadataValueDto_FloatImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_RationalImplCopyWith<$Res> {
  factory _$$MetadataValueDto_RationalImplCopyWith(
    _$MetadataValueDto_RationalImpl value,
    $Res Function(_$MetadataValueDto_RationalImpl) then,
  ) = __$$MetadataValueDto_RationalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RationalDto field0});
}

/// @nodoc
class __$$MetadataValueDto_RationalImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_RationalImpl>
    implements _$$MetadataValueDto_RationalImplCopyWith<$Res> {
  __$$MetadataValueDto_RationalImplCopyWithImpl(
    _$MetadataValueDto_RationalImpl _value,
    $Res Function(_$MetadataValueDto_RationalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_RationalImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as RationalDto,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_RationalImpl extends MetadataValueDto_Rational {
  const _$MetadataValueDto_RationalImpl(this.field0) : super._();

  @override
  final RationalDto field0;

  @override
  String toString() {
    return 'MetadataValueDto.rational(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_RationalImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_RationalImplCopyWith<_$MetadataValueDto_RationalImpl>
  get copyWith =>
      __$$MetadataValueDto_RationalImplCopyWithImpl<
        _$MetadataValueDto_RationalImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return rational(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return rational?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (rational != null) {
      return rational(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return rational(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return rational?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (rational != null) {
      return rational(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_Rational extends MetadataValueDto {
  const factory MetadataValueDto_Rational(final RationalDto field0) =
      _$MetadataValueDto_RationalImpl;
  const MetadataValueDto_Rational._() : super._();

  @override
  RationalDto get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_RationalImplCopyWith<_$MetadataValueDto_RationalImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_SignedRationalImplCopyWith<$Res> {
  factory _$$MetadataValueDto_SignedRationalImplCopyWith(
    _$MetadataValueDto_SignedRationalImpl value,
    $Res Function(_$MetadataValueDto_SignedRationalImpl) then,
  ) = __$$MetadataValueDto_SignedRationalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({RationalDto field0});
}

/// @nodoc
class __$$MetadataValueDto_SignedRationalImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<
          $Res,
          _$MetadataValueDto_SignedRationalImpl
        >
    implements _$$MetadataValueDto_SignedRationalImplCopyWith<$Res> {
  __$$MetadataValueDto_SignedRationalImplCopyWithImpl(
    _$MetadataValueDto_SignedRationalImpl _value,
    $Res Function(_$MetadataValueDto_SignedRationalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_SignedRationalImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as RationalDto,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_SignedRationalImpl
    extends MetadataValueDto_SignedRational {
  const _$MetadataValueDto_SignedRationalImpl(this.field0) : super._();

  @override
  final RationalDto field0;

  @override
  String toString() {
    return 'MetadataValueDto.signedRational(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_SignedRationalImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_SignedRationalImplCopyWith<
    _$MetadataValueDto_SignedRationalImpl
  >
  get copyWith =>
      __$$MetadataValueDto_SignedRationalImplCopyWithImpl<
        _$MetadataValueDto_SignedRationalImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return signedRational(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return signedRational?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (signedRational != null) {
      return signedRational(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return signedRational(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return signedRational?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (signedRational != null) {
      return signedRational(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_SignedRational extends MetadataValueDto {
  const factory MetadataValueDto_SignedRational(final RationalDto field0) =
      _$MetadataValueDto_SignedRationalImpl;
  const MetadataValueDto_SignedRational._() : super._();

  @override
  RationalDto get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_SignedRationalImplCopyWith<
    _$MetadataValueDto_SignedRationalImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_DateTimeImplCopyWith<$Res> {
  factory _$$MetadataValueDto_DateTimeImplCopyWith(
    _$MetadataValueDto_DateTimeImpl value,
    $Res Function(_$MetadataValueDto_DateTimeImpl) then,
  ) = __$$MetadataValueDto_DateTimeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValueDto_DateTimeImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_DateTimeImpl>
    implements _$$MetadataValueDto_DateTimeImplCopyWith<$Res> {
  __$$MetadataValueDto_DateTimeImplCopyWithImpl(
    _$MetadataValueDto_DateTimeImpl _value,
    $Res Function(_$MetadataValueDto_DateTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_DateTimeImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_DateTimeImpl extends MetadataValueDto_DateTime {
  const _$MetadataValueDto_DateTimeImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValueDto.dateTime(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_DateTimeImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_DateTimeImplCopyWith<_$MetadataValueDto_DateTimeImpl>
  get copyWith =>
      __$$MetadataValueDto_DateTimeImplCopyWithImpl<
        _$MetadataValueDto_DateTimeImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return dateTime(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return dateTime?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (dateTime != null) {
      return dateTime(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return dateTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return dateTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (dateTime != null) {
      return dateTime(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_DateTime extends MetadataValueDto {
  const factory MetadataValueDto_DateTime(final String field0) =
      _$MetadataValueDto_DateTimeImpl;
  const MetadataValueDto_DateTime._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_DateTimeImplCopyWith<_$MetadataValueDto_DateTimeImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_NaiveDateTimeImplCopyWith<$Res> {
  factory _$$MetadataValueDto_NaiveDateTimeImplCopyWith(
    _$MetadataValueDto_NaiveDateTimeImpl value,
    $Res Function(_$MetadataValueDto_NaiveDateTimeImpl) then,
  ) = __$$MetadataValueDto_NaiveDateTimeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValueDto_NaiveDateTimeImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<
          $Res,
          _$MetadataValueDto_NaiveDateTimeImpl
        >
    implements _$$MetadataValueDto_NaiveDateTimeImplCopyWith<$Res> {
  __$$MetadataValueDto_NaiveDateTimeImplCopyWithImpl(
    _$MetadataValueDto_NaiveDateTimeImpl _value,
    $Res Function(_$MetadataValueDto_NaiveDateTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_NaiveDateTimeImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_NaiveDateTimeImpl
    extends MetadataValueDto_NaiveDateTime {
  const _$MetadataValueDto_NaiveDateTimeImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValueDto.naiveDateTime(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_NaiveDateTimeImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_NaiveDateTimeImplCopyWith<
    _$MetadataValueDto_NaiveDateTimeImpl
  >
  get copyWith =>
      __$$MetadataValueDto_NaiveDateTimeImplCopyWithImpl<
        _$MetadataValueDto_NaiveDateTimeImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return naiveDateTime(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return naiveDateTime?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (naiveDateTime != null) {
      return naiveDateTime(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return naiveDateTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return naiveDateTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (naiveDateTime != null) {
      return naiveDateTime(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_NaiveDateTime extends MetadataValueDto {
  const factory MetadataValueDto_NaiveDateTime(final String field0) =
      _$MetadataValueDto_NaiveDateTimeImpl;
  const MetadataValueDto_NaiveDateTime._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_NaiveDateTimeImplCopyWith<
    _$MetadataValueDto_NaiveDateTimeImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_BytesImplCopyWith<$Res> {
  factory _$$MetadataValueDto_BytesImplCopyWith(
    _$MetadataValueDto_BytesImpl value,
    $Res Function(_$MetadataValueDto_BytesImpl) then,
  ) = __$$MetadataValueDto_BytesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValueDto_BytesImplCopyWithImpl<$Res>
    extends _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_BytesImpl>
    implements _$$MetadataValueDto_BytesImplCopyWith<$Res> {
  __$$MetadataValueDto_BytesImplCopyWithImpl(
    _$MetadataValueDto_BytesImpl _value,
    $Res Function(_$MetadataValueDto_BytesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_BytesImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_BytesImpl extends MetadataValueDto_Bytes {
  const _$MetadataValueDto_BytesImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValueDto.bytes(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_BytesImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_BytesImplCopyWith<_$MetadataValueDto_BytesImpl>
  get copyWith =>
      __$$MetadataValueDto_BytesImplCopyWithImpl<_$MetadataValueDto_BytesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return bytes(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return bytes?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (bytes != null) {
      return bytes(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return bytes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return bytes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (bytes != null) {
      return bytes(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_Bytes extends MetadataValueDto {
  const factory MetadataValueDto_Bytes(final String field0) =
      _$MetadataValueDto_BytesImpl;
  const MetadataValueDto_Bytes._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_BytesImplCopyWith<_$MetadataValueDto_BytesImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_RationalArrayImplCopyWith<$Res> {
  factory _$$MetadataValueDto_RationalArrayImplCopyWith(
    _$MetadataValueDto_RationalArrayImpl value,
    $Res Function(_$MetadataValueDto_RationalArrayImpl) then,
  ) = __$$MetadataValueDto_RationalArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<RationalDto> field0});
}

/// @nodoc
class __$$MetadataValueDto_RationalArrayImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<
          $Res,
          _$MetadataValueDto_RationalArrayImpl
        >
    implements _$$MetadataValueDto_RationalArrayImplCopyWith<$Res> {
  __$$MetadataValueDto_RationalArrayImplCopyWithImpl(
    _$MetadataValueDto_RationalArrayImpl _value,
    $Res Function(_$MetadataValueDto_RationalArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_RationalArrayImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as List<RationalDto>,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_RationalArrayImpl
    extends MetadataValueDto_RationalArray {
  const _$MetadataValueDto_RationalArrayImpl(final List<RationalDto> field0)
    : _field0 = field0,
      super._();

  final List<RationalDto> _field0;
  @override
  List<RationalDto> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'MetadataValueDto.rationalArray(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_RationalArrayImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_RationalArrayImplCopyWith<
    _$MetadataValueDto_RationalArrayImpl
  >
  get copyWith =>
      __$$MetadataValueDto_RationalArrayImplCopyWithImpl<
        _$MetadataValueDto_RationalArrayImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return rationalArray(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return rationalArray?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (rationalArray != null) {
      return rationalArray(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return rationalArray(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return rationalArray?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (rationalArray != null) {
      return rationalArray(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_RationalArray extends MetadataValueDto {
  const factory MetadataValueDto_RationalArray(final List<RationalDto> field0) =
      _$MetadataValueDto_RationalArrayImpl;
  const MetadataValueDto_RationalArray._() : super._();

  @override
  List<RationalDto> get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_RationalArrayImplCopyWith<
    _$MetadataValueDto_RationalArrayImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_SignedRationalArrayImplCopyWith<$Res> {
  factory _$$MetadataValueDto_SignedRationalArrayImplCopyWith(
    _$MetadataValueDto_SignedRationalArrayImpl value,
    $Res Function(_$MetadataValueDto_SignedRationalArrayImpl) then,
  ) = __$$MetadataValueDto_SignedRationalArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<RationalDto> field0});
}

/// @nodoc
class __$$MetadataValueDto_SignedRationalArrayImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<
          $Res,
          _$MetadataValueDto_SignedRationalArrayImpl
        >
    implements _$$MetadataValueDto_SignedRationalArrayImplCopyWith<$Res> {
  __$$MetadataValueDto_SignedRationalArrayImplCopyWithImpl(
    _$MetadataValueDto_SignedRationalArrayImpl _value,
    $Res Function(_$MetadataValueDto_SignedRationalArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_SignedRationalArrayImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as List<RationalDto>,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_SignedRationalArrayImpl
    extends MetadataValueDto_SignedRationalArray {
  const _$MetadataValueDto_SignedRationalArrayImpl(
    final List<RationalDto> field0,
  ) : _field0 = field0,
      super._();

  final List<RationalDto> _field0;
  @override
  List<RationalDto> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'MetadataValueDto.signedRationalArray(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_SignedRationalArrayImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_SignedRationalArrayImplCopyWith<
    _$MetadataValueDto_SignedRationalArrayImpl
  >
  get copyWith =>
      __$$MetadataValueDto_SignedRationalArrayImplCopyWithImpl<
        _$MetadataValueDto_SignedRationalArrayImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return signedRationalArray(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return signedRationalArray?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (signedRationalArray != null) {
      return signedRationalArray(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return signedRationalArray(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return signedRationalArray?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (signedRationalArray != null) {
      return signedRationalArray(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_SignedRationalArray extends MetadataValueDto {
  const factory MetadataValueDto_SignedRationalArray(
    final List<RationalDto> field0,
  ) = _$MetadataValueDto_SignedRationalArrayImpl;
  const MetadataValueDto_SignedRationalArray._() : super._();

  @override
  List<RationalDto> get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_SignedRationalArrayImplCopyWith<
    _$MetadataValueDto_SignedRationalArrayImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_U8ArrayImplCopyWith<$Res> {
  factory _$$MetadataValueDto_U8ArrayImplCopyWith(
    _$MetadataValueDto_U8ArrayImpl value,
    $Res Function(_$MetadataValueDto_U8ArrayImpl) then,
  ) = __$$MetadataValueDto_U8ArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Uint8List field0});
}

/// @nodoc
class __$$MetadataValueDto_U8ArrayImplCopyWithImpl<$Res>
    extends _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_U8ArrayImpl>
    implements _$$MetadataValueDto_U8ArrayImplCopyWith<$Res> {
  __$$MetadataValueDto_U8ArrayImplCopyWithImpl(
    _$MetadataValueDto_U8ArrayImpl _value,
    $Res Function(_$MetadataValueDto_U8ArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_U8ArrayImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Uint8List,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_U8ArrayImpl extends MetadataValueDto_U8Array {
  const _$MetadataValueDto_U8ArrayImpl(this.field0) : super._();

  @override
  final Uint8List field0;

  @override
  String toString() {
    return 'MetadataValueDto.u8Array(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_U8ArrayImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_U8ArrayImplCopyWith<_$MetadataValueDto_U8ArrayImpl>
  get copyWith =>
      __$$MetadataValueDto_U8ArrayImplCopyWithImpl<
        _$MetadataValueDto_U8ArrayImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return u8Array(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return u8Array?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (u8Array != null) {
      return u8Array(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return u8Array(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return u8Array?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (u8Array != null) {
      return u8Array(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_U8Array extends MetadataValueDto {
  const factory MetadataValueDto_U8Array(final Uint8List field0) =
      _$MetadataValueDto_U8ArrayImpl;
  const MetadataValueDto_U8Array._() : super._();

  @override
  Uint8List get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_U8ArrayImplCopyWith<_$MetadataValueDto_U8ArrayImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_U16ArrayImplCopyWith<$Res> {
  factory _$$MetadataValueDto_U16ArrayImplCopyWith(
    _$MetadataValueDto_U16ArrayImpl value,
    $Res Function(_$MetadataValueDto_U16ArrayImpl) then,
  ) = __$$MetadataValueDto_U16ArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Int32List field0});
}

/// @nodoc
class __$$MetadataValueDto_U16ArrayImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_U16ArrayImpl>
    implements _$$MetadataValueDto_U16ArrayImplCopyWith<$Res> {
  __$$MetadataValueDto_U16ArrayImplCopyWithImpl(
    _$MetadataValueDto_U16ArrayImpl _value,
    $Res Function(_$MetadataValueDto_U16ArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_U16ArrayImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Int32List,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_U16ArrayImpl extends MetadataValueDto_U16Array {
  const _$MetadataValueDto_U16ArrayImpl(this.field0) : super._();

  @override
  final Int32List field0;

  @override
  String toString() {
    return 'MetadataValueDto.u16Array(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_U16ArrayImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_U16ArrayImplCopyWith<_$MetadataValueDto_U16ArrayImpl>
  get copyWith =>
      __$$MetadataValueDto_U16ArrayImplCopyWithImpl<
        _$MetadataValueDto_U16ArrayImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return u16Array(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return u16Array?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (u16Array != null) {
      return u16Array(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return u16Array(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return u16Array?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (u16Array != null) {
      return u16Array(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_U16Array extends MetadataValueDto {
  const factory MetadataValueDto_U16Array(final Int32List field0) =
      _$MetadataValueDto_U16ArrayImpl;
  const MetadataValueDto_U16Array._() : super._();

  @override
  Int32List get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_U16ArrayImplCopyWith<_$MetadataValueDto_U16ArrayImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValueDto_U32ArrayImplCopyWith<$Res> {
  factory _$$MetadataValueDto_U32ArrayImplCopyWith(
    _$MetadataValueDto_U32ArrayImpl value,
    $Res Function(_$MetadataValueDto_U32ArrayImpl) then,
  ) = __$$MetadataValueDto_U32ArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Int64List field0});
}

/// @nodoc
class __$$MetadataValueDto_U32ArrayImplCopyWithImpl<$Res>
    extends
        _$MetadataValueDtoCopyWithImpl<$Res, _$MetadataValueDto_U32ArrayImpl>
    implements _$$MetadataValueDto_U32ArrayImplCopyWith<$Res> {
  __$$MetadataValueDto_U32ArrayImplCopyWithImpl(
    _$MetadataValueDto_U32ArrayImpl _value,
    $Res Function(_$MetadataValueDto_U32ArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValueDto_U32ArrayImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Int64List,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValueDto_U32ArrayImpl extends MetadataValueDto_U32Array {
  const _$MetadataValueDto_U32ArrayImpl(this.field0) : super._();

  @override
  final Int64List field0;

  @override
  String toString() {
    return 'MetadataValueDto.u32Array(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValueDto_U32ArrayImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValueDto_U32ArrayImplCopyWith<_$MetadataValueDto_U32ArrayImpl>
  get copyWith =>
      __$$MetadataValueDto_U32ArrayImplCopyWithImpl<
        _$MetadataValueDto_U32ArrayImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(RationalDto field0) rational,
    required TResult Function(RationalDto field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<RationalDto> field0) rationalArray,
    required TResult Function(List<RationalDto> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) {
    return u32Array(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(RationalDto field0)? rational,
    TResult? Function(RationalDto field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<RationalDto> field0)? rationalArray,
    TResult? Function(List<RationalDto> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) {
    return u32Array?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(RationalDto field0)? rational,
    TResult Function(RationalDto field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<RationalDto> field0)? rationalArray,
    TResult Function(List<RationalDto> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) {
    if (u32Array != null) {
      return u32Array(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValueDto_Text value) text,
    required TResult Function(MetadataValueDto_Integer value) integer,
    required TResult Function(MetadataValueDto_Float value) float,
    required TResult Function(MetadataValueDto_Rational value) rational,
    required TResult Function(MetadataValueDto_SignedRational value)
    signedRational,
    required TResult Function(MetadataValueDto_DateTime value) dateTime,
    required TResult Function(MetadataValueDto_NaiveDateTime value)
    naiveDateTime,
    required TResult Function(MetadataValueDto_Bytes value) bytes,
    required TResult Function(MetadataValueDto_RationalArray value)
    rationalArray,
    required TResult Function(MetadataValueDto_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValueDto_U8Array value) u8Array,
    required TResult Function(MetadataValueDto_U16Array value) u16Array,
    required TResult Function(MetadataValueDto_U32Array value) u32Array,
  }) {
    return u32Array(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValueDto_Text value)? text,
    TResult? Function(MetadataValueDto_Integer value)? integer,
    TResult? Function(MetadataValueDto_Float value)? float,
    TResult? Function(MetadataValueDto_Rational value)? rational,
    TResult? Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult? Function(MetadataValueDto_DateTime value)? dateTime,
    TResult? Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValueDto_Bytes value)? bytes,
    TResult? Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult? Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValueDto_U8Array value)? u8Array,
    TResult? Function(MetadataValueDto_U16Array value)? u16Array,
    TResult? Function(MetadataValueDto_U32Array value)? u32Array,
  }) {
    return u32Array?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValueDto_Text value)? text,
    TResult Function(MetadataValueDto_Integer value)? integer,
    TResult Function(MetadataValueDto_Float value)? float,
    TResult Function(MetadataValueDto_Rational value)? rational,
    TResult Function(MetadataValueDto_SignedRational value)? signedRational,
    TResult Function(MetadataValueDto_DateTime value)? dateTime,
    TResult Function(MetadataValueDto_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValueDto_Bytes value)? bytes,
    TResult Function(MetadataValueDto_RationalArray value)? rationalArray,
    TResult Function(MetadataValueDto_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValueDto_U8Array value)? u8Array,
    TResult Function(MetadataValueDto_U16Array value)? u16Array,
    TResult Function(MetadataValueDto_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (u32Array != null) {
      return u32Array(this);
    }
    return orElse();
  }
}

abstract class MetadataValueDto_U32Array extends MetadataValueDto {
  const factory MetadataValueDto_U32Array(final Int64List field0) =
      _$MetadataValueDto_U32ArrayImpl;
  const MetadataValueDto_U32Array._() : super._();

  @override
  Int64List get field0;

  /// Create a copy of MetadataValueDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValueDto_U32ArrayImplCopyWith<_$MetadataValueDto_U32ArrayImpl>
  get copyWith => throw _privateConstructorUsedError;
}
