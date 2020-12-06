import 'dart:math';
import '../models/enums.dart';

class BoardData {
  static Map<String, bool> tileWhiteData = {
    "A1": false,
    "B1": true,
    "C1": false,
    "D1": true,
    "E1": false,
    "F1": true,
    "G1": false,
    "H1": true,
    "A2": true,
    "B2": false,
    "C2": true,
    "D2": false,
    "E2": true,
    "F2": false,
    "G2": true,
    "H2": false,
    "A3": false,
    "B3": true,
    "C3": false,
    "D3": true,
    "E3": false,
    "F3": true,
    "G3": false,
    "H3": true,
    "A4": true,
    "B4": false,
    "C4": true,
    "D4": false,
    "E4": true,
    "F4": false,
    "G4": true,
    "H4": false,
    "A8": true,
    "B8": false,
    "C8": true,
    "D8": false,
    "I8": true,
    "J8": false,
    "K8": true,
    "L8": false,
    "A7": false,
    "B7": true,
    "C7": false,
    "D7": true,
    "I7": false,
    "J7": true,
    "K7": false,
    "L7": true,
    "A6": true,
    "B6": false,
    "C6": true,
    "D6": false,
    "I6": true,
    "J6": false,
    "K6": true,
    "L6": false,
    "A5": false,
    "B5": true,
    "C5": false,
    "D5": true,
    "I5": false,
    "J5": true,
    "K5": false,
    "L5": true,
    "L12": true,
    "K12": false,
    "J12": true,
    "I12": false,
    "E12": true,
    "F12": false,
    "G12": true,
    "H12": false,
    "L11": false,
    "K11": true,
    "J11": false,
    "I11": true,
    "E11": false,
    "F11": true,
    "G11": false,
    "H11": true,
    "L10": true,
    "K10": false,
    "J10": true,
    "I10": false,
    "E10": true,
    "F10": false,
    "G10": true,
    "H10": false,
    "L9": false,
    "K9": true,
    "J9": false,
    "I9": true,
    "E9": false,
    "F9": true,
    "G9": false,
    "H9": true,
  };

  static Map<String, PlayerColor> sideData = {
    "A1": PlayerColor.white,
    "B1": PlayerColor.white,
    "C1": PlayerColor.white,
    "D1": PlayerColor.white,
    "E1": PlayerColor.white,
    "F1": PlayerColor.white,
    "G1": PlayerColor.white,
    "H1": PlayerColor.white,
    "A2": PlayerColor.white,
    "B2": PlayerColor.white,
    "C2": PlayerColor.white,
    "D2": PlayerColor.white,
    "E2": PlayerColor.white,
    "F2": PlayerColor.white,
    "G2": PlayerColor.white,
    "H2": PlayerColor.white,
    "A3": PlayerColor.white,
    "B3": PlayerColor.white,
    "C3": PlayerColor.white,
    "D3": PlayerColor.white,
    "E3": PlayerColor.white,
    "F3": PlayerColor.white,
    "G3": PlayerColor.white,
    "H3": PlayerColor.white,
    "A4": PlayerColor.white,
    "B4": PlayerColor.white,
    "C4": PlayerColor.white,
    "D4": PlayerColor.white,
    "E4": PlayerColor.white,
    "F4": PlayerColor.white,
    "G4": PlayerColor.white,
    "H4": PlayerColor.white,
    "L8": PlayerColor.black,
    "K8": PlayerColor.black,
    "J8": PlayerColor.black,
    "I8": PlayerColor.black,
    "D8": PlayerColor.black,
    "C8": PlayerColor.black,
    "B8": PlayerColor.black,
    "A8": PlayerColor.black,
    "L7": PlayerColor.black,
    "K7": PlayerColor.black,
    "J7": PlayerColor.black,
    "I7": PlayerColor.black,
    "D7": PlayerColor.black,
    "C7": PlayerColor.black,
    "B7": PlayerColor.black,
    "A7": PlayerColor.black,
    "L6": PlayerColor.black,
    "K6": PlayerColor.black,
    "J6": PlayerColor.black,
    "I6": PlayerColor.black,
    "D6": PlayerColor.black,
    "C6": PlayerColor.black,
    "B6": PlayerColor.black,
    "A6": PlayerColor.black,
    "L5": PlayerColor.black,
    "K5": PlayerColor.black,
    "J5": PlayerColor.black,
    "I5": PlayerColor.black,
    "D5": PlayerColor.black,
    "C5": PlayerColor.black,
    "B5": PlayerColor.black,
    "A5": PlayerColor.black,
    "H12": PlayerColor.red,
    "G12": PlayerColor.red,
    "F12": PlayerColor.red,
    "E12": PlayerColor.red,
    "I12": PlayerColor.red,
    "J12": PlayerColor.red,
    "K12": PlayerColor.red,
    "L12": PlayerColor.red,
    "H11": PlayerColor.red,
    "G11": PlayerColor.red,
    "F11": PlayerColor.red,
    "E11": PlayerColor.red,
    "I11": PlayerColor.red,
    "J11": PlayerColor.red,
    "K11": PlayerColor.red,
    "L11": PlayerColor.red,
    "H10": PlayerColor.red,
    "G10": PlayerColor.red,
    "F10": PlayerColor.red,
    "E10": PlayerColor.red,
    "I10": PlayerColor.red,
    "J10": PlayerColor.red,
    "K10": PlayerColor.red,
    "L10": PlayerColor.red,
    "H9": PlayerColor.red,
    "G9": PlayerColor.red,
    "F9": PlayerColor.red,
    "E9": PlayerColor.red,
    "I9": PlayerColor.red,
    "J9": PlayerColor.red,
    "K9": PlayerColor.red,
    "L9": PlayerColor.red,
  };


