import 'package:flutter/material.dart';
import 'package:notificare_scannables/notificare_scannables.dart';

import '../../logger/logger.dart';

class ScannablesView extends StatefulWidget {
  const ScannablesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannablesViewState();
}

class _ScannablesViewState extends State<ScannablesView> {
  bool _nfcAvailable = false;

  @override
  void initState() {
    super.initState();

    _checkNfcAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Scannables'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 1,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: _onStartQrCodeScannableSessionClicked,
                    child: const Text("QR Code Scanning"),
                  ),
                  const Divider(height: 0),
                  TextButton(
                    onPressed: _nfcAvailable ? _onStartNfcScannableSessionClicked : null,
                    child: const Text("NFC Scanning"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkNfcAvailable() async {
    try {
      final nfcAvailable = await NotificareScannables.canStartNfcScannableSession;

      setState(() {
        _nfcAvailable = nfcAvailable;
      });
    } catch (error) {
      logger.e('Failed to check NFC available.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onStartQrCodeScannableSessionClicked() async {
    try {
      logger.i('QR Code scannable session clicked.');
      await NotificareScannables.startQrCodeScannableSession();
    } catch (error) {
      logger.e('QR code scannable session failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }

  void _onStartNfcScannableSessionClicked() async {
    try {
      logger.i('NFC scannable session clicked.');
      await NotificareScannables.startNfcScannableSession();
    } catch (error) {
      logger.e('NFC scannable session failed.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
