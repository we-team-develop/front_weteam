/// 다양한 값을 메모리에 잠시 캐시해두기 위한 클래스입니다.
class MemCache {
  /// 캐시 데이터가 저장되는 Map입니다.
  static final Map<MemCacheKey, dynamic> _map = {};

  /// 데이터를 추가합니다. 이미 key에 해당하는 데이터가 존재하면 덮어씁니다.
  static put(MemCacheKey key, dynamic value) {
    _map[key] = value;
  }

  /// 데이터를 가져옵니다. 데이터가 없는 경우 null을 반환합니다.
  static dynamic get(MemCacheKey key) {
    return _map[key];
  }

  /// key에 해당하는 데이터가 존재하는지 확인하는 메소드입니다.
  static bool contains(MemCacheKey key) {
    return _map[key] == null;
  }

  /// key에 해당하는 데이터를 삭제하는 메소드입니다.
  static remove(MemCacheKey key) {
    return _map.remove(key);
  }

  /// 모든 데이터를 삭제합니다.
  static void clear() {
    _map.clear();
  }
}

/// MemCache에 사용되는 키들입니다.
/// 오타로 인한 버그 발생 위험을 줄여주는 역할입니다.
enum MemCacheKey {
  firebaseAuthIdToken,
  weteamUserJson,
}
