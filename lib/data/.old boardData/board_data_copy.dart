import 'dart:math';
import '../models/enums.dart';

class BoardData {

  static Map<String, bool> tileWhiteData = {

    "A1" : false,

    "B1" : true,

    "C1" : false,

    "D1" : true,

    "E1" : false,

    "F1" : true,

    "G1" : false,

    "H1" : true,

    "A2" : true,

    "B2" : false,

    "C2" : true,

    "D2" : false,

    "E2" : true,

    "F2" : false,

    "G2" : true,

    "H2" : false,

    "A3" : false,

    "B3" : true,

    "C3" : false,

    "D3" : true,

    "E3" : false,

    "F3" : true,

    "G3" : false,

    "H3" : true,

    "A4" : true,

    "B4" : false,

    "C4" : true,

    "D4" : false,

    "E4" : true,

    "F4" : false,

    "G4" : true,

    "H4" : false,

    "L8" : true,

    "K8" : false,

    "J8" : true,

    "I8" : false,

    "D8" : true,

    "C8" : false,

    "B8" : true,

    "A8" : false,

    "L7" : false,

    "K7" : true,

    "J7" : false,

    "I7" : true,

    "D7" : false,

    "C7" : true,

    "B7" : false,

    "A7" : true,

    "L6" : true,

    "K6" : false,

    "J6" : true,

    "I6" : false,

    "D6" : true,

    "C6" : false,

    "B6" : true,

    "A6" : false,

    "L5" : false,

    "K5" : true,

    "J5" : false,

    "I5" : true,

    "D5" : false,

    "C5" : true,

    "B5" : false,

    "A5" : true,

    "H12" : true,

    "G12" : false,

    "F12" : true,

    "E12" : false,

    "I12" : true,

    "J12" : false,

    "K12" : true,

    "L12" : false,

    "H11" : false,

    "G11" : true,

    "F11" : false,

    "E11" : true,

    "I11" : false,

    "J11" : true,

    "K11" : false,

    "L11" : true,

    "H10" : true,

    "G10" : false,

    "F10" : true,

    "E10" : false,

    "I10" : true,

    "J10" : false,

    "K10" : true,

    "L10" : false,

    "H9" : false,

    "G9" : true,

    "F9" : false,

    "E9" : true,

    "I9" : false,

    "J9" : true,

    "K9" : false,

    "L9" : true,

  };

  static Map<String, PlayerColor> sideData = {

    "A1" : PlayerColor.white,

    "B1" : PlayerColor.white,

    "C1" : PlayerColor.white,

    "D1" : PlayerColor.white,

    "E1" : PlayerColor.white,

    "F1" : PlayerColor.white,

    "G1" : PlayerColor.white,

    "H1" : PlayerColor.white,

    "A2" : PlayerColor.white,

    "B2" : PlayerColor.white,

    "C2" : PlayerColor.white,

    "D2" : PlayerColor.white,

    "E2" : PlayerColor.white,

    "F2" : PlayerColor.white,

    "G2" : PlayerColor.white,

    "H2" : PlayerColor.white,

    "A3" : PlayerColor.white,

    "B3" : PlayerColor.white,

    "C3" : PlayerColor.white,

    "D3" : PlayerColor.white,

    "E3" : PlayerColor.white,

    "F3" : PlayerColor.white,

    "G3" : PlayerColor.white,

    "H3" : PlayerColor.white,

    "A4" : PlayerColor.white,

    "B4" : PlayerColor.white,

    "C4" : PlayerColor.white,

    "D4" : PlayerColor.white,

    "E4" : PlayerColor.white,

    "F4" : PlayerColor.white,

    "G4" : PlayerColor.white,

    "H4" : PlayerColor.white,

    "L8" : PlayerColor.black,

    "K8" : PlayerColor.black,

    "J8" : PlayerColor.black,

    "I8" : PlayerColor.black,

    "D8" : PlayerColor.black,

    "C8" : PlayerColor.black,

    "B8" : PlayerColor.black,

    "A8" : PlayerColor.black,

    "L7" : PlayerColor.black,

    "K7" : PlayerColor.black,

    "J7" : PlayerColor.black,

    "I7" : PlayerColor.black,

    "D7" : PlayerColor.black,

    "C7" : PlayerColor.black,

    "B7" : PlayerColor.black,

    "A7" : PlayerColor.black,

    "L6" : PlayerColor.black,

    "K6" : PlayerColor.black,

    "J6" : PlayerColor.black,

    "I6" : PlayerColor.black,

    "D6" : PlayerColor.black,

    "C6" : PlayerColor.black,

    "B6" : PlayerColor.black,

    "A6" : PlayerColor.black,

    "L5" : PlayerColor.black,

    "K5" : PlayerColor.black,

    "J5" : PlayerColor.black,

    "I5" : PlayerColor.black,

    "D5" : PlayerColor.black,

    "C5" : PlayerColor.black,

    "B5" : PlayerColor.black,

    "A5" : PlayerColor.black,

    "H12" : PlayerColor.red,

    "G12" : PlayerColor.red,

    "F12" : PlayerColor.red,

    "E12" : PlayerColor.red,

    "I12" : PlayerColor.red,

    "J12" : PlayerColor.red,

    "K12" : PlayerColor.red,

    "L12" : PlayerColor.red,

    "H11" : PlayerColor.red,

    "G11" : PlayerColor.red,

    "F11" : PlayerColor.red,

    "E11" : PlayerColor.red,

    "I11" : PlayerColor.red,

    "J11" : PlayerColor.red,

    "K11" : PlayerColor.red,

    "L11" : PlayerColor.red,

    "H10" : PlayerColor.red,

    "G10" : PlayerColor.red,

    "F10" : PlayerColor.red,

    "E10" : PlayerColor.red,

    "I10" : PlayerColor.red,

    "J10" : PlayerColor.red,

    "K10" : PlayerColor.red,

    "L10" : PlayerColor.red,

    "H9" : PlayerColor.red,

    "G9" : PlayerColor.red,

    "F9" : PlayerColor.red,

    "E9" : PlayerColor.red,

    "I9" : PlayerColor.red,

    "J9" : PlayerColor.red,

    "K9" : PlayerColor.red,

    "L9" : PlayerColor.red,

  };



