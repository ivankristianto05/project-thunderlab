import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:kontena_pos/app_state.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ConfigApp {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // final directoryDocument = await getApplicationDocumentsDirectory();
    // final directoryLibrary = await getLibraryDirectory();
    // final directoryAppData = await getApplicationSupportDirectory();

    String folderName = 'tnp';
    String path = '';

    Directory newDir = Directory('${directory.path}/$folderName');

    print('dir, $newDir');

    if (await newDir.exists()) {
      path = newDir.path;
    } else {
      newDir.create(recursive: true).then((Directory dir) {
        path = dir.path;
      });
    }
    return path;
  }

  Future<File> get _localFileConfig async {
    final path = await _localPath;
    return File('$path/cftnp.dat');
  }

  Future<File> writeConfig(dynamic config) async {
    final file = await _localFileConfig;

    String data = json.encode(config).toString();
    // String dataEncode = generateCode64(data);
    String dataEncode = generateBase64WithKey(data, 'tlab123');

    return file.writeAsString(dataEncode);
  }

  Future<dynamic> readConfig() async {
    try {
      final file = await _localFileConfig;

      final contents = await file.readAsString();
      // String dataDecode = generateDecode64(contents);
      String dataDecode = decryptBase64WithKey(contents, 'tlab123');
      print('test config, ${jsonDecode(dataDecode)}');
      return jsonDecode(dataDecode);
    } catch (e) {
      print('error: $e');
      return {};
    }
  }

  dynamic generateConfig(
    dynamic printer,
    dynamic application,
  ) {
    dynamic tmpConfig = {};
    try {
      tmpConfig = {
        'config_printer': printer,
        'config_application': application,
      };
    } catch (e) {
      print('gagal generate config, $e');
    }

    return tmpConfig;
  }

  String generateCode64(String data) {
    final encode = base64.encode(utf8.encode(data));
    return encode;
  }

  String generateDecode64(String data) {
    final decode = base64.decode(data);
    return utf8.decode(decode);
  }

  String generateBase64WithKey(String data, String key) {
    // Konversi input dan kunci ke dalam bentuk bytes
    List<int> inputBytes = utf8.encode(data);
    List<int> keyBytes = utf8.encode(key);

    // XOR antara input dan kunci
    List<int> xoredBytes = [];
    for (int i = 0; i < inputBytes.length; i++) {
      xoredBytes.add(inputBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    // Encode hasil XOR ke dalam Base64
    String base64Encoded = base64Encode(Uint8List.fromList(xoredBytes));
    return base64Encoded;
  }

  String decryptBase64WithKey(String data, String key) {
    // Decode dari Base64
    List<int> decodedBytes = base64Decode(data);

    // Konversi kunci ke dalam bentuk bytes
    List<int> keyBytes = utf8.encode(key);

    // XOR antara hasil decode dan kunci
    List<int> decryptedBytes = [];
    for (int i = 0; i < decodedBytes.length; i++) {
      decryptedBytes.add(decodedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    // Decode hasil XOR ke dalam string utf-8
    String decryptedString = utf8.decode(Uint8List.fromList(decryptedBytes));
    return decryptedString;
  }

  void setToState(dynamic config) {
    dynamic tmpConfigOutlet = config['config_outlet'] ?? null;
    dynamic tmpConfigDevice = config['config_device'] ?? null;
    List<dynamic> tmpConfigPayment = config['config_payment'] ?? [];
    dynamic tmpConfigPrinter = config['config_printer'];
    dynamic tmpConfigVoid = config['config_void'] ?? null;

    AppState().update(() {
      AppState().configPrinter = tmpConfigPrinter;
    });

    // FFAppState().update(() {
    //   FFAppState().configSettingOutlet = tmpConfigOutlet;
    //   FFAppState().configSettingDevices = tmpConfigDevice;
    //   FFAppState().configSettingPayments = tmpConfigPayment;
    //   FFAppState().configSettingPrinter = tmpConfigPrinter;
    //   FFAppState().configVoid = bool.parse(tmpConfigVoid);
    // });
  }

  Future<void> initPlatform() async {
    // var deviceData = <String, dynamic>{};
    //
    // try {
    //
    // } on PlatformException {
    //   deviceData = <String, dynamic>{
    //     'Error:': 'Failed to get platform version.'
    //   };
    // }
  }

  // Future<void> getIpAddress() async {
  //   try {
  //     for (var interface in await NetworkInterface.list()) {
  //       for (var addr in interface.addresses) {
  //         FFAppState().ipAddress = addr.address;
  //       }
  //     }
  //   } catch (e) {
  //     print('Error getting IP address: $e');
  //   }
  // }
}
