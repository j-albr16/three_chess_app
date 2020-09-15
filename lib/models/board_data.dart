import 'dart:math';

class BoardData{
  //Starting right bottom relative to white and iterating clockwise (1 right bottom, 2 left bottom, 3 left top, 4 right top)
  // White:
  //first Row:
  static final List<List<Point>> tilePointsThird = [
  [
    Point(270.9, 690.7),
    Point(223.1, 690.7),
    Point(199.3, 649.5),
    Point(252.5, 638.7)
  ],
  [
    Point(318.5, 690.5),
    Point(270.9, 690.7),
    Point(252.5, 638.7),
    Point(306.9, 628.5)
  ],
  [
    Point(366.9, 690.5),
    Point(318.5, 690.5),
    Point(306.9, 628.5),
    Point(360.9, 618.7)
  ],
  [
    Point(415.5, 690.4),
    Point(366.9, 690.5),
    Point(360.9, 618.7),
    Point(415.1, 608.4)
  ],
  [
    Point(463.1, 691.1),
    Point(415.5, 690.4),
    Point(415.1, 608.4),
    Point(469.1, 618.5)
  ],
  [
    Point(511.0, 691.2),
    Point(463.1, 691.1),
    Point(469.1, 618.5),
    Point(522.8, 629.2)
  ],
   [
    Point(559.2, 690.8),
    Point(511.0, 691.2),
    Point(522.8, 629.2),
    Point(576.8, 639.5)
  ],
  [
    Point(606.8, 690.8),
    Point(559.2, 690.8),
    Point(576.8, 639.5),
    Point(629.8, 649.5)
  ],
// second row:
   [
    Point(252.5, 638.7),
    Point(199.3, 649.5),
    Point(175.0, 608.0),
    Point(234.2, 587.2)
  ],
  [
    Point(306.9, 628.5),
    Point(252.5, 638.7),
    Point(234.2, 587.2),
    Point(294.5, 566.5)
  ],
  [
    Point(360.9, 618.7),
    Point(306.9, 628.5),
    Point(294.5, 566.5),
    Point(354.8, 545.8)
  ],
   [
    Point(415.1, 608.4),
    Point(360.9, 618.7),
    Point(354.8, 545.8),
    Point(414.7, 525.5)
  ],
  [
    Point(469.1, 618.5),
    Point(415.1, 608.4),
    Point(414.7, 525.5),
    Point(474.5, 545.8)
  ],
   [
    Point(522.8, 629.2),
    Point(469.1, 618.5),
    Point(474.5, 545.8),
    Point(534.7, 566.5)
  ],
   [
    Point(576.8, 639.5),
    Point(522.8, 629.2),
    Point(534.7, 566.5),
    Point(594.9, 587.1)
  ],
   [
    Point(629.8, 649.5),
    Point(576.8, 639.5),
    Point(594.9, 587.1),
    Point(654.4, 608.2)
  ],
  //third row:
   [
    Point(234.2, 587.2),
    Point(175.0, 608.0),
    Point(151.5, 566.1),
    Point(216.9, 535.2)
  ],
  [
    Point(294.5, 566.5),
    Point(234.2, 587.2),
    Point(216.9, 535.2),
    Point(283.0, 504.4)
  ],
   [
    Point(354.8, 545.8),
    Point(294.5, 566.5),
    Point(283.0, 504.4),
    Point(348.9, 473.2)
  ],
   [
    Point(414.7, 525.5),
    Point(354.8, 545.8),
    Point(348.9, 473.2),
    Point(415.2, 441.8)
  ],
  [
    Point(474.5, 545.8),
    Point(414.7, 525.5),
    Point(415.2, 441.8),
    Point(480.9, 473.2)
  ],
   [
    Point(534.7, 566.5),
    Point(474.5, 545.8),
    Point(480.9, 473.2),
    Point(547.2, 504.4)
  ],
  [
    Point(594.9, 587.1),
    Point(534.7, 566.5),
    Point(547.2, 504.4),
    Point(613.0, 535.4)
  ],
  [
    Point(654.4, 608.2),
    Point(594.9, 587.1),
    Point(613.0, 535.4),
    Point(678.5, 566.8)
  ],
// fourth  row:
   [
    Point(216.9, 535.2),
    Point(151.5, 566.1),
    Point(127.1, 524.9),
    Point(198.6, 483.6)
  ],
   [
    Point(283.0, 504.4),
    Point(216.9, 535.2),
    Point(198.6, 483.6),
    Point(270.6, 441.9)
  ],
   [
    Point(348.9, 473.2),
    Point(283.0, 504.4),
    Point(270.6, 441.9),
    Point(342.8, 400.5)
  ],
   [
    Point(415.2, 441.8),
    Point(348.9, 473.2),
    Point(342.8, 400.5),
    Point(415.1, 358.8)
  ],
  [
    Point(480.9, 473.2),
    Point(415.2, 441.8),
    Point(415.1, 358.8),
    Point(487.4, 400.6)
  ],
  [
    Point(547.2, 504.4),
    Point(480.9, 473.2),
    Point(487.4, 400.6),
    Point(559.0, 442.0)
  ],
   [
    Point(613.0, 535.4),
    Point(547.2, 504.4),
    Point(559.0, 442.0),
    Point(631.4, 483.5)
  ],
  [
    Point(678.5, 566.8),
    Point(613.0, 535.4),
    Point(631.4, 483.5),
    Point(702.5, 525.1)
  ],
];
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


static final Map<String, Directions> adjacentTiles = {
  "A1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: []  , leftTop: []    , top: ["A2"], topRight: ["B2"], right: ["A2"]),
"B1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["A1"], leftTop: ["A2"], top: ["B2"], topRight: ["C2"], right: ["C1"]),
"C1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["B1"], leftTop: ["B2"], top: ["C2"], topRight: ["D2"], right: ["D1"]),
"D1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["C1"], leftTop: ["C2"], top: ["D2"], topRight: ["E2"], right: ["E1"]),
"E1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["D1"], leftTop: ["D2"], top: ["E2"], topRight: ["F2"], right: ["F1"]),
"F1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["E1"], leftTop: ["E2"], top: ["F2"], topRight: ["G2"], right: ["G1"]),
"G1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["F1"], leftTop: ["F2"], top: ["G2"], topRight: ["H2"], right: ["H1"]),
"H1": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["G1"], leftTop: ["G2"], top: ["H2"], topRight: []    , right: []    ),
//row 2
"A2": Directions(bottomRight: ["B1"], bottom:["A1"], bottomLeft: [], left: [], leftTop: [], top: ["A3"], topRight: ["B3"], right: ["B2"]),
"B2": Directions(bottomRight: ["C1"], bottom:["B1"], bottomLeft: ["A1"], left: ["A2"], leftTop: ["A3"], top: ["B3"], topRight: ["C3"], right: ["C2"]),
"C2": Directions(bottomRight: ["D1"], bottom:["C1"], bottomLeft: ["B1"], left: ["B2"], leftTop: ["C3"], top: ["C3"], topRight: ["D3"], right: ["D2"]),
"D2": Directions(bottomRight: ["E1"], bottom:["D1"], bottomLeft: ["C1"], left: ["C2"], leftTop: ["D3"], top: ["D3"], topRight: ["E3"], right: ["E2"]),
"E2": Directions(bottomRight: ["F1"], bottom:["E1"], bottomLeft: ["D1"], left: ["D2"], leftTop: ["E3"], top: ["E3"], topRight: ["F3"], right: ["F2"]),
"F2": Directions(bottomRight: ["G1"], bottom:["F1"], bottomLeft: ["E1"], left: ["E2"], leftTop: ["F3"], top: ["F3"], topRight: ["G3"], right: ["G2"]),
"G2": Directions(bottomRight: ["H1"], bottom:["G1"], bottomLeft: ["F1"], left: ["F2"], leftTop: ["G3"], top: ["G3"], topRight: ["H3"], right: ["H2"]),
"H2": Directions(bottomRight: []    , bottom:["H1"], bottomLeft: ["G1"], left: ["G2"], leftTop: ["G3"], top: ["H3"], topRight: []    , right: []    ),
//row 3
"A3": Directions(bottomRight: ["B2"], bottom:["A2"], bottomLeft: []    , left: []    , leftTop: []    , top: ["A4"], topRight: ["B4"], right: ["B3"]),
"B3": Directions(bottomRight: ["C2"], bottom:["B2"], bottomLeft: ["A2"], left: ["A3"], leftTop: ["A4"], top: ["B4"], topRight: ["C4"], right: ["C3"]),
"C3": Directions(bottomRight: ["D2"], bottom:["C2"], bottomLeft: ["B2"], left: ["B3"], leftTop: ["B4"], top: ["C4"], topRight: ["D4"], right: ["D3"]),
"D3": Directions(bottomRight: ["E2"], bottom:["D2"], bottomLeft: ["C2"], left: ["C3"], leftTop: ["C4"], top: ["D4"], topRight: ["E4"], right: ["E3"]),
"E3": Directions(bottomRight: ["F2"], bottom:["E2"], bottomLeft: ["D2"], left: ["D3"], leftTop: ["D4"], top: ["E4"], topRight: ["F4"], right: ["F3"]),
"F3": Directions(bottomRight: ["G2"], bottom:["F2"], bottomLeft: ["E2"], left: ["E3"], leftTop: ["E4"], top: ["F4"], topRight: ["G4"], right: ["G3"]),
"G3": Directions(bottomRight: ["H2"], bottom:["G2"], bottomLeft: ["F2"], left: ["F3"], leftTop: ["F4"], top: ["G4"], topRight: ["H4"], right: ["H3"]),
"H3": Directions(bottomRight: []    , bottom:["H2"], bottomLeft: ["G2"], left: ["G3"], leftTop: ["G4"], top: ["H4"], topRight: []    , right: []    ),
//row 4
"A4": Directions(bottomRight: ["B3"], bottom:["A3"], bottomLeft: []    , left: []    , leftTop: []          , top: ["A5"]      , topRight: ["B5"]      , right: ["B4"]),
"B4": Directions(bottomRight: ["C3"], bottom:["B3"], bottomLeft: ["A3"], left: ["A4"], leftTop: ["A5"]      , top: ["B5"]      , topRight: ["C5"]      , right: ["C4"]),
"C4": Directions(bottomRight: ["D3"], bottom:["C3"], bottomLeft: ["B3"], left: ["B4"], leftTop: ["B5"]      , top: ["C5"]      , topRight: ["D5"]      , right: ["D3"]),
"D4": Directions(bottomRight: ["E3"], bottom:["D3"], bottomLeft: ["C3"], left: ["C4"], leftTop: ["C5"]      , top: ["D5", "I9"], topRight: ["I5", "E9"], right: ["E3"]),
"E4": Directions(bottomRight: ["F3"], bottom:["E3"], bottomLeft: ["E3"], left: ["D4"], leftTop: ["I9", "D5"], top: ["E9", "I5"], topRight: ["F9"]      , right: ["F3"]),
"F4": Directions(bottomRight: ["G3"], bottom:["F3"], bottomLeft: ["F3"], left: ["E4"], leftTop: ["E9"]      , top: ["F9"]      , topRight: ["G9"]      , right: ["G3"]),
"G4": Directions(bottomRight: ["H3"], bottom:["G3"], bottomLeft: ["G3"], left: ["F4"], leftTop: ["F9"]      , top: ["G9"]      , topRight: ["H9"]      , right: ["H3"]),
"H4": Directions(bottomRight: []    , bottom:["H3"], bottomLeft: []    , left: ["G4"], leftTop: ["G9"]      , top: ["H9"]      , topRight: []          , right: []    ),

//black:
// first Row:
  "L8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: []    , leftTop: []    , top: ["L7"], topRight: ["K7"], right: ["K8"]),
  "K8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["L8"], leftTop: ["L7"], top: ["K7"], topRight: ["J7"], right: ["J8"]),
  "J8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["K8"], leftTop: ["K7"], top: ["J7"], topRight: ["I7"], right: ["I8"]),
  "I8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["J8"], leftTop: ["J7"], top: ["I7"], topRight: ["D7"], right: ["D8"]),
  "D8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["I8"], leftTop: ["I7"], top: ["D7"], topRight: ["C7"], right: ["C8"]),
  "C8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["D8"], leftTop: ["D7"], top: ["C7"], topRight: ["B7"], right: ["B8"]),
  "B8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["C8"], leftTop: ["C7"], top: ["B7"], topRight: ["A7"], right: ["A8"]),
  "A8": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["B8"], leftTop: ["B7"], top: ["A7"], topRight: []    , right: []   ),
