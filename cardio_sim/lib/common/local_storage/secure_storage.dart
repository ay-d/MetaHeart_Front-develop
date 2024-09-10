import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Flutter 애플리케이션에서 로컬 스토리지 관련 작업
class SecureStorage extends FlutterSecureStorage{
  static final SecureStorage _instance = SecureStorage._singleton();
  SecureStorage._singleton();
  factory SecureStorage() => _instance;
}
