import 'package:flutter/material.dart';
import 'package:langnote/constants/theme_colors.dart';
import 'package:langnote/models/word.dart';
import 'package:langnote/screens/add_word_screen.dart';
import 'package:langnote/screens/word_detail_screen.dart';
import 'package:langnote/services/hive_service.dart';
import 'package:langnote/widgets/word_card.dart';
import 'package:langnote/widgets/custome_app_bar.dart';
import 'package:langnote/widgets/search_bar_widget.dart';
import 'package:langnote/widgets/category_filter_chips.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Word> _words = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _loadWords();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    setState(() => _isLoading = true);

    try {
      final words = await HiveService.getAllWords();
      setState(() {
        _words = words;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Word> get _filteredWords {
    List<Word> filtered = _words;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((word) => word.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((word) {
            return word.langA.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                word.langB.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                word.category.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          CustomAppBar(title: 'LangNote', subtitle: 'Master German vocabulary'),

          // Search and Filter Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar
                  SearchBarWidget(
                    hintText: 'Search words, translations...',
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Category Filter
                  CategoryFilterChips(
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Words List Header
          SliverToBoxAdapter(child: _buildWordsListHeader()),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Words List
          _buildWordsList(),

          // Bottom spacing for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildWordsListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredWords.length} words',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ThemeColors.textMuted,
            ),
          ),
          if (_filteredWords.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ThemeColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 16,
                    color: ThemeColors.successGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Learning',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.successGreen,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWordsList() {
    if (_isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: ThemeColors.primaryPurple),
        ),
      );
    }

    if (_filteredWords.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final word = _filteredWords[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: WordCard(
              word: word,
              onTap: () => _navigateToWordDetail(word),
            ),
          );
        }, childCount: _filteredWords.length),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchQuery.isNotEmpty
                  ? Icons.search_off_rounded
                  : Icons.book_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ? 'No words found' : 'No words yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ThemeColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Add some words to get started!',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: AppGradients.primary,
          boxShadow: [
            BoxShadow(
              color: ThemeColors.primaryPurple.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: _navigateToAddWord,
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
          label: const Text(
            'Add Word',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToWordDetail(Word word) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => WordDetailScreen(
              word: word,
              onDelete: (id) async {
                await HiveService.deleteWord(id);
                _loadWords();
                Navigator.pop(context);
              },
              onUpdate: (updatedWord) async {
                await HiveService.updateWord(updatedWord);
                _loadWords();
                Navigator.pop(context);
              },
            ),
      ),
    );
  }

  void _navigateToAddWord() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddWordScreen(
              onAdd: (String langA, String langB, String category) async {
                final nextId = await HiveService.getNextId();
                final newWord = Word(
                  id: nextId,
                  langA: langA,
                  langB: langB,
                  category: category,
                );
                await HiveService.addWord(newWord);
                _loadWords();
              },
            ),
      ),
    );
  }
}