  static Map<String, List<Point>> tileData = {
    "A1": [
      Point(299.6151407894796, 832.1318750315601),
      Point(239.75068249368047, 832.1318750315601),
      Point(209.9436927982826, 780.5332206008712),
      Point(276.571081529172, 767.0073597306907)
    ],
    "B1": [
      Point(359.2291201802754, 831.8813961265566),
      Point(299.6151407894796, 832.1318750315601),
      Point(276.571081529172, 767.0073597306907),
      Point(344.70134369008144, 754.2329355755202)
    ],
    "C1": [
      Point(419.84501519108454, 831.8813961265566),
      Point(359.2291201802754, 831.8813961265566),
      Point(344.70134369008144, 754.2329355755202),
      Point(412.3306480409842, 741.9594692303564)
    ],
    "D1": [
      Point(480.71138910689706, 831.7561566740551),
      Point(419.84501519108454, 831.8813961265566),
      Point(412.3306480409842, 741.9594692303564),
      Point(480.2104312968904, 729.0598056226842)
    ],
    "E1": [
      Point(540.3253684976929, 832.6328328415668),
      Point(480.71138910689706, 831.7561566740551),
      Point(480.2104312968904, 729.0598056226842),
      Point(547.8397356477932, 741.7089903253529)
    ],
    "F1": [
      Point(600.3150662459936, 832.7580722940685),
      Point(540.3253684976929, 832.6328328415668),
      Point(547.8397356477932, 741.7089903253529),
      Point(615.0933216411909, 755.1096117430319)
    ],
    "G1": [
      Point(660.6804823517995, 832.2571144840616),
      Point(600.3150662459936, 832.7580722940685),
      Point(615.0933216411909, 755.1096117430319),
      Point(682.7226259920936, 768.009275350704)
    ],
    "H1": [
      Point(720.2944617425952, 832.2571144840616),
      Point(660.6804823517995, 832.2571144840616),
      Point(682.7226259920936, 768.009275350704),
      Point(749.0995358179797, 780.5332206008712)
    ],
    "A2": [
      Point(276.571081529172, 767.0073597306907),
      Point(209.9436927982826, 780.5332206008712),
      Point(179.5105058403763, 728.5588478126774),
      Point(253.65226172136602, 702.5090416923298)
    ],
    "B2": [
      Point(344.70134369008144, 754.2329355755202),
      Point(276.571081529172, 767.0073597306907),
      Point(253.65226172136602, 702.5090416923298),
      Point(329.17165157987415, 676.5844750244836)
    ],
    "C2": [
      Point(412.3306480409842, 741.9594692303564),
      Point(344.70134369008144, 754.2329355755202),
      Point(329.17165157987415, 676.5844750244836),
      Point(404.6910414383823, 650.6599083566375)
    ],
    "D2": [
      Point(480.2104312968904, 729.0598056226842),
      Point(412.3306480409842, 741.9594692303564),
      Point(404.6910414383823, 650.6599083566375),
      Point(479.70947348688367, 625.2362994987982)
    ],
    "E2": [
      Point(547.8397356477932, 741.7089903253529),
      Point(480.2104312968904, 729.0598056226842),
      Point(479.70947348688367, 625.2362994987982),
      Point(554.6026660828835, 650.6599083566375)
    ],
    "F2": [
      Point(615.0933216411909, 755.1096117430319),
      Point(547.8397356477932, 741.7089903253529),
      Point(554.6026660828835, 650.6599083566375),
      Point(629.99681648889, 676.5844750244836)
    ],
    "G2": [
      Point(682.7226259920936, 768.009275350704),
      Point(615.0933216411909, 755.1096117430319),
      Point(629.99681648889, 676.5844750244836),
      Point(705.3909668948963, 702.3838022398281)
    ],
    "H2": [
      Point(749.0995358179797, 780.5332206008712),
      Point(682.7226259920936, 768.009275350704),
      Point(705.3909668948963, 702.3838022398281),
      Point(779.9084411333911, 728.8093267176808)
    ],
    "A3": [
      Point(253.65226172136602, 702.5090416923298),
      Point(179.5105058403763, 728.5588478126774),
      Point(150.07923450248344, 676.0835172144771),
      Point(231.98583643857683, 637.3845263914604)
    ],
    "B3": [
      Point(329.17165157987415, 676.5844750244836),
      Point(253.65226172136602, 702.5090416923298),
      Point(231.98583643857683, 637.3845263914604),
      Point(314.7691145421819, 598.8107750209455)
    ],
    "C3": [
      Point(404.6910414383823, 650.6599083566375),
      Point(329.17165157987415, 676.5844750244836),
      Point(314.7691145421819, 598.8107750209455),
      Point(397.3019137407836, 559.7360658404239)
    ],
    "D3": [
      Point(479.70947348688367, 625.2362994987982),
      Point(404.6910414383823, 650.6599083566375),
      Point(397.3019137407836, 559.7360658404239),
      Point(480.335670749392, 520.4108777548989)
    ],
    "E3": [
      Point(554.6026660828835, 650.6599083566375),
      Point(479.70947348688367, 625.2362994987982),
      Point(480.335670749392, 520.4108777548989),
      Point(562.6179910429904, 559.7360658404239)
    ],
    "F3": [
      Point(629.99681648889, 676.5844750244836),
      Point(554.6026660828835, 650.6599083566375),
      Point(562.6179910429904, 559.7360658404239),
      Point(645.6517480515988, 598.8107750209455)
    ],
    "G3": [
      Point(705.3909668948963, 702.3838022398281),
      Point(629.99681648889, 676.5844750244836),
      Point(645.6517480515988, 598.8107750209455),
      Point(728.0593077976989, 637.6350052964638)
    ],
    "H3": [
      Point(779.9084411333911, 728.8093267176808),
      Point(705.3909668948963, 702.3838022398281),
      Point(728.0593077976989, 637.6350052964638),
      Point(810.0911491862939, 676.9601933819886)
    ],
    "A4": [
      Point(231.98583643857683, 637.3845263914604),
      Point(150.07923450248344, 676.0835172144771),
      Point(119.5208080920755, 624.4848627837881),
      Point(209.06701663077087, 572.7609689005977)
    ],
    "B4": [
      Point(314.7691145421819, 598.8107750209455),
      Point(231.98583643857683, 637.3845263914604),
      Point(209.06701663077087, 572.7609689005977),
      Point(299.2394224319746, 520.5361172074006)
    ],
    "C4": [
      Point(397.3019137407836, 559.7360658404239),
      Point(314.7691145421819, 598.8107750209455),
      Point(299.2394224319746, 520.5361172074006),
      Point(389.6623071381817, 468.68698387170843)
    ],
    "D4": [
      Point(480.335670749392, 520.4108777548989),
      Point(397.3019137407836, 559.7360658404239),
      Point(389.6623071381817, 468.68698387170843),
      Point(480.2104312968904, 416.4621321785113)
    ],
    "E4": [
      Point(562.6179910429904, 559.7360658404239),
      Point(480.335670749392, 520.4108777548989),
      Point(480.2104312968904, 416.4621321785113),
      Point(570.7585554555991, 468.81222332421015)
    ],
    "F4": [
      Point(645.6517480515988, 598.8107750209455),
      Point(562.6179910429904, 559.7360658404239),
      Point(570.7585554555991, 468.81222332421015),
      Point(660.430003446796, 520.6613566599023)
    ],
    "G4": [
      Point(728.0593077976989, 637.6350052964638),
      Point(645.6517480515988, 598.8107750209455),
      Point(660.430003446796, 520.6613566599023),
      Point(751.1033670580066, 572.6357294480961)
    ],
    "H4": [
      Point(810.0911491862939, 676.9601933819886),
      Point(728.0593077976989, 637.6350052964638),
      Point(751.1033670580066, 572.6357294480961),
      Point(840.1486177866951, 624.7353416887916)
    ],
    "L8": [
      Point(29.93222914789954, 365.02737013523546),
      Point(0, 416.8715118031916),
      Point(29.782250690372134, 468.4844493050916),
      Point(74.80968417744702, 417.54636851141044)
    ],
    "K8": [
      Point(59.956139938142506, 313.525389014626),
      Point(29.93222914789954, 365.02737013523546),
      Point(74.80968417744702, 417.54636851141044),
      Point(119.93779109499702, 364.9310427911545)
    ],
    "J8": [
      Point(90.26408744354708, 261.03048406213486),
      Point(59.956139938142506, 313.525389014626),
      Point(119.93779109499702, 364.9310427911545),
      Point(164.38157691785358, 312.4990803555851)
    ],
    "I8": [
      Point(120.80573494887588, 208.38127774104947),
      Point(90.26408744354708, 261.03048406213486),
      Point(164.38157691785358, 312.4990803555851),
      Point(209.4929049303245, 260.1632954564249)
    ],
    "D8": [
      Point(149.85350081231624, 156.31571908418243),
      Point(120.80573494887588, 208.38127774104947),
      Point(209.4929049303245, 260.1632954564249),
      Point(232.35304181610312, 195.2700074969392)
    ],
    "C8": [
      Point(179.73988913904398, 104.300497142553),
      Point(149.85350081231624, 156.31571908418243),
      Point(232.35304181610312, 195.2700074969392),
      Point(254.37455623859407, 130.32638282221612)
    ],
    "B8": [
      Point(210.3564393816371, 52.27299218991017),
      Point(179.73988913904398, 104.300497142553),
      Point(254.37455623859407, 130.32638282221612),
      Point(277.01777202952786, 65.30785541022865)
    ],
    "A8": [
      Point(240.16342907703492, 0.6457716167992157),
      Point(210.3564393816371, 52.27299218991017),
      Point(277.01777202952786, 65.30785541022865),
      Point(299.36017220022075, 1.5617926512187792)
    ],
    "L7": [
      Point(74.80968417744702, 417.54636851141044),
      Point(29.782250690372134, 468.4844493050916),
      Point(59.576784391757464, 520.8275487228565),
      Point(119.2074561961328, 469.64380770890904)
    ],
    "K7": [
      Point(119.93779109499702, 364.9310427911545),
      Point(74.80968417744702, 417.54636851141044),
      Point(119.2074561961328, 469.64380770890904),
      Point(179.41848444184484, 417.2043809470631)
    ],
    "J7": [
      Point(164.38157691785358, 312.4990803555851),
      Point(119.93779109499702, 364.9310427911545),
      Point(179.41848444184484, 417.2043809470631),
      Point(239.62951268755697, 364.76495418521716)
    ],
    "I7": [
      Point(209.4929049303245, 260.1632954564249),
      Point(164.38157691785358, 312.4990803555851),
      Point(239.62951268755697, 364.76495418521716),
      Point(299.1562198385755, 312.508890708058)
    ],
    "D7": [
      Point(232.35304181610312, 195.2700074969392),
      Point(209.4929049303245, 260.1632954564249),
      Point(299.1562198385755, 312.508890708058),
      Point(314.58532500980743, 234.93767892048183)
    ],
    "C7": [
      Point(254.37455623859407, 130.32638282221612),
      Point(232.35304181610312, 195.2700074969392),
      Point(314.58532500980743, 234.93767892048183),
      Point(329.8310668963527, 156.6821460382123)
    ],
    "B7": [
      Point(277.01777202952786, 65.30785541022865),
      Point(254.37455623859407, 130.32638282221612),
      Point(329.8310668963527, 156.6821460382123),
      Point(345.1852693303204, 78.4892328821937)
    ],
    "A7": [
      Point(299.36017220022075, 1.5617926512187792),
      Point(277.01777202952786, 65.30785541022865),
      Point(345.1852693303204, 78.4892328821937),
      Point(359.55883094341976, 0.7424449268783851)
    ],
    "L6": [
      Point(119.2074561961328, 469.64380770890904),
      Point(59.576784391757464, 520.8275487228565),
      Point(90.30611809283957, 572.5534426662448),
      Point(164.7737282144395, 520.9697400634365)
    ],
    "K6": [
      Point(179.41848444184484, 417.2043809470631),
      Point(119.2074561961328, 469.64380770890904),
      Point(164.7737282144395, 520.9697400634365),
      Point(239.57121587237273, 468.5641939024199)
    ],
    "J6": [
      Point(239.62951268755697, 364.76495418521716),
      Point(179.41848444184484, 417.2043809470631),
      Point(239.57121587237273, 468.5641939024199),
      Point(314.6773062674943, 416.6260477412516)
    ],
    "I6": [
      Point(299.1562198385755, 312.508890708058),
      Point(239.62951268755697, 364.76495418521716),
      Point(314.6773062674943, 416.6260477412516),
      Point(390.25079666246427, 364.379298842895)
    ],
    "D6": [
      Point(314.58532500980743, 234.93767892048183),
      Point(299.1562198385755, 312.508890708058),
      Point(390.25079666246427, 364.379298842895),
      Point(397.3353449185977, 273.4581251435485)
    ],
    "C6": [
      Point(329.8310668963527, 156.6821460382123),
      Point(314.58532500980743, 234.93767892048183),
      Point(397.3353449185977, 273.4581251435485),
      Point(405.01253262708116, 182.01142761216863)
    ],
    "B6": [
      Point(345.1852693303204, 78.4892328821937),
      Point(329.8310668963527, 156.6821460382123),
      Point(405.01253262708116, 182.01142761216863),
      Point(412.5935427991556, 91.23227227040287)
    ],
    "A6": [
      Point(359.55883094341976, 0.7424449268783851),
      Point(345.1852693303204, 78.4892328821937),
      Point(412.5935427991556, 91.23227227040287),
      Point(419.55285160278714, 0.5280196659014126)
    ],
    "L5": [
      Point(164.7737282144395, 520.9697400634365),
      Point(90.30611809283957, 572.5534426662448),
      Point(119.7126504257066, 624.8171434526798),
      Point(209.27996078054775, 573.1297989871858)
    ],
    "K5": [
      Point(239.57121587237273, 468.5641939024199),
      Point(164.7737282144395, 520.9697400634365),
      Point(209.27996078054775, 573.1297989871858),
      Point(299.59421195633314, 521.1506306895826)
    ],
    "J5": [
      Point(314.6773062674943, 416.6260477412516),
      Point(239.57121587237273, 468.5641939024199),
      Point(299.59421195633314, 521.1506306895826),
      Point(389.7083209423526, 468.766682118382)
    ],
    "I5": [
      Point(390.25079666246427, 364.379298842895),
      Point(314.6773062674943, 416.6260477412516),
      Point(389.7083209423526, 468.766682118382),
      Point(480.2104312968904, 416.4621321785113)
    ],
    "D5": [
      Point(397.3353449185977, 273.4581251435485),
      Point(390.25079666246427, 364.379298842895),
      Point(480.2104312968904, 416.4621321785113),
      Point(480.14798455363876, 311.8701108191927)
    ],
    "C5": [
      Point(405.01253262708116, 182.01142761216863),
      Point(397.3353449185977, 273.4581251435485),
      Point(480.14798455363876, 311.8701108191927),
      Point(480.0810419163213, 208.2877921968349)
    ],
    "B5": [
      Point(412.5935427991556, 91.23227227040287),
      Point(405.01253262708116, 182.01142761216863),
      Point(480.0810419163213, 208.2877921968349),
      Point(480.406596541588, 103.77516946884634)
    ],
    "A5": [
      Point(419.55285160278714, 0.5280196659014126),
      Point(412.5935427991556, 91.23227227040287),
      Point(480.406596541588, 103.77516946884634),
      Point(479.8096341781712, 0.6099141310993765)
    ],
    "H12": [
      Point(749.8933429384705, 52.22715136873842),
      Point(719.9611137905711, 0.3830097007822668),
      Point(660.3718734048011, 0.3687266295712506),
      Point(681.9718286486154, 64.8326682934327)
    ],
    "G12": [
      Point(779.4834115390233, 103.9796113943513),
      Point(749.8933429384705, 52.22715136873842),
      Point(681.9718286486154, 64.8326682934327),
      Point(704.9739838919747, 130.2224181688593)
    ],
    "F12": [
      Point(809.7913590444281, 156.4745163468425),
      Point(779.4834115390233, 103.9796113943513),
      Point(704.9739838919747, 130.2224181688593),
      Point(728.1595024200211, 194.9278469495924)
    ],
    "E12": [
      Point(840.1160854549117, 209.24896212042952),
      Point(809.7913590444281, 156.4745163468425),
      Point(728.1595024200211, 194.9278469495924),
      Point(750.9279576634564, 260.1632954564249)
    ],
    "I12": [
      Point(870.6822989822671, 260.4378446097848),
      Point(840.1160854549117, 209.24896212042952),
      Point(750.9279576634564, 260.1632954564249),
      Point(795.6971251285805, 312.40739871324183)
    ],
    "J12": [
      Point(900.78560840384, 312.32782709891245),
      Point(870.6822989822671, 260.4378446097848),
      Point(795.6971251285805, 312.40739871324183),
      Point(840.9291966994871, 363.95040197028607)
    ],
    "K12": [
      Point(930.5344742670527, 364.8562898615621),
      Point(900.78560840384, 312.32782709891245),
      Point(840.9291966994871, 363.95040197028607),
      Point(885.9152852594561, 416.0692657746013)
    ],
    "L12": [
      Point(960.3414639624506, 416.48351043467324),
      Point(930.5344742670527, 364.8562898615621),
      Point(885.9152852594561, 416.0692657746013),
      Point(929.9497949146494, 467.29138328344396)
    ],
    "H11": [
      Point(681.9718286486154, 64.8326682934327),
      Point(660.3718734048011, 0.3687266295712506),
      Point(600.1441527455094, 0.0),
      Point(614.6552368221237, 77.23354713429525)
    ],
    "G11": [
      Point(704.9739838919747, 130.2224181688593),
      Point(681.9718286486154, 64.8326682934327),
      Point(614.6552368221237, 77.23354713429525),
      Point(629.9635984349197, 155.59754056398725)
    ],
    "F11": [
      Point(728.1595024200211, 194.9278469495924),
      Point(704.9739838919747, 130.2224181688593),
      Point(629.9635984349197, 155.59754056398725),
      Point(645.2719600477158, 233.96153399367924)
    ],
    "E11": [
      Point(750.9279576634564, 260.1632954564249),
      Point(728.1595024200211, 194.9278469495924),
      Point(645.2719600477158, 233.96153399367924),
      Point(660.7636849451985, 311.6412063286778)
    ],
    "I11": [
      Point(795.6971251285805, 312.40739871324183),
      Point(750.9279576634564, 260.1632954564249),
      Point(660.7636849451985, 311.6412063286778),
      Point(720.2277723699663, 363.7888092584146)
    ],
    "J11": [
      Point(840.9291966994871, 363.95040197028607),
      Point(795.6971251285805, 312.40739871324183),
      Point(720.2277723699663, 363.7888092584146),
      Point(780.3761808894277, 416.119775472838)
    ],
    "K11": [
      Point(885.9152852594561, 416.0692657746013),
      Point(840.9291966994871, 363.95040197028607),
      Point(780.3761808894277, 416.119775472838),
      Point(840.4161288614664, 468.5133614135122)
    ],
    "L11": [
      Point(929.9497949146494, 467.29138328344396),
      Point(885.9152852594561, 416.0692657746013),
      Point(840.4161288614664, 468.5133614135122),
      Point(900.5600414868617, 519.8346248909747)
    ],
    "H10": [
      Point(614.6552368221237, 77.23354713429525),
      Point(600.1441527455094, 0.0),
      Point(539.9835477065344, 0.7494366548121644),
      Point(547.4225395210278, 91.03213008063706)
    ],
    "G10": [
      Point(629.9635984349197, 155.59754056398725),
      Point(614.6552368221237, 77.23354713429525),
      Point(547.4225395210278, 91.03213008063706),
      Point(555.4083299666996, 182.01142761216863)
    ],
    "F10": [
      Point(645.2719600477158, 233.96153399367924),
      Point(629.9635984349197, 155.59754056398725),
      Point(555.4083299666996, 182.01142761216863),
      Point(562.8350387701797, 273.0242829538584)
    ],
    "E10": [
      Point(660.7636849451985, 311.6412063286778),
      Point(645.2719600477158, 233.96153399367924),
      Point(562.8350387701797, 273.0242829538584),
      Point(570.2953053838182, 364.59621993774)
    ],
    "I10": [
      Point(720.2277723699663, 363.7888092584146),
      Point(660.7636849451985, 311.6412063286778),
      Point(570.2953053838182, 364.59621993774),
      Point(645.493077421283, 416.1922055515615)
    ],
    "J10": [
      Point(780.3761808894277, 416.119775472838),
      Point(720.2277723699663, 363.7888092584146),
      Point(645.493077421283, 416.1922055515615),
      Point(720.849646721408, 468.5641939024199)
    ],
    "K10": [
      Point(840.4161288614664, 468.5133614135122),
      Point(780.3761808894277, 416.119775472838),
      Point(720.849646721408, 468.5641939024199),
      Point(795.6761962954339, 520.5191189686674)
    ],
    "L10": [
      Point(900.5600414868617, 519.8346248909747),
      Point(840.4161288614664, 468.5133614135122),
      Point(795.6761962954339, 520.5191189686674),
      Point(870.7487288803969, 571.8981834876439)
    ],
    "H9": [
      Point(547.4225395210278, 91.03213008063706),
      Point(539.9835477065344, 0.7494366548121644),
      Point(480.01858896325945, 0.0843902990659772),
      Point(479.99748714711365, 103.4956286477504)
    ],
    "G9": [
      Point(555.4083299666996, 182.01142761216863),
      Point(547.4225395210278, 91.03213008063706),
      Point(479.99748714711365, 103.4956286477504),
      Point(479.85564177253195, 207.69964863855074)
    ],
    "F9": [
      Point(562.8350387701797, 273.0242829538584),
      Point(555.4083299666996, 182.01142761216863),
      Point(479.85564177253195, 207.69964863855074),
      Point(480.16441749271956, 311.9327305454435)
    ],
    "E9": [
      Point(570.2953053838182, 364.59621993774),
      Point(562.8350387701797, 273.0242829538584),
      Point(480.16441749271956, 311.9327305454435),
      Point(480.2104312968904, 416.4621321785113)
    ],
    "I9": [
      Point(645.493077421283, 416.1922055515615),
      Point(570.2953053838182, 364.59621993774),
      Point(480.2104312968904, 416.4621321785113),
      Point(570.8210021988508, 468.70406239213105)
    ],
    "J9": [
      Point(720.849646721408, 468.5641939024199),
      Point(645.493077421283, 416.1922055515615),
      Point(570.8210021988508, 468.70406239213105),
      Point(660.5593928273652, 520.4372476787968)
    ],
    "K9": [
      Point(795.6761962954339, 520.5191189686674),
      Point(720.849646721408, 468.5641939024199),
      Point(660.5593928273652, 520.4372476787968),
      Point(750.9072018133087, 572.9754976185916)
    ],
    "L9": [
      Point(870.7487288803969, 571.8981834876439),
      Point(795.6761962954339, 520.5191189686674),
      Point(750.9072018133087, 572.9754976185916),
      Point(840.5494149054141, 624.0411407156431)
    ],
  };
  //Starting right bottom relative to white and iterating clockwise (1 right bottom, 2 left bottom, 3 left top, 4 right top)
  // White:
  //first Row:

