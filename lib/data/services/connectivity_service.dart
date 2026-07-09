import 'dart:async';

/// The device's online/offline signal.
///
/// Deliberately a simple, app-controlled toggle rather than a real
/// network monitor: it keeps the app runnable anywhere with zero setup
/// and lets a demo button — and tests — flip connectivity on command. A
/// production build would back this with `connectivity_plus` behind the
/// same tiny surface.
class ConnectivityService {
  /// Creates the signal, [online] by default.
  ConnectivityService({bool online = true}) : _online = online;

  bool _online;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  /// Whether the device currently has connectivity.
  bool get isOnline => _online;

  /// Emits whenever connectivity flips, with the new value.
  Stream<bool> get onStatusChange => _controller.stream;

  /// Flips connectivity and notifies listeners, ignoring no-op changes.
  set isOnline(bool value) {
    if (value == _online) return;
    _online = value;
    _controller.add(value);
  }

  /// Closes the status stream. Called when the owning provider disposes.
  void dispose() => unawaited(_controller.close());
}
