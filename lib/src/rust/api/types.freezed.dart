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
mixin _$MediaMetadata {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageExif field0) imageExif,
    required TResult Function(VideoTrack field0) videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageExif field0)? imageExif,
    TResult? Function(VideoTrack field0)? videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageExif field0)? imageExif,
    TResult Function(VideoTrack field0)? videoTrack,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MediaMetadata_ImageExif value) imageExif,
    required TResult Function(MediaMetadata_VideoTrack value) videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MediaMetadata_ImageExif value)? imageExif,
    TResult? Function(MediaMetadata_VideoTrack value)? videoTrack,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MediaMetadata_ImageExif value)? imageExif,
    TResult Function(MediaMetadata_VideoTrack value)? videoTrack,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaMetadataCopyWith<$Res> {
  factory $MediaMetadataCopyWith(
    MediaMetadata value,
    $Res Function(MediaMetadata) then,
  ) = _$MediaMetadataCopyWithImpl<$Res, MediaMetadata>;
}

/// @nodoc
class _$MediaMetadataCopyWithImpl<$Res, $Val extends MediaMetadata>
    implements $MediaMetadataCopyWith<$Res> {
  _$MediaMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaMetadata
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MediaMetadata_ImageExifImplCopyWith<$Res> {
  factory _$$MediaMetadata_ImageExifImplCopyWith(
    _$MediaMetadata_ImageExifImpl value,
    $Res Function(_$MediaMetadata_ImageExifImpl) then,
  ) = __$$MediaMetadata_ImageExifImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ImageExif field0});
}

/// @nodoc
class __$$MediaMetadata_ImageExifImplCopyWithImpl<$Res>
    extends _$MediaMetadataCopyWithImpl<$Res, _$MediaMetadata_ImageExifImpl>
    implements _$$MediaMetadata_ImageExifImplCopyWith<$Res> {
  __$$MediaMetadata_ImageExifImplCopyWithImpl(
    _$MediaMetadata_ImageExifImpl _value,
    $Res Function(_$MediaMetadata_ImageExifImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MediaMetadata_ImageExifImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as ImageExif,
      ),
    );
  }
}

/// @nodoc

class _$MediaMetadata_ImageExifImpl extends MediaMetadata_ImageExif {
  const _$MediaMetadata_ImageExifImpl(this.field0) : super._();

  @override
  final ImageExif field0;

  @override
  String toString() {
    return 'MediaMetadata.imageExif(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaMetadata_ImageExifImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MediaMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaMetadata_ImageExifImplCopyWith<_$MediaMetadata_ImageExifImpl>
  get copyWith =>
      __$$MediaMetadata_ImageExifImplCopyWithImpl<
        _$MediaMetadata_ImageExifImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageExif field0) imageExif,
    required TResult Function(VideoTrack field0) videoTrack,
  }) {
    return imageExif(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageExif field0)? imageExif,
    TResult? Function(VideoTrack field0)? videoTrack,
  }) {
    return imageExif?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageExif field0)? imageExif,
    TResult Function(VideoTrack field0)? videoTrack,
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
    required TResult Function(MediaMetadata_ImageExif value) imageExif,
    required TResult Function(MediaMetadata_VideoTrack value) videoTrack,
  }) {
    return imageExif(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MediaMetadata_ImageExif value)? imageExif,
    TResult? Function(MediaMetadata_VideoTrack value)? videoTrack,
  }) {
    return imageExif?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MediaMetadata_ImageExif value)? imageExif,
    TResult Function(MediaMetadata_VideoTrack value)? videoTrack,
    required TResult orElse(),
  }) {
    if (imageExif != null) {
      return imageExif(this);
    }
    return orElse();
  }
}

abstract class MediaMetadata_ImageExif extends MediaMetadata {
  const factory MediaMetadata_ImageExif(final ImageExif field0) =
      _$MediaMetadata_ImageExifImpl;
  const MediaMetadata_ImageExif._() : super._();

  @override
  ImageExif get field0;

