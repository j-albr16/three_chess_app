import 'package:flutter/material.dart';

import '../providers/popup_provider.dart';
import 'package:provider/provider.dart';


abstract class ScreenBone extends StatefulWidget {
  ScreenBone({Key key}) : super(key: key);

  @override
  _ScreenBoneState createState() => _ScreenBoneState();
}

class _ScreenBoneState extends State<ScreenBone> {

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

  @override
  Widget build(BuildContext context) {
  }
}