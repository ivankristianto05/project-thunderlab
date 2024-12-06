import 'package:flutter/material.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';

class EmptyData extends StatelessWidget {
  EmptyData({
    Key? key,
  }) : super(key: key);

  // final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15.0, 60.0, 15.0, 60.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fastfood_outlined,
            color: theme.colorScheme.secondary,
            size: 90.0,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No data available yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
