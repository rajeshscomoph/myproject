import 'dart:async';

class DebouncerComponent<T> {
  Timer? _debounce;
  T? _lastValue;

  void run({
    required String text,
    required T? Function(String input) parser,
    required void Function(T value) onValidChange,
    Duration delay = const Duration(milliseconds: 500),
  }) {
    final parsed = parser(text.trim());
    if (parsed == null) return;

    if (_lastValue == parsed) return;

    _debounce?.cancel();
    _debounce = Timer(delay, () {
      _lastValue = parsed;
      onValidChange(parsed);
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}
