import 'package:revmo/environment/key_saver.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService implements KeySaver {
  static FileService _service = new FileService._singleton();

  FileService._singleton();

  factory FileService() {
    return _service;
  }

  Directory? _baseDirectory;

  Future<File> getFile(String filename) async {
    await _initDirectories();
    return new File(_baseDirectory!.path + "/" + filename);
  }

  Future<void> _initDirectories() async {
    if (_baseDirectory == null) _baseDirectory = await getApplicationDocumentsDirectory();
  }

  @override
  Future<String?> read(String key) async {
    try {
      File loadedFile = await getFile(key);
      return await loadedFile.exists() ? await loadedFile.readAsString() : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> save(String key, String value) async {
    try {
      File file = await getFile(key);
      file = await file.writeAsString(value);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> delete(String key) async {
    await _initDirectories();
    try {
      File loadedFile = await getFile(key);
      if (await loadedFile.exists()) {
        FileSystemEntity entity = await loadedFile.delete(recursive: true);
        return !await entity.exists();
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
