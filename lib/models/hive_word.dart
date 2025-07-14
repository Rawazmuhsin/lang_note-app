import 'package:hive/hive.dart';

part 'hive_word.g.dart';

@HiveType(typeId: 0)
class HiveWord extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String langA;

  @HiveField(2)
  String langB;

  @HiveField(3)
  String category;

  HiveWord({
    required this.id,
    required this.langA,
    required this.langB,
    required this.category,
  });

  @override
  String toString() {
    return 'HiveWord(id: $id, langA: $langA, langB: $langB, category: $category)';
  }
}