  //Strings of player




  static final Map<String, Directions> adjacentTiles = {
    "A1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["A2"],
        topRight: ["B2"],
        right: ["A2"]),
    "B1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["A1"],
        leftTop: ["A2"],
        top: ["B2"],
        topRight: ["C2"],
        right: ["C1"]),
    "C1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["B1"],
        leftTop: ["B2"],
        top: ["C2"],
        topRight: ["D2"],
        right: ["D1"]),
    "D1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["C1"],
        leftTop: ["C2"],
        top: ["D2"],
        topRight: ["E2"],
        right: ["E1"]),
    "E1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["D1"],
        leftTop: ["D2"],
        top: ["E2"],
        topRight: ["F2"],
        right: ["F1"]),
    "F1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["E1"],
        leftTop: ["E2"],
        top: ["F2"],
        topRight: ["G2"],
        right: ["G1"]),
    "G1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["F1"],
        leftTop: ["F2"],
        top: ["G2"],
        topRight: ["H2"],
        right: ["H1"]),
    "H1": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["G1"],
        leftTop: ["G2"],
        top: ["H2"],
        topRight: [],
        right: []),
//row 2
    "A2": Directions(
        bottomRight: ["B1"],
        bottom: ["A1"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["A3"],
        topRight: ["B3"],
        right: ["B2"]),
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
        leftTop: ["C3"],
        top: ["C3"],
        topRight: ["D3"],
        right: ["D2"]),
    "D2": Directions(
        bottomRight: ["E1"],
        bottom: ["D1"],
        bottomLeft: ["C1"],
        left: ["C2"],
        leftTop: ["D3"],
        top: ["D3"],
        topRight: ["E3"],
        right: ["E2"]),
    "E2": Directions(
        bottomRight: ["F1"],
        bottom: ["E1"],
        bottomLeft: ["D1"],
        left: ["D2"],
        leftTop: ["E3"],
        top: ["E3"],
        topRight: ["F3"],
        right: ["F2"]),
    "F2": Directions(
        bottomRight: ["G1"],
        bottom: ["F1"],
        bottomLeft: ["E1"],
        left: ["E2"],
        leftTop: ["F3"],
        top: ["F3"],
        topRight: ["G3"],
        right: ["G2"]),
    "G2": Directions(
        bottomRight: ["H1"],
        bottom: ["G1"],
        bottomLeft: ["F1"],
        left: ["F2"],
        leftTop: ["G3"],
        top: ["G3"],
        topRight: ["H3"],
        right: ["H2"]),
    "H2": Directions(
        bottomRight: [],
        bottom: ["H1"],
        bottomLeft: ["G1"],
        left: ["G2"],
        leftTop: ["G3"],
        top: ["H3"],
        topRight: [],
        right: []),
