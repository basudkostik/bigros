import 'package:bigross/views/anasayfa.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.asset(
              category.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          category.label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
