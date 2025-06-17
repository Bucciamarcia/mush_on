import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/kennel/dog/single_dog_notes_widget.dart';
import 'package:mush_on/services/models/notes.dart';

void main() {
  group('SingleDogNotesWidget', () {
    late List<SingleDogNote> testNotes;
    late SingleDogNote Function(SingleDogNote) onNoteAdded;
    late Function(String) onNoteDeleted;
    late List<SingleDogNote> addedNotes;
    late List<String> deletedNoteIds;

    setUp(() {
      testNotes = [
        SingleDogNote(
          id: 'note1',
          content: 'First note content',
          date: DateTime(2023, 1, 1, 12, 0),
        ),
        SingleDogNote(
          id: 'note2',
          content: 'Second note content',
          date: DateTime(2023, 1, 2, 14, 30),
        ),
      ];
      
      addedNotes = [];
      deletedNoteIds = [];
      
      onNoteAdded = (note) {
        addedNotes.add(note);
        return note;
      };
      
      onNoteDeleted = (id) {
        deletedNoteIds.add(id);
      };
    });

    testWidgets('renders with notes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNotesWidget(
              dogNotes: testNotes,
              onNoteAdded: onNoteAdded,
              onNoteDeleted: onNoteDeleted,
            ),
          ),
        ),
      );

      expect(find.text('Dog Notes'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Note count badge
      expect(find.text('First note content'), findsOneWidget);
      expect(find.text('Second note content'), findsOneWidget);
      expect(find.text('Add a new note'), findsOneWidget);
    });

    testWidgets('renders empty state when no notes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNotesWidget(
              dogNotes: [],
              onNoteAdded: onNoteAdded,
              onNoteDeleted: onNoteDeleted,
            ),
          ),
        ),
      );

      expect(find.text('Dog Notes'), findsOneWidget);
      expect(find.text('No notes for this dog yet'), findsOneWidget);
      expect(find.byIcon(Icons.note_add_outlined), findsOneWidget);
      expect(find.text('Add a new note'), findsOneWidget);
      expect(find.text('2'), findsNothing); // No count badge
    });

    testWidgets('shows add note widget when add button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNotesWidget(
              dogNotes: [],
              onNoteAdded: onNoteAdded,
              onNoteDeleted: onNoteDeleted,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add a new note'));
      await tester.pumpAndSettle();

      expect(find.byType(AddSingleNoteWidget), findsOneWidget);
      expect(find.text('Enter new note...'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add Note'), findsOneWidget);
    });

    testWidgets('notes are sorted by date (newest first)', (tester) async {
      final unsortedNotes = [
        SingleDogNote(
          id: 'old',
          content: 'Old note',
          date: DateTime(2023, 1, 1),
        ),
        SingleDogNote(
          id: 'new',
          content: 'New note',
          date: DateTime(2023, 1, 3),
        ),
        SingleDogNote(
          id: 'middle',
          content: 'Middle note',
          date: DateTime(2023, 1, 2),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNotesWidget(
              dogNotes: unsortedNotes,
              onNoteAdded: onNoteAdded,
              onNoteDeleted: onNoteDeleted,
            ),
          ),
        ),
      );

      final noteWidgets = tester.widgetList<SingleDogNoteWidget>(
        find.byType(SingleDogNoteWidget),
      );
      
      expect(noteWidgets.length, 3);
      expect(noteWidgets.first.note.content, 'New note');
      expect(noteWidgets.first.isFirst, true);
      expect(noteWidgets.elementAt(1).note.content, 'Middle note');
      expect(noteWidgets.last.note.content, 'Old note');
    });

    testWidgets('handles notes with null dates', (tester) async {
      final notesWithNullDate = [
        SingleDogNote(
          id: 'note1',
          content: 'Note with date',
          date: DateTime(2023, 1, 1),
        ),
        SingleDogNote(
          id: 'note2',
          content: 'Note without date',
          date: null,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNotesWidget(
              dogNotes: notesWithNullDate,
              onNoteAdded: onNoteAdded,
              onNoteDeleted: onNoteDeleted,
            ),
          ),
        ),
      );

      expect(find.text('Note with date'), findsOneWidget);
      expect(find.text('Note without date'), findsOneWidget);
      
      // Note with null date should appear last
      final noteWidgets = tester.widgetList<SingleDogNoteWidget>(
        find.byType(SingleDogNoteWidget),
      );
      expect(noteWidgets.last.note.content, 'Note without date');
    });
  });

  group('SingleDogNoteWidget', () {
    late SingleDogNote testNote;
    late Function() onNoteDeleted;
    late Function(SingleDogNote) onNoteChanged;
    late bool deleteCalled;
    late List<SingleDogNote> changedNotes;

    setUp(() {
      testNote = SingleDogNote(
        id: 'test-note',
        content: 'Test note content',
        date: DateTime(2023, 1, 1, 12, 0),
      );
      
      deleteCalled = false;
      changedNotes = [];
      
      onNoteDeleted = () {
        deleteCalled = true;
      };
      
      onNoteChanged = (note) {
        changedNotes.add(note);
      };
    });

    testWidgets('renders note content and date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      expect(find.text('Test note content'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('shows LATEST badge when isFirst is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
              isFirst: true,
            ),
          ),
        ),
      );

      expect(find.text('LATEST'), findsOneWidget);
    });

    testWidgets('does not show LATEST badge when isFirst is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
              isFirst: false,
            ),
          ),
        ),
      );

      expect(find.text('LATEST'), findsNothing);
    });

    testWidgets('enters edit mode when edit button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('enters edit mode when tapping on content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test note content'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows save icon when content is changed in edit mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Modified content');
      await tester.pump();

      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('saves note when save button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Modified content');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      expect(changedNotes.length, 1);
      expect(changedNotes.first.content, 'Modified content');
      expect(changedNotes.first.id, testNote.id);
      
      // The widget exits edit mode and shows original content
      // The parent should re-render with updated note
      expect(find.byType(TextField), findsNothing);
      expect(find.text('Test note content'), findsOneWidget);
    });

    testWidgets('shows delete confirmation dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Delete Note'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this note?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('calls onNoteDeleted when delete confirmed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(deleteCalled, true);
    });

    testWidgets('does not delete when cancel pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: testNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(deleteCalled, false);
    });

    testWidgets('formats date correctly for recent notes', (tester) async {
      final recentNote = SingleDogNote(
        id: 'recent',
        content: 'Recent note',
        date: DateTime.now().subtract(const Duration(minutes: 30)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: recentNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      expect(find.textContaining('min ago'), findsOneWidget);
    });

    testWidgets('shows "No date" for null date', (tester) async {
      final noDateNote = SingleDogNote(
        id: 'no-date',
        content: 'Note without date',
        date: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleDogNoteWidget(
              note: noDateNote,
              onNoteDeleted: onNoteDeleted,
              onNoteChanged: onNoteChanged,
            ),
          ),
        ),
      );

      expect(find.text('No date'), findsOneWidget);
    });
  });

  group('AddSingleNoteWidget', () {
    late Function(SingleDogNote) onNoteAdded;
    late VoidCallback onCancel;
    late List<SingleDogNote> addedNotes;
    late bool cancelCalled;

    setUp(() {
      addedNotes = [];
      cancelCalled = false;
      
      onNoteAdded = (note) {
        addedNotes.add(note);
      };
      
      onCancel = () {
        cancelCalled = true;
      };
    });

    testWidgets('renders add note form', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddSingleNoteWidget(
              onNoteAdded: onNoteAdded,
              onCancel: onCancel,
            ),
          ),
        ),
      );

      expect(find.text('Enter new note...'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add Note'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('autofocus is enabled on text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddSingleNoteWidget(
              onNoteAdded: onNoteAdded,
              onCancel: onCancel,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, true);
    });

    testWidgets('calls onCancel when cancel button pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddSingleNoteWidget(
              onNoteAdded: onNoteAdded,
              onCancel: onCancel,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(cancelCalled, true);
    });

    testWidgets('adds note when Add Note button pressed with content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddSingleNoteWidget(
              onNoteAdded: onNoteAdded,
              onCancel: onCancel,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'New test note');
      await tester.tap(find.text('Add Note'));
      await tester.pumpAndSettle();

      expect(addedNotes.length, 1);
      expect(addedNotes.first.content, 'New test note');
      expect(addedNotes.first.id.isNotEmpty, true);
      expect(addedNotes.first.date, isNotNull);
    });

    testWidgets('shows snackbar when trying to add empty note', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddSingleNoteWidget(
              onNoteAdded: onNoteAdded,
              onCancel: onCancel,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Note'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a note'), findsOneWidget);
      expect(addedNotes.isEmpty, true);
    });

    testWidgets('shows snackbar when trying to add whitespace-only note', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddSingleNoteWidget(
              onNoteAdded: onNoteAdded,
              onCancel: onCancel,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '   ');
      await tester.tap(find.text('Add Note'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a note'), findsOneWidget);
      expect(addedNotes.isEmpty, true);
    });

    testWidgets('clears text field after successful note addition', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddSingleNoteWidget(
              onNoteAdded: onNoteAdded,
              onCancel: onCancel,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test note');
      await tester.tap(find.text('Add Note'));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, '');
    });
  });
}