  /// Create a copy of MediaMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaMetadata_ImageExifImplCopyWith<_$MediaMetadata_ImageExifImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MediaMetadata_VideoTrackImplCopyWith<$Res> {
  factory _$$MediaMetadata_VideoTrackImplCopyWith(
    _$MediaMetadata_VideoTrackImpl value,
    $Res Function(_$MediaMetadata_VideoTrackImpl) then,
  ) = __$$MediaMetadata_VideoTrackImplCopyWithImpl<$Res>;
  @useResult
  $Res call({VideoTrack field0});
}

/// @nodoc
class __$$MediaMetadata_VideoTrackImplCopyWithImpl<$Res>
    extends _$MediaMetadataCopyWithImpl<$Res, _$MediaMetadata_VideoTrackImpl>
    implements _$$MediaMetadata_VideoTrackImplCopyWith<$Res> {
  __$$MediaMetadata_VideoTrackImplCopyWithImpl(
    _$MediaMetadata_VideoTrackImpl _value,
    $Res Function(_$MediaMetadata_VideoTrackImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MediaMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MediaMetadata_VideoTrackImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as VideoTrack,
      ),
    );
  }
}

/// @nodoc

class _$MediaMetadata_VideoTrackImpl extends MediaMetadata_VideoTrack {
  const _$MediaMetadata_VideoTrackImpl(this.field0) : super._();

  @override
  final VideoTrack field0;

  @override
  String toString() {
    return 'MediaMetadata.videoTrack(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaMetadata_VideoTrackImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MediaMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaMetadata_VideoTrackImplCopyWith<_$MediaMetadata_VideoTrackImpl>
  get copyWith =>
      __$$MediaMetadata_VideoTrackImplCopyWithImpl<
        _$MediaMetadata_VideoTrackImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ImageExif field0) imageExif,
    required TResult Function(VideoTrack field0) videoTrack,
  }) {
    return videoTrack(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ImageExif field0)? imageExif,
    TResult? Function(VideoTrack field0)? videoTrack,
  }) {
    return videoTrack?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ImageExif field0)? imageExif,
    TResult Function(VideoTrack field0)? videoTrack,
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
    required TResult Function(MediaMetadata_ImageExif value) imageExif,
    required TResult Function(MediaMetadata_VideoTrack value) videoTrack,
  }) {
    return videoTrack(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MediaMetadata_ImageExif value)? imageExif,
    TResult? Function(MediaMetadata_VideoTrack value)? videoTrack,
  }) {
    return videoTrack?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MediaMetadata_ImageExif value)? imageExif,
    TResult Function(MediaMetadata_VideoTrack value)? videoTrack,
    required TResult orElse(),
  }) {
    if (videoTrack != null) {
      return videoTrack(this);
    }
    return orElse();
  }
}

abstract class MediaMetadata_VideoTrack extends MediaMetadata {
  const factory MediaMetadata_VideoTrack(final VideoTrack field0) =
      _$MediaMetadata_VideoTrackImpl;
  const MediaMetadata_VideoTrack._() : super._();

  @override
  VideoTrack get field0;

