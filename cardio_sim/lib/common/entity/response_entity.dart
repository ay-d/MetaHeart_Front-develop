class ResponseEntity<T> {
  T? entity;
  String? message;
  ResponseType _type;

  bool get isSuccess => _type == ResponseType.success;

  bool get isError => _type == ResponseType.error;

  ResponseEntity._(this.entity, this.message, this._type);

  factory ResponseEntity.success({T? entity, String? message}) =>
      ResponseEntity._(entity, message, ResponseType.success);

  factory ResponseEntity.error({T? entity, String? message}) =>
      ResponseEntity._(entity, message, ResponseType.error);
}

enum ResponseType {
  success,
  error;
}
