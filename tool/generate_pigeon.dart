// Regenerates Pigeon bindings (FFI + JNI + MethodChannel) and mirrors the
// generated Objective-C FFI trampolines to both separated iOS and macOS packages.
//
// Run from the package root:
//   dart run tool/generate_pigeon.dart
//
// 重新生成所有 Pigeon 绑定（FFI + JNI + MethodChannel），并将生成的 Objective-C
// FFI 桥接文件同步到独立的 iOS 与 macOS 目录。
import 'dart:io';

const String _ffiAssetId =
    'package:xue_hua_media_info/xue_hua_media_info_objc_gen.dylib';

Future<void> main(List<String> args) async {
  final environment = Map<String, String>.from(Platform.environment);
  if (!environment.containsKey('ANDROID_HOME')) {
    final home = environment['HOME'];
    if (home != null) {
      final defaultSdk = '$home/Library/Android/sdk';
      if (Directory(defaultSdk).existsSync()) {
        environment['ANDROID_HOME'] = defaultSdk;
      }
    }
  }

  final pigeonResult = await Process.run(
    'dart',
    <String>['run', 'pigeon', '--input', 'pigeons/messages.dart', ...args],
    environment: environment,
    runInShell: false,
  );
  stdout.write(pigeonResult.stdout);
  stderr.write(pigeonResult.stderr);
  if (pigeonResult.exitCode != 0) {
    exitCode = pigeonResult.exitCode;
    return;
  }

  _injectFfiAssetId();
  if (Platform.isMacOS) {
    final ffigenResult = await Process.run(
      'dart',
      <String>['run', 'tool/pigeon/messages_ffigen_config.dart'],
      environment: environment,
      runInShell: false,
    );
    stdout.write(ffigenResult.stdout);
    stderr.write(ffigenResult.stderr);
    if (ffigenResult.exitCode != 0) {
      exitCode = ffigenResult.exitCode;
      return;
    }
  }

  _syncObjcGenToMacos();
  await _normalizeGeneratedDartFiles();
  _verifyFfiDefaultAsset();
}

void _injectFfiAssetId() {
  final configFile = File('tool/pigeon/messages_ffigen_config.dart');
  if (!configFile.existsSync()) {
    throw StateError('Missing ffigen config file: ${configFile.path}');
  }
  var content = configFile.readAsStringSync();
  final assetIdLine = "      assetId: '$_ffiAssetId',";
  if (content.contains("assetId: '$_ffiAssetId'")) {
    return;
  }
  const anchor = "      module: 'xue_hua_media_info',";
  if (!content.contains(anchor)) {
    throw StateError(
      'Could not find Output module anchor in ${configFile.path}',
    );
  }
  content = content.replaceFirst(anchor, '$anchor\n$assetIdLine');
  configFile.writeAsStringSync(content);
}

void _verifyFfiDefaultAsset() {
  final ffiBindings = File('lib/src/messages.g.ffi.dart');
  if (!ffiBindings.existsSync()) {
    return;
  }
  final content = ffiBindings.readAsStringSync();
  final pattern = RegExp(
    "@ffi\\.DefaultAsset\\(\\s*'${RegExp.escape(_ffiAssetId)}',?\\s*\\)\\r?\\nlibrary;",
  );
  if (!pattern.hasMatch(content)) {
    throw StateError(
      'Missing @ffi.DefaultAsset(\'$_ffiAssetId\') in ${ffiBindings.path}',
    );
  }
}

Future<void> _normalizeGeneratedDartFiles() async {
  final nativeInterop = File('lib/src/messages.native_interop.g.dart');
  if (nativeInterop.existsSync()) {
    var content = nativeInterop.readAsStringSync();
    if (!content.contains('// ignore_for_file: unused_element')) {
      content = content.replaceFirst(
        '// ignore_for_file: type=lint',
        '// ignore_for_file: type=lint\n// ignore_for_file: unused_element',
      );
      nativeInterop.writeAsStringSync(content);
    }
  }

  final jniBindings = File('lib/src/messages.g.jni.dart');
  if (jniBindings.existsSync()) {
    var content = jniBindings.readAsStringSync();
    if (!content.contains(
      '// ignore_for_file: override_on_non_overriding_member',
    )) {
      content = content.replaceFirst(
        '// ignore_for_file: overridden_fields',
        '// ignore_for_file: overridden_fields\n// ignore_for_file: override_on_non_overriding_member',
      );
      jniBindings.writeAsStringSync(content);
    }
  }

  final ffiBindings = File('lib/src/messages.g.ffi.dart');
  if (ffiBindings.existsSync()) {
    var content = ffiBindings.readAsStringSync();
    const duplicatedIgnore =
        '// ignore_for_file: type=lint, unused_import, unused_element, deprecated_member_use_from_same_package';
    const deduplicatedIgnore =
        '// ignore_for_file: type=lint, unused_import, deprecated_member_use_from_same_package';
    if (content.contains(duplicatedIgnore)) {
      content = content.replaceFirst(duplicatedIgnore, deduplicatedIgnore);
      ffiBindings.writeAsStringSync(content);
    }
  }

  final formatResult = await Process.run('dart', <String>[
    'format',
    'lib/src',
    'tool/pigeon',
  ], runInShell: false);
  stdout.write(formatResult.stdout);
  stderr.write(formatResult.stderr);
  if (formatResult.exitCode != 0) {
    exitCode = formatResult.exitCode;
  }
}

void _syncObjcGenToMacos() {
  final iosObjcDir = Directory(
    'ios/xue_hua_media_info/Sources/xue_hua_media_info_objc_gen',
  );
  final macosObjcDir = Directory(
    'macos/xue_hua_media_info/Sources/xue_hua_media_info_objc_gen',
  );
  if (!iosObjcDir.existsSync()) {
    return;
  }
  if (!macosObjcDir.existsSync()) {
    macosObjcDir.createSync(recursive: true);
  }
  for (final entity in macosObjcDir.listSync()) {
    if (entity is File) {
      entity.deleteSync();
    }
  }
  for (final entity in iosObjcDir.listSync()) {
    if (entity is! File) {
      continue;
    }
    final name = entity.uri.pathSegments.last;
    if (name.endsWith('.o')) {
      // Remove intermediate object files left by swiftgen builds.
      entity.deleteSync();
      continue;
    }
    if (name.endsWith('.h') || name.endsWith('.m')) {
      entity.copySync('${macosObjcDir.path}/$name');
    }
  }
}
