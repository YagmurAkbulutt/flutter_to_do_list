import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/ui/views/home_page.dart';
import '../cubit/add_task_cubit.dart';
import '../cubit/category_cubit.dart';
import '../widgets/digital_time_picker.dart';
import '../../utils/safe_date_format.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> with TickerProviderStateMixin {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final newCategoryCtrl = TextEditingController();
  DateTime? selectedDateTime;
  String selectedCategory = "Kişisel";
  bool isAddingNewCategory = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();

    context.read<CategoryCubit>().listenCategories();
  }

  @override
  void dispose() {
    _animationController.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    newCategoryCtrl.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'İş':
        return const Color(0xFF6B4EFF);
      case 'Ev':
        return const Color(0xFFFF6B9D);
      case 'Kişisel':
        return const Color(0xFF4ECDC4);
      default:
        return const Color(0xFF999999);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'İş':
        return Icons.work_outline_rounded;
      case 'Ev':
        return Icons.home_outlined;
      case 'Kişisel':
        return Icons.person_outline_rounded;
      default:
        return Icons.label_outline_rounded;
    }
  }

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF6B4EFF),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    // Show custom digital time picker
    if (mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          TimeOfDay selectedTime = TimeOfDay.now();
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DigitalTimePicker(
                      initialTime: TimeOfDay.now(),
                      onTimeChanged: (time) {
                        selectedTime = time;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('İptal'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final fullDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                              setState(() => selectedDateTime = fullDateTime);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B4EFF),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Tamam'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTaskCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yeni Görev',
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Hadi yeni bir görev oluşturalım 🎯',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Input
                          _buildInputSection(
                            'Görev Başlığı',
                            'Bugün ne yapacaksın?',
                            titleCtrl,
                            Icons.edit_note_rounded,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Description Input
                          _buildInputSection(
                            'Açıklama',
                            'Daha fazla detay ekle (isteğe bağlı)',
                            descCtrl,
                            Icons.description_outlined,
                            maxLines: 3,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Category Selection
                          _buildCategorySection(),
                          
                          const SizedBox(height: 24),
                          
                          // Date Time Selection
                          _buildDateTimeSection(),
                          
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  
                  // Bottom Save Button
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4EFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Görevi Kaydet',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4EFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: const Color(0xFF6B4EFF),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(20),
              hintStyle: TextStyle(
                color: const Color(0xFF999999),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4EFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 16,
                color: Color(0xFF6B4EFF),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Kategori',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BlocBuilder<CategoryCubit, List<String>>(
            builder: (context, categories) {
              if (categories.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Kategoriler yüklüyor...'),
                );
              }
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    // Existing categories
                    categories.length <= 3
                        ? Row(
                            children: [
                              for (var category in categories)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = category;
                                        isAddingNewCategory = false;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: selectedCategory == category && !isAddingNewCategory
                                            ? _getCategoryColor(category)
                                            : _getCategoryColor(category).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            _getCategoryIcon(category),
                                            size: 20,
                                            color: selectedCategory == category && !isAddingNewCategory
                                                ? Colors.white
                                                : _getCategoryColor(category),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            category,
                                            style: TextStyle(
                                              color: selectedCategory == category && !isAddingNewCategory
                                                  ? Colors.white
                                                  : _getCategoryColor(category),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Column(
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (var category in categories)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = category;
                                          isAddingNewCategory = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: selectedCategory == category && !isAddingNewCategory
                                              ? _getCategoryColor(category)
                                              : _getCategoryColor(category).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getCategoryIcon(category),
                                              size: 14,
                                              color: selectedCategory == category && !isAddingNewCategory
                                                  ? Colors.white
                                                  : _getCategoryColor(category),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              category,
                                              style: TextStyle(
                                                color: selectedCategory == category && !isAddingNewCategory
                                                    ? Colors.white
                                                    : _getCategoryColor(category),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                    
                    const SizedBox(height: 12),
                    
                    // Add new category button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAddingNewCategory = true;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isAddingNewCategory 
                              ? const Color(0xFF6B4EFF).withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF6B4EFF),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: const Color(0xFF6B4EFF),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Yeni Kategori Ekle',
                              style: TextStyle(
                                color: const Color(0xFF6B4EFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // New category input field
                    if (isAddingNewCategory) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: newCategoryCtrl,
                        autofocus: true,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Kategori adı girin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF6B4EFF),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF6B4EFF),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintStyle: TextStyle(
                            color: const Color(0xFF999999),
                            fontSize: 14,
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isAddingNewCategory = false;
                                    newCategoryCtrl.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFFFF6B6B),
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (newCategoryCtrl.text.trim().isNotEmpty) {
                                    await context.read<CategoryCubit>().addCategory(newCategoryCtrl.text.trim());
                                    setState(() {
                                      selectedCategory = newCategoryCtrl.text.trim();
                                      isAddingNewCategory = false;
                                      newCategoryCtrl.clear();
                                    });
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('"${selectedCategory}" kategorisi eklendi!'),
                                          backgroundColor: const Color(0xFF4ECDC4),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(
                                  Icons.check,
                                  color: Color(0xFF4ECDC4),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onSubmitted: (value) async {
                          if (value.trim().isNotEmpty) {
                            await context.read<CategoryCubit>().addCategory(value.trim());
                            setState(() {
                              selectedCategory = value.trim();
                              isAddingNewCategory = false;
                              newCategoryCtrl.clear();
                            });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('"$value" kategorisi eklendi!'),
                                  backgroundColor: const Color(0xFF4ECDC4),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4EFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: Color(0xFF6B4EFF),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Tarih & Saat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: pickDateTime,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedDateTime != null
                    ? const Color(0xFF6B4EFF)
                    : const Color(0xFFE0E0E0),
                width: selectedDateTime != null ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedDateTime != null
                        ? const Color(0xFF6B4EFF).withOpacity(0.1)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: selectedDateTime != null
                        ? const Color(0xFF6B4EFF)
                        : const Color(0xFF999999),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDateTime == null
                            ? 'Tarih ve saat seçin'
                            : SafeDateFormat.formatTurkishDate(selectedDateTime!),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedDateTime != null
                              ? const Color(0xFF333333)
                              : const Color(0xFF999999),
                        ),
                      ),
                      if (selectedDateTime != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          SafeDateFormat.formatTime(selectedDateTime!),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B4EFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: const Color(0xFF999999),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveTask() async {
    if (titleCtrl.text.trim().isEmpty || selectedDateTime == null) {
      _showErrorSnackBar(
        titleCtrl.text.trim().isEmpty
            ? 'Lütfen görev başlığı girin'
            : 'Lütfen tarih ve saat seçin',
      );
      return;
    }

    String categoryToSave = isAddingNewCategory && newCategoryCtrl.text.trim().isNotEmpty 
        ? newCategoryCtrl.text.trim() 
        : selectedCategory;

    try {
      await context.read<AddTaskCubit>().addTask(
            titleCtrl.text.trim(),
            descCtrl.text.trim(),
            selectedDateTime!,
            categoryToSave,
          );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Görev başarıyla eklendi!'),
              ],
            ),
            backgroundColor: const Color(0xFF4ECDC4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Bir hata oluştu: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
