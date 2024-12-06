import 'package:flutter/material.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/config_app.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/core/utils/alert.dart';
import 'package:kontena_pos/features/setting/persentation/select_item_group.dart';
import 'package:kontena_pos/widgets/custom_elevated_button.dart';
import 'package:kontena_pos/widgets/custom_outlined_button.dart';

class SettingApplication extends StatefulWidget {
  SettingApplication({Key? key}) : super(key: key);

  @override
  _SettingApplicationState createState() => _SettingApplicationState();
}

class _SettingApplicationState extends State<SettingApplication> {
  bool canVoid = true;
  final List<String> options = ["Option 1", "Option 2", "Option 3", "Option 4"];
  List<dynamic> selectedItemGroup = [];
  List<dynamic> itemGroupDisplay = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      itemGroupDisplay = AppState().configPosProfile['item_groups'];

      if ((AppState().configApplication != null) &&
          (AppState()
              .configApplication
              .containsKey('itemGroupSelectedPrint'))) {
        selectedItemGroup =
            AppState().configApplication['itemGroupSelectedPrint'];
      }
    });
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  // decoration: BoxDecoration(
                  //   color: theme.colorScheme.primaryContainer,
                  // ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 12.0),
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 12.0, 12.0, 12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 12.0),
                                              child: Text(
                                                'Setting Application',
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
                                              padding: EdgeInsetsDirectional
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
                                                          'Item Group Selected',
                                                          style: TextStyle(
                                                            color: theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Item for print checker',
                                                          style: TextStyle(
                                                            color: theme
                                                                .colorScheme
                                                                .onPrimaryContainer,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      6.0,
                                                                      0.0,
                                                                      12.0),
                                                          child:
                                                              CustomOutlinedButton(
                                                            height: 38.0,
                                                            text:
                                                                "Choose Item Group",
                                                            buttonTextStyle:
                                                                TextStyle(
                                                                    color: theme
                                                                        .colorScheme
                                                                        .primary),
                                                            buttonStyle:
                                                                CustomButtonStyles
                                                                    .outlinePrimary,
                                                            onPressed: () {
                                                              onTapItemGroup(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                        Text(
                                                          "Selected: ${selectedItemGroup.join(", ")}",
                                                          style: TextStyle(
                                                            color: theme
                                                                .colorScheme
                                                                .secondary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
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
                                                            onTapSaveConfiguration(
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

  void onTapItemGroup(BuildContext context) async {
    // List<String> tempSelectedOptions = List.from(selectedOptions);
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: const Color(0x8A000000),
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) {
        return SelectItemGroup(
            selected: selectedItemGroup,
            onSelected: (value) {
              print('check value, $value');
              setState(() {
                selectedItemGroup = value;
              });
            });
      },
    ).then((value) {
      print('value 2, $value');
    });
  }

  onTapSaveConfiguration(BuildContext context) async {
    setState(() {
      AppState().configApplication = {
        'itemGroupSelectedPrint': selectedItemGroup,
      };
    });
    dynamic configPrinter = ConfigApp().generateConfig(
      AppState().configPrinter,
      AppState().configApplication,
    );
    ConfigApp().writeConfig(configPrinter);
    alertSuccess(context, 'Configuration application saved..');
  }
}