// second row:
  "L7": Directions(bottomRight: ["K8"], bottom:["L8"], bottomLeft: []    , left: []    , leftTop: []    , top: ["L6"], topRight: ["K6"], right: ["K7"]),
  "K7": Directions(bottomRight: ["J8"], bottom:["K8"], bottomLeft: ["L8"], left: ["L7"], leftTop: ["L6"], top: ["K6"], topRight: ["J6"], right: ["J7"]),
  "J7": Directions(bottomRight: ["I8"], bottom:["J8"], bottomLeft: ["K8"], left: ["K7"], leftTop: ["K6"], top: ["J6"], topRight: ["I6"], right: ["I7"]),
  "I7": Directions(bottomRight: ["D8"], bottom:["I8"], bottomLeft: ["J8"], left: ["J7"], leftTop: ["J6"], top: ["I6"], topRight: ["D6"], right: ["D7"]),
  "D7": Directions(bottomRight: ["C8"], bottom:["D8"], bottomLeft: ["I8"], left: ["I7"], leftTop: ["I6"], top: ["D6"], topRight: ["C6"], right: ["C7"]),
  "C7": Directions(bottomRight: ["B8"], bottom:["C8"], bottomLeft: ["D8"], left: ["D7"], leftTop: ["D6"], top: ["C6"], topRight: ["B6"], right: ["B7"]),
  "B7": Directions(bottomRight: ["A8"], bottom:["B8"], bottomLeft: ["C8"], left: ["L7"], leftTop: ["C6"], top: ["B6"], topRight: ["A6"], right: ["A7"]),
  "A7": Directions(bottomRight: []    , bottom:["A8"], bottomLeft: ["B8"], left: ["L7"], leftTop: ["B6"], top: ["A6"], topRight: []    , right: []   ),