//row 3
    "A3": Directions(
        bottomRight: ["B2"],
        bottom: ["A2"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["A4"],
        topRight: ["B4"],
        right: ["B3"]),
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
        bottomRight: [],
        bottom: ["H2"],
        bottomLeft: ["G2"],
        left: ["G3"],
        leftTop: ["G4"],
        top: ["H4"],
        topRight: [],
        right: []),
//row 4
    "A4": Directions(
        bottomRight: ["B3"],
        bottom: ["A3"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["A5"],
        topRight: ["B5"],
        right: ["B4"]),
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
        right: ["D3"]),
    "D4": Directions(
        bottomRight: ["E3"],
        bottom: ["D3"],
        bottomLeft: ["C3"],
        left: ["C4"],
        leftTop: ["C5"],
        top: ["D5", "I9"],
        topRight: ["I5", "E9"],
        right: ["E3"]),
    "E4": Directions(
        bottomRight: ["F3"],
        bottom: ["E3"],
        bottomLeft: ["E3"],
        left: ["D4"],
        leftTop: ["I9", "D5"],
        top: ["E9", "I5"],
        topRight: ["F9"],
        right: ["F3"]),
    "F4": Directions(
        bottomRight: ["G3"],
        bottom: ["F3"],
        bottomLeft: ["F3"],
        left: ["E4"],
        leftTop: ["E9"],
        top: ["F9"],
        topRight: ["G9"],
        right: ["G3"]),
    "G4": Directions(
        bottomRight: ["H3"],
        bottom: ["G3"],
        bottomLeft: ["G3"],
        left: ["F4"],
        leftTop: ["F9"],
        top: ["G9"],
        topRight: ["H9"],
        right: ["H3"]),
    "H4": Directions(
        bottomRight: [],
        bottom: ["H3"],
        bottomLeft: [],
        left: ["G4"],
        leftTop: ["G9"],
        top: ["H9"],
        topRight: [],
        right: []),

