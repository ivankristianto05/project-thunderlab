import 'package:flutter/material.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/number_ui.dart';

class NumPad extends StatefulWidget {
  final Function(String) onResult;
  double? initialValue = 0.0;
  bool isDisable = false;
  NumPad({
    super.key,
    required this.onResult,
    this.initialValue,
    required this.isDisable,
  });
  @override
  _NumPadWidgetState createState() => _NumPadWidgetState();
}

class _NumPadWidgetState extends State<NumPad> {
  double nominal = 0;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.initialValue != null) {
        nominal = widget.initialValue!;
      }
    });
  }

  @override
  void didUpdateWidget(NumPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        nominal = widget.initialValue ?? 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.31,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 1,
            height: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        numberFormat('idr', nominal),
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 34.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              for (int number = 7; number <= 8; number++)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 2.0, 2.0, 2.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (widget.isDisable == false) {
                                          setState(() {
                                            nominal = addNominal(
                                                nominal, number.toString());
                                          });
                                          widget.onResult(nominal.toString());
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.1,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.background,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              number.toString(),
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              for (int number = 4; number <= 5; number++)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 2.0, 2.0, 2.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (widget.isDisable == false) {
                                          setState(() {
                                            nominal = addNominal(
                                                nominal, number.toString());
                                          });
                                          widget.onResult(nominal.toString());
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.1,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.background,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              number.toString(),
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              for (int number = 1; number <= 2; number++)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 2.0, 2.0, 2.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (widget.isDisable == false) {
                                          setState(() {
                                            nominal = addNominal(
                                                nominal, number.toString());
                                          });
                                          widget.onResult(nominal.toString());
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.1,
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.background,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              number.toString(),
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.isDisable == false) {
                                  setState(() {
                                    nominal = addNominal(nominal, '0');
                                  });
                                  widget.onResult(nominal.toString());
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.isDisable == false) {
                                  setState(() {
                                    nominal = addNominal(nominal, '9');
                                  });
                                  widget.onResult(nominal.toString());
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '9',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.isDisable == false) {
                                  setState(() {
                                    nominal = addNominal(nominal, '6');
                                  });
                                  widget.onResult(nominal.toString());
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '6',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.isDisable == false) {
                                  setState(() {
                                    nominal = addNominal(nominal, '3');
                                  });
                                  widget.onResult(nominal.toString());
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '3',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.isDisable == false) {
                                  setState(() {
                                    nominal = addNominal(nominal, '00');
                                  });
                                  widget.onResult(nominal.toString());
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '00',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.isDisable == false) {
                                  if (nominal > 10) {
                                    setState(() {
                                      nominal = removeNominal(nominal);
                                    });
                                  } else {
                                    setState(() {
                                      nominal = 0;
                                    });
                                  }
                                  widget.onResult(nominal.toString());
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.205,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_rounded,
                                      color: theme.colorScheme.secondary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 2.0, 2.0, 2.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (widget.isDisable == false) {
                                  setState(() {
                                    nominal = 0;
                                  });
                                  widget.onResult(nominal.toString());
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.205,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.background,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'C',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // onTap()

  addNominal(double nominal, String num) {
    int oldVal = nominal.round();
    String tmp = oldVal.toString() + num;
    return double.parse(tmp);
  }

  removeNominal(double nominal) {
    int oldVal = nominal.round();
    String data = oldVal.toString();
    return double.parse(data.substring(0, data.length - 1));
  }
}
