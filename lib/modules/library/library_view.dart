import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/book_card.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/inputs.dart';
import 'library_controller.dart';
import 'widgets/add_book_modal.dart';
import 'widgets/book_details_modal.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LibraryController());
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;
    final crossCount = width >= 1200
        ? 5
        : width >= 900
            ? 4
            : width >= 600
                ? 3
                : 2;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(isDesktop ? 32 : 18, isDesktop ? 28 : 18,
            isDesktop ? 32 : 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Library', style: AppTextStyles.h1),
                PrimaryButton(
                  label: 'Add Book',
                  icon: Icons.add_rounded,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () => AddBookModal.show(context),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AppSearchBar(
              hint: 'Search books, authors...',
              onChanged: (v) => c.search.value = v,
            ),
            const SizedBox(height: 14),
            Obx(() => FilterTabs(
                  options: LibraryController.filters,
                  selected: c.filter.value,
                  onSelected: (v) => c.filter.value = v,
                )),
            const SizedBox(height: 18),
            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.green),
                  );
                }
                final books = c.filteredBooks;
                if (books.isEmpty) {
                  return Center(
                    child: Text(
                      c.books.isEmpty
                          ? 'Your library is empty. Add your first book!'
                          : 'No books found',
                      style: AppTextStyles.bodySecondary,
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: books.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossCount,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, i) {
                    final book = books[i];
                    return BookCard(
                      book: book,
                      onTap: () => BookDetailsModal.show(context, book),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
