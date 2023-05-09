import 'package:flutter/material.dart';
import 'package:sample/ui/monetize/monetize.dart';

import '../../assets/assets.dart';
import '../../custom_events/custom_events.dart';
import '../../scannables/scannables.dart';

class OtherFeaturesCardViewView extends StatelessWidget {
  const OtherFeaturesCardViewView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Text(
            "Other Features".toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Card(
          elevation: 1,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScannablesView(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code_scanner),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Scannables", style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                    ],
                  ),
                ),
              ),
              Container(margin: const EdgeInsets.fromLTRB(48, 0, 0, 0), child: const Divider(height: 0)),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssetsView(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.folder),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Assets", style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                    ],
                  ),
                ),
              ),
              Container(margin: const EdgeInsets.fromLTRB(48, 0, 0, 0), child: const Divider(height: 0)),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonetizeView(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_bag),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Monetize", style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                    ],
                  ),
                ),
              ),
              Container(margin: const EdgeInsets.fromLTRB(48, 0, 0, 0), child: const Divider(height: 0)),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomEventsView(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.event),
                      const SizedBox(
                        width: 12,
                      ),
                      Text("Custom Events", style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