//third row:
  "L6": Directions(bottomRight: ["K7"], bottom:["L7"], bottomLeft: []    , left: []    , leftTop: []    , top: ["L5"], topRight: ["K5"], right: ["K6"]),
  "K6": Directions(bottomRight: ["J7"], bottom:["K7"], bottomLeft: ["L7"], left: ["L6"], leftTop: ["L5"], top: ["K5"], topRight: ["J5"], right: ["J6"]),
  "J6": Directions(bottomRight: ["I7"], bottom:["J7"], bottomLeft: ["K7"], left: ["K6"], leftTop: ["K5"], top: ["J5"], topRight: ["I5"], right: ["I6"]),
  "I6": Directions(bottomRight: ["D7"], bottom:["I7"], bottomLeft: ["J7"], left: ["J6"], leftTop: ["J5"], top: ["I5"], topRight: ["D5"], right: ["D6"]),
  "D6": Directions(bottomRight: ["C7"], bottom:["D7"], bottomLeft: ["I7"], left: ["I6"], leftTop: ["I5"], top: ["D5"], topRight: ["C5"], right: ["C6"]),
  "C6": Directions(bottomRight: ["B7"], bottom:["C7"], bottomLeft: ["D7"], left: ["D6"], leftTop: ["D5"], top: ["C5"], topRight: ["B5"], right: ["B6"]),
  "B6": Directions(bottomRight: ["A7"], bottom:["B7"], bottomLeft: ["C7"], left: ["C6"], leftTop: ["C5"], top: ["B5"], topRight: ["A5"], right: ["A6"]),
  "A6": Directions(bottomRight: []    , bottom:["A7"], bottomLeft: ["B7"], left: ["B6"], leftTop: ["B5"], top: ["A5"], topRight: []    , right: []   ),
