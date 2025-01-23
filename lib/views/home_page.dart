import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteapp/views/note_detail_page.dart';
import '../controllers/note_controller.dart';

class HomePage extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Your Notes")),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: noteController.logout,
          ),
        ],
      ),
      body: Obx(
        () {
          if (noteController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (noteController.notes.isEmpty) {
            return const Center(
              child: Text(
                "No notes available. Add a new one!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: noteController.notes.length,
            itemBuilder: (context, index) {
              final note = noteController.notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () {
                  Get.to(NoteDetailPage(note: note));
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => noteController.deleteNote(note.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/note-create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
