import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/category_repo.dart';

class CategoryCubit extends Cubit<List<String>> {
  CategoryCubit() : super([]);

  final CategoryRepo repo = CategoryRepo();

  void listenCategories() {
    repo.getAllCategoriesStream().listen((categories) {
      emit(categories);
    });
  }

  Future<void> addCategory(String categoryName) async {
    if (categoryName.trim().isEmpty) return;
    await repo.addCategory(categoryName.trim());
  }

  Future<void> deleteCategory(String categoryName) async {
    await repo.deleteCategory(categoryName);
  }
}