import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@Riverpod(keepAlive: true)
class SplashShown extends _$SplashShown {
  @override
  bool build() => false;

  void markAsShown() => state = true;
}
