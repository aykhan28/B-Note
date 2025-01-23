import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noteapp/views/home_page.dart';
import 'package:noteapp/views/login_page.dart';
import 'package:noteapp/views/note_create_page.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/note-create', page: () => NoteCreatePage()),
      ],
    );
  }
}