import 'package:hive_flutter/hive_flutter.dart';
import 'package:langnote/models/hive_word.dart';
import 'package:langnote/models/word.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

/// Service to manage Hive database and word operations
class HiveService {
  static const String _boxName = 'words';

  /// Initialize Hive database
  static Future<void> initHive() async {
    // Initialize Hive and set the application documents directory
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);

    // Register adapters
    Hive.registerAdapter(HiveWordAdapter());
  }

  /// Close all open Hive boxes
  static Future<void> closeHive() async {
    await Hive.close();
  }

  // Get reference to the box
  static Future<Box<HiveWord>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<HiveWord>(_boxName);
    }
    return Hive.box<HiveWord>(_boxName);
  }

  // Convert between domain model and Hive model
  static Word _mapToWord(HiveWord hiveModel) {
    return Word(
      id: hiveModel.id,
      langA: hiveModel.langA,
      langB: hiveModel.langB,
      category: hiveModel.category,
    );
  }

  static HiveWord _mapToHiveModel(Word word) {
    return HiveWord(
      id: word.id,
      langA: word.langA,
      langB: word.langB,
      category: word.category,
    );
  }

  /// Get all words
  static Future<List<Word>> getAllWords() async {
    final box = await _getBox();
    return box.values.map((hiveModel) => _mapToWord(hiveModel)).toList();
  }

  /// Add a new word
  static Future<void> addWord(Word word) async {
    final box = await _getBox();
    await box.put(word.id, _mapToHiveModel(word));
  }

  /// Update an existing word
  static Future<void> updateWord(Word word) async {
    final box = await _getBox();
    await box.put(word.id, _mapToHiveModel(word));
  }

  /// Delete a word
  static Future<void> deleteWord(int id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  /// Get the next available ID
  static Future<int> getNextId() async {
    final box = await _getBox();
    if (box.isEmpty) {
      return 1;
    }

    final ids = box.values.map((model) => model.id).toList();
    return ids.reduce((curr, next) => curr > next ? curr : next) + 1;
  }

  /// Initialize with default data if empty
  static Future<void> initializeDefaultData() async {
    final box = await _getBox();

    if (box.isEmpty) {
      final defaultWords = [
        Word(id: 1, langA: 'Hello', langB: 'Hallo', category: 'Greeting'),
        Word(id: 2, langA: 'Thank you', langB: 'Danke', category: 'Courtesy'),
        Word(
          id: 3,
          langA: 'Good morning',
          langB: 'Guten Morgen',
          category: 'Greeting',
        ),
        Word(id: 4, langA: 'Water', langB: 'Wasser', category: 'Food & Drink'),
        Word(
          id: 5,
          langA: 'Friend',
          langB: 'Freund',
          category: 'Relationships',
        ),
      ];

      for (var word in defaultWords) {
        await addWord(word);
      }
    }
  }
}
