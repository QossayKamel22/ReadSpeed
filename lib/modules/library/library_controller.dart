import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/services/auth_service.dart';

class LibraryController extends GetxController {
  final _auth = Get.find<AuthService>();
  final _bookRepo = BookRepository();

  final search = ''.obs;
  final filter = 'All'.obs;
  final isLoading = true.obs;
  final books = <Book>[].obs;

  static const filters = ['All', 'Books', 'PDFs', 'Articles'];

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    final uid = _auth.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }
    _sub = _bookRepo.watchBooks(uid).listen((list) {
      books.assignAll(list);
      isLoading.value = false;
    });
  }

  List<Book> get filteredBooks {
    return books.where((b) {
      final matchesSearch = search.value.isEmpty ||
          b.title.toLowerCase().contains(search.value.toLowerCase()) ||
          b.author.toLowerCase().contains(search.value.toLowerCase());
      final matchesFilter = filter.value == 'All' ||
          (filter.value == 'Books' && b.type == BookType.book) ||
          (filter.value == 'PDFs' && b.type == BookType.pdf) ||
          (filter.value == 'Articles' && b.type == BookType.article);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> addBook({
    required String title,
    required String author,
    required BookType type,
  }) async {
    final uid = _auth.uid;
    if (uid == null) throw StateError('Not signed in');
    await _bookRepo.addBook(
      uid: uid,
      title: title,
      author: author,
      type: type,
      coverIndex: books.length,
    );
  }

  Future<void> deleteBook(String bookId) async {
    final uid = _auth.uid;
    if (uid == null) return;
    await _bookRepo.deleteBook(uid, bookId);
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
