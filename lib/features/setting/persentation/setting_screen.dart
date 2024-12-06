import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:kontena_pos/app_state.dart';
import 'package:kontena_pos/core/theme/theme_helper.dart';
import 'package:kontena_pos/data/setting_menu.dart';
import 'package:kontena_pos/features/setting/persentation/setting_application.dart';
import 'package:kontena_pos/features/setting/persentation/setting_devices.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
    bool? isInitialize,
  }) : isInitialize = isInitialize ?? false;

  final bool isInitialize;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? _barcode;
  late bool visible;
  String isSelected = 'application';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 45.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Setting POS',
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              onTapClose(context);
                            },
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
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1,
              color: theme.colorScheme.outline,
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (context) {
                              final menuList = menuSetting;
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: menuList.length,
                                itemBuilder: (context, index) {
                                  final menuListItem = menuList[index];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Container(
                                      width: 100.0,
                                      height: 72.0,
                                      decoration: BoxDecoration(
                                        color:
                                            (isSelected == menuListItem['name'])
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme
                                                    .primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        border: Border(
                                          bottom: BorderSide(
                                            color: theme.colorScheme.outline,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          setState(() {});
                                          onTapMenu(context, menuListItem);
                                        },
                                        child: ListTile(
                                          title: Text(
                                            menuListItem['label'],
                                            style: TextStyle(
                                              color: (isSelected ==
                                                      menuListItem['name'])
                                                  ? theme.colorScheme
                                                      .primaryContainer
                                                  : theme.colorScheme.secondary,
                                            ),
                                          ),
                                          subtitle: Text(
                                            menuListItem['group'],
                                            style: TextStyle(
                                              color: (isSelected ==
                                                      menuListItem['name'])
                                                  ? theme.colorScheme
                                                      .primaryContainer
                                                  : theme.colorScheme
                                                      .onPrimaryContainer,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: (isSelected ==
                                                    menuListItem['name'])
                                                ? theme.colorScheme
                                                    .primaryContainer
                                                : theme.colorScheme.secondary,
                                            size: 20.0,
                                          ),
                                          tileColor: theme
                                              .colorScheme.primaryContainer,
                                          dense: false,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Divider(
                            height: 5.0,
                            thickness: 0.5,
                            indent: 0.0,
                            endIndent: 0.0,
                            color: theme.colorScheme.outline,
                          ),
                          Container(
                            height: 50.0,
                            transformAlignment: Alignment.bottomCenter,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'POS - Version ${AppState().version} ${(AppState().domain.contains('erp2')) ? ' - Testing' : ''}',
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 980.0,
                                decoration: BoxDecoration(
                                    // color: theme.colorScheme.outline,
                                    ),
                                child: (isSelected == 'application')
                                    ? SettingApplication()
                                    : SettingDevices(),
                              ),
                            ],
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
    );
  }

  onTapClose(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.invoiceScreen,
      (route) => false,
    );
  }

  onTapMenu(BuildContext context, dynamic param) {
    setState(() {
      isSelected = param['name'];
    });
  }
}
