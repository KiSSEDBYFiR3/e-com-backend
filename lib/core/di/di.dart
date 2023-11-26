class ServiceLocator {
  ServiceLocator._();

  static late final ServiceLocator instance;

  static void init() {
    instance = ServiceLocator._();
  }

  final Map _objects = {};

  void registerSingletone(Object object) {
    _objects[object.runtimeType] = object;
  }

  void registerSingltoneAs(Type type, Object object) {
    _objects[type] = object;
    print(_objects);
  }

  T getObject<T extends Object>(Type? type) {
    return _objects[type];
  }
}
