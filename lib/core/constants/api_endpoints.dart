class ApiEndpoints {
  // Auth Endpoints
  static const auth = _Auth();
  static const user = _User();
  static const discover = _Discover();
  static const worker = _Worker();
  static const credits = _Credits();
}

class _Auth {
  const _Auth();

  String get signUp => '/auth/signup';
  String get signIn => '/auth/signin';
  String get signOut => '/auth/signout';
  String get forgotPassword => '/auth/forgot-password';
}

class _User {
  const _User();

  String get profile => '/profile';
  String get updateProfile => '/profile';
  String get deleteAccount => '/profile';
}

class _Discover {
  const _Discover();

  String getImage(String id) => '/discover/image?id=$id';
  String getImages({
    int page = 1,
    String filter = '',
    String orderBy = 'created_at',
  }) {
    final params = <String>[];
    params.add('page=$page');
    params.add('filter=$filter');
    params.add('order_by=$orderBy');

    return '/discover/images?${params.join('&')}';
  }
}

class _Worker {
  const _Worker();

  String get queue => '/worker/queue';
  String get process => '/worker/process';
}

class _Credits {
  const _Credits();

  String get balance => '/credits';
  String get purchase => '/credits';
  String getHistory(int page) => '/credits-history?page=$page';
}
