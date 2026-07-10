import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:field_notes/ui/core/theme.dart';

/// Runs before every test in this directory. It configures Alchemist to
/// render goldens in the app's own light theme.
///
/// Alchemist writes two variants of each golden: a platform-agnostic "ci"
/// image (text as blocks, no shadows) that CI compares against, and a
/// host-platform image for local eyeballing. Two settings keep the golden
/// test green on the Linux CI runner:
///
/// 1. Host-platform goldens are disabled in CI — the runner is Linux and
///    there is no committed `goldens/linux/` image; those goldens are for
///    local review only.
/// 2. A small `diffThreshold` lets anti-aliased curves (the rounded card,
///    the avatar, the status pill) differ by a pixel or two between macOS
///    and Linux without failing. A real visual change still trips it.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isCi = Platform.environment.containsKey('CI');
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      theme: AppTheme.light(),
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: !isCi,
        diffThreshold: 0.01,
      ),
      ciGoldensConfig: const CiGoldensConfig(diffThreshold: 0.01),
    ),
    run: testMain,
  );
}
