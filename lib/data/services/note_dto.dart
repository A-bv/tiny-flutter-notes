import 'package:field_notes/domain/models/note.dart';

/// The wire representation of a note: the shape the server exchanges.
///
/// It exists so JSON never leaks into the domain and the domain never
/// leaks into the network. Serialization is hand-written — one small
/// type does not justify json_serializable's codegen.
class NoteDto {
  /// Creates a DTO from its wire fields.
  const NoteDto({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  /// Builds a DTO from a domain [note], dropping the local-only
  /// `syncStatus`.
  factory NoteDto.fromDomain(Note note) =>
      NoteDto(id: note.id, text: note.text, createdAt: note.createdAt);

  /// The note id.
  final String id;

  /// The note body.
  final String text;

  /// When the note was created.
  final DateTime createdAt;

  /// The JSON map sent to the server.
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };
}
