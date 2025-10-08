import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepo {
  final CollectionReference categoriesRef =
      FirebaseFirestore.instance.collection('categories');

  // Default categories
  final List<String> defaultCategories = ['İş', 'Ev', 'Kişisel'];

  Future<void> addCategory(String categoryName) async {
    await categoriesRef.add({
      'name': categoryName,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<String>> getAllCategoriesStream() {
    return categoriesRef.snapshots().map((snapshot) {
      List<String> customCategories = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).map((data) => data['name'] as String).toList();
      
      // Combine default categories with custom ones
      List<String> allCategories = [...defaultCategories];
      for (String category in customCategories) {
        if (!allCategories.contains(category)) {
          allCategories.add(category);
        }
      }
      return allCategories;
    });
  }

  Future<void> deleteCategory(String categoryName) async {
    // Don't allow deletion of default categories
    if (defaultCategories.contains(categoryName)) {
      return;
    }
    
    QuerySnapshot snapshot = await categoriesRef
        .where('name', isEqualTo: categoryName)
        .get();
    
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}