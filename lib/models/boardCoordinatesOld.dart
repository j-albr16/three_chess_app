import 'dart:math';

class BoardData{

static final Map<String,List<Point>> tilePoints = {
  //Starting right bottom relative to white and iterating clockwise (1 right bottom, 2 left bottom, 3 left top, 4 right top)
  // White:
  //first Row:
  "A1": [
    Point(270.9, 690.7),
    Point(223.1, 690.7),
    Point(199.3, 649.5),
    Point(252.5, 638.7)
  ],
  "B1": [
    Point(318.5, 690.5),
    Point(270.9, 690.7),
    Point(252.5, 638.7),
    Point(306.9, 628.5)
  ],
  "C1": [
    Point(366.9, 690.5),
    Point(318.5, 690.5),
    Point(306.9, 628.5),
    Point(360.9, 618.7)
  ],
  "D1": [
    Point(415.5, 690.4),
    Point(366.9, 690.5),
    Point(360.9, 618.7),
    Point(415.1, 608.4)
  ],
  "E1": [
    Point(463.1, 691.1),
    Point(415.5, 690.4),
    Point(415.1, 608.4),
    Point(469.1, 618.5)
  ],
  "F1": [
    Point(511.0, 691.2),
    Point(463.1, 691.1),
    Point(469.1, 618.5),
    Point(522.8, 629.2)
  ],
  "G1": [
    Point(559.2, 690.8),
    Point(511.0, 691.2),
    Point(522.8, 629.2),
    Point(576.8, 639.5)
  ],
  "H1": [
    Point(606.8, 690.8),
    Point(559.2, 690.8),
    Point(576.8, 639.5),
    Point(629.8, 649.5)
  ],
// second row:
  "A2": [
    Point(252.5, 638.7),
    Point(199.3, 649.5),
    Point(175.0, 608.0),
    Point(234.2, 587.2)
  ],
  "B2": [
    Point(306.9, 628.5),
    Point(252.5, 638.7),
    Point(234.2, 587.2),
    Point(294.5, 566.5)
  ],
  "C2": [
    Point(360.9, 618.7),
    Point(306.9, 628.5),
    Point(294.5, 566.5),
    Point(354.8, 545.8)
  ],
  "D2": [
    Point(415.1, 608.4),
    Point(360.9, 618.7),
    Point(354.8, 545.8),
    Point(414.7, 525.5)
  ],
  "E2": [
    Point(469.1, 618.5),
    Point(415.1, 608.4),
    Point(414.7, 525.5),
    Point(474.5, 545.8)
  ],
  "F2": [
    Point(522.8, 629.2),
    Point(469.1, 618.5),
    Point(474.5, 545.8),
    Point(534.7, 566.5)
  ],
  "G2": [
    Point(576.8, 639.5),
    Point(522.8, 629.2),
    Point(534.7, 566.5),
    Point(594.9, 587.1)
  ],
  "H2": [
    Point(629.8, 649.5),
    Point(576.8, 639.5),
    Point(594.9, 587.1),
    Point(654.4, 608.2)
  ],
  //third row:
  "A3": [
    Point(234.2, 587.2),
    Point(175.0, 608.0),
    Point(151.5, 566.1),
    Point(216.9, 535.2)
  ],
  "B3": [
    Point(294.5, 566.5),
    Point(234.2, 587.2),
    Point(216.9, 535.2),
    Point(283.0, 504.4)
  ],
  "C3": [
    Point(354.8, 545.8),
    Point(294.5, 566.5),
    Point(283.0, 504.4),
    Point(348.9, 473.2)
  ],
  "D3": [
    Point(414.7, 525.5),
    Point(354.8, 545.8),
    Point(348.9, 473.2),
    Point(415.2, 441.8)
  ],
  "E3": [
    Point(474.5, 545.8),
    Point(414.7, 525.5),
    Point(415.2, 441.8),
    Point(480.9, 473.2)
  ],
  "F3": [
    Point(534.7, 566.5),
    Point(474.5, 545.8),
    Point(480.9, 473.2),
    Point(547.2, 504.4)
  ],
  "G3": [
    Point(594.9, 587.1),
    Point(534.7, 566.5),
    Point(547.2, 504.4),
    Point(613.0, 535.4)
  ],
  "H3": [
    Point(654.4, 608.2),
    Point(594.9, 587.1),
    Point(613.0, 535.4),
    Point(678.5, 566.8)
  ],
// fourth  row:
  "A4": [
    Point(216.9, 535.2),
    Point(151.5, 566.1),
    Point(127.1, 524.9),
    Point(198.6, 483.6)
  ],
  "B4": [
    Point(283.0, 504.4),
    Point(216.9, 535.2),
    Point(198.6, 483.6),
    Point(270.6, 441.9)
  ],
  "C4": [
    Point(348.9, 473.2),
    Point(283.0, 504.4),
    Point(270.6, 441.9),
    Point(342.8, 400.5)
  ],
  "D4": [
    Point(415.2, 441.8),
    Point(348.9, 473.2),
    Point(342.8, 400.5),
    Point(415.1, 358.8)
  ],
  "E4": [
    Point(480.9, 473.2),
    Point(415.2, 441.8),
    Point(415.1, 358.8),
    Point(487.4, 400.6)
  ],
  "F4": [
    Point(547.2, 504.4),
    Point(480.9, 473.2),
    Point(487.4, 400.6),
    Point(559.0, 442.0)
  ],
  "G4": [
    Point(613.0, 535.4),
    Point(547.2, 504.4),
    Point(559.0, 442.0),
    Point(631.4, 483.5)
  ],
  "H4": [
    Point(678.5, 566.8),
    Point(613.0, 535.4),
    Point(631.4, 483.5),
    Point(702.5, 525.1)
  ],
};
  //Strings of player
  static final List<List<String>> CoordinateStrings =[
    [
      "A1",
      "B1",
      "C1",
      "D1",
      "E1",
      "F1",
      "G1",
      "H1",
      //row 2
      "A2",
      "B2",
      "C2",
      "D2",
      "E2",
      "F2",
      "G2",
      "H2",
      //row 3
      "A3",
      "B3",
      "C3",
      "D3",
      "E3",
      "F3",
      "G3",
      "H3",
      //row 4
      "A4",
      "B4",
      "C4",
      "D4",
      "E4",
      "F4",
      "G4",
      "H4",
],
    [
      //black:
// first Row:
  "L8",
  "K8",
  "J8",
  "I8",
  "D8",
  "C8",
  "B8",
  "A8",
// second row:
      "L7",
      "K7",
      "J7",
      "I7",
      "D7",
      "C7",
      "B7",
      "A7",
  //third row:
      "L6",
      "K6",
      "J6",
      "I6",
      "D6",
      "C6",
      "B6",
      "A6",
// fourth row:
      "L5",
      "K5",
      "J5",
      "I5",
      "D5",
      "C5",
      "B5",
      "A5",

  ],[
        //red:
  //first Row:
  "H12",
  "G12",
  "F12",
  "E12",
  "I12",
  "J12",
  "K12",
  "L12",
// second row:
  "H11",
  "G11",
  "F11",
  "E11",
  "I11",
  "J11",
  "K11",
  "L11",
  //third row:
  "H10",
  "G10",
  "F10",
  "E10",
  "I10",
  "J10",
  "K10",
  "L10",
// fourth row:
  "H9" ,
  "G9",
  "F9",
  "E9",
  "I9",
  "J9",
  "K9",
  "L9",
    ]];




//black:
  //first Row:
//   "A8",
//   "B8",
//   "C8",
//   "D8",
//   "I8",
//   "J8",
//   "K8",
//   "L8",
// // second row:
//   "A7",
//   "B7",
//   "C7",
//   "D7",
//   "I7",
//   "J7",
//   "K7",
//   "L7",
//   //third row:
//   "A6",
//   "B6",
//   "C6",
//   "D6",
//   "I6",
//   "J6",
//   "K6",
//   "L6",
// // fourth row:
//   "A5",
//   "B5",
//   "C5",
//   "D5",
//   "I5",
//   "J5",
//   "K5",
//   "L5",
//
//   //red:
//   //first Row:
//   "H12",
//   "G12",
//   "F12",
//   "E12",
//   "I12",
//   "J12",
//   "K12",
//   "L12",
// // second row:
//   "H11",
//   "G11",
//   "F11",
//   "E11",
//   "I11",
//   "J11",
//   "K11",
//   "L11",
//   //third row:
//   "H10",
//   "G10",
//   "F10",
//   "E10",
//   "I10",
//   "J10",
//   "K10",
//   "L10",
// // fourth row:
//   "H9" ,
//   "G9",
//   "F9",
//   "E9",
//   "I9",
//   "J9",
//   "K9",
//   "L9",

//first Row:
//   "A8": [Point(),Point(),Point(),Point()],
//   "B8": [Point(),Point(),Point(),Point()],
//   "C8": [Point(),Point(),Point(),Point()],
//   "D8": [Point(),Point(),Point(),Point()],
//   "I8": [Point(),Point(),Point(),Point()],
//   "J8": [Point(),Point(),Point(),Point()],
//   "K8": [Point(),Point(),Point(),Point()],
//   "L8": [Point(),Point(),Point(),Point()],
// // second row:
//   "A7": [Point(),Point(),Point(),Point()],
//   "B7": [Point(),Point(),Point(),Point()],
//   "C7": [Point(),Point(),Point(),Point()],
//   "D7": [Point(),Point(),Point(),Point()],
//   "I7": [Point(),Point(),Point(),Point()],
//   "J7": [Point(),Point(),Point(),Point()],
//   "K7": [Point(),Point(),Point(),Point()],
//   "L7": [Point(),Point(),Point(),Point()],
//   //third row:
//   "A6": [Point(),Point(),Point(),Point()],
//   "B6": [Point(),Point(),Point(),Point()],
//   "C6": [Point(),Point(),Point(),Point()],
//   "D6": [Point(),Point(),Point(),Point()],
//   "I6": [Point(),Point(),Point(),Point()],
//   "J6": [Point(),Point(),Point(),Point()],
//   "K6": [Point(),Point(),Point(),Point()],
//   "L6": [Point(),Point(),Point(),Point()],
// // fourth row:
//   "A5": [Point(),Point(),Point(),Point()],
//   "B5": [Point(),Point(),Point(),Point()],
//   "C5": [Point(),Point(),Point(),Point()],
//   "D5": [Point(),Point(),Point(),Point()],
//   "I5": [Point(),Point(),Point(),Point()],
//   "J5": [Point(),Point(),Point(),Point()],
//   "K5": [Point(),Point(),Point(),Point()],
//   "L5": [Point(),Point(),Point(),Point()],
//
//   //red:
//   //first Row:
//   "H12": [Point(),Point(),Point(),Point()],
//   "G12": [Point(),Point(),Point(),Point()],
//   "F12": [Point(),Point(),Point(),Point()],
//   "E12": [Point(),Point(),Point(),Point()],
//   "I12": [Point(),Point(),Point(),Point()],
//   "J12": [Point(),Point(),Point(),Point()],
//   "K12": [Point(),Point(),Point(),Point()],
//   "L12": [Point(),Point(),Point(),Point()],
// // second row:
//   "H11": [Point(),Point(),Point(),Point()],
//   "G11": [Point(),Point(),Point(),Point()],
//   "F11": [Point(),Point(),Point(),Point()],
//   "E11": [Point(),Point(),Point(),Point()],
//   "I11": [],
//   "J11": [Point(),Point(),Point(),Point()],
//   "K11": [Point(),Point(),Point(),Point()],
//   "L11": [Point(),Point(),Point(),Point()],
//   //third row:
//   "H10": [Point(),Point(),Point(),Point()],
//   "G10": [Point(),Point(),Point(),Point()],
//   "F10": [Point(),Point(),Point(),Point()],
//   "E10": [Point(),Point(),Point(),Point()],
//   "I10": [Point(),Point(),Point(),Point()],
//   "J10": [Point(),Point(),Point(),Point()],
//   "K10": [Point(),Point(),Point(),Point()],
//   "L10": [Point(),Point(),Point(),Point()],
// // fourth row:
//   "H9": [Point(),Point(),Point(),Point()],
//   "G9": [Point(),Point(),Point(),Point()],
//   "F9": [Point(),Point(),Point(),Point()],
//   "E9": [Point(),Point(),Point(),Point()],
//   "I9": [Point(),Point(),Point(),Point()],
//   "J9": [Point(),Point(),Point(),Point()],
//   "K9": [Point(),Point(),Point(),Point()],
//   "L9": [Point(),Point(),Point(),Point()],


}