import 'package:flutter/material.dart';


mixin ScrollSections{

  ScrollController get controller;
  List<ScrollSection> sections;
  double _screenHeight;
  double bottomSpace = 0;
  bool _verbose = false;

  @protected
  updateHeightOf({@required int sectionIndex, @required double height}){
    sections[sectionIndex].height = height;
  }

  @protected
  bool onEndNotification({@required ScrollNotification scrollNotification, @required double screenHeight}){
    _screenHeight = screenHeight;
    if (scrollNotification is ScrollEndNotification) {
      Future.delayed(Duration.zero)
          .then((_) => _scrollToSection(_nearestSection()));
      //print("i tried, this scroll just ended");
    }
    return true;
  }

  _scrollToSection(int sectionIndex){
    controller.animateTo( _sectionScrollPosition(sectionIndex),
        curve: Curves.linear,
        duration: Duration(milliseconds: 200));
  }

  double _sectionScrollPosition(int sectionIndex){
    if(sections[sectionIndex].isAnchorTop){

      double controllerPosition = _topOfSection(sectionIndex);

      //Check weather the position is reachable
      if((controllerPosition - controller.position.maxScrollExtent).abs() < _screenHeight){
        controllerPosition = controller.position.maxScrollExtent - _screenHeight;
      }
      return controllerPosition;
    }

    double controllerPosition = _bottomOfSection(sectionIndex) - _screenHeight;

    //Check weather the position is reachable and return
    return controllerPosition < 0 ? 0 : controllerPosition;
  }

  double _topOfSection(int sectionIndex){
    double heightIterator = 0;
    for(ScrollSection section in sections.sublist(0,sectionIndex)){
      heightIterator += section.height;
    }
    if(_verbose){
      print("topSection of $sectionIndex is $heightIterator");
    }
    return heightIterator;
  }

  double _bottomOfSection(int sectionIndex){
    double heightIterator = 0;
    for(ScrollSection section in sections.sublist(0,sectionIndex+1)){
      heightIterator += section.height;
    }
    if(_verbose){
      print("botSection of $sectionIndex is $heightIterator");
    }
    return heightIterator;
  }

  int _nearestSection(){

    if(_verbose){
      print("_nearestSection: ");
      print("currentPosition: ${controller.offset}");
    }

    double currentPosition = controller.offset;

    double getDifference(int sectionsIndex, double currentPosition){
      return (_sectionScrollPosition(sectionsIndex) - currentPosition).abs();
    }

    double difference = getDifference(0, currentPosition);
    int index = 0;
    //print("input: $input");
    if(_verbose){
      print("difference: $difference");
      print("index: $index");
    }

    for (int i = 1; i < sections.length; i++) {

      if(_verbose){
        print("difference: ${getDifference(i, currentPosition)}");
        print("index: $i");
      }

      if (getDifference(i, currentPosition) < difference) {
        difference = getDifference(i, currentPosition);
        index = i;
      }
    }

    if(_verbose){
      print("returned index: $index");
    }

    return index;
  }

}

class ScrollSection{
  double height;
  bool isAnchorTop;
  //name is completely optional
  String name;

  ScrollSection({this.name, @required this.height, this.isAnchorTop});
}