  static Map<String, List<Point>> tileData = {
    "A1": [
      Point(300, 832),
      Point(240, 832),
      Point(210, 781),
      Point(277, 767),
    ],
    "B1": [
      Point(359, 832),
      Point(300, 832),
      Point(277, 767),
      Point(345, 754),
    ],
    "C1": [
      Point(420, 832),
      Point(359, 832),
      Point(345, 754),
      Point(412, 742),
    ],
    "D1": [
      Point(481, 832),
      Point(420, 832),
      Point(412, 742),
      Point(480, 729),
    ],
    "E1": [
      Point(540, 833),
      Point(481, 832),
      Point(480, 729),
      Point(548, 742),
    ],
    "F1": [
      Point(600, 833),
      Point(540, 833),
      Point(548, 742),
      Point(615, 755),
    ],
    "G1": [
      Point(661, 832),
      Point(600, 833),
      Point(615, 755),
      Point(683, 768),
    ],
    "H1": [
      Point(720, 832),
      Point(661, 832),
      Point(683, 768),
      Point(749, 781),
    ],
    "A2": [
      Point(277, 767),
      Point(210, 781),
      Point(180, 729),
      Point(254, 703),
    ],
    "B2": [
      Point(345, 754),
      Point(277, 767),
      Point(254, 703),
      Point(329, 677),
    ],
    "C2": [
      Point(412, 742),
      Point(345, 754),
      Point(329, 677),
      Point(405, 651),
    ],
    "D2": [
      Point(480, 729),
      Point(412, 742),
      Point(405, 651),
      Point(480, 625),
    ],
    "E2": [
      Point(548, 742),
      Point(480, 729),
      Point(480, 625),
      Point(555, 651),
    ],
    "F2": [
      Point(615, 755),
      Point(548, 742),
      Point(555, 651),
      Point(630, 677),
    ],
    "G2": [
      Point(683, 768),
      Point(615, 755),
      Point(630, 677),
      Point(705, 702),
    ],
    "H2": [
      Point(749, 781),
      Point(683, 768),
      Point(705, 702),
      Point(780, 729),
    ],
    "A3": [
      Point(254, 703),
      Point(180, 729),
      Point(150, 676),
      Point(232, 637),
    ],
    "B3": [
      Point(329, 677),
      Point(254, 703),
      Point(232, 637),
      Point(315, 599),
    ],
    "C3": [
      Point(405, 651),
      Point(329, 677),
      Point(315, 599),
      Point(397, 560),
    ],
    "D3": [
      Point(480, 625),
      Point(405, 651),
      Point(397, 560),
      Point(480, 520),
    ],
    "E3": [
      Point(555, 651),
      Point(480, 625),
      Point(480, 520),
      Point(563, 560),
    ],
    "F3": [
      Point(630, 677),
      Point(555, 651),
      Point(563, 560),
      Point(646, 599),
    ],
    "G3": [
      Point(705, 702),
      Point(630, 677),
      Point(646, 599),
      Point(728, 638),
    ],
    "H3": [
      Point(780, 729),
      Point(705, 702),
      Point(728, 638),
      Point(810, 677),
    ],
    "A4": [
      Point(232, 637),
      Point(150, 676),
      Point(120, 624),
      Point(209, 573),
    ],
    "B4": [
      Point(315, 599),
      Point(232, 637),
      Point(209, 573),
      Point(299, 521),
    ],
    "C4": [
      Point(397, 560),
      Point(315, 599),
      Point(299, 521),
      Point(390, 469),
    ],
    "D4": [
      Point(480, 520),
      Point(397, 560),
      Point(390, 469),
      Point(480, 416),
    ],
    "E4": [
      Point(563, 560),
      Point(480, 520),
      Point(480, 416),
      Point(571, 469),
    ],
    "F4": [
      Point(646, 599),
      Point(563, 560),
      Point(571, 469),
      Point(660, 521),
    ],
    "G4": [
      Point(728, 638),
      Point(646, 599),
      Point(660, 521),
      Point(751, 573),
    ],
    "H4": [
      Point(810, 677),
      Point(728, 638),
      Point(751, 573),
      Point(840, 625),
    ],
    "L8": [
      Point(30, 365),
      Point(0, 417),
      Point(30, 468),
      Point(75, 418),
    ],
    "K8": [
      Point(60, 314),
      Point(30, 365),
      Point(75, 418),
      Point(120, 365),
    ],
    "J8": [
      Point(90, 261),
      Point(60, 314),
      Point(120, 365),
      Point(164, 312),
    ],
    "I8": [
      Point(121, 208),
      Point(90, 261),
      Point(164, 312),
      Point(209, 260),
    ],
    "D8": [
      Point(150, 156),
      Point(121, 208),
      Point(209, 260),
      Point(232, 195),
    ],
    "C8": [
      Point(180, 104),
      Point(150, 156),
      Point(232, 195),
      Point(254, 130),
    ],
    "B8": [
      Point(210, 52),
      Point(180, 104),
      Point(254, 130),
      Point(277, 65),
    ],
    "A8": [
      Point(240, 1),
      Point(210, 52),
      Point(277, 65),
      Point(299, 2),
    ],
    "L7": [
      Point(75, 418),
      Point(30, 468),
      Point(60, 521),
      Point(119, 470),
    ],
    "K7": [
      Point(120, 365),
      Point(75, 418),
      Point(119, 470),
      Point(179, 417),
    ],
    "J7": [
      Point(164, 312),
      Point(120, 365),
      Point(179, 417),
      Point(240, 365),
    ],
    "I7": [
      Point(209, 260),
      Point(164, 312),
      Point(240, 365),
      Point(299, 313),
    ],
    "D7": [
      Point(232, 195),
      Point(209, 260),
      Point(299, 313),
      Point(315, 235),
    ],
    "C7": [
      Point(254, 130),
      Point(232, 195),
      Point(315, 235),
      Point(330, 157),
    ],
    "B7": [
      Point(277, 65),
      Point(254, 130),
      Point(330, 157),
      Point(345, 78),
    ],
    "A7": [
      Point(299, 2),
      Point(277, 65),
      Point(345, 78),
      Point(360, 1),
    ],
    "L6": [
      Point(119, 470),
      Point(60, 521),
      Point(90, 573),
      Point(165, 521),
    ],
    "K6": [
      Point(179, 417),
      Point(119, 470),
      Point(165, 521),
      Point(240, 469),
    ],
    "J6": [
      Point(240, 365),
      Point(179, 417),
      Point(240, 469),
      Point(315, 417),
    ],
    "I6": [
      Point(299, 313),
      Point(240, 365),
      Point(315, 417),
      Point(390, 364),
    ],
    "D6": [
      Point(315, 235),
      Point(299, 313),
      Point(390, 364),
      Point(397, 273),
    ],
    "C6": [
      Point(330, 157),
      Point(315, 235),
      Point(397, 273),
      Point(405, 182),
    ],
    "B6": [
      Point(345, 78),
      Point(330, 157),
      Point(405, 182),
      Point(413, 91),
    ],
    "A6": [
      Point(360, 1),
      Point(345, 78),
      Point(413, 91),
      Point(420, 1),
    ],
    "L5": [
      Point(165, 521),
      Point(90, 573),
      Point(120, 625),
      Point(209, 573),
    ],
    "K5": [
      Point(240, 469),
      Point(165, 521),
      Point(209, 573),
      Point(300, 521),
    ],
    "J5": [
      Point(315, 417),
      Point(240, 469),
      Point(300, 521),
      Point(390, 469),
    ],
    "I5": [
      Point(390, 364),
      Point(315, 417),
      Point(390, 469),
      Point(480, 416),
    ],
    "D5": [
      Point(397, 273),
      Point(390, 364),
      Point(480, 416),
      Point(480, 312),
    ],
    "C5": [
      Point(405, 182),
      Point(397, 273),
      Point(480, 312),
      Point(480, 208),
    ],
    "B5": [
      Point(413, 91),
      Point(405, 182),
      Point(480, 208),
      Point(480, 104),
    ],
    "A5": [
      Point(420, 1),
      Point(413, 91),
      Point(480, 104),
      Point(480, 1),
    ],
    "H12": [
      Point(750, 52),
      Point(720, 0),
      Point(660, 0),
      Point(682, 65),
    ],
    "G12": [
      Point(779, 104),
      Point(750, 52),
      Point(682, 65),
      Point(705, 130),
    ],
    "F12": [
      Point(810, 156),
      Point(779, 104),
      Point(705, 130),
      Point(728, 195),
    ],
    "E12": [
      Point(840, 209),
      Point(810, 156),
      Point(728, 195),
      Point(751, 260),
    ],
    "I12": [
      Point(871, 260),
      Point(840, 209),
      Point(751, 260),
      Point(796, 312),
    ],
    "J12": [
      Point(901, 312),
      Point(871, 260),
      Point(796, 312),
      Point(841, 364),
    ],
    "K12": [
      Point(931, 365),
      Point(901, 312),
      Point(841, 364),
      Point(886, 416),
    ],
    "L12": [
      Point(960, 416),
      Point(931, 365),
      Point(886, 416),
      Point(930, 467),
    ],
    "H11": [
      Point(682, 65),
      Point(660, 0),
      Point(600, 0),
      Point(615, 77),
    ],
    "G11": [
      Point(705, 130),
      Point(682, 65),
      Point(615, 77),
      Point(630, 156),
    ],
    "F11": [
      Point(728, 195),
      Point(705, 130),
      Point(630, 156),
      Point(645, 234),
    ],
    "E11": [
      Point(751, 260),
      Point(728, 195),
      Point(645, 234),
      Point(661, 312),
    ],
    "I11": [
      Point(796, 312),
      Point(751, 260),
      Point(661, 312),
      Point(720, 364),
    ],
    "J11": [
      Point(841, 364),
      Point(796, 312),
      Point(720, 364),
      Point(780, 416),
    ],
    "K11": [
      Point(886, 416),
      Point(841, 364),
      Point(780, 416),
      Point(840, 469),
    ],
    "L11": [
      Point(930, 467),
      Point(886, 416),
      Point(840, 469),
      Point(901, 520),
    ],
    "H10": [
      Point(615, 77),
      Point(600, 0),
      Point(540, 1),
      Point(547, 91),
    ],
    "G10": [
      Point(630, 156),
      Point(615, 77),
      Point(547, 91),
      Point(555, 182),
    ],
    "F10": [
      Point(645, 234),
      Point(630, 156),
      Point(555, 182),
      Point(563, 273),
    ],
    "E10": [
      Point(661, 312),
      Point(645, 234),
      Point(563, 273),
      Point(570, 365),
    ],
    "I10": [
      Point(720, 364),
      Point(661, 312),
      Point(570, 365),
      Point(645, 416),
    ],
    "J10": [
      Point(780, 416),
      Point(720, 364),
      Point(645, 416),
      Point(721, 469),
    ],
    "K10": [
      Point(840, 469),
      Point(780, 416),
      Point(721, 469),
      Point(796, 521),
    ],
    "L10": [
      Point(901, 520),
      Point(840, 469),
      Point(796, 521),
      Point(871, 572),
    ],
    "H9": [
      Point(547, 91),
      Point(540, 1),
      Point(480, 0),
      Point(480, 103),
    ],
    "G9": [
      Point(555, 182),
      Point(547, 91),
      Point(480, 103),
      Point(480, 208),
    ],
    "F9": [
      Point(563, 273),
      Point(555, 182),
      Point(480, 208),
      Point(480, 312),
    ],
    "E9": [
      Point(570, 365),
      Point(563, 273),
      Point(480, 312),
      Point(480, 416),
    ],
    "I9": [
      Point(645, 416),
      Point(570, 365),
      Point(480, 416),
      Point(571, 469),
    ],
    "J9": [
      Point(721, 469),
      Point(645, 416),
      Point(571, 469),
      Point(661, 520),
    ],
    "K9": [
      Point(796, 521),
      Point(721, 469),
      Point(661, 520),
      Point(751, 573),
    ],
    "L9": [
      Point(871, 572),
      Point(796, 521),
      Point(751, 573),
      Point(841, 624),
    ],
  };

