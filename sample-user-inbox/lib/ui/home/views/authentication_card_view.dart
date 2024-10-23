import 'package:flutter/material.dart';

import '../../../logger/logger.dart';

class AuthenticationCardView extends StatelessWidget {
  final bool isLoggedIn;
  final bool isDeviceRegistered;
  final VoidCallback startLogin;
  final VoidCallback startLogout;

  const AuthenticationCardView({
    super.key,
    required this.isLoggedIn,
    required this.isDeviceRegistered,
    required this.startLogin,
    required this.startLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                "Authentication Flow".toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showAuthenticationStatusInfo(context),
                icon: const Icon(Icons.info),
              ),
            ],
          ),
        ),
        Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: isLoggedIn ? null : () => startLogin(),
                    child: const Text("Login"),
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: TextButton(
                    onPressed: !isLoggedIn ? null : () => startLogout(),
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAuthenticationStatusInfo(BuildContext context) async {
    try {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Authentication"),
            content: Wrap(
              children: [
                Row(
                  children: [
                    const Text("Logged in: "),
                    const Spacer(),
                    Text(
                      isLoggedIn.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text("Device registered: "),
                    const Spacer(),
                    Text(
                      isDeviceRegistered.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: const Text("Ok"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      logger.e('Authentication flow info error.', error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red.shade900,
        ),
      );
    }
  }
}
