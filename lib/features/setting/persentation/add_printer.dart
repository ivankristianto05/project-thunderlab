import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/widgets/custom_elevated_button.dart';

import 'package:kontena_pos/core/api/get_printer.dart' as callGetPrinter;

class AddPrinter extends StatefulWidget {
  VoidCallback? onTapAdd;
  AddPrinter({
    Key? key,
    this.onTapAdd,
  });

  @override
  _AddPrinterState createState() => _AddPrinterState();
}

class _AddPrinterState extends State<AddPrinter> {
  late SingleValueDropDownController selectedPrinterUSB =
      SingleValueDropDownController();
  List<DropDownValueModel> listPrinterModel = [];

  List<dynamic> listPrinter = [];
  List<String> optionsSize = ["58 mm", "80 mm"];

  String selectedPrinter = '';
  String selectedPaperSize = '80 mm';

  @override
  void initState() {
    super.initState();
    onGetPrinter(context);

    if (AppState().listPrinter.isNotEmpty) {
      setState(() {
        // listPrinter = AppState().listPrinter;
        // for (var printer in AppState().listPrinter) {
        //   listPrinterModel.add(DropDownValueModel(
        //     name: printer['name'],
        //     value: printer['name'],
        //   ));
        // }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  onGetPrinter(BuildContext context) async {
    String url = 'getPrinter';
    String ipAddress = '127.0.0.1';
    final callGetPrinter.getPrinter dataPrinter =
        callGetPrinter.getPrinter(url: url, ipAddress: ipAddress);

    final resultPrinter =
        await callGetPrinter.requestGetPrinter(requestQuery: dataPrinter);

    if (resultPrinter.containsKey('printer')) {
      setState(() {
        AppState().listPrinter = resultPrinter['printer'];
        listPrinter = resultPrinter['printer'];
        for (var printer in listPrinter) {
          listPrinterModel.add(DropDownValueModel(
            name: printer['name'],
            value: printer['name'],
          ));
        }
      });
    }
  }

  onTapAdd(BuildContext context) async {
    Navigator.pop(context, {
      'selectedPrinter': selectedPrinter,
      'selectedPaperSize': selectedPaperSize,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.3,
                height: MediaQuery.sizeOf(context).height * 0.5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 16.0),
                            child: Text(
                              'Add Printer',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.of(context).pop(false);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16.0, 16.0, 16.0, 16.0),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: theme.colorScheme.secondary,
                                    size: 20.0,
                                  ),
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
                      color: theme.colorScheme.outline,
                    ),
                    Expanded(
                      // width: double.infinity,
                      // height: 48.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 6.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Set Printer',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 6.0, 0.0, 16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 300.0,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.primaryContainer,
                                          border: Border.all(
                                            color: theme.colorScheme.outline,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(6.0, 0.0, 6.0, 0.0),
                                          child: DropDownTextField(
                                            controller: selectedPrinterUSB,
                                            dropDownItemCount:
                                                listPrinter.length,
                                            enableSearch: false,
                                            clearOption: false,
                                            // initialValue: selectedPrinter ?? '',
                                            dropDownList: listPrinterModel,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedPrinter = value.name;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(5.0, 0.0, 0.0, 0.0),
                                        child: CustomElevatedButton(
                                          text: "Get Printer",
                                          width: 120.0,
                                          height: 42.0,
                                          buttonTextStyle: TextStyle(
                                            color: theme.colorScheme.primary,
                                          ),
                                          buttonStyle:
                                              CustomButtonStyles.outlinePrimary,
                                          onPressed: () async {
                                            await onGetPrinter(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Paper Size',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 6.0, 0.0, 0.0),
                                  child: Container(
                                    width: 300.0,
                                    height: 45.0,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      border: Border.all(
                                        color: theme.colorScheme.outline,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: const Text("Select an Option"),
                                          value: selectedPaperSize,
                                          items: optionsSize.map(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedPaperSize = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
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
                      color: theme.colorScheme.outline,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          8.0, 8.0, 8.0, 8.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // onTapDone(context);
                          // widget.onTapSave();
                          onTapAdd(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          alignment: const AlignmentDirectional(0.00, 0.00),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 4.0, 4.0, 4.0),
                            child: Text(
                              'Add Printer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.colorScheme.primaryContainer,
                              ),
                            ),
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
    );
  }
}