  //Starting right bottom relative to white and iterating clockwise (1 right bottom, 2 left bottom, 3 left top, 4 right top)
  // White:
  //first Row:

  //Strings of player

  static final Map<String, Directions> adjacentTiles = {
    "A1": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: [], leftTop: [], top: ["A2"], topRight: ["B2"], right: ["B1"]),
    "B1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["A1"], leftTop: ["A2"], top: ["B2"], topRight: ["C2"], right: ["C1"]),
    "C1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["B1"], leftTop: ["B2"], top: ["C2"], topRight: ["D2"], right: ["D1"]),
    "D1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["C1"], leftTop: ["C2"], top: ["D2"], topRight: ["E2"], right: ["E1"]),
    "E1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["D1"], leftTop: ["D2"], top: ["E2"], topRight: ["F2"], right: ["F1"]),
    "F1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["E1"], leftTop: ["E2"], top: ["F2"], topRight: ["G2"], right: ["G1"]),
    "G1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["F1"], leftTop: ["F2"], top: ["G2"], topRight: ["H2"], right: ["H1"]),
    "H1": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: ["G1"], leftTop: ["G2"], top: ["H2"], topRight: [], right: []),
//row 2
    "A2": Directions(
        bottomRight: ["B1"], bottom: ["A1"], bottomLeft: [], left: [], leftTop: [], top: ["A3"], topRight: ["B3"], right: ["B2"]),
    "B2": Directions(
        bottomRight: ["C1"],
        bottom: ["B1"],
        bottomLeft: ["A1"],
        left: ["A2"],
        leftTop: ["A3"],
        top: ["B3"],
        topRight: ["C3"],
        right: ["C2"]),
    "C2": Directions(
        bottomRight: ["D1"],
        bottom: ["C1"],
        bottomLeft: ["B1"],
        left: ["B2"],
        leftTop: ["B3"],
        top: ["C3"],
        topRight: ["D3"],
        right: ["D2"]),
    "D2": Directions(
        bottomRight: ["E1"],
        bottom: ["D1"],
        bottomLeft: ["C1"],
        left: ["C2"],
        leftTop: ["C3"],
        top: ["D3"],
        topRight: ["E3"],
        right: ["E2"]),
    "E2": Directions(
        bottomRight: ["F1"],
        bottom: ["E1"],
        bottomLeft: ["D1"],
        left: ["D2"],
        leftTop: ["D3"],
        top: ["E3"],
        topRight: ["F3"],
        right: ["F2"]),
    "F2": Directions(
        bottomRight: ["G1"],
        bottom: ["F1"],
        bottomLeft: ["E1"],
        left: ["E2"],
        leftTop: ["E3"],
        top: ["F3"],
        topRight: ["G3"],
        right: ["G2"]),
    "G2": Directions(
        bottomRight: ["H1"],
        bottom: ["G1"],
        bottomLeft: ["F1"],
        left: ["F2"],
        leftTop: ["F3"],
        top: ["G3"],
        topRight: ["H3"],
        right: ["H2"]),
    "H2": Directions(
        bottomRight: [], bottom: ["H1"], bottomLeft: ["G1"], left: ["G2"], leftTop: ["G3"], top: ["H3"], topRight: [], right: []),