// fourth row:
  "L5": Directions(bottomRight: ["K6"], bottom:["L6"], bottomLeft: []    , left: []    , leftTop: []          , top: ["L9"]      , topRight: ["K9"]      , right: ["K5"]),
  "K5": Directions(bottomRight: ["J6"], bottom:["K6"], bottomLeft: ["L6"], left: ["L5"], leftTop: ["I9"]      , top: ["K9"]      , topRight: ["J9"]      , right: ["J5"]),
  "J5": Directions(bottomRight: ["I6"], bottom:["J6"], bottomLeft: ["K6"], left: ["K5"], leftTop: ["K9"]      , top: ["J9"]      , topRight: ["I9"]      , right: ["I5"]),
  "I5": Directions(bottomRight: ["D6"], bottom:["I6"], bottomLeft: ["J6"], left: ["J5"], leftTop: ["J9"]      , top: ["I9", "E4"], topRight: ["E9", "D4"], right: ["D5"]),
  "D5": Directions(bottomRight: ["C6"], bottom:["D6"], bottomLeft: ["I6"], left: ["I5"], leftTop: ["I9", "E9"], top: ["D4", "E9"], topRight: ["C4"]      , right: ["C5"]),
  "C5": Directions(bottomRight: ["B6"], bottom:["C6"], bottomLeft: ["D6"], left: ["D5"], leftTop: ["D4"]      , top: ["C4"]      , topRight: ["B4"]      , right: ["B5"]),
  "B5": Directions(bottomRight: ["A6"], bottom:["B6"], bottomLeft: ["C6"], left: ["C5"], leftTop: ["C4"]      , top: ["B4"]      , topRight: ["A4"]      , right: ["A5"]),
  "A5": Directions(bottomRight: []    , bottom:["A6"], bottomLeft: ["B6"], left: ["B5"], leftTop: ["B4"]      , top: ["A4"]      , topRight: []           ,right: []    ),
 
  //red:
  //first Row:
  "H12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: []     , leftTop: []     , top: ["H11"], topRight: ["G11"], right: ["G12"]),
  "G12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["H12"], leftTop: ["H11"], top: ["G11"], topRight: ["F11"], right: ["F12"]),
  "F12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["G12"], leftTop: ["G11"], top: ["F11"], topRight: ["E11"], right: ["E12"]),
  "E12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["F12"], leftTop: ["F11"], top: ["E11"], topRight: ["I11"], right: ["I12"]),
  "I12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["E12"], leftTop: ["E11"], top: ["I11"], topRight: ["J11"], right: ["J12"]),
  "J12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["I12"], leftTop: ["I11"], top: ["J11"], topRight: ["K11"], right: ["K12"]),
  "K12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["J12"], leftTop: ["J11"], top: ["K11"], topRight: ["L11"], right: ["L12"]),
  "L12": Directions(bottomRight: [], bottom:[], bottomLeft: [], left: ["K12"], leftTop: ["K11"], top: ["L11"], topRight: []     , right: []     ),
