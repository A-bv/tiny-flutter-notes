import 'package:meta/meta.dart';

/// Whether a note has reached the remote server yet.
///
/// This lives in the domain layer because both the UI (to show a
/// "not synced yet" badge) and the data layer (to know what still
/// needs uploading) care about it.
enum SyncStatus {
  /// Saved on the device but not yet confirmed by the server.
  pending,

  /// Confirmed by the remote server.
  synced,

  /// Deleted on the device, waiting to be removed from the server.
  pendingDeletion,
}

/// A single field note written by the user.
///
/// It gives both layers one shared, immutable shape for a note.
/// Immutable means you never change a `Note`; you build a modified copy.
/// That keeps state predictable, which is the point of the architecture.
@immutable
class Note {
  /// Creates a note. Every field is required so a note is never half
  /// built.
  const Note({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.syncStatus,
  });

  /// Stable unique identifier, generated when the note is created.
  final String id;

  /// The note body typed by the user.
  final String text;

  /// When the note was created, used to sort newest first.
  final DateTime createdAt;

  /// Whether this note has been uploaded to the server yet.
  final SyncStatus syncStatus;

  /// Returns a copy of this note with the given fields replaced.
  ///
  /// Only [syncStatus] is replaceable because it is the only field that
  /// changes during a note's life (pending -> synced).
  Note copyWith({SyncStatus? syncStatus}) {
    return Note(
      id: id,
      text: text,
      createdAt: createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Note &&
        other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.syncStatus == syncStatus;
  }

  @override
  int get hashCode => Object.hash(id, text, createdAt, syncStatus);
}
