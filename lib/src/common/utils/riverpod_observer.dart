import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logman/logman.dart';

class RiverpodObserver extends ProviderObserver {
  final logman = Logman.instance;

  // gọi khi một provider mới được thêm vào ProviderContainer.
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    logman.recordSimpleLog('Provider $provider was initialized with $value');
  }

  // gọi khi một provider được loại bỏ khỏi ProviderContainer.
  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    logman.recordSimpleLog('Provider $provider was disposed');
  }

  // gọi khi giá trị của một provider được cập nhật.
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logman.recordSimpleLog(
      'Provider $provider updated from $previousValue to $newValue',
    );
  }

  // gọi khi một provider ném ra một ngoại lệ.
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logman.recordSimpleLog('Provider $provider threw $error at $stackTrace');
  }
}