//black:
// first Row:
    "L8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["L7"],
        topRight: ["K7"],
        right: ["K8"]),
    "K8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["L8"],
        leftTop: ["L7"],
        top: ["K7"],
        topRight: ["J7"],
        right: ["J8"]),
    "J8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["K8"],
        leftTop: ["K7"],
        top: ["J7"],
        topRight: ["I7"],
        right: ["I8"]),
    "I8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["J8"],
        leftTop: ["J7"],
        top: ["I7"],
        topRight: ["D7"],
        right: ["D8"]),
    "D8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["I8"],
        leftTop: ["I7"],
        top: ["D7"],
        topRight: ["C7"],
        right: ["C8"]),
    "C8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["D8"],
        leftTop: ["D7"],
        top: ["C7"],
        topRight: ["B7"],
        right: ["B8"]),
    "B8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["C8"],
        leftTop: ["C7"],
        top: ["B7"],
        topRight: ["A7"],
        right: ["A8"]),
    "A8": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["B8"],
        leftTop: ["B7"],
        top: ["A7"],
        topRight: [],
        right: []),
// second row:
    "L7": Directions(
        bottomRight: ["K8"],
        bottom: ["L8"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["L6"],
        topRight: ["K6"],
        right: ["K7"]),
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
        left: ["L7"],
        leftTop: ["C6"],
        top: ["B6"],
        topRight: ["A6"],
        right: ["A7"]),
    "A7": Directions(
        bottomRight: [],
        bottom: ["A8"],
        bottomLeft: ["B8"],
        left: ["L7"],
        leftTop: ["B6"],
        top: ["A6"],
        topRight: [],
        right: []),
