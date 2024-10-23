import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:notificare_user_inbox/notificare_user_inbox.dart';
import 'package:timeago/timeago.dart' as timeago;

class InboxItemView extends StatelessWidget {
  final NotificareUserInboxItem item;

  const InboxItemView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final attachmentUrl = item.notification.attachments.firstOrNull?.uri;

    final attachmentWidget = attachmentUrl != null
        ? Container(
            padding: const EdgeInsets.only(right: 16),
            child: Image.network(
              attachmentUrl,
              width: 96,
              height: 64,
            ),
          )
        : Container();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          attachmentWidget,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.notification.title ?? '---',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  item.notification.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  item.notification.type,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeago.format(item.time, locale: 'en_short'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                !item.opened
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 43, 66, 247),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
