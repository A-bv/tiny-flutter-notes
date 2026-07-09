import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:field_notes/ui/core/theme.dart';

/// Runs before every test in this directory. It configures Alchemist to
/// render goldens in the app's own light theme. By default Alchemist
/// writes two variants — a platform-agnostic "ci" image (text as blocks,
/// no shadows, stable across machines) that CI compares against, and a
/// host-platform image for local eyeballing that CI skips.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(theme: AppTheme.light()),
    run: testMain,
  );
}
