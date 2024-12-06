import 'dart:convert';
import 'dart:io';

// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kontena_pos/core/utils/alert.dart';
import 'package:kontena_pos/features/setting/persentation/add_printer.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/config_app.dart';
// import 'package:kontena_pos/core/plugins/bluetooth_print_model.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/widgets/custom_elevated_button.dart';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:kontena_pos/core/api/get_printer.dart' as callGetPrinter;
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class SettingDevices extends StatefulWidget {
  SettingDevices({Key? key}) : super(key: key);

  @override
  _SettingDevicesState createState() => _SettingDevicesState();
}

class _SettingDevicesState extends State<SettingDevices> {
  bool canVoid = true;
  String selectedTipePrinter = 'USB';
  List<String> options = ['USB', 'Bluetooth'];
  List<dynamic> listPrinter = [];
  String selectedPrinter = '';
  List<dynamic> connectedPrinter = [];

  // BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  // List<BluetoothDevice> _devices = [];
  // BluetoothDevice? _device;
  bool _connected = false;

  // -----------
  // print bluetooth thermal plugin
  List<BluetoothInfo> items = [];
  BluetoothInfo? selected;

  String optionprinttype = "80 mm";
  List<String> optionsSize = ["58 mm", "80 mm"];

  late SingleValueDropDownController selectedPrinterUSB =
      SingleValueDropDownController();
  List<DropDownValueModel> listPrinterModel = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // if (AppState().configPrinter != '') {
    //   setState(() {
    //     selectedPrinter = AppState().configPrinter;
    //   });
    // }
    // printerManager.scanResults.listen((devices) async {
    //   // print('UI: Devices found ${devices.length}');
    //   setState(() {
    //     _devices = devices;
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    // onGetPrinter(context);
    // initPlatformState();
    platformState();
    onGetPrinter(context);

    if (AppState().configPrinter != null) {
      setState(() {
        selectedTipePrinter = AppState().configPrinter['tipeConnection'];
        selectedPrinter = AppState().configPrinter['selectedPrinter'];
        // selectedMacAddPrinter =
        selectedPrinterUSB.setDropDown(
            DropDownValueModel(name: selectedPrinter, value: selectedPrinter));

        if (selectedTipePrinter == 'Bluetooth') {}
      });
    }

    // WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  // decoration: BoxDecoration(
                  //   color: theme.colorScheme.primaryContainer,
                  // ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        12.0, 12.0, 12.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     blurRadius: 5.0,
                                  //     color: Color(0x44111417),
                                  //     offset: Offset(0.0, 2.0),
                                  //   )
                                  // ],
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 12.0, 12.0, 12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Text(
                                                'Setting Devices',
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 2.0,
                                              color: theme.colorScheme.outline,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 6.0, 0.0, 12.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Type Connection Printer',
                                                          style: TextStyle(
                                                            color: theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  6.0,
                                                                  0.0,
                                                                  0.0),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 45.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: theme
                                                                  .colorScheme
                                                                  .primaryContainer,
                                                              border:
                                                                  Border.all(
                                                                color: theme
                                                                    .colorScheme
                                                                    .outline,
                                                                width: 2.0,
                                                              ),
                                                            ),
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: const Text(
                                                                      "Select an Option"),
                                                                  value:
                                                                      selectedTipePrinter,
                                                                  items:
                                                                      <String>[
                                                                    'USB',
                                                                    'Bluetooth',
                                                                  ].map((String
                                                                          value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          value,
                                                                      child:
                                                                          Text(
                                                                        value,
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      selectedTipePrinter =
                                                                          newValue!;
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
                                            if (selectedTipePrinter == 'USB')
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 6.0, 0.0, 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'List Printer',
                                                            style: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .secondary,
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                connectedPrinter
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final currentItem =
                                                                  connectedPrinter[
                                                                      index];
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        6.0,
                                                                        0.0,
                                                                        12.0),
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 62.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color: theme
                                                                              .colorScheme
                                                                              .primaryContainer,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                theme.colorScheme.outline,
                                                                          )),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "${currentItem['selectedPrinter']} - ${currentItem['selectedPaperSize']}",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                theme.colorScheme.secondary,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              8.0,
                                                                              8.0,
                                                                              8.0,
                                                                              8.0),
                                                                          child:
                                                                              InkWell(
                                                                            splashColor:
                                                                                Colors.transparent,
                                                                            focusColor:
                                                                                Colors.transparent,
                                                                            hoverColor:
                                                                                Colors.transparent,
                                                                            highlightColor:
                                                                                Colors.transparent,
                                                                            onTap:
                                                                                () async {
                                                                              onTapDeletePrinter(context, index);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 60.0,
                                                                              height: 40.0,
                                                                              decoration: BoxDecoration(
                                                                                color: theme.colorScheme.error,
                                                                                borderRadius: BorderRadius.circular(4.0),
                                                                              ),
                                                                              alignment: const AlignmentDirectional(0.00, 0.00),
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
                                                                                child: Text(
                                                                                  'Delete',
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
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomElevatedButton(
                                                    text: "Add Printer",
                                                    width: 100,
                                                    height: 30,
                                                    buttonTextStyle: TextStyle(
                                                      color: theme
                                                          .colorScheme.primary,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    buttonStyle:
                                                        CustomButtonStyles
                                                            .outlinePrimary,
                                                    onPressed: () {
                                                      onTapAddPrinter(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (selectedTipePrinter ==
                                                'Bluetooth')
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0.0, 6.0, 0.0, 12.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'List Printer',
                                                            style: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .secondary,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    6.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 280.0,
                                                                  height: 45.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: theme
                                                                        .colorScheme
                                                                        .primaryContainer,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: theme
                                                                          .colorScheme
                                                                          .outline,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          DropdownButton(
                                                                        items: items
                                                                            .map((dv) {
                                                                          return DropdownMenuItem<
                                                                              BluetoothInfo>(
                                                                            value:
                                                                                dv,
                                                                            child:
                                                                                Text('${dv.name} - ${dv.macAdress}'),
                                                                          );
                                                                        }).toList(),
                                                                        value:
                                                                            selected,
                                                                        onChanged:
                                                                            (BluetoothInfo?
                                                                                dvc) {
                                                                          // String mac = items[]
                                                                          setState(
                                                                              () {
                                                                            selected =
                                                                                dvc;
                                                                            connect(dvc!.macAdress);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (_connected ==
                                                                    false)
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        5.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                                    child:
                                                                        CustomElevatedButton(
                                                                      text:
                                                                          "Connect",
                                                                      width:
                                                                          120.0,
                                                                      height:
                                                                          42.0,
                                                                      buttonTextStyle: TextStyle(
                                                                          color: theme
                                                                              .colorScheme
                                                                              .primary),
                                                                      buttonStyle:
                                                                          CustomButtonStyles
                                                                              .outlinePrimary,
                                                                      onPressed:
                                                                          () async {
                                                                        // await onConnectPrinterBluetooth(
                                                                        //     context);
                                                                        connect(
                                                                            selected!.macAdress);
                                                                      },
                                                                    ),
                                                                  ),
                                                                // if (_connected)
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      CustomElevatedButton(
                                                                    text:
                                                                        "Disconnect",
                                                                    width:
                                                                        120.0,
                                                                    height:
                                                                        42.0,
                                                                    buttonTextStyle: TextStyle(
                                                                        color: theme
                                                                            .colorScheme
                                                                            .secondary),
                                                                    buttonStyle:
                                                                        CustomButtonStyles
                                                                            .outlineSecondary,
                                                                    onPressed:
                                                                        () async {
                                                                      // await onDisconnectPrinterBluetooth(
                                                                      //     context);
                                                                      disconnect();
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    12.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      CustomElevatedButton(
                                                                    text:
                                                                        "Get Printer",
                                                                    width:
                                                                        120.0,
                                                                    height:
                                                                        42.0,
                                                                    buttonTextStyle: TextStyle(
                                                                        color: theme
                                                                            .colorScheme
                                                                            .primary),
                                                                    buttonStyle:
                                                                        CustomButtonStyles
                                                                            .outlinePrimary,
                                                                    onPressed:
                                                                        () async {
                                                                      getBluetoots();
                                                                    },
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          5.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      CustomElevatedButton(
                                                                    text:
                                                                        "Test Print",
                                                                    width:
                                                                        120.0,
                                                                    height:
                                                                        42.0,
                                                                    buttonTextStyle: TextStyle(
                                                                        color: theme
                                                                            .colorScheme
                                                                            .primary),
                                                                    buttonStyle:
                                                                        CustomButtonStyles
                                                                            .outlinePrimary,
                                                                    onPressed:
                                                                        () async {
                                                                      // await onTestPrintBluetooth(
                                                                      //     context);
                                                                      printTest();
                                                                    },
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
                                              ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      0.0, 24.0, 0.0, 6.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CustomElevatedButton(
                                                          text: "Save",
                                                          buttonTextStyle: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .primaryContainer),
                                                          buttonStyle:
                                                              CustomButtonStyles
                                                                  .primaryButton,
                                                          onPressed: () {
                                                            onTapSaveConfigPrinter(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  onTapAddPrinter(BuildContext context) async {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        return AddPrinter();
      },
    ).then(
      (value) => {
        if (value != null)
          {
            setState(() {
              connectedPrinter.add(value);
              //   selectedPrinter = value.selectedPrinter;
              //   optionprinttype = value.selectedPaperSize;
            })
            // print('check, ${connectedPrinter}'),
          }
        // print('check value, $value'),
      },
    );
  }

  onTapDeletePrinter(BuildContext context, int indexPrinter) async {
    setState(() {
      connectedPrinter.removeAt(indexPrinter);
    });
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

  onTapSaveConfigPrinter(BuildContext context) async {
    setState(() {
      if (selectedTipePrinter == 'USB') {
        AppState().configPrinter = {
          'tipeConnection': selectedTipePrinter,
          'isMultiple': true,
          'selectedPrinter': selectedPrinter,
          'selectedMacAddPrinter': '',
          'printers': connectedPrinter,
          // 'printer': null,
        };
      } else {
        AppState().configPrinter = {
          'tipeConnection': selectedTipePrinter,
          'isMultiple': false,
          'selectedPrinter': selected!.name,
          'selectedMacAddPrinter': selected!.macAdress,
          'printers': [],
          // 'printer': null,
        };
        AppState().selectedPrinter = selected;
      }
    });
    dynamic configPrinter = ConfigApp().generateConfig(
      AppState().configPrinter,
      AppState().configApplication,
    );
    ConfigApp().writeConfig(configPrinter);
    alertSuccess(context, 'Configuration device saved..');
  }

  getPermission() async {
    setState(() {});
  }

  Future<void> platformState() async {
    // int porcentbatery = 0;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // print("patformversion: $platformVersion");
      // porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    if (result) {
    } else {}

    setState(() {});
  }

  Future<void> getBluetoots() async {
    setState(() {
      items = [];
    });
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    setState(() {});

    if (listResult.isEmpty) {
    } else {}

    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      _connected = false;
    });
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) _connected = true;
    setState(() {});
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      _connected = false;
    });
    print("status disconnect $status");
  }

  Future<void> printTest() async {
    /*if (kDebugMode) {
      bool result = await PrintBluetoothThermalWindows.writeBytes(bytes: "Hello \n".codeUnits);
      return;
    }*/

    // print('check, ${selected.}')

    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (connectionStatus) {
      if (Platform.isWindows) {
        // List<int> ticket = await testWindows();
        // result = await PrintBluetoothThermalWindows.writeBytes(bytes: ticket);
      } else {}
    } else {
      setState(() {
        disconnect();
      });
      //throw Exception("Not device connected");
    }
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    // final ByteData data = await rootBundle.load('assets/mylogo.jpg');
    // final Uint8List bytesImg = data.buffer.asUint8List();
    // img.Image? image = img.decodeImage(bytesImg);

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col5',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, underline: true),
      ),
      PosColumn(
        text: 'col7',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);

    return bytes;
  }
}
