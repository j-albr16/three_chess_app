import 'package:flutter/material.dart';

import '../providers/popup_provider.dart';
import 'package:provider/provider.dart';

mixin notificationPort<T extends StatefulWidget> on State<T> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool hasPopup = Provider.of<PopupProvider>(context).hasPopup;
    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (hasPopup) {
        Provider.of<PopupProvider>(context, listen: false)
            .displayPopup(context);
        hasPopup = false;
      }
    });
  }
}
