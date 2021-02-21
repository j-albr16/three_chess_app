import 'package:flutter/material.dart';

import '../lib/helpers/scroll_sections.dart';


void main(){

}


class TestingSections with ScrollSections{
  ScrollController controller = ScrollController();
  bool hasChat = true;
  double chatScreenHeight = 0;
  double tableIconBarHeight = 0;
  double tableBodyHeight = 0;
  double screenHeight = 0;

  TestingSections(){
    sections = _createSections();
  }

  List<ScrollSection> _createSections(){
    return [
      if(hasChat)
        ScrollSection(name: "Chat", height: chatScreenHeight, isAnchorTop: true),
      ScrollSection(name: "Board", height: screenHeight, isAnchorTop: true),
      ScrollSection(name: "Requests", height: 0, isAnchorTop: false),
      ScrollSection(name: "IconBar", height: tableIconBarHeight, isAnchorTop: false),
      ScrollSection(name: "Table", height: tableBodyHeight, isAnchorTop: false),
    ];
  }

}