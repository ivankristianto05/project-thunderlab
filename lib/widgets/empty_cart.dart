import 'package:flutter/material.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';

class EmptyCart extends StatelessWidget {
  EmptyCart({
    Key? key,
  }) : super(key: key);

  // final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cart Masih Kosong',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
