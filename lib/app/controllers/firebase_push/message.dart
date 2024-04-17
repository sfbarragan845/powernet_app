import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../clases/cConfig_UI.dart';

/// Message route arguments.
class MessageArguments {
  /// The RemoteMessage
  final RemoteMessage message;

  /// Whether this message caused the application to open.
  final bool openedApplication;

  // ignore: public_member_api_docs
  MessageArguments(this.message, this.openedApplication);
}

/// Displays information about a [RemoteMessage].
class MessageView extends StatelessWidget {
  /// A single data row.
  Widget row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: '),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MessageArguments args =
        ModalRoute.of(context)!.settings.arguments! as MessageArguments;
    RemoteMessage message = args.message;
    RemoteNotification? notification = message.notification;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Notificaciones', style: TextStyle(color: ColorFondo.BLANCO)),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            //row('Message ID', message.messageId),
            /// row('Sender ID', message.senderId),
//row('Category', message.category),
            ///  row('Collapse Key', message.collapseKey),
            //  row('Content Available', message.contentAvailable.toString()),
            //  row('Data', message.data.toString()),
            //  row('From', message.from),
            //  row('Message ID', message.messageId),
            //  row('Sent Time', message.sentTime?.toString()),
            //  row('Thread ID', message.threadId),
            //  row('Time to Live (TTL)', message.ttl?.toString()),
            if (notification != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    row(
                      'titulo',
                      notification.title,
                    ),
                    row(
                      'cuerpo',
                      notification.body,
                    ),
                    if (notification.apple != null) ...[
                      const Text(
                        'Apple Properties',
                        style: TextStyle(fontSize: 18),
                      ),
                      row(
                        'Subtitle',
                        notification.apple!.subtitle,
                      ),
                      row(
                        'Badge',
                        notification.apple!.badge,
                      ),
                      row(
                        'Sound',
                        notification.apple!.sound?.name,
                      ),
                    ]
                  ],
                ),
              )
            ]
          ],
        ),
      )),
    );
  }
}
