import 'package:flutter/material.dart';
import 'package:langnote/constants/categories.dart';
import 'package:langnote/constants/theme_colors.dart';
import 'package:langnote/models/word.dart';
import 'package:langnote/utils/category_helper.dart';
import 'package:langnote/widgets/custome_app_bar.dart';
import 'package:langnote/widgets/language_input_section.dart';
import 'package:langnote/widgets/custome_button.dart';

class WordDetailScreen extends StatefulWidget {
  final Word word;
  final Function(int) onDelete;
  final Function(Word) onUpdate;

  const WordDetailScreen({
    super.key,
    required this.word,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen>
    with TickerProviderStateMixin {
  late TextEditingController _langAController;
  late TextEditingController _langBController;
  late String _selectedCategory;
  bool _isEditing = false;
  bool _isSubmitting = false;

  late AnimationController _animationController;
  late AnimationController _editAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _editFadeAnimation;

  final List<String> _categories = AppCategories.wordCategories;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
  }

  void _initializeControllers() {
    _langAController = TextEditingController(text: widget.word.langA);
    _langBController = TextEditingController(text: widget.word.langB);
    _selectedCategory = widget.word.category;
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _editAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _editFadeAnimation = CurvedAnimation(
      parent: _editAnimationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _langAController.dispose();
    _langBController.dispose();
    _animationController.dispose();
    _editAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          CustomAppBar(
            title: _isEditing ? 'Edit Word' : 'Word Details',
            subtitle: widget.word.category,
            gradient: AppGradients.categoryGradient(widget.word.category),
            leading: _buildBackButton(),
            actions: _buildAppBarActions(),
          ),

          // Content
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _isEditing ? _buildEditForm() : _buildWordDisplay(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ThemeColors.textSecondary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isEditing) return [];

    return [
      Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.edit_rounded,
            color: ThemeColors.primaryPurple,
          ),
          onPressed: _enterEditMode,
        ),
      ),
    ];
  }

  Widget _buildWordDisplay() {
    return Column(
      children: [
        // Main Word Card
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ThemeColors.getCategoryColor(
                widget.word.category,
              ).withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.getCategoryColor(
                  widget.word.category,
                ).withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // German Section
              _buildLanguageDisplaySection(
                flag: '🇩🇪',
                language: 'German',
                text: widget.word.langB,
                colors: [
                  Colors.red.shade50,
                  Colors.red.shade100.withOpacity(0.5),
                ],
                borderColor: Colors.red.shade100,
                badgeColor: Colors.red.shade100,
                textColor: const Color(0xFF7F1D1D),
                fontSize: 36,
              ),

              const SizedBox(height: 20),

              // Translation Arrow
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.translate_rounded,
                  color: Colors.grey.shade600,
                  size: 24,
                ),
              ),

              const SizedBox(height: 20),

              // English Section
              _buildLanguageDisplaySection(
                flag: '🇬🇧',
                language: 'English',
                text: widget.word.langA,
                colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade100.withOpacity(0.5),
                ],
                borderColor: Colors.blue.shade100,
                badgeColor: Colors.blue.shade100,
                textColor: const Color(0xFF1E3A8A),
                fontSize: 28,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Action Buttons
        _buildViewActions(),
      ],
    );
  }

  Widget _buildLanguageDisplaySection({
    required String flag,
    required String language,
    required String text,
    required List<Color> colors,
    required Color borderColor,
    required Color badgeColor,
    required Color textColor,
    required double fontSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$flag $language',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: ThemeColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return FadeTransition(
      opacity: _editFadeAnimation,
      child: Column(
        children: [
          // German Edit Section
          LanguageInputSection(
            emoji: '🇩🇪',
            language: 'German',
            subtitle: 'Edit German word',
            controller: _langBController,
            hintText: 'Enter German word...',
            isPrimary: true,
          ),

          const SizedBox(height: 24),

          // English Edit Section
          LanguageInputSection(
            emoji: '🇬🇧',
            language: 'English',
            subtitle: 'Edit English translation',
            controller: _langAController,
            hintText: 'Enter English translation...',
          ),

          const SizedBox(height: 24),

          // Category Edit Section
          _buildEditCategorySection(),

          const SizedBox(height: 32),

          // Edit Action Buttons
          _buildEditActions(),
        ],
      ),
    );
  }

  Widget _buildEditCategorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                CategoryHelper.getEmoji(_selectedCategory),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ThemeColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: ThemeColors.primaryPurple,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            items:
                _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Text(
                          CategoryHelper.getEmoji(category),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() => _selectedCategory = value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildViewActions() {
    return Row(
      children: [
        // Edit Button
        Expanded(
          child: GradientButton(
            text: 'Edit',
            icon: Icons.edit_rounded,
            onPressed: _enterEditMode,
          ),
        ),

        const SizedBox(width: 16),

        // Delete Button
        Expanded(
          child: OutlineButton(
            text: 'Delete',
            borderColor: ThemeColors.warningRed,
            textColor: ThemeColors.warningRed,
            onPressed: _showDeleteConfirmation,
          ),
        ),
      ],
    );
  }

  Widget _buildEditActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Save Button
        GradientButton(
          text: 'Save Changes',
          icon: Icons.save_rounded,
          gradient: AppGradients.success,
          isLoading: _isSubmitting,
          onPressed: _handleUpdate,
        ),

        const SizedBox(height: 16),

        // Cancel Button
        OutlineButton(
          text: 'Cancel',
          onPressed: _isSubmitting ? null : _cancelEdit,
        ),
      ],
    );
  }

  void _enterEditMode() {
    setState(() => _isEditing = true);
    _editAnimationController.forward();
  }

  void _cancelEdit() {
    setState(() {
      // Reset form
      _langAController.text = widget.word.langA;
      _langBController.text = widget.word.langB;
      _selectedCategory = widget.word.category;
      _isEditing = false;
    });
    _editAnimationController.reverse();
  }

  Future<void> _handleUpdate() async {
    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call

      final updatedWord = Word(
        id: widget.word.id,
        langA: _langAController.text.trim(),
        langB: _langBController.text.trim(),
        category: _selectedCategory,
      );

      widget.onUpdate(updatedWord);
    } catch (e) {
      setState(() => _isSubmitting = false);
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: ThemeColors.warningRed,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Delete Word',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${widget.word.langB}"? This action cannot be undone.',
            style: const TextStyle(fontSize: 16, color: ThemeColors.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.textMuted,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.warningRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDelete(widget.word.id);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
