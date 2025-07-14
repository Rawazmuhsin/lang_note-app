import 'package:flutter/material.dart';
import 'package:langnote/app/app.dart';
import 'package:langnote/services/hive_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await HiveService.initHive();

  // Initialize default data if needed
  await HiveService.initializeDefaultData();

  // Run the app
  runApp(const LangNoteApp());
}
