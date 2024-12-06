import 'package:flutter/material.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';

class DialogCustomWidget extends StatefulWidget {
  const DialogCustomWidget({
    Key? key,
    this.data,
    // required this.title,
    required this.description,
    this.isConfirm = false,
    this.onConfirm,
    this.captionConfirm,
    this.captionCancel,
    this.styleConfirm,
  }) : super(key: key);

  final dynamic data;
  // final String title;
  final String description;
  final bool isConfirm;
  final String? captionConfirm;
  final TextStyle? styleConfirm;
  final Function()? onConfirm;
  final String? captionCancel;

  @override
  _DialogCustomWidgetWidgetState createState() =>
      _DialogCustomWidgetWidgetState();
}

class _DialogCustomWidgetWidgetState extends State<DialogCustomWidget> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.3,
              height: MediaQuery.sizeOf(context).height * 0.22,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 5.0,
                    thickness: 0.5,
                    color: theme.colorScheme.outline,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.captionCancel ?? 'Batal',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ),
                        if (widget.isConfirm)
                          Expanded(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.onConfirm != null) {
                                  widget.onConfirm!();
                                  Navigator.pop(context);
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.captionConfirm ?? 'Lanjutkan',
                                    textAlign: TextAlign.center,
                                    style: widget.styleConfirm ??
                                        theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
