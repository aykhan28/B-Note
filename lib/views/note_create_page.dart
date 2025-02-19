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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create Note",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Write down your thoughts",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Title Input
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.title, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Content Input
                  TextField(
                    controller: contentController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Content",
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.notes, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Konum Bilgisi
                  Obx(() => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                noteController.location.value.isEmpty
                                    ? "No location set"
                                    : "Location: ${noteController.location.value}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),

                  // Konum Alma Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => noteController.fetchCurrentLocation(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Get Current Location"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dosya Seçme Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Select File", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Dosya Adı Gösterme
                  if (selectedFile != null)
                    Text(
                      "Selected File: ${selectedFile!.name}",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  const SizedBox(height: 16),

                  // Kaydet Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        noteController.addNote(
                          titleController.text,
                          contentController.text,
                          selectedFile,
                        );
                        Get.toNamed('/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save Note", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Alt Logo
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "B-Note",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}