//row 3
    "A3": Directions(
        bottomRight: ["B2"], bottom: ["A2"], bottomLeft: [], left: [], leftTop: [], top: ["A4"], topRight: ["B4"], right: ["B3"]),
    "B3": Directions(
        bottomRight: ["C2"],
        bottom: ["B2"],
        bottomLeft: ["A2"],
        left: ["A3"],
        leftTop: ["A4"],
        top: ["B4"],
        topRight: ["C4"],
        right: ["C3"]),
    "C3": Directions(
        bottomRight: ["D2"],
        bottom: ["C2"],
        bottomLeft: ["B2"],
        left: ["B3"],
        leftTop: ["B4"],
        top: ["C4"],
        topRight: ["D4"],
        right: ["D3"]),
    "D3": Directions(
        bottomRight: ["E2"],
        bottom: ["D2"],
        bottomLeft: ["C2"],
        left: ["C3"],
        leftTop: ["C4"],
        top: ["D4"],
        topRight: ["E4"],
        right: ["E3"]),
    "E3": Directions(
        bottomRight: ["F2"],
        bottom: ["E2"],
        bottomLeft: ["D2"],
        left: ["D3"],
        leftTop: ["D4"],
        top: ["E4"],
        topRight: ["F4"],
        right: ["F3"]),
    "F3": Directions(
        bottomRight: ["G2"],
        bottom: ["F2"],
        bottomLeft: ["E2"],
        left: ["E3"],
        leftTop: ["E4"],
        top: ["F4"],
        topRight: ["G4"],
        right: ["G3"]),
    "G3": Directions(
        bottomRight: ["H2"],
        bottom: ["G2"],
        bottomLeft: ["F2"],
        left: ["F3"],
        leftTop: ["F4"],
        top: ["G4"],
        topRight: ["H4"],
        right: ["H3"]),
    "H3": Directions(
        bottomRight: [], bottom: ["H2"], bottomLeft: ["G2"], left: ["G3"], leftTop: ["G4"], top: ["H4"], topRight: [], right: []),
