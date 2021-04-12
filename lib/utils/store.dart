class Store {
  static final Map<dynamic, dynamic> _item = <dynamic, dynamic>{};
  static final Store _cache = Store._internal();

  factory Store() {
    return _cache;
  }

  Store._internal();

  set(dynamic key, dynamic value) => _item[key] = value;

  get(dynamic key) => _item[key];
}
