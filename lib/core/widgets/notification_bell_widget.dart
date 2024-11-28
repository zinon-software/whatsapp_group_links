import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/storage/storage_repository.dart';
import 'package:linkati/core/widgets/toast_widget.dart';

import '../notification/notification_manager.dart';

class NotificationBellWidget extends StatefulWidget {
  const NotificationBellWidget({
    super.key,
    required this.topic,
  });
  final String topic;

  @override
  State<NotificationBellWidget> createState() => _NotificationBellWidgetState();
}

class _NotificationBellWidgetState extends State<NotificationBellWidget> {
  bool isNotified = false;

  @override
  void initState() {
    super.initState();

    if (instance<StorageRepository>().containsKey(widget.topic)) {
      isNotified =
          instance<StorageRepository>().getData(key: widget.topic) ?? false;
    } else {
      isNotified = true;
      NotificationManager.subscribeToTopic(widget.topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        isNotified = !isNotified;
        if (isNotified) {
          NotificationManager.subscribeToTopic(widget.topic);
          showToast( "تم تفعيل الاشعارات");
        } else {
          NotificationManager.unSubscribeToTopic(widget.topic);
          showToast("تم تعطيل الاشعارات");
        }
        setState(() {});
      },
      icon: Icon(
        isNotified ? CupertinoIcons.bell_fill : CupertinoIcons.bell,
        color: isNotified ? Colors.green : Colors.grey,
      ),
    );
  }
}
