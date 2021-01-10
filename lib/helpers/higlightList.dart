import 'package:collection/collection.dart';

class HighlightList{ //TODO include whatsHit for cleaner code in threeChessBoard
  List<String> highlights;

  HighlightList(this.highlights);

  @override
  bool operator ==(Object other) {
    return ListEquality().equals(highlights, other);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => highlights.hashCode;


}