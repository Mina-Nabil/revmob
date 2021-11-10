abstract class KeySaver{
  Future<bool> save(String key, String value);
  Future<String?> read(String key);
}