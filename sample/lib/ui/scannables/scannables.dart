import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notificare_scannables/notificare_scannables.dart';

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

    _checkNfcScannableSession();
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
                  TextButton(onPressed: _onStartQrCodeScannableSessionClicked, child: const Text("QR Code Scanning")),
                  const Divider(height: 0),
                  TextButton(
                      onPressed: _nfcAvailable ? _onStartNfcScannableSessionClicked : null, child: const Text("NFC Scanning")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkNfcScannableSession() async {
    try {
      final nfcAvailable = await NotificareScannables.canStartNfcScannableSession;

      setState(() {
        _nfcAvailable = nfcAvailable;
      });
    } catch (error) {
      Logger().e('Failed to check NFC available.', error);

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
      Logger().i('QR Code scannable session clicked.');
      await NotificareScannables.startQrCodeScannableSession();
    } catch (error) {
      Logger().e('QR code scannable session failed.', error);

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
      Logger().i('NFC scannable session clicked.');
      await NotificareScannables.startNfcScannableSession();
    } catch (error) {
      Logger().e('NFC scannable session failed.', error);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
