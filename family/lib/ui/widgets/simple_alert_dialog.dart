import 'package:family/ui/shared/colors.dart';
import 'package:flutter/material.dart';

class DialogAction {
  final String label;
  final Function onTap;

  const DialogAction({
    @required this.label,
    @required this.onTap,
  });
}

class SimpleAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final DialogAction confirmingAction;
  final DialogAction dismissiveAction;

  const SimpleAlertDialog({
    Key key,
    @required this.title,
    @required this.description,
    @required this.confirmingAction,
    this.dismissiveAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void close() => Navigator.of(context, rootNavigator: true).pop('dialog');

    Widget dialogButton({Widget child, Function onPressed}) {
      return FlatButton(
        child: child,
        onPressed: () {
          if (onPressed != null) onPressed();
          close();
        },
        textColor: AppColors.primaryAccent,
      );
    }

    DialogAction dismissiveAction = this.dismissiveAction;
    if (dismissiveAction == null) {
      dismissiveAction = DialogAction(
        label: 'Cancel',
        onTap: null,
      );
    }

    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        description,
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      actions: <Widget>[
        dialogButton(
          child: Text(dismissiveAction.label.toUpperCase()),
        ),
        dialogButton(
          child: Text(confirmingAction.label.toUpperCase()),
          onPressed: confirmingAction.onTap,
        ),
      ],
      backgroundColor: AppColors.dialogBackground,
    );
  }
}
