import 'package:bigross/card/category_card.dart';
import 'package:bigross/constants/routers.dart';
import 'package:bigross/dialogs/admin_dialog.dart';
import 'package:bigross/dialogs/logout_dialog.dart';
import 'package:bigross/enums/menu_action.dart';
import 'package:bigross/services/user/auth_service.dart';
import 'package:bigross/views/anasayfa.dart';
import 'package:bigross/views/product_view.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage({super.key});

  final List<Category> categories = [
    Category(image: 'assets/images/fruit_vegetable.png', label: 'Meyve, Sebze'),
    Category(
        image: 'assets/images/et_balık_tavuk.png', label: 'Et, Tavuk, Balık'),
    Category(image: 'assets/images/icecekler.png', label: 'İçecekler'),
    Category(image: 'assets/images/peynir.png', label: 'Süt Ürünleri'),
    Category(image: 'assets/images/temizlik.png', label: 'Deterjan, Temizlik'),
    Category(image: 'assets/images/aburcubur.png', label: 'Atıştırmalık'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }
                  break;
                case MenuAction.admin:
                  await showAdminLoginDialog(context); // Call the function
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.admin,
                  child: Text('Admin Panel'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      categoryId: category.label,
                    ),
                  ),
                );
              },
              child: CategoryCard(category: category),
            );
          },
        ),
      ),
    );
  }
}
