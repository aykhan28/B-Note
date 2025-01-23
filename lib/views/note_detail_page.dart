import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteapp/models/note.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NoteDetailPage extends StatelessWidget {
  late Note note;

  NoteDetailPage({super.key, required this.note});

  Future<void> _logNoteView() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'note_detail_view',
      parameters: <String, String>{
        'note_id': note.id,
        'user_id': note.userId!,
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    _logNoteView();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(note.title)),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: Get.back,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.content, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Location: '),
                if (note.location != null)
                  Text(note.location!),
              ],
            ),
            const SizedBox(height: 10),
            if (note.fileUrl != null && note.fileUrl!.isNotEmpty)
              GestureDetector(
                onTap: () => _launchURL(note.fileUrl!),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Attached File',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
