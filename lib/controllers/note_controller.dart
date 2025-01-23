import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/note.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteController extends GetxController {
  var notes = <Note>[].obs;
  var isLoading = false.obs;
  var location = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
    fetchCurrentLocation();
  }

  void fetchNotes() async {
    try {
      isLoading(true);
      final currentUser = _auth.currentUser;
      final querySnapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: currentUser?.uid)
          .get();
      notes.value = querySnapshot.docs.map((doc) {
        return Note(
          id: doc.id,
          title: doc['title'],
          content: doc['content'],
          location: doc['location'],
          fileUrl: doc['fileUrl'],
          userId: doc['userId'],
          createdAt: doc['createdAt'].toDate(),
        );
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch notes: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<String?> uploadFile(PlatformFile? selectedFile) async {
    if (selectedFile == null) return null;

    try {
      final path = 'files/${selectedFile.name}';
      final ref = FirebaseStorage.instance.ref().child(path);

      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(selectedFile.bytes!);
      } else {
        final file = File(selectedFile.path!);
        uploadTask = ref.putFile(file);
      }

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Get.snackbar("Error", "Failed to upload file: $e",
          snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  Future<void> fetchCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final position = await Geolocator.getCurrentPosition();
      location.value = '${position.latitude}, ${position.longitude}';
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch location: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void addNote(String title, String content, PlatformFile? selectedFile) async {
    try {
      isLoading(true);

      String? fileUrl = await uploadFile(selectedFile);
      final currentUser = _auth.currentUser;

      await _firestore.collection('notes').add({
        'title': title,
        'content': content,
        'location': location.value,
        'fileUrl': fileUrl,
        'userId': currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Note added successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to add note: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  void deleteNote(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
      notes.removeWhere((note) => note.id == id);
      Get.snackbar("Success", "Note deleted successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete note: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}

//import 'package:geocoding/geocoding.dart';

  //Future<String> _getAddressFromLatLng(Position position) async {
  //  try {
  //    List<Placemark> placemarks = await placemarkFromCoordinates(
  //        position.latitude, position.longitude);
  //    Placemark place = placemarks[0];
  //
  //    addr = "${place.street}, ${place.locality}, ${place.country}";
  //    return addr;
  //  } catch (e) {
  //    return "Unknown Location";
  //  }
  //}