//third row:
    "L6": Directions(
        bottomRight: ["K7"],
        bottom: ["L7"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["L5"],
        topRight: ["K5"],
        right: ["K6"]),
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
        bottomRight: [],
        bottom: ["A7"],
        bottomLeft: ["B7"],
        left: ["B6"],
        leftTop: ["B5"],
        top: ["A5"],
        topRight: [],
        right: []),
// fourth row:
    "L5": Directions(
        bottomRight: ["K6"],
        bottom: ["L6"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["L9"],
        topRight: ["K9"],
        right: ["K5"]),
    "K5": Directions(
        bottomRight: ["J6"],
        bottom: ["K6"],
        bottomLeft: ["L6"],
        left: ["L5"],
        leftTop: ["I9"],
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
        leftTop: ["I9", "E9"],
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
        bottomRight: [],
        bottom: ["A6"],
        bottomLeft: ["B6"],
        left: ["B5"],
        leftTop: ["B4"],
        top: ["A4"],
        topRight: [],
        right: []),

    //red:
    //first Row:
    "H12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["H11"],
        topRight: ["G11"],
        right: ["G12"]),
    "G12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["H12"],
        leftTop: ["H11"],
        top: ["G11"],
        topRight: ["F11"],
        right: ["F12"]),
    "F12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["G12"],
        leftTop: ["G11"],
        top: ["F11"],
        topRight: ["E11"],
        right: ["E12"]),
    "E12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["F12"],
        leftTop: ["F11"],
        top: ["E11"],
        topRight: ["I11"],
        right: ["I12"]),
    "I12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["E12"],
        leftTop: ["E11"],
        top: ["I11"],
        topRight: ["J11"],
        right: ["J12"]),
    "J12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["I12"],
        leftTop: ["I11"],
        top: ["J11"],
        topRight: ["K11"],
        right: ["K12"]),
    "K12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["J12"],
        leftTop: ["J11"],
        top: ["K11"],
        topRight: ["L11"],
        right: ["L12"]),
    "L12": Directions(
        bottomRight: [],
        bottom: [],
        bottomLeft: [],
        left: ["K12"],
        leftTop: ["K11"],
        top: ["L11"],
        topRight: [],
        right: []),
