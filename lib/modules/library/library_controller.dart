import 'package:get/get.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/book.dart';

class LibraryController extends GetxController {
  final search = ''.obs;
  final filter = 'All'.obs;

  static const filters = ['All', 'Books', 'PDFs', 'Articles'];

  final allBooks = MockData.books;

  List<Book> get filteredBooks {
    return allBooks.where((b) {
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
}
