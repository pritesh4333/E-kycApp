///Dart import
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

///Package imports

// ignore: avoid_classes_with_only_static_members
///To save the pdf file in the device
class FileSaveHelper {
  static const MethodChannel _platformCall = MethodChannel('launchFile');

  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    String path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory = await getApplicationSupportDirectory();

      path = directory.path;
      print("If Device PATH"+path);
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
        print("Else Device PATH"+path);
    }
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      final Map<String, String> argument = <String, String>{
        'file_path': '$path/$fileName'
      };
      try {
        //ignore: unused_local_variable
        final Future<Map<String, String>> result =
            _platformCall.invokeMethod('viewPdf', argument);
      } catch (e) {
        throw Exception(e);
      }
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
  }
}