// second row:
    "H11": Directions(
        bottomRight: ["G12"],
        bottom: ["H12"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["H10"],
        topRight: ["G10"],
        right: ["G11"]),
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
        bottomRight: [],
        bottom: ["L12"],
        bottomLeft: ["K12"],
        left: ["K11"],
        leftTop: ["K10"],
        top: ["L10"],
        topRight: [],
        right: []),
    //third row:
    "H10": Directions(
        bottomRight: ["G11"],
        bottom: ["H11"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["H9"],
        topRight: ["G9"],
        right: ["G10"]),
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
        bottomRight: [],
        bottom: ["L11"],
        bottomLeft: ["K11"],
        left: ["K10"],
        leftTop: ["K9"],
        top: ["L9"],
        topRight: [],
        right: []),
// fourth row:
    "H9": Directions(
        bottomRight: ["G10"],
        bottom: ["H10"],
        bottomLeft: [],
        left: [],
        leftTop: [],
        top: ["H4"],
        topRight: ["G4"],
        right: ["G9"]),
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
        leftTop: ["4", "D5"],
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
        bottomRight: [],
        bottom: ["L10"],
        bottomLeft: ["K10"],
        left: ["K9"],
        leftTop: ["K5"],
        top: ["L5"],
        topRight: [],
        right: []),
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

  List<List<String>> get _allDir{
    return [bottomRight, bottom, bottomLeft, left, leftTop, top, topRight, right];
  }

  List<String> getFromEnum(Direction direction){
    return _allDir[direction.index];
  }

    List<String> getRelativeEnum(Direction direction, PlayerColor playerColor, PlayerColor side){
   // print("playerColor: " + playerColor.toString()+ " side: " + side.toString() + " direction.index: " + direction.index.toString() + " i: " + ((playerColor != side) ? (direction.index+4)%8 : direction.index).toString());
    int i = (playerColor != side) ? (direction.index+4)%8 : direction.index;
    return _allDir[i];
  }

  static Direction makeRelativeEnum(Direction direction, PlayerColor playerColor, PlayerColor side){
    // to test only: return playerColor == side ? direction : [];
    return Direction.values[(playerColor != side) ? (direction.index+4)%8 : direction.index];
  }

  Directions(
      {this.bottomRight,
      this.bottom,
      this.bottomLeft,
      this.left,
      this.leftTop,
      this.top,
      this.topRight,
      this.right});

  List<String> get key => null;
}
