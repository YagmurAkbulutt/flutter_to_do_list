import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/task.dart';
import '../cubit/home_cubit.dart';
import '../cubit/category_cubit.dart';
import 'add_task_page.dart';
import 'detail_page.dart';
import '../../utils/safe_date_format.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String selectedFilter = "Tümü";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Yeni Kategori Ekle',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(
            hintText: 'Kategori adı girin',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (categoryController.text.trim().isNotEmpty) {
                await context.read<CategoryCubit>().addCategory(categoryController.text.trim());
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${categoryController.text.trim()}" kategorisi eklendi!'),
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
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(String category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Kategoriyi Sil',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '"$category" kategorisini silmek istediğinize emin misiniz?\n\nBu işlem geri alınamaz.',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'İptal',
              style: TextStyle(
                color: Color(0xFF666666),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<CategoryCubit>().deleteCategory(category);
              if (mounted) {
                if (selectedFilter == category) {
                  setState(() {
                    selectedFilter = "Tümü";
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"$category" kategorisi silindi!'),
                    backgroundColor: const Color(0xFFFF6B6B),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Evet'),
          ),
        ],
      ),
    );
  }

  void _showCategoryManagementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Kategori Yönetimi',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: BlocBuilder<CategoryCubit, List<String>>(
            builder: (context, categories) {
              final customCategories = categories.where((cat) => 
                !['İş', 'Ev', 'Kişisel'].contains(cat)).toList();
              
              if (customCategories.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Henüz özel kategori yok.\nYeni kategori ekleyebilirsiniz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF666666)),
                  ),
                );
              }
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Özel kategorilerinizi silebilirsiniz:',
                    style: TextStyle(color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 16),
                  ...customCategories.map((category) => ListTile(
                    leading: Icon(
                      _getCategoryIcon(category),
                      color: _getCategoryColor(category),
                    ),
                    title: Text(category),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFFF6B6B),
                      ),
                      onPressed: () async {
                        await context.read<CategoryCubit>().deleteCategory(category);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"$category" kategorisi silindi!'),
                              backgroundColor: const Color(0xFFFF6B6B),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )),
                ],
              );
            },
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kapat'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddCategoryDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EFF),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Yeni Ekle'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..listenTasks(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Merhaba! 👋',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Bugün neler yapacaksın?',
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Category Filter
                        BlocBuilder<CategoryCubit, List<String>>(
                          builder: (context, categories) {
                            List<String> allFilters = ["Tümü", ...categories];
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var category in allFilters)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: _buildCategoryChip(category),
                                    ),
                                  // Add Category Button
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: _showAddCategoryDialog,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: const Color(0xFF6B4EFF),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add_rounded,
                                              size: 16,
                                              color: Color(0xFF6B4EFF),
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Kategori Ekle',
                                              style: TextStyle(
                                                color: Color(0xFF6B4EFF),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Manage Categories Button
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: GestureDetector(
                                      onTap: _showCategoryManagementDialog,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: const Color(0xFFFF6B6B),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.settings_rounded,
                                              size: 16,
                                              color: Color(0xFFFF6B6B),
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Yönet',
                                              style: TextStyle(
                                                color: Color(0xFFFF6B6B),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Task List Section
                  Expanded(
                    child: BlocBuilder<HomeCubit, List<Task>>(
                      builder: (context, tasks) {
                        if (tasks.isEmpty) {
                          return _buildEmptyState();
                        }

                        final filteredTasks = selectedFilter == "Tümü"
                            ? tasks
                            : tasks.where((t) => t.category == selectedFilter).toList();

                        if (filteredTasks.isEmpty) {
                          return _buildEmptyCategory();
                        }

                        final pendingTasks = filteredTasks.where((t) => !t.isDone).toList();
                        final completedTasks = filteredTasks.where((t) => t.isDone).toList();

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pending Tasks Section
                              if (pendingTasks.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Görevlerin',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6B4EFF).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${pendingTasks.length}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: const Color(0xFF6B4EFF),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    children: [
                                      for (int index = 0; index < pendingTasks.length; index++)
                                        _buildTaskCard(pendingTasks[index], index),
                                    ],
                                  ),
                                ),
                              ],
                              
                              // Completed Tasks Section
                              if (completedTasks.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Tamamlanan Görevler',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF4ECDC4),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4ECDC4).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${completedTasks.length}',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: const Color(0xFF4ECDC4),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    children: [
                                      for (int index = 0; index < completedTasks.length; index++)
                                        _buildTaskCard(completedTasks[index], index),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 100), // Add bottom padding for FAB
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = selectedFilter == category;
    final color = category == "Tümü" ? const Color(0xFF6B4EFF) : _getCategoryColor(category);
    final canDelete = category != "Tümü" && !['İş', 'Ev', 'Kişisel'].contains(category);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = category;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category != "Tümü") ...[
              Icon(
                _getCategoryIcon(category),
                size: 14,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (canDelete) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _showDeleteCategoryDialog(category),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: isSelected ? Colors.white : const Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => DetailPage(task: task),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.read<HomeCubit>().toggleDone(task),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: task.isDone ? _getCategoryColor(task.category) : Colors.transparent,
                            border: Border.all(
                              color: task.isDone ? _getCategoryColor(task.category) : const Color(0xFFE0E0E0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: task.isDone
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                decoration: task.isDone ? TextDecoration.lineThrough : null,
                                color: task.isDone ? const Color(0xFF999999) : null,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (task.description != null && task.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: task.isDone ? const Color(0xFFCCCCCC) : const Color(0xFF666666),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => DetailPage(task: task),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B4EFF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFF6B4EFF),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => context.read<HomeCubit>().deleteTask(task.id!),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFFF6B6B),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(task.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCategoryIcon(task.category),
                              size: 14,
                              color: _getCategoryColor(task.category),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.category,
                              style: TextStyle(
                                color: _getCategoryColor(task.category),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (task.dueDate != null)
                        Row(
                          children: [
                            // Overdue warning icon
                            if (SafeDateFormat.isOverdue(task.dueDate!) && !task.isDone) ...[
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.warning_rounded,
                                  size: 14,
                                  color: Color(0xFFFF6B6B),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: SafeDateFormat.isOverdue(task.dueDate!) && !task.isDone 
                                  ? const Color(0xFFFF6B6B)
                                  : const Color(0xFF999999),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              SafeDateFormat.formatTurkishDateTime(task.dueDate!),
                              style: TextStyle(
                                color: SafeDateFormat.isOverdue(task.dueDate!) && !task.isDone 
                                    ? const Color(0xFFFF6B6B)
                                    : const Color(0xFF999999),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (SafeDateFormat.isOverdue(task.dueDate!) && !task.isDone) ...[
                              const SizedBox(width: 6),
                              Text(
                                '(${SafeDateFormat.getRelativeTime(task.dueDate!)})',
                                style: const TextStyle(
                                  color: Color(0xFFFF6B6B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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
              color: const Color(0xFF6B4EFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              size: 48,
              color: Color(0xFF6B4EFF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Henüz görev yok',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'İlk görevini ekleyerek başla!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '🎯',
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            '$selectedFilter kategorisinde görev yok',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bu kategoriye yeni görev ekleyebilirsin',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4EFF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AddTaskPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        backgroundColor: const Color(0xFF6B4EFF),
        foregroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'Yeni Görev',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
