enum PrintColors {
  Red,
  Black,
  Green,
  Yellow,
  Blue,
  Magenta,
  Cyan,
  White,
  Reset
}

const Map<PrintColors, String> printColorInterface = {
  PrintColors.Black: '\x1B[30m',
  PrintColors.Red: '\x1B[31m',
  PrintColors.Green: '\x1B[32m',
  PrintColors.Yellow: '\x1B[33m',
  PrintColors.Blue: '\x1B[34m',
  PrintColors.Magenta: '\x1B[35m',
  PrintColors.Cyan: '\x1B[36m',
  PrintColors.White: '\x1B[37m',
  PrintColors.Reset: '\x1B[0m',
};

class ColoredPrint {
  static String getPrintColorString(PrintColors color) {
    return printColorInterface[color];
  }

  static void printColored(String text, PrintColors color) {
    print(getPrintColorString(color) +
        text +
        getPrintColorString(PrintColors.Reset));
  }
}