//row 4
    "A4": Directions(
        bottomRight: ["B3"], bottom: ["A3"], bottomLeft: [], left: [], leftTop: [], top: ["A5"], topRight: ["B5"], right: ["B4"]),
    "B4": Directions(
        bottomRight: ["C3"],
        bottom: ["B3"],
        bottomLeft: ["A3"],
        left: ["A4"],
        leftTop: ["A5"],
        top: ["B5"],
        topRight: ["C5"],
        right: ["C4"]),
    "C4": Directions(
        bottomRight: ["D3"],
        bottom: ["C3"],
        bottomLeft: ["B3"],
        left: ["B4"],
        leftTop: ["B5"],
        top: ["C5"],
        topRight: ["D5"],
        right: ["D4"]),
    "D4": Directions(
        bottomRight: ["E3"],
        bottom: ["D3"],
        bottomLeft: ["C3"],
        left: ["C4"],
        leftTop: ["C5"],
        top: ["D5", "I9"],
        topRight: ["I5", "E9"],
        right: ["E4"]),
    "E4": Directions(
        bottomRight: ["F3"],
        bottom: ["E3"],
        bottomLeft: ["D3"],
        left: ["D4"],
        leftTop: ["I9", "D5"],
        top: ["E9", "I5"],
        topRight: ["F9"],
        right: ["F4"]),
    "F4": Directions(
        bottomRight: ["G3"],
        bottom: ["F3"],
        bottomLeft: ["E3"],
        left: ["E4"],
        leftTop: ["E9"],
        top: ["F9"],
        topRight: ["G9"],
        right: ["G4"]),
    "G4": Directions(
        bottomRight: ["H3"],
        bottom: ["G3"],
        bottomLeft: ["F3"],
        left: ["F4"],
        leftTop: ["F9"],
        top: ["G9"],
        topRight: ["H9"],
        right: ["H4"]),
    "H4": Directions(
        bottomRight: [], bottom: ["H3"], bottomLeft: ["G3"], left: ["G4"], leftTop: ["G9"], top: ["H9"], topRight: [], right: []),

