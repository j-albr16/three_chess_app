import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'basic/text_field.dart';
import '../providers/server_provider.dart';

class ReportErrorDialog extends StatefulWidget {
  @required
  final ThemeData theme;
  final Size size;

  ReportErrorDialog({
    this.theme,
    this.size,
  });

  @override
  _ReportErrorDialogState createState() => _ReportErrorDialogState();
}

class _ReportErrorDialogState extends State<ReportErrorDialog> {
  TextEditingController controller;
  FocusNode focusNode;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void submit(String text, context) {
    if (!controller.text.isEmpty) {
      Provider.of<ServerProvider>(context, listen: false)
          .sendErrorReport(controller.text);
    }
    focusNode.unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        content: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: ChessTextField(
            controller: controller,
            focusNode: focusNode,
            expands: true,
            labelText: 'You Error Report',
            // maxLines: 10,
            textInputType: TextInputType.multiline,
            obscuringText: false,
            theme: widget.theme,
            size: Size(widget.size.width * 0.9, double.infinity),
          ),
        ),
        actions: [
          FlatButton(
              onPressed: () {
                focusNode.unfocus();
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
          FlatButton(
              onPressed: () => submit(controller.text, context),
              child: Text('Submitt'))
        ],
      ),
    );
  }
}
