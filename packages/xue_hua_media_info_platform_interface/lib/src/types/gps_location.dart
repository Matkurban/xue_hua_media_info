import 'package:flutter/foundation.dart';

/// A geographic location parsed from media metadata.
/// 从媒体元数据解析出的地理位置。
@immutable
final class GpsLocation {
  /// Creates a GPS location. / 创建 GPS 位置。
  const GpsLocation({
    required this.latitude,
    required this.longitude,
    this.altitudeMeters,
  });

  /// Latitude in decimal degrees, positive north.
  /// 纬度（十进制度，北纬为正）。
  final double latitude;

  /// Longitude in decimal degrees, positive east.
  /// 经度（十进制度，东经为正）。
  final double longitude;

  /// Altitude in metres, when present. / 海拔（米），缺失时为 `null`。
  final double? altitudeMeters;

  @override
  bool operator ==(Object other) =>
      other is GpsLocation &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.altitudeMeters == altitudeMeters;

  @override
  int get hashCode => Object.hash(latitude, longitude, altitudeMeters);

  @override
  String toString() =>
      'GpsLocation($latitude, $longitude'
      '${altitudeMeters == null ? '' : ', ${altitudeMeters}m'})';
}
