part of "../persistent_bottom_nav_bar_v2.dart";

/// Needed to make this package backwards compatible with versions of flutter
/// before 3.0.0 while working for flutter 3.0.0 and above without triggering
/// any warnings.
/// See: https://github.com/flutter/website/blob/3e6d87f13ad2a8dd9cf16081868cc3b3794abb90/src/development/tools/sdk/release-notes/release-notes-3.0.0.md#your-code
///
/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;
