import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/widgets/move_table.dart';

class AcceptRequestType extends StatelessWidget {
  final Function onAccept;
  final Function onDecline;
  final int movesLeftToVote;
  final ThemeData theme;
  final RequestType requestType;
  final double height;
  final PlayerColor whosAsking;

  AcceptRequestType(
      {this.onAccept,
      this.theme,
      this.onDecline,
      this.movesLeftToVote,
      this.requestType,
      this.whosAsking,
      this.height});

  String voteText(RequestType requestType) {
    Map<RequestType, String> text = {
      RequestType.TakeBack: "Take Back Request by $whosAsking",
      RequestType.Remi: "Draw Request by $whosAsking",
      RequestType.Surrender: "Surrender Request by $whosAsking",
    };
    return text[requestType];
  }

  Widget decideRow(double screenWidth) {
    return Align(
      alignment: Alignment.bottomCenter,
      child:
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: screenWidth * 0.04),
              SizedBox(
                width: screenWidth * 0.3,
                child: Text(voteText(requestType), style: theme.textTheme.bodyText2.copyWith(color: Colors.white),),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 7),
                width: screenWidth * 0.3,
                child: InkWell(
                  child: Card(
                    elevation: 3,
                    color: Colors.green,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => onAccept(),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.04,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 7),
                width: screenWidth * 0.3,
                child: InkWell(
                  child: Card(
                    elevation: 3,
                      color: theme.colorScheme.error,
                      child: Text(
                        "X",
                        style: theme.textTheme.subtitle2
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                  onTap: () => onDecline(),
                ),
              )
            ],
          ),
          // Positioned.fill(
          //   child: Container(
          //     child: Align(
          //       alignment: Alignment.centerRight,
          //       child: Text("Move till vote expires: $movesLeftToVote    "),
          //     ),
          //   ),
          // )
    );
    //TODO THIS IS ALSO IN FRIENDLIST, CAN BE IMPORTED FROM THE SAME GENERALIZATION
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color:Colors.black54,
        ),
        // height: height,
        child: decideRow(screenWidth),
      );
    });
  }
}
