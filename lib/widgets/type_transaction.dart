import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';

class TypeTransaction extends StatefulWidget {
  TypeTransaction({Key? key, this.selected}) : super(key: key);

  String? selected;

  @override
  _TypeTransactionState createState() => _TypeTransactionState();
}

class _TypeTransactionState extends State<TypeTransaction> {
  String typeTransaction = 'dinein';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      typeTransaction = widget.selected!;
    }
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
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        child: Text(
                          'Choose the type of order',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      InkWell(
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
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 16.0, 16.0, 16.0),
                              child: Icon(
                                Icons.close_rounded,
                                color: theme.colorScheme.secondary,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: theme.colorScheme.surface,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 8.0, 8.0, 8.0),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 6.0, 8.0, 6.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        setState(() {
                                          if (typeTransaction == '') {
                                            typeTransaction = 'dine-in';
                                          } else if (typeTransaction !=
                                              'dine-in') {
                                            typeTransaction = 'dine-in';
                                          } else {
                                            typeTransaction = '';
                                          }
                                        });
                                        print('check, $typeTransaction');
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: (typeTransaction == "dine-in")
                                              ? theme.colorScheme.primary
                                              : theme
                                                  .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color:
                                                (typeTransaction == "dine-in")
                                                    ? theme.colorScheme.primary
                                                    : theme.colorScheme.surface,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 6.0, 0.0, 6.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'DINE IN',
                                                style: (typeTransaction ==
                                                        "dine-in")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelMedium,
                                              ),
                                              Text(
                                                'Order Dine In',
                                                style: (typeTransaction ==
                                                        "dine-in")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 4.0, 8.0, 4.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        setState(() {
                                          if (typeTransaction == '') {
                                            typeTransaction = 'ta';
                                          } else if (typeTransaction != 'ta') {
                                            typeTransaction = 'ta';
                                          } else {
                                            typeTransaction = '';
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: (typeTransaction == "ta")
                                              ? theme.colorScheme.primary
                                              : theme
                                                  .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: (typeTransaction == "ta")
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.surface,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 6.0, 0.0, 6.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'TA',
                                                style: (typeTransaction == "ta")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelMedium,
                                              ),
                                              Text(
                                                'Order Take Away',
                                                style: (typeTransaction == "ta")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 4.0, 8.0, 4.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        setState(() {
                                          if (typeTransaction == '') {
                                            typeTransaction = 'gojek';
                                          } else if (typeTransaction !=
                                              'gojek') {
                                            typeTransaction = 'gojek';
                                          } else {
                                            typeTransaction = '';
                                          }
                                        });
                                        print('check, $typeTransaction');
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: (typeTransaction == "gojek")
                                              ? theme.colorScheme.primary
                                              : theme
                                                  .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: (typeTransaction == "gojek")
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.surface,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 6.0, 0.0, 6.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'GOJEK',
                                                style: (typeTransaction ==
                                                        "gojek")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelMedium,
                                              ),
                                              Text(
                                                'Order GoFood',
                                                style: (typeTransaction ==
                                                        "gojek")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 4.0, 8.0, 4.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        setState(() {
                                          if (typeTransaction == '') {
                                            typeTransaction = 'grab';
                                          } else if (typeTransaction !=
                                              'grab') {
                                            typeTransaction = 'grab';
                                          } else {
                                            typeTransaction = '';
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: (typeTransaction == "grab")
                                              ? theme.colorScheme.primary
                                              : theme
                                                  .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: (typeTransaction == "grab")
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.surface,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 6.0, 0.0, 6.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'GRAB',
                                                style: (typeTransaction ==
                                                        "grab")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelMedium,
                                              ),
                                              Text(
                                                'Order GrabFood',
                                                style: (typeTransaction ==
                                                        "grab")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 4.0, 8.0, 4.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        setState(() {
                                          if (typeTransaction == '') {
                                            typeTransaction = 'shopee';
                                          } else if (typeTransaction !=
                                              'shopee') {
                                            typeTransaction = 'shopee';
                                          } else {
                                            typeTransaction = '';
                                          }
                                        });
                                        print('check, $typeTransaction');
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: (typeTransaction == "shopee")
                                              ? theme.colorScheme.primary
                                              : theme
                                                  .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: theme.colorScheme.surface,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 6.0, 0.0, 6.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'SHOPEE',
                                                style: (typeTransaction ==
                                                        "shopee")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelMedium,
                                              ),
                                              Text(
                                                'Order ShopeeFood',
                                                style: (typeTransaction ==
                                                        "shopee")
                                                    ? TextStyle(
                                                        color: theme.colorScheme
                                                            .primaryContainer)
                                                    : theme
                                                        .textTheme.labelMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: theme.colorScheme.surface,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 8.0, 8.0, 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              // typeTransaction = 'dinein';
                              setState(() {
                                AppState().typeTransaction = typeTransaction;
                              });
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              alignment: AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 4.0, 4.0, 4.0),
                                child: Text(
                                  'Confirm',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: theme.colorScheme.primaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