// second row:
  "H11": Directions(bottomRight: ["G12"], bottom:["H12"], bottomLeft: [], left: [], leftTop: [], top: ["H10"], topRight: ["G10"], right: ["G11"]),
  "G11": Directions(bottomRight: ["F12"], bottom:["G12"], bottomLeft: ["H12"], left: ["H11"], leftTop: ["H10"], top: ["G10"], topRight: ["F10"], right: ["F11"]),
  "F11": Directions(bottomRight: ["E12"], bottom:["F12"], bottomLeft: ["G12"], left: ["G11"], leftTop: ["G10"], top: ["F10"], topRight: ["E10"], right: ["E11"]),
  "E11": Directions(bottomRight: ["I12"], bottom:["E12"], bottomLeft: ["F12"], left: ["F11"], leftTop: ["F10"], top: ["E10"], topRight: ["I10"], right: ["I11"]),
  "I11": Directions(bottomRight: ["J12"], bottom:["I12"], bottomLeft: ["E12"], left: ["E11"], leftTop: ["E10"], top: ["I10"], topRight: ["J10"], right: ["J11"]),
  "J11": Directions(bottomRight: ["K12"], bottom:["J12"], bottomLeft: ["I12"], left: ["I11"], leftTop: ["I10"], top: ["J10"], topRight: ["K10"], right: ["K11"]),
  "K11": Directions(bottomRight: ["L12"], bottom:["K12"], bottomLeft: ["J12"], left: ["J11"], leftTop: ["J10"], top: ["K10"], topRight: ["L10"], right: ["L11"]),
  "L11": Directions(bottomRight: [],      bottom:["L12"], bottomLeft: ["K12"], left: ["K11"], leftTop: ["K10"], top: ["L10"], topRight: []     , right: []     ),
  //third row:
  "H10": Directions(bottomRight: ["G11"], bottom:["H11"], bottomLeft: []     , left: []     , leftTop: []    , top: ["H9"], topRight: ["G9"], right: ["G10"]),
  "G10": Directions(bottomRight: ["F11"], bottom:["G11"], bottomLeft: ["H11"], left: ["H10"], leftTop: ["H9"], top: ["G9"], topRight: ["F9"], right: ["F10"]),
  "F10": Directions(bottomRight: ["E11"], bottom:["F11"], bottomLeft: ["G11"], left: ["G10"], leftTop: ["G9"], top: ["F9"], topRight: ["E9"], right: ["E10"]),
  "E10": Directions(bottomRight: ["I11"], bottom:["E11"], bottomLeft: ["F11"], left: ["F10"], leftTop: ["F9"], top: ["E9"], topRight: ["I9"], right: ["I10"]),
  "I10": Directions(bottomRight: ["J11"], bottom:["I11"], bottomLeft: ["E11"], left: ["E10"], leftTop: ["E9"], top: ["I9"], topRight: ["J9"], right: ["J10"]),
  "J10": Directions(bottomRight: ["K11"], bottom:["J11"], bottomLeft: ["I11"], left: ["I10"], leftTop: ["I9"], top: ["J9"], topRight: ["K9"], right: ["K10"]),
  "K10": Directions(bottomRight: ["L11"], bottom:["K11"], bottomLeft: ["J11"], left: ["J10"], leftTop: ["J9"], top: ["K9"], topRight: ["L9"], right: ["L10"]),
  "L10": Directions(bottomRight: []     , bottom:["L11"], bottomLeft: ["K11"], left: ["K10"], leftTop: ["K9"], top: ["L9"], topRight: []    , right: []     ),
