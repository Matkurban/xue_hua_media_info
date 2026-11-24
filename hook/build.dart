import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

const String _assetName = 'xue_hua_media_info_objc_gen.dylib';
const List<String> _objCFlags = <String>['-x', 'objective-c', '-fobjc-arc'];

final Map<Architecture, String> _appleClangMacosTargetFlags =
    <Architecture, String>{
      Architecture.arm64: 'arm64-apple-darwin',
      Architecture.arm64e: 'arm64e-apple-darwin',
      Architecture.x64: 'x86_64-apple-darwin',
    };

final Map<Architecture, Map<IOSSdk, String>> _appleClangIosTargetFlags =
    <Architecture, Map<IOSSdk, String>>{
      Architecture.arm64: <IOSSdk, String>{
        IOSSdk.iPhoneOS: 'arm64-apple-ios',
        IOSSdk.iPhoneSimulator: 'arm64-apple-ios-simulator',
      },
      Architecture.arm64e: <IOSSdk, String>{
        IOSSdk.iPhoneOS: 'arm64e-apple-ios',
        IOSSdk.iPhoneSimulator: 'arm64e-apple-ios-simulator',
      },
      Architecture.x64: <IOSSdk, String>{
        IOSSdk.iPhoneSimulator: 'x86_64-apple-ios-simulator',
      },
    };

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) {
      return;
    }

    final codeConfig = input.config.code;
    final os = codeConfig.targetOS;
    if (os != OS.iOS && os != OS.macOS) {
      return;
    }

    if (codeConfig.linkModePreference == LinkModePreference.static) {
      throw UnsupportedError('LinkModePreference.static is not supported.');
    }

    final platformDir = os == OS.iOS ? 'ios' : 'macos';
    final objcGenDir = Directory.fromUri(
      input.packageRoot.resolve(
        '$platformDir/xue_hua_media_info/Sources/xue_hua_media_info_objc_gen/',
      ),
    );
    if (!objcGenDir.existsSync()) {
      throw StateError(
        'Missing Objective-C trampoline directory: ${objcGenDir.path}',
      );
    }

    final mFiles = <String>[];
    final hFiles = <String>[];
    for (final entity in objcGenDir.listSync(recursive: true)) {
      if (entity is! File) {
        continue;
      }
      final filePath = entity.path;
      if (filePath.endsWith('.m')) {
        mFiles.add(filePath);
      } else if (filePath.endsWith('.h')) {
        hFiles.add(filePath);
      }
    }
    mFiles.sort();
    hFiles.sort();

    if (mFiles.isEmpty) {
      throw StateError(
        'No Objective-C (.m) trampoline sources found in ${objcGenDir.path}',
      );
    }

    final compiler = _findCompiler(codeConfig);
    final sysroot = _sdkPath(codeConfig);
    final targetTriple = _toTargetTriple(codeConfig);
    final minVersionFlag = _minOSVersionFlag(codeConfig);

    final baseFlags = <String>[
      '-isysroot',
      sysroot,
      '-target',
      targetTriple,
      minVersionFlag,
    ];
    final compileFlags = <String>[
      ...baseFlags,
      ..._objCFlags,
      '-fpic',
      '-gline-tables-only',
      '-I',
      objcGenDir.path,
    ];
    final linkFlags = <String>[
      '-shared',
      if (os == OS.iOS) '-Wl,-encryptable',
      ...baseFlags,
      '-framework',
      'Foundation',
      '-lobjc',
    ];

    final objOutDir = Directory.fromUri(input.outputDirectory.resolve('obj/'));
    objOutDir.createSync(recursive: true);

    final objectFiles = await Future.wait(<Future<String>>[
      for (var i = 0; i < mFiles.length; i++)
        _compileObject(
          compiler: compiler,
          sourceFile: mFiles[i],
          objectFile: objOutDir.uri.resolve('trampoline_$i.o').toFilePath(),
          flags: compileFlags,
        ),
    ]);

    final assetPath = input.outputDirectory.resolve(_assetName);
    await _runCompiler(
      compiler: compiler,
      args: <String>[
        ...linkFlags,
        ...objectFiles,
        '-o',
        assetPath.toFilePath(),
      ],
    );

    output.dependencies.addAll(mFiles.map(Uri.file));
    output.dependencies.addAll(hFiles.map(Uri.file));

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: _assetName,
        file: assetPath,
        linkMode: DynamicLoadingBundled(),
      ),
    );
  });
}

String _findCompiler(CodeConfig codeConfig) {
  final compiler = codeConfig.cCompiler?.compiler.toFilePath();
  if (compiler != null && File(compiler).existsSync()) {
    return compiler;
  }
  return 'clang';
}

Future<String> _compileObject({
  required String compiler,
  required String sourceFile,
  required String objectFile,
  required List<String> flags,
}) async {
  await _runCompiler(
    compiler: compiler,
    args: <String>[...flags, '-c', sourceFile, '-o', objectFile],
  );
  return objectFile;
}

Future<void> _runCompiler({
  required String compiler,
  required List<String> args,
}) async {
  final result = await Process.run(compiler, args);
  if (result.exitCode != 0) {
    throw ProcessException(
      compiler,
      args,
      'stdout:\n${result.stdout}\nstderr:\n${result.stderr}',
      result.exitCode,
    );
  }
}

String _sdkPath(CodeConfig codeConfig) {
  final String sdk;
  if (codeConfig.targetOS == OS.iOS) {
    sdk = codeConfig.iOS.targetSdk == IOSSdk.iPhoneOS
        ? 'iphoneos'
        : 'iphonesimulator';
  } else {
    sdk = 'macosx';
  }
  final result = Process.runSync('xcrun', <String>[
    '--show-sdk-path',
    '--sdk',
    sdk,
  ]);
  if (result.exitCode != 0) {
    throw ProcessException(
      'xcrun',
      <String>['--show-sdk-path', '--sdk', sdk],
      '${result.stderr}',
      result.exitCode,
    );
  }
  return (result.stdout as String)
      .split('\n')
      .map((line) => line.trim())
      .firstWhere((line) => line.isNotEmpty);
}

String _minOSVersionFlag(CodeConfig codeConfig) {
  if (codeConfig.targetOS == OS.iOS) {
    final version = _formatAppleVersion(codeConfig.iOS.deploymentVersion);
    if (codeConfig.iOS.targetSdk == IOSSdk.iPhoneSimulator) {
      return '-mios-simulator-version-min=$version';
    }
    return '-mios-version-min=$version';
  }
  final version = _formatAppleVersion(codeConfig.macOS.deploymentVersion);
  return '-mmacosx-version-min=$version';
}

String _toTargetTriple(CodeConfig codeConfig) {
  final architecture = codeConfig.targetArchitecture;
  if (codeConfig.targetOS == OS.iOS) {
    final sdk = codeConfig.iOS.targetSdk;
    final triple = _appleClangIosTargetFlags[architecture]?[sdk];
    if (triple == null) {
      throw UnsupportedError(
        'Unsupported iOS target: architecture=$architecture, sdk=$sdk',
      );
    }
    return triple;
  }
  final triple = _appleClangMacosTargetFlags[architecture];
  if (triple == null) {
    throw UnsupportedError(
      'Unsupported macOS target architecture: $architecture',
    );
  }
  return triple;
}

String _formatAppleVersion(AppleVersion version) {
  final major = version.major;
  final minor = version.minor;
  final patch = version.patch;
  if (patch != 0) {
    return '$major.$minor.$patch';
  }
  if (minor != 0) {
    return '$major.$minor';
  }
  return '$major';
}
