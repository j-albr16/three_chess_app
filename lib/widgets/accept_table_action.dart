import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/widgets/move_table.dart';

class AcceptRequestType extends StatelessWidget {
  final Function onAccept;
  final Function onDecline;
  final int movesLeftToVote;
  final RequestType requestType;
  final double height;
  final PlayerColor whosAsking;

  AcceptRequestType(
      {this.onAccept, this.onDecline, this.movesLeftToVote, this.requestType, this.whosAsking, this.height});

  String voteText(RequestType requestType) {
    Map<RequestType, String> text = {
      RequestType.TakeBack: "Do you agree to let $whosAsking take back?",
      RequestType.Remi: "Do you agree to a draw?",
      RequestType.Surrender: "Do you want to Surrender with $whosAsking",
    };
    return text[requestType];
  }


  Widget decideRow(double screenWidth) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: screenWidth * 0.4,
                child: InkWell(
                  child: Card(
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  onTap: () => onAccept(),
                ),
              ),
              Container(
                width: screenWidth * 0.1,
                color: Colors.transparent,
              ),
              Container(
                width: screenWidth * 0.4,
                child: InkWell(
                  child: Card(
                    child: Center(
                        child: Text("X",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold))),
                  ),
                  onTap: () => onDecline(),
                ),
              )
            ],
          ),
          Positioned.fill(
            child: Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("Move till vote expires: $movesLeftToVote    "),
              ),
            ),
          )
        ],
      ),
    );
    //TODO THIS IS ALSO IN FRIENDLIST, CAN BE IMPORTED FROM THE SAME GENERALIZATION
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
          return Container(
            color: Colors.black45,
            height: height,
            child: FittedBox(
              child: Column(
                children: [
                  Text(voteText(requestType)),
                  decideRow(screenWidth)
                ],
              ),
            ),
          );
        }
    );
  }
}