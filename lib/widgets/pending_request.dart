import 'package:flutter/material.dart';
import 'package:three_chess/widgets/basic/decline_button.dart';
import 'package:relative_scale/relative_scale.dart';

import '../models/enums.dart';
import '../models/request.dart';
import '../helpers/constants.dart';

class PendingRequest extends StatelessWidget {
  final Request request;
  final ThemeData theme;
  final Function onCancel;
  final int movesLeftToCancel;
  final double height;

  PendingRequest(
      {this.movesLeftToCancel,
      this.height,
      this.request,
      this.theme,
      this.onCancel});

  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: FittedBox(
        child: RelativeBuilder(
            builder: (_, __, width, ___, ____) => Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(cornerRadius)),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      requestInformation(width),
                      DeclineButton(
                        onDecline:onCancel,
                        size: Size(width * 0.23, height * 0.55),
                        theme: theme,
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  Widget requestInformation(double width) {
    return Padding(
      padding: EdgeInsets.only(left: width * 0.04),
      child: SizedBox(
        height: height * 0.6,
        width: width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              requestTypeInterface[request.requestType] + ' requested',
              style: theme.textTheme.bodyText2.copyWith(color: Colors.white),
            ),
            Text(
              'Ends in $movesLeftToCancel move(s)',
              style: theme.textTheme.bodyText2.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
