import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';

class ProductGrid extends StatelessWidget {
  final Widget? image;
  final VoidCallback? onTap;
  final String name;
  final String category;
  final String description;
  final String price;

  const ProductGrid({
    super.key,
    this.image,
    this.onTap,
    this.name = 'Item Name',
    this.description = 'Item Deskripsi',
    this.category = 'None',
    this.price = '10000',
  });

  // Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.85, // Adjust aspect ratio as needed
              child: Container(
                color: Colors.grey[300],
                child: Center(
                  child: Image.asset(
                    'assets/images/stock-card-image.jpg',
                    height: 200.v,
                    width: 280.v,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                16.0,
                8.0,
                16.0,
                10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0,
                      0.0,
                      0.0,
                      4.0,
                    ),
                    child: AutoSizeText(
                      category,
                      style: theme.textTheme.labelMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 9,
                    ),
                  ),
                  AutoSizeText(
                    name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                  ),
                  const SizedBox(height: 12.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      price,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
