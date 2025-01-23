import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import 'package:file_picker/file_picker.dart';

// ignore: must_be_immutable
class NoteCreatePage extends StatelessWidget {
  final NoteController noteController = Get.find();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  PlatformFile? selectedFile;

  NoteCreatePage({super.key});

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      selectedFile = result.files.first;
      Get.snackbar("File Selected", "File: ${selectedFile!.name}");
    } else {
      Get.snackbar("No File Selected", "Please select a file to continue",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
                  "Location: ${noteController.location.value.isEmpty ? "No location set" : noteController.location.value}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => noteController.fetchCurrentLocation(),
              child: const Text("Get Current Location"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Select File"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                noteController.addNote(
                  titleController.text,
                  contentController.text,
                  selectedFile,
                );
                Get.back();
              },
              child: const Text("Save Note"),
            ),
          ],
        ),
      ),
    );
  }
}
