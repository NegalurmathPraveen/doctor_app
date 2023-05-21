import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../global_variables.dart';


class LocalStorage {
  final String path1;
  LocalStorage({required this.path1});
  Future<String> get _localPath async {
    directory = Platform.isAndroid?await getExternalStorageDirectory():await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$path1');
  }

  Future<dynamic> readData() async {
    try {
      final file = await _localFile;
      // Read the file
      var contents = '';
      contents=await file.readAsString();
      print('conteeeennnttsss:$contents');
      return json.decode(contents);
    } catch (e) {
      // If encountering an error, return 0
      print(e);
      return 0;
    }
  }

  Future<File> writeData(dynamic data) async {

    final file = await _localFile;
    ++writeCount;
    print(writeCount);
    // Write the file
    return file.writeAsString('$data');
  }

  Future<void> deleteFile() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }


}