//black:
// first Row:
    "L8": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: [], leftTop: [], top: ["L7"], topRight: ["K7"], right: ["K8"]),
    "K8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["L8"], leftTop: ["L7"], top: ["K7"], topRight: ["J7"], right: ["J8"]),
    "J8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["K8"], leftTop: ["K7"], top: ["J7"], topRight: ["I7"], right: ["I8"]),
    "I8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["J8"], leftTop: ["J7"], top: ["I7"], topRight: ["D7"], right: ["D8"]),
    "D8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["I8"], leftTop: ["I7"], top: ["D7"], topRight: ["C7"], right: ["C8"]),
    "C8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["D8"], leftTop: ["D7"], top: ["C7"], topRight: ["B7"], right: ["B8"]),
    "B8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["C8"], leftTop: ["C7"], top: ["B7"], topRight: ["A7"], right: ["A8"]),
    "A8": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: ["B8"], leftTop: ["B7"], top: ["A7"], topRight: [], right: []),
// second row:
    "L7": Directions(
        bottomRight: ["K8"], bottom: ["L8"], bottomLeft: [], left: [], leftTop: [], top: ["L6"], topRight: ["K6"], right: ["K7"]),
    "K7": Directions(
        bottomRight: ["J8"],
        bottom: ["K8"],
        bottomLeft: ["L8"],
        left: ["L7"],
        leftTop: ["L6"],
        top: ["K6"],
        topRight: ["J6"],
        right: ["J7"]),
    "J7": Directions(
        bottomRight: ["I8"],
        bottom: ["J8"],
        bottomLeft: ["K8"],
        left: ["K7"],
        leftTop: ["K6"],
        top: ["J6"],
        topRight: ["I6"],
        right: ["I7"]),
    "I7": Directions(
        bottomRight: ["D8"],
        bottom: ["I8"],
        bottomLeft: ["J8"],
        left: ["J7"],
        leftTop: ["J6"],
        top: ["I6"],
        topRight: ["D6"],
        right: ["D7"]),
    "D7": Directions(
        bottomRight: ["C8"],
        bottom: ["D8"],
        bottomLeft: ["I8"],
        left: ["I7"],
        leftTop: ["I6"],
        top: ["D6"],
        topRight: ["C6"],
        right: ["C7"]),
    "C7": Directions(
        bottomRight: ["B8"],
        bottom: ["C8"],
        bottomLeft: ["D8"],
        left: ["D7"],
        leftTop: ["D6"],
        top: ["C6"],
        topRight: ["B6"],
        right: ["B7"]),
    "B7": Directions(
        bottomRight: ["A8"],
        bottom: ["B8"],
        bottomLeft: ["C8"],
        left: ["C7"],
        leftTop: ["C6"],
        top: ["B6"],
        topRight: ["A6"],
        right: ["A7"]),
    "A7": Directions(
        bottomRight: [], bottom: ["A8"], bottomLeft: ["B8"], left: ["B7"], leftTop: ["B6"], top: ["A6"], topRight: [], right: []),
//third row:
    "L6": Directions(
        bottomRight: ["K7"], bottom: ["L7"], bottomLeft: [], left: [], leftTop: [], top: ["L5"], topRight: ["K5"], right: ["K6"]),
    "K6": Directions(
        bottomRight: ["J7"],
        bottom: ["K7"],
        bottomLeft: ["L7"],
        left: ["L6"],
        leftTop: ["L5"],
        top: ["K5"],
        topRight: ["J5"],
        right: ["J6"]),
    "J6": Directions(
        bottomRight: ["I7"],
        bottom: ["J7"],
        bottomLeft: ["K7"],
        left: ["K6"],
        leftTop: ["K5"],
        top: ["J5"],
        topRight: ["I5"],
        right: ["I6"]),
    "I6": Directions(
        bottomRight: ["D7"],
        bottom: ["I7"],
        bottomLeft: ["J7"],
        left: ["J6"],
        leftTop: ["J5"],
        top: ["I5"],
        topRight: ["D5"],
        right: ["D6"]),
    "D6": Directions(
        bottomRight: ["C7"],
        bottom: ["D7"],
        bottomLeft: ["I7"],
        left: ["I6"],
        leftTop: ["I5"],
        top: ["D5"],
        topRight: ["C5"],
        right: ["C6"]),
    "C6": Directions(
        bottomRight: ["B7"],
        bottom: ["C7"],
        bottomLeft: ["D7"],
        left: ["D6"],
        leftTop: ["D5"],
        top: ["C5"],
        topRight: ["B5"],
        right: ["B6"]),
    "B6": Directions(
        bottomRight: ["A7"],
        bottom: ["B7"],
        bottomLeft: ["C7"],
        left: ["C6"],
        leftTop: ["C5"],
        top: ["B5"],
        topRight: ["A5"],
        right: ["A6"]),
    "A6": Directions(
        bottomRight: [], bottom: ["A7"], bottomLeft: ["B7"], left: ["B6"], leftTop: ["B5"], top: ["A5"], topRight: [], right: []),