// fourth row:
  "H9": Directions(bottomRight: ["G10"], bottom:["H10"], bottomLeft: []     , left: []    , leftTop: []          , top: ["H4"]      , topRight: ["G4"]      , right: ["G9"]),
  "G9": Directions(bottomRight: ["F10"], bottom:["G10"], bottomLeft: ["H10"], left: ["H9"], leftTop: ["H4"]      , top: ["G4"]      , topRight: ["F4"]      , right: ["F9"]),
  "F9": Directions(bottomRight: ["E10"], bottom:["F10"], bottomLeft: ["G10"], left: ["G9"], leftTop: ["G4"]      , top: ["F4"]      , topRight: ["E4"]      , right: ["E9"]),
  "E9": Directions(bottomRight: ["I10"], bottom:["E10"], bottomLeft: ["F10"], left: ["F9"], leftTop: ["F4"]      , top: ["E4", "D5"], topRight: ["D4", "I5"], right: ["I9"]),
  "I9": Directions(bottomRight: ["J10"], bottom:["I10"], bottomLeft: ["E10"], left: ["E9"], leftTop: ["4", "D5"] , top: ["I5", "D4"], topRight: ["J5"]      , right: ["J9"]),
  "J9": Directions(bottomRight: ["K10"], bottom:["J10"], bottomLeft: ["I10"], left: ["I9"], leftTop: ["I5"]      , top: ["J5"]      , topRight: ["K5"]      , right: ["K9"]),
  "K9": Directions(bottomRight: ["L10"], bottom:["K10"], bottomLeft: ["J10"], left: ["J9"], leftTop: ["J5"]      , top: ["K5"]      , topRight: ["L5"]      , right: ["L9"]),
  "L9": Directions(bottomRight: []     , bottom:["L10"], bottomLeft: ["K10"], left: ["K9"], leftTop: ["K5"]      , top: ["L5"]      , topRight: []          , right: []    ),
  
};


}

class Directions{
  List<String> bottomRight;
  List<String> bottom;
  List<String> bottomLeft;
  List<String> left;
  List<String> leftTop;
  List<String> top;
  List<String> topRight;
  List<String> right;
  
  Directions({this.bottomRight, this.bottom, this.bottomLeft, this.left, this.leftTop, this.top, this.topRight, this.right});
}