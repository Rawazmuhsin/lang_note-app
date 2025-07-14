import 'package:flutter/material.dart';
import 'package:langnote/constants/categories.dart';
import 'package:langnote/constants/theme_colors.dart';
import 'package:langnote/utils/category_helper.dart';

class AddWordScreen extends StatefulWidget {
  final Function(String, String, String) onAdd;

  const AddWordScreen({super.key, required this.onAdd});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _langAController = TextEditingController();
  final _langBController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isSubmitting = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _categories = AppCategories.wordCategories;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _langAController.dispose();
    _langBController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Compact App Bar - Fixed Height
          SliverAppBar(
            expandedHeight: 140, // Reduced from 160
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: _buildBackButton(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      16,
                      24,
                      16,
                    ), // Reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  8,
                                ), // Reduced padding
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  '🎯',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ), // Reduced size
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Add New Word',
                                      style: TextStyle(
                                        fontSize: 24, // Reduced from 32
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Expand your German vocabulary',
                                      style: TextStyle(
                                        fontSize: 14, // Reduced from 16
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Form Content - More Compact
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20), // Reduced from 24
                  child: _buildForm(),
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

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // German Word Section - More Compact
          _buildCompactLanguageSection(
            emoji: '🇩🇪',
            language: 'German',
            subtitle: 'Enter the German word',
            controller: _langBController,
            hintText: 'z.B. Hallo, Danke, Wasser...',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a German word';
              }
              return null;
            },
            isPrimary: true,
          ),

          const SizedBox(height: 20), // Reduced spacing
          // English Translation Section
          _buildCompactLanguageSection(
            emoji: '🇬🇧',
            language: 'English',
            subtitle: 'Enter the English translation',
            controller: _langAController,
            hintText: 'e.g. Hello, Thank you, Water...',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter an English translation';
              }
              return null;
            },
          ),

          const SizedBox(height: 20), // Reduced spacing
          // Category Section - More Compact
          _buildCompactCategorySection(),

          const SizedBox(height: 24), // Reduced spacing
          // Action Buttons - More Compact
          _buildCompactActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCompactLanguageSection({
    required String emoji,
    required String language,
    required String subtitle,
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isPrimary
                  ? ThemeColors.primaryPurple.withOpacity(0.2)
                  : Colors.grey.shade200,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isPrimary
                    ? ThemeColors.primaryPurple.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            blurRadius: isPrimary ? 15 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8), // Reduced padding
                decoration: BoxDecoration(
                  color:
                      isPrimary
                          ? ThemeColors.primaryPurple.withOpacity(0.1)
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        isPrimary
                            ? ThemeColors.primaryPurple.withOpacity(0.2)
                            : Colors.grey.shade200,
                  ),
                ),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 16), // Reduced size
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: isPrimary ? 16 : 15, // Reduced sizes
                        fontWeight: FontWeight.w700,
                        color:
                            isPrimary
                                ? ThemeColors.primaryPurple
                                : ThemeColors.textSecondary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12, // Reduced size
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced spacing
          TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: isPrimary ? 16 : 15, // Reduced sizes
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      isPrimary
                          ? ThemeColors.primaryPurple
                          : ThemeColors.primaryBlue,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.all(12), // Reduced padding
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCategorySection() {
    return Container(
      padding: const EdgeInsets.all(16), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8), // Reduced padding
                decoration: BoxDecoration(
                  color: ThemeColors.getCategoryColor(
                    _selectedCategory,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ThemeColors.getCategoryColor(
                      _selectedCategory,
                    ).withOpacity(0.2),
                  ),
                ),
                child: Text(
                  CategoryHelper.getEmoji(_selectedCategory),
                  style: const TextStyle(fontSize: 16), // Reduced size
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 15, // Reduced size
                        fontWeight: FontWeight.w700,
                        color: ThemeColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Choose the word category',
                      style: TextStyle(
                        fontSize: 12, // Reduced size
                        color: ThemeColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced spacing
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
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
              contentPadding: const EdgeInsets.all(12), // Reduced padding
            ),
            items:
                _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Text(
                          CategoryHelper.getEmoji(category),
                          style: const TextStyle(fontSize: 14), // Reduced size
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14, // Reduced size
                          ),
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

  Widget _buildCompactActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Save Button - More Compact
        Container(
          height: 48, // Reduced height
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.primaryPurple.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                _isSubmitting
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Save Word',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
          ),
        ),

        const SizedBox(height: 12), // Reduced spacing
        // Cancel Button - More Compact
        Container(
          height: 48, // Reduced height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextButton(
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate API call

        widget.onAdd(
          _langAController.text.trim(),
          _langBController.text.trim(),
          _selectedCategory,
        );

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