// fourth row:
    "L5": Directions(
        bottomRight: ["K6"], bottom: ["L6"], bottomLeft: [], left: [], leftTop: [], top: ["L9"], topRight: ["K9"], right: ["K5"]),
    "K5": Directions(
        bottomRight: ["J6"],
        bottom: ["K6"],
        bottomLeft: ["L6"],
        left: ["L5"],
        leftTop: ["L9"],
        top: ["K9"],
        topRight: ["J9"],
        right: ["J5"]),
    "J5": Directions(
        bottomRight: ["I6"],
        bottom: ["J6"],
        bottomLeft: ["K6"],
        left: ["K5"],
        leftTop: ["K9"],
        top: ["J9"],
        topRight: ["I9"],
        right: ["I5"]),
    "I5": Directions(
        bottomRight: ["D6"],
        bottom: ["I6"],
        bottomLeft: ["J6"],
        left: ["J5"],
        leftTop: ["J9"],
        top: ["I9", "E4"],
        topRight: ["E9", "D4"],
        right: ["D5"]),
    "D5": Directions(
        bottomRight: ["C6"],
        bottom: ["D6"],
        bottomLeft: ["I6"],
        left: ["I5"],
        leftTop: ["I9", "E4"],
        top: ["D4", "E9"],
        topRight: ["C4"],
        right: ["C5"]),
    "C5": Directions(
        bottomRight: ["B6"],
        bottom: ["C6"],
        bottomLeft: ["D6"],
        left: ["D5"],
        leftTop: ["D4"],
        top: ["C4"],
        topRight: ["B4"],
        right: ["B5"]),
    "B5": Directions(
        bottomRight: ["A6"],
        bottom: ["B6"],
        bottomLeft: ["C6"],
        left: ["C5"],
        leftTop: ["C4"],
        top: ["B4"],
        topRight: ["A4"],
        right: ["A5"]),
    "A5": Directions(
        bottomRight: [], bottom: ["A6"], bottomLeft: ["B6"], left: ["B5"], leftTop: ["B4"], top: ["A4"], topRight: [], right: []),

    //red:
    //first Row:
    "H12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: [], leftTop: [], top: ["H11"], topRight: ["G11"], right: ["G12"]),
    "G12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["H12"], leftTop: ["H11"], top: ["G11"], topRight: ["F11"], right: ["F12"]),
    "F12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["G12"], leftTop: ["G11"], top: ["F11"], topRight: ["E11"], right: ["E12"]),
    "E12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["F12"], leftTop: ["F11"], top: ["E11"], topRight: ["I11"], right: ["I12"]),
    "I12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["E12"], leftTop: ["E11"], top: ["I11"], topRight: ["J11"], right: ["J12"]),
    "J12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["I12"], leftTop: ["I11"], top: ["J11"], topRight: ["K11"], right: ["K12"]),
    "K12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["J12"], leftTop: ["J11"], top: ["K11"], topRight: ["L11"], right: ["L12"]),
    "L12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["K12"], leftTop: ["K11"], top: ["L11"], topRight: [], right: []),
// second row:
    "H11": Directions(
        bottomRight: ["G12"], bottom: ["H12"], bottomLeft: [], left: [], leftTop: [], top: ["H10"], topRight: ["G10"], right: ["G11"]),
    "G11": Directions(
        bottomRight: ["F12"],
        bottom: ["G12"],
        bottomLeft: ["H12"],
        left: ["H11"],
        leftTop: ["H10"],
        top: ["G10"],
        topRight: ["F10"],
        right: ["F11"]),
    "F11": Directions(
        bottomRight: ["E12"],
        bottom: ["F12"],
        bottomLeft: ["G12"],
        left: ["G11"],
        leftTop: ["G10"],
        top: ["F10"],
        topRight: ["E10"],
        right: ["E11"]),
    "E11": Directions(
        bottomRight: ["I12"],
        bottom: ["E12"],
        bottomLeft: ["F12"],
        left: ["F11"],
        leftTop: ["F10"],
        top: ["E10"],
        topRight: ["I10"],
        right: ["I11"]),
    "I11": Directions(
        bottomRight: ["J12"],
        bottom: ["I12"],
        bottomLeft: ["E12"],
        left: ["E11"],
        leftTop: ["E10"],
        top: ["I10"],
        topRight: ["J10"],
        right: ["J11"]),
    "J11": Directions(
        bottomRight: ["K12"],
        bottom: ["J12"],
        bottomLeft: ["I12"],
        left: ["I11"],
        leftTop: ["I10"],
        top: ["J10"],
        topRight: ["K10"],
        right: ["K11"]),
    "K11": Directions(
        bottomRight: ["L12"],
        bottom: ["K12"],
        bottomLeft: ["J12"],
        left: ["J11"],
        leftTop: ["J10"],
        top: ["K10"],
        topRight: ["L10"],
        right: ["L11"]),
    "L11": Directions(
        bottomRight: [], bottom: ["L12"], bottomLeft: ["K12"], left: ["K11"], leftTop: ["K10"], top: ["L10"], topRight: [], right: []),
    //third row:
    "H10": Directions(
        bottomRight: ["G11"], bottom: ["H11"], bottomLeft: [], left: [], leftTop: [], top: ["H9"], topRight: ["G9"], right: ["G10"]),
    "G10": Directions(
        bottomRight: ["F11"],
        bottom: ["G11"],
        bottomLeft: ["H11"],
        left: ["H10"],
        leftTop: ["H9"],
        top: ["G9"],
        topRight: ["F9"],
        right: ["F10"]),
    "F10": Directions(
        bottomRight: ["E11"],
        bottom: ["F11"],
        bottomLeft: ["G11"],
        left: ["G10"],
        leftTop: ["G9"],
        top: ["F9"],
        topRight: ["E9"],
        right: ["E10"]),
    "E10": Directions(
        bottomRight: ["I11"],
        bottom: ["E11"],
        bottomLeft: ["F11"],
        left: ["F10"],
        leftTop: ["F9"],
        top: ["E9"],
        topRight: ["I9"],
        right: ["I10"]),
    "I10": Directions(
        bottomRight: ["J11"],
        bottom: ["I11"],
        bottomLeft: ["E11"],
        left: ["E10"],
        leftTop: ["E9"],
        top: ["I9"],
        topRight: ["J9"],
        right: ["J10"]),
    "J10": Directions(
        bottomRight: ["K11"],
        bottom: ["J11"],
        bottomLeft: ["I11"],
        left: ["I10"],
        leftTop: ["I9"],
        top: ["J9"],
        topRight: ["K9"],
        right: ["K10"]),
    "K10": Directions(
        bottomRight: ["L11"],
        bottom: ["K11"],
        bottomLeft: ["J11"],
        left: ["J10"],
        leftTop: ["J9"],
        top: ["K9"],
        topRight: ["L9"],
        right: ["L10"]),
    "L10": Directions(
        bottomRight: [], bottom: ["L11"], bottomLeft: ["K11"], left: ["K10"], leftTop: ["K9"], top: ["L9"], topRight: [], right: []),
