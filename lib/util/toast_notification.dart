import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';
import 'package:zuvo/constant/app_colors.dart';

class ToastNotification {
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String description,
    Duration duration = const Duration(seconds: 5),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedCheckmarkCircle02,
        color: Colors.green,
      ),
      showProgressBar: false,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.always),
      // primaryColor: Colors.green,
      backgroundColor: softOffWhite,
      closeOnClick: true,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    required String description,
    Duration duration = const Duration(seconds: 5),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedAlertDiamond,
        color: Colors.red,
      ),
      showProgressBar: false,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.always),
      // primaryColor: Colors.red,
      backgroundColor: softOffWhite,
      closeOnClick: true,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    required String description,
    Duration duration = const Duration(seconds: 5),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedInformationDiamond,
        color: Colors.blue,
      ),
      showProgressBar: false,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.always),
      // primaryColor: Colors.blue,
      backgroundColor: softOffWhite,
      closeOnClick: true,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    required String description,
    Duration duration = const Duration(seconds: 5),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedAlertDiamond,
        color: Colors.orange,
      ),
      showProgressBar: false,
      closeButton: ToastCloseButton(showType: CloseButtonShowType.always),
      // primaryColor: Colors.orange,
      backgroundColor: softOffWhite,
      closeOnClick: true,
    );
  }
}