  /// Create a copy of MediaMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaMetadata_VideoTrackImplCopyWith<_$MediaMetadata_VideoTrackImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MetadataValue {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
    required TResult Function(Uint8List field0) u8Array,
    required TResult Function(Int32List field0) u16Array,
    required TResult Function(Int64List field0) u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? text,
    TResult? Function(int field0)? integer,
    TResult? Function(double field0)? float,
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
    TResult? Function(Uint8List field0)? u8Array,
    TResult? Function(Int32List field0)? u16Array,
    TResult? Function(Int64List field0)? u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? text,
    TResult Function(int field0)? integer,
    TResult Function(double field0)? float,
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
    TResult Function(Uint8List field0)? u8Array,
    TResult Function(Int32List field0)? u16Array,
    TResult Function(Int64List field0)? u32Array,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataValueCopyWith<$Res> {
  factory $MetadataValueCopyWith(
    MetadataValue value,
    $Res Function(MetadataValue) then,
  ) = _$MetadataValueCopyWithImpl<$Res, MetadataValue>;
}

/// @nodoc
class _$MetadataValueCopyWithImpl<$Res, $Val extends MetadataValue>
    implements $MetadataValueCopyWith<$Res> {
  _$MetadataValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MetadataValue_TextImplCopyWith<$Res> {
  factory _$$MetadataValue_TextImplCopyWith(
    _$MetadataValue_TextImpl value,
    $Res Function(_$MetadataValue_TextImpl) then,
  ) = __$$MetadataValue_TextImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValue_TextImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_TextImpl>
    implements _$$MetadataValue_TextImplCopyWith<$Res> {
  __$$MetadataValue_TextImplCopyWithImpl(
    _$MetadataValue_TextImpl _value,
    $Res Function(_$MetadataValue_TextImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_TextImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_TextImpl extends MetadataValue_Text {
  const _$MetadataValue_TextImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValue.text(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_TextImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_TextImplCopyWith<_$MetadataValue_TextImpl> get copyWith =>
      __$$MetadataValue_TextImplCopyWithImpl<_$MetadataValue_TextImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_Text extends MetadataValue {
  const factory MetadataValue_Text(final String field0) =
      _$MetadataValue_TextImpl;
  const MetadataValue_Text._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_TextImplCopyWith<_$MetadataValue_TextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_IntegerImplCopyWith<$Res> {
  factory _$$MetadataValue_IntegerImplCopyWith(
    _$MetadataValue_IntegerImpl value,
    $Res Function(_$MetadataValue_IntegerImpl) then,
  ) = __$$MetadataValue_IntegerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$MetadataValue_IntegerImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_IntegerImpl>
    implements _$$MetadataValue_IntegerImplCopyWith<$Res> {
  __$$MetadataValue_IntegerImplCopyWithImpl(
    _$MetadataValue_IntegerImpl _value,
    $Res Function(_$MetadataValue_IntegerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_IntegerImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_IntegerImpl extends MetadataValue_Integer {
  const _$MetadataValue_IntegerImpl(this.field0) : super._();

  @override
  final int field0;

  @override
  String toString() {
    return 'MetadataValue.integer(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_IntegerImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_IntegerImplCopyWith<_$MetadataValue_IntegerImpl>
  get copyWith =>
      __$$MetadataValue_IntegerImplCopyWithImpl<_$MetadataValue_IntegerImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return integer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return integer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_Integer extends MetadataValue {
  const factory MetadataValue_Integer(final int field0) =
      _$MetadataValue_IntegerImpl;
  const MetadataValue_Integer._() : super._();

  @override
  int get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_IntegerImplCopyWith<_$MetadataValue_IntegerImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_FloatImplCopyWith<$Res> {
  factory _$$MetadataValue_FloatImplCopyWith(
    _$MetadataValue_FloatImpl value,
    $Res Function(_$MetadataValue_FloatImpl) then,
  ) = __$$MetadataValue_FloatImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$MetadataValue_FloatImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_FloatImpl>
    implements _$$MetadataValue_FloatImplCopyWith<$Res> {
  __$$MetadataValue_FloatImplCopyWithImpl(
    _$MetadataValue_FloatImpl _value,
    $Res Function(_$MetadataValue_FloatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_FloatImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_FloatImpl extends MetadataValue_Float {
  const _$MetadataValue_FloatImpl(this.field0) : super._();

  @override
  final double field0;

  @override
  String toString() {
    return 'MetadataValue.float(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_FloatImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_FloatImplCopyWith<_$MetadataValue_FloatImpl> get copyWith =>
      __$$MetadataValue_FloatImplCopyWithImpl<_$MetadataValue_FloatImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return float(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return float?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (float != null) {
      return float(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_Float extends MetadataValue {
  const factory MetadataValue_Float(final double field0) =
      _$MetadataValue_FloatImpl;
  const MetadataValue_Float._() : super._();

  @override
  double get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_FloatImplCopyWith<_$MetadataValue_FloatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_RationalImplCopyWith<$Res> {
  factory _$$MetadataValue_RationalImplCopyWith(
    _$MetadataValue_RationalImpl value,
    $Res Function(_$MetadataValue_RationalImpl) then,
  ) = __$$MetadataValue_RationalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Rational field0});
}

/// @nodoc
class __$$MetadataValue_RationalImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_RationalImpl>
    implements _$$MetadataValue_RationalImplCopyWith<$Res> {
  __$$MetadataValue_RationalImplCopyWithImpl(
    _$MetadataValue_RationalImpl _value,
    $Res Function(_$MetadataValue_RationalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_RationalImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Rational,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_RationalImpl extends MetadataValue_Rational {
  const _$MetadataValue_RationalImpl(this.field0) : super._();

  @override
  final Rational field0;

  @override
  String toString() {
    return 'MetadataValue.rational(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_RationalImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_RationalImplCopyWith<_$MetadataValue_RationalImpl>
  get copyWith =>
      __$$MetadataValue_RationalImplCopyWithImpl<_$MetadataValue_RationalImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return rational(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return rational?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (rational != null) {
      return rational(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_Rational extends MetadataValue {
  const factory MetadataValue_Rational(final Rational field0) =
      _$MetadataValue_RationalImpl;
  const MetadataValue_Rational._() : super._();

  @override
  Rational get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_RationalImplCopyWith<_$MetadataValue_RationalImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_SignedRationalImplCopyWith<$Res> {
  factory _$$MetadataValue_SignedRationalImplCopyWith(
    _$MetadataValue_SignedRationalImpl value,
    $Res Function(_$MetadataValue_SignedRationalImpl) then,
  ) = __$$MetadataValue_SignedRationalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Rational field0});
}

/// @nodoc
class __$$MetadataValue_SignedRationalImplCopyWithImpl<$Res>
    extends
        _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_SignedRationalImpl>
    implements _$$MetadataValue_SignedRationalImplCopyWith<$Res> {
  __$$MetadataValue_SignedRationalImplCopyWithImpl(
    _$MetadataValue_SignedRationalImpl _value,
    $Res Function(_$MetadataValue_SignedRationalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_SignedRationalImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Rational,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_SignedRationalImpl extends MetadataValue_SignedRational {
  const _$MetadataValue_SignedRationalImpl(this.field0) : super._();

  @override
  final Rational field0;

  @override
  String toString() {
    return 'MetadataValue.signedRational(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_SignedRationalImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_SignedRationalImplCopyWith<
    _$MetadataValue_SignedRationalImpl
  >
  get copyWith =>
      __$$MetadataValue_SignedRationalImplCopyWithImpl<
        _$MetadataValue_SignedRationalImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return signedRational(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return signedRational?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (signedRational != null) {
      return signedRational(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_SignedRational extends MetadataValue {
  const factory MetadataValue_SignedRational(final Rational field0) =
      _$MetadataValue_SignedRationalImpl;
  const MetadataValue_SignedRational._() : super._();

  @override
  Rational get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_SignedRationalImplCopyWith<
    _$MetadataValue_SignedRationalImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_DateTimeImplCopyWith<$Res> {
  factory _$$MetadataValue_DateTimeImplCopyWith(
    _$MetadataValue_DateTimeImpl value,
    $Res Function(_$MetadataValue_DateTimeImpl) then,
  ) = __$$MetadataValue_DateTimeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValue_DateTimeImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_DateTimeImpl>
    implements _$$MetadataValue_DateTimeImplCopyWith<$Res> {
  __$$MetadataValue_DateTimeImplCopyWithImpl(
    _$MetadataValue_DateTimeImpl _value,
    $Res Function(_$MetadataValue_DateTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_DateTimeImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_DateTimeImpl extends MetadataValue_DateTime {
  const _$MetadataValue_DateTimeImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValue.dateTime(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_DateTimeImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_DateTimeImplCopyWith<_$MetadataValue_DateTimeImpl>
  get copyWith =>
      __$$MetadataValue_DateTimeImplCopyWithImpl<_$MetadataValue_DateTimeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return dateTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return dateTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (dateTime != null) {
      return dateTime(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_DateTime extends MetadataValue {
  const factory MetadataValue_DateTime(final String field0) =
      _$MetadataValue_DateTimeImpl;
  const MetadataValue_DateTime._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_DateTimeImplCopyWith<_$MetadataValue_DateTimeImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_NaiveDateTimeImplCopyWith<$Res> {
  factory _$$MetadataValue_NaiveDateTimeImplCopyWith(
    _$MetadataValue_NaiveDateTimeImpl value,
    $Res Function(_$MetadataValue_NaiveDateTimeImpl) then,
  ) = __$$MetadataValue_NaiveDateTimeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValue_NaiveDateTimeImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_NaiveDateTimeImpl>
    implements _$$MetadataValue_NaiveDateTimeImplCopyWith<$Res> {
  __$$MetadataValue_NaiveDateTimeImplCopyWithImpl(
    _$MetadataValue_NaiveDateTimeImpl _value,
    $Res Function(_$MetadataValue_NaiveDateTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_NaiveDateTimeImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_NaiveDateTimeImpl extends MetadataValue_NaiveDateTime {
  const _$MetadataValue_NaiveDateTimeImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValue.naiveDateTime(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_NaiveDateTimeImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_NaiveDateTimeImplCopyWith<_$MetadataValue_NaiveDateTimeImpl>
  get copyWith =>
      __$$MetadataValue_NaiveDateTimeImplCopyWithImpl<
        _$MetadataValue_NaiveDateTimeImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return naiveDateTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return naiveDateTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (naiveDateTime != null) {
      return naiveDateTime(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_NaiveDateTime extends MetadataValue {
  const factory MetadataValue_NaiveDateTime(final String field0) =
      _$MetadataValue_NaiveDateTimeImpl;
  const MetadataValue_NaiveDateTime._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_NaiveDateTimeImplCopyWith<_$MetadataValue_NaiveDateTimeImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_BytesImplCopyWith<$Res> {
  factory _$$MetadataValue_BytesImplCopyWith(
    _$MetadataValue_BytesImpl value,
    $Res Function(_$MetadataValue_BytesImpl) then,
  ) = __$$MetadataValue_BytesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$MetadataValue_BytesImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_BytesImpl>
    implements _$$MetadataValue_BytesImplCopyWith<$Res> {
  __$$MetadataValue_BytesImplCopyWithImpl(
    _$MetadataValue_BytesImpl _value,
    $Res Function(_$MetadataValue_BytesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_BytesImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_BytesImpl extends MetadataValue_Bytes {
  const _$MetadataValue_BytesImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'MetadataValue.bytes(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_BytesImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_BytesImplCopyWith<_$MetadataValue_BytesImpl> get copyWith =>
      __$$MetadataValue_BytesImplCopyWithImpl<_$MetadataValue_BytesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return bytes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return bytes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (bytes != null) {
      return bytes(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_Bytes extends MetadataValue {
  const factory MetadataValue_Bytes(final String field0) =
      _$MetadataValue_BytesImpl;
  const MetadataValue_Bytes._() : super._();

  @override
  String get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_BytesImplCopyWith<_$MetadataValue_BytesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_RationalArrayImplCopyWith<$Res> {
  factory _$$MetadataValue_RationalArrayImplCopyWith(
    _$MetadataValue_RationalArrayImpl value,
    $Res Function(_$MetadataValue_RationalArrayImpl) then,
  ) = __$$MetadataValue_RationalArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Rational> field0});
}

/// @nodoc
class __$$MetadataValue_RationalArrayImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_RationalArrayImpl>
    implements _$$MetadataValue_RationalArrayImplCopyWith<$Res> {
  __$$MetadataValue_RationalArrayImplCopyWithImpl(
    _$MetadataValue_RationalArrayImpl _value,
    $Res Function(_$MetadataValue_RationalArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_RationalArrayImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as List<Rational>,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_RationalArrayImpl extends MetadataValue_RationalArray {
  const _$MetadataValue_RationalArrayImpl(final List<Rational> field0)
    : _field0 = field0,
      super._();

  final List<Rational> _field0;
  @override
  List<Rational> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'MetadataValue.rationalArray(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_RationalArrayImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_RationalArrayImplCopyWith<_$MetadataValue_RationalArrayImpl>
  get copyWith =>
      __$$MetadataValue_RationalArrayImplCopyWithImpl<
        _$MetadataValue_RationalArrayImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return rationalArray(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return rationalArray?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (rationalArray != null) {
      return rationalArray(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_RationalArray extends MetadataValue {
  const factory MetadataValue_RationalArray(final List<Rational> field0) =
      _$MetadataValue_RationalArrayImpl;
  const MetadataValue_RationalArray._() : super._();

  @override
  List<Rational> get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_RationalArrayImplCopyWith<_$MetadataValue_RationalArrayImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_SignedRationalArrayImplCopyWith<$Res> {
  factory _$$MetadataValue_SignedRationalArrayImplCopyWith(
    _$MetadataValue_SignedRationalArrayImpl value,
    $Res Function(_$MetadataValue_SignedRationalArrayImpl) then,
  ) = __$$MetadataValue_SignedRationalArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Rational> field0});
}

/// @nodoc
class __$$MetadataValue_SignedRationalArrayImplCopyWithImpl<$Res>
    extends
        _$MetadataValueCopyWithImpl<
          $Res,
          _$MetadataValue_SignedRationalArrayImpl
        >
    implements _$$MetadataValue_SignedRationalArrayImplCopyWith<$Res> {
  __$$MetadataValue_SignedRationalArrayImplCopyWithImpl(
    _$MetadataValue_SignedRationalArrayImpl _value,
    $Res Function(_$MetadataValue_SignedRationalArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_SignedRationalArrayImpl(
        null == field0
            ? _value._field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as List<Rational>,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_SignedRationalArrayImpl
    extends MetadataValue_SignedRationalArray {
  const _$MetadataValue_SignedRationalArrayImpl(final List<Rational> field0)
    : _field0 = field0,
      super._();

  final List<Rational> _field0;
  @override
  List<Rational> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'MetadataValue.signedRationalArray(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_SignedRationalArrayImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_SignedRationalArrayImplCopyWith<
    _$MetadataValue_SignedRationalArrayImpl
  >
  get copyWith =>
      __$$MetadataValue_SignedRationalArrayImplCopyWithImpl<
        _$MetadataValue_SignedRationalArrayImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return signedRationalArray(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return signedRationalArray?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (signedRationalArray != null) {
      return signedRationalArray(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_SignedRationalArray extends MetadataValue {
  const factory MetadataValue_SignedRationalArray(final List<Rational> field0) =
      _$MetadataValue_SignedRationalArrayImpl;
  const MetadataValue_SignedRationalArray._() : super._();

  @override
  List<Rational> get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_SignedRationalArrayImplCopyWith<
    _$MetadataValue_SignedRationalArrayImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_U8ArrayImplCopyWith<$Res> {
  factory _$$MetadataValue_U8ArrayImplCopyWith(
    _$MetadataValue_U8ArrayImpl value,
    $Res Function(_$MetadataValue_U8ArrayImpl) then,
  ) = __$$MetadataValue_U8ArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Uint8List field0});
}

/// @nodoc
class __$$MetadataValue_U8ArrayImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_U8ArrayImpl>
    implements _$$MetadataValue_U8ArrayImplCopyWith<$Res> {
  __$$MetadataValue_U8ArrayImplCopyWithImpl(
    _$MetadataValue_U8ArrayImpl _value,
    $Res Function(_$MetadataValue_U8ArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_U8ArrayImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Uint8List,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_U8ArrayImpl extends MetadataValue_U8Array {
  const _$MetadataValue_U8ArrayImpl(this.field0) : super._();

  @override
  final Uint8List field0;

  @override
  String toString() {
    return 'MetadataValue.u8Array(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_U8ArrayImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_U8ArrayImplCopyWith<_$MetadataValue_U8ArrayImpl>
  get copyWith =>
      __$$MetadataValue_U8ArrayImplCopyWithImpl<_$MetadataValue_U8ArrayImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return u8Array(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return u8Array?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (u8Array != null) {
      return u8Array(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_U8Array extends MetadataValue {
  const factory MetadataValue_U8Array(final Uint8List field0) =
      _$MetadataValue_U8ArrayImpl;
  const MetadataValue_U8Array._() : super._();

  @override
  Uint8List get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_U8ArrayImplCopyWith<_$MetadataValue_U8ArrayImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_U16ArrayImplCopyWith<$Res> {
  factory _$$MetadataValue_U16ArrayImplCopyWith(
    _$MetadataValue_U16ArrayImpl value,
    $Res Function(_$MetadataValue_U16ArrayImpl) then,
  ) = __$$MetadataValue_U16ArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Int32List field0});
}

/// @nodoc
class __$$MetadataValue_U16ArrayImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_U16ArrayImpl>
    implements _$$MetadataValue_U16ArrayImplCopyWith<$Res> {
  __$$MetadataValue_U16ArrayImplCopyWithImpl(
    _$MetadataValue_U16ArrayImpl _value,
    $Res Function(_$MetadataValue_U16ArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_U16ArrayImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Int32List,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_U16ArrayImpl extends MetadataValue_U16Array {
  const _$MetadataValue_U16ArrayImpl(this.field0) : super._();

  @override
  final Int32List field0;

  @override
  String toString() {
    return 'MetadataValue.u16Array(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_U16ArrayImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_U16ArrayImplCopyWith<_$MetadataValue_U16ArrayImpl>
  get copyWith =>
      __$$MetadataValue_U16ArrayImplCopyWithImpl<_$MetadataValue_U16ArrayImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return u16Array(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return u16Array?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (u16Array != null) {
      return u16Array(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_U16Array extends MetadataValue {
  const factory MetadataValue_U16Array(final Int32List field0) =
      _$MetadataValue_U16ArrayImpl;
  const MetadataValue_U16Array._() : super._();

  @override
  Int32List get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_U16ArrayImplCopyWith<_$MetadataValue_U16ArrayImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MetadataValue_U32ArrayImplCopyWith<$Res> {
  factory _$$MetadataValue_U32ArrayImplCopyWith(
    _$MetadataValue_U32ArrayImpl value,
    $Res Function(_$MetadataValue_U32ArrayImpl) then,
  ) = __$$MetadataValue_U32ArrayImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Int64List field0});
}

/// @nodoc
class __$$MetadataValue_U32ArrayImplCopyWithImpl<$Res>
    extends _$MetadataValueCopyWithImpl<$Res, _$MetadataValue_U32ArrayImpl>
    implements _$$MetadataValue_U32ArrayImplCopyWith<$Res> {
  __$$MetadataValue_U32ArrayImplCopyWithImpl(
    _$MetadataValue_U32ArrayImpl _value,
    $Res Function(_$MetadataValue_U32ArrayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? field0 = null}) {
    return _then(
      _$MetadataValue_U32ArrayImpl(
        null == field0
            ? _value.field0
            : field0 // ignore: cast_nullable_to_non_nullable
                  as Int64List,
      ),
    );
  }
}

/// @nodoc

class _$MetadataValue_U32ArrayImpl extends MetadataValue_U32Array {
  const _$MetadataValue_U32ArrayImpl(this.field0) : super._();

  @override
  final Int64List field0;

  @override
  String toString() {
    return 'MetadataValue.u32Array(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetadataValue_U32ArrayImpl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetadataValue_U32ArrayImplCopyWith<_$MetadataValue_U32ArrayImpl>
  get copyWith =>
      __$$MetadataValue_U32ArrayImplCopyWithImpl<_$MetadataValue_U32ArrayImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) text,
    required TResult Function(int field0) integer,
    required TResult Function(double field0) float,
    required TResult Function(Rational field0) rational,
    required TResult Function(Rational field0) signedRational,
    required TResult Function(String field0) dateTime,
    required TResult Function(String field0) naiveDateTime,
    required TResult Function(String field0) bytes,
    required TResult Function(List<Rational> field0) rationalArray,
    required TResult Function(List<Rational> field0) signedRationalArray,
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
    TResult? Function(Rational field0)? rational,
    TResult? Function(Rational field0)? signedRational,
    TResult? Function(String field0)? dateTime,
    TResult? Function(String field0)? naiveDateTime,
    TResult? Function(String field0)? bytes,
    TResult? Function(List<Rational> field0)? rationalArray,
    TResult? Function(List<Rational> field0)? signedRationalArray,
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
    TResult Function(Rational field0)? rational,
    TResult Function(Rational field0)? signedRational,
    TResult Function(String field0)? dateTime,
    TResult Function(String field0)? naiveDateTime,
    TResult Function(String field0)? bytes,
    TResult Function(List<Rational> field0)? rationalArray,
    TResult Function(List<Rational> field0)? signedRationalArray,
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
    required TResult Function(MetadataValue_Text value) text,
    required TResult Function(MetadataValue_Integer value) integer,
    required TResult Function(MetadataValue_Float value) float,
    required TResult Function(MetadataValue_Rational value) rational,
    required TResult Function(MetadataValue_SignedRational value)
    signedRational,
    required TResult Function(MetadataValue_DateTime value) dateTime,
    required TResult Function(MetadataValue_NaiveDateTime value) naiveDateTime,
    required TResult Function(MetadataValue_Bytes value) bytes,
    required TResult Function(MetadataValue_RationalArray value) rationalArray,
    required TResult Function(MetadataValue_SignedRationalArray value)
    signedRationalArray,
    required TResult Function(MetadataValue_U8Array value) u8Array,
    required TResult Function(MetadataValue_U16Array value) u16Array,
    required TResult Function(MetadataValue_U32Array value) u32Array,
  }) {
    return u32Array(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MetadataValue_Text value)? text,
    TResult? Function(MetadataValue_Integer value)? integer,
    TResult? Function(MetadataValue_Float value)? float,
    TResult? Function(MetadataValue_Rational value)? rational,
    TResult? Function(MetadataValue_SignedRational value)? signedRational,
    TResult? Function(MetadataValue_DateTime value)? dateTime,
    TResult? Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult? Function(MetadataValue_Bytes value)? bytes,
    TResult? Function(MetadataValue_RationalArray value)? rationalArray,
    TResult? Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult? Function(MetadataValue_U8Array value)? u8Array,
    TResult? Function(MetadataValue_U16Array value)? u16Array,
    TResult? Function(MetadataValue_U32Array value)? u32Array,
  }) {
    return u32Array?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MetadataValue_Text value)? text,
    TResult Function(MetadataValue_Integer value)? integer,
    TResult Function(MetadataValue_Float value)? float,
    TResult Function(MetadataValue_Rational value)? rational,
    TResult Function(MetadataValue_SignedRational value)? signedRational,
    TResult Function(MetadataValue_DateTime value)? dateTime,
    TResult Function(MetadataValue_NaiveDateTime value)? naiveDateTime,
    TResult Function(MetadataValue_Bytes value)? bytes,
    TResult Function(MetadataValue_RationalArray value)? rationalArray,
    TResult Function(MetadataValue_SignedRationalArray value)?
    signedRationalArray,
    TResult Function(MetadataValue_U8Array value)? u8Array,
    TResult Function(MetadataValue_U16Array value)? u16Array,
    TResult Function(MetadataValue_U32Array value)? u32Array,
    required TResult orElse(),
  }) {
    if (u32Array != null) {
      return u32Array(this);
    }
    return orElse();
  }
}

abstract class MetadataValue_U32Array extends MetadataValue {
  const factory MetadataValue_U32Array(final Int64List field0) =
      _$MetadataValue_U32ArrayImpl;
  const MetadataValue_U32Array._() : super._();

  @override
  Int64List get field0;

  /// Create a copy of MetadataValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetadataValue_U32ArrayImplCopyWith<_$MetadataValue_U32ArrayImpl>
  get copyWith => throw _privateConstructorUsedError;
}