// fourth row:
    "H9": Directions(
        bottomRight: ["G10"], bottom: ["H10"], bottomLeft: [], left: [], leftTop: [], top: ["H4"], topRight: ["G4"], right: ["G9"]),
    "G9": Directions(
        bottomRight: ["F10"],
        bottom: ["G10"],
        bottomLeft: ["H10"],
        left: ["H9"],
        leftTop: ["H4"],
        top: ["G4"],
        topRight: ["F4"],
        right: ["F9"]),
    "F9": Directions(
        bottomRight: ["E10"],
        bottom: ["F10"],
        bottomLeft: ["G10"],
        left: ["G9"],
        leftTop: ["G4"],
        top: ["F4"],
        topRight: ["E4"],
        right: ["E9"]),
    "E9": Directions(
        bottomRight: ["I10"],
        bottom: ["E10"],
        bottomLeft: ["F10"],
        left: ["F9"],
        leftTop: ["F4"],
        top: ["E4", "D5"],
        topRight: ["D4", "I5"],
        right: ["I9"]),
    "I9": Directions(
        bottomRight: ["J10"],
        bottom: ["I10"],
        bottomLeft: ["E10"],
        left: ["E9"],
        leftTop: ["E4", "D5"],
        top: ["I5", "D4"],
        topRight: ["J5"],
        right: ["J9"]),
    "J9": Directions(
        bottomRight: ["K10"],
        bottom: ["J10"],
        bottomLeft: ["I10"],
        left: ["I9"],
        leftTop: ["I5"],
        top: ["J5"],
        topRight: ["K5"],
        right: ["K9"]),
    "K9": Directions(
        bottomRight: ["L10"],
        bottom: ["K10"],
        bottomLeft: ["J10"],
        left: ["J9"],
        leftTop: ["J5"],
        top: ["K5"],
        topRight: ["L5"],
        right: ["L9"]),
    "L9": Directions(
        bottomRight: [], bottom: ["L10"], bottomLeft: ["K10"], left: ["K9"], leftTop: ["K5"], top: ["L5"], topRight: [], right: []),
  };
}

class Directions {
  List<String> bottomRight;
  List<String> bottom;
  List<String> bottomLeft;
  List<String> left;
  List<String> leftTop;
  List<String> top;
  List<String> topRight;
  List<String> right;

  List<List<String>> get _allDir {
    return [bottomRight, bottom, bottomLeft, left, leftTop, top, topRight, right];
  }

  List<String> getFromEnum(Direction direction) {
    return _allDir[direction.index];
  }

  List<String> getRelativeEnum(Direction direction, PlayerColor playerColor, PlayerColor side) {
    // print("playerColor: " + playerColor.toString()+ " side: " + side.toString() + " direction.index: " + direction.index.toString() + " i: " + ((playerColor != side) ? (direction.index+4)%8 : direction.index).toString());
    int i = (playerColor != side) ? (direction.index + 4) % 8 : direction.index;
    return _allDir[i];
  }

  static Direction makeRelativeEnum(Direction direction, PlayerColor playerColor, PlayerColor side) {
    // to test only: return playerColor == side ? direction : [];
    return Direction.values[(playerColor != side) ? (direction.index + 4) % 8 : direction.index];
  }

  Directions({this.bottomRight, this.bottom, this.bottomLeft, this.left, this.leftTop, this.top, this.topRight, this.right});

  List<String> get key => null;
}