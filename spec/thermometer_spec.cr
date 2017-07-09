require "spec"
require "../src/thermometer"

CASES = [
  {
    # Janko 001 - solvable with single row/column only
    [2, 4, 3, 3, 5, 3],
    [4, 2, 2, 3, 4, 5],
    [
      [{2_u32, 1_u32}, {2_u32, 2_u32}, {2_u32, 3_u32}, {2_u32, 4_u32}, {2_u32, 5_u32}, {10_u32, 3_u32}],
      [{8_u32, 5_u32}, {8_u32, 4_u32}, {8_u32, 3_u32}, {8_u32, 2_u32}, {8_u32, 1_u32}, {10_u32, 2_u32}],
      [{5_u32, 5_u32}, {5_u32, 4_u32}, {5_u32, 3_u32}, {5_u32, 2_u32}, {5_u32, 1_u32}, {10_u32, 1_u32}],
      [{1_u32, 3_u32}, {3_u32, 1_u32}, {4_u32, 3_u32}, {6_u32, 1_u32}, {9_u32, 1_u32}, {11_u32, 3_u32}],
      [{1_u32, 2_u32}, {3_u32, 2_u32}, {4_u32, 2_u32}, {6_u32, 2_u32}, {9_u32, 2_u32}, {11_u32, 2_u32}],
      [{1_u32, 1_u32}, {3_u32, 3_u32}, {4_u32, 1_u32}, {7_u32, 1_u32}, {7_u32, 2_u32}, {11_u32, 1_u32}],
    ],
    [
      [true, true, true, false, false, true],
      [false, false, false, false, true, true],
      [false, false, false, false, true, true],
      [false, true, false, true, true, false],
      [false, true, true, true, true, false],
      [true, true, true, true, true, false],
    ],
  },
  {
    # Janko 010 - needs a guess
    [4, 2, 5, 4, 6, 5, 4, 4],
    [6, 5, 4, 6, 4, 2, 3, 4],
    [
      [{3_u32, 3_u32}, {3_u32, 2_u32}, {3_u32, 1_u32}, {7_u32, 1_u32}, {7_u32, 2_u32}, {16_u32, 3_u32}, {16_u32, 2_u32}, {16_u32, 1_u32}],
      [{1_u32, 1_u32}, {1_u32, 2_u32}, {5_u32, 1_u32}, {8_u32, 1_u32}, {14_u32, 5_u32}, {13_u32, 6_u32}, {13_u32, 5_u32}, {13_u32, 4_u32}],
      [{2_u32, 2_u32}, {2_u32, 3_u32}, {5_u32, 2_u32}, {8_u32, 2_u32}, {14_u32, 4_u32}, {13_u32, 1_u32}, {13_u32, 2_u32}, {13_u32, 3_u32}],
      [{2_u32, 1_u32}, {2_u32, 4_u32}, {5_u32, 3_u32}, {8_u32, 3_u32}, {14_u32, 3_u32}, {14_u32, 2_u32}, {14_u32, 1_u32}, {17_u32, 1_u32}],
      [{6_u32, 4_u32}, {6_u32, 3_u32}, {6_u32, 2_u32}, {11_u32, 4_u32}, {11_u32, 3_u32}, {11_u32, 2_u32}, {11_u32, 1_u32}, {17_u32, 2_u32}],
      [{4_u32, 5_u32}, {4_u32, 6_u32}, {6_u32, 1_u32}, {10_u32, 1_u32}, {10_u32, 2_u32}, {10_u32, 3_u32}, {10_u32, 4_u32}, {10_u32, 5_u32}],
      [{4_u32, 4_u32}, {4_u32, 1_u32}, {9_u32, 5_u32}, {9_u32, 4_u32}, {9_u32, 3_u32}, {12_u32, 1_u32}, {15_u32, 1_u32}, {15_u32, 2_u32}],
      [{4_u32, 3_u32}, {4_u32, 2_u32}, {9_u32, 6_u32}, {9_u32, 1_u32}, {9_u32, 2_u32}, {12_u32, 2_u32}, {12_u32, 3_u32}, {12_u32, 4_u32}],
    ],
    [
      [true, true, true, true, true, false, false, true],
      [true, true, true, true, true, false, false, false],
      [true, false, true, false, true, true, false, false],
      [true, false, true, false, true, true, true, true],
      [false, false, false, false, true, true, true, true],
      [false, false, true, true, false, false, false, false],
      [false, false, false, false, false, true, true, true],
      [false, false, false, true, true, true, true, false],

    ],
  },
  {
    # Janko 013 - also needs a guess
    [6, 6, 3, 6, 7, 9, 4, 7, 3, 2],
    [4, 7, 7, 3, 5, 8, 2, 7, 7, 3],
    [
      [{1_u32, 1_u32}, {3_u32, 1_u32}, {13_u32, 3_u32}, {13_u32, 2_u32}, {13_u32, 1_u32}, {18_u32, 3_u32}, {20_u32, 3_u32}, {23_u32, 1_u32}, {27_u32, 4_u32}, {29_u32, 1_u32}],
      [{1_u32, 2_u32}, {3_u32, 2_u32}, {8_u32, 2_u32}, {10_u32, 2_u32}, {14_u32, 1_u32}, {18_u32, 2_u32}, {20_u32, 2_u32}, {23_u32, 2_u32}, {27_u32, 3_u32}, {29_u32, 2_u32}],
      [{4_u32, 2_u32}, {4_u32, 1_u32}, {8_u32, 1_u32}, {10_u32, 1_u32}, {14_u32, 2_u32}, {18_u32, 1_u32}, {20_u32, 1_u32}, {23_u32, 3_u32}, {27_u32, 2_u32}, {29_u32, 3_u32}],
      [{5_u32, 3_u32}, {5_u32, 2_u32}, {5_u32, 1_u32}, {15_u32, 1_u32}, {15_u32, 2_u32}, {15_u32, 3_u32}, {15_u32, 4_u32}, {15_u32, 5_u32}, {27_u32, 1_u32}, {29_u32, 4_u32}],
      [{16_u32, 6_u32}, {16_u32, 5_u32}, {16_u32, 4_u32}, {16_u32, 3_u32}, {16_u32, 2_u32}, {16_u32, 1_u32}, {21_u32, 1_u32}, {21_u32, 2_u32}, {21_u32, 3_u32}, {21_u32, 4_u32}],
      [{2_u32, 1_u32}, {11_u32, 4_u32}, {11_u32, 3_u32}, {11_u32, 2_u32}, {11_u32, 1_u32}, {19_u32, 2_u32}, {24_u32, 2_u32}, {24_u32, 1_u32}, {28_u32, 4_u32}, {30_u32, 4_u32}],
      [{2_u32, 2_u32}, {6_u32, 1_u32}, {12_u32, 3_u32}, {12_u32, 2_u32}, {12_u32, 1_u32}, {19_u32, 1_u32}, {25_u32, 2_u32}, {25_u32, 1_u32}, {28_u32, 3_u32}, {30_u32, 3_u32}],
      [{2_u32, 3_u32}, {6_u32, 2_u32}, {9_u32, 1_u32}, {9_u32, 2_u32}, {9_u32, 3_u32}, {9_u32, 4_u32}, {9_u32, 5_u32}, {9_u32, 6_u32}, {28_u32, 2_u32}, {30_u32, 2_u32}],
      [{7_u32, 1_u32}, {7_u32, 2_u32}, {7_u32, 3_u32}, {7_u32, 4_u32}, {17_u32, 1_u32}, {17_u32, 2_u32}, {17_u32, 3_u32}, {17_u32, 4_u32}, {28_u32, 1_u32}, {30_u32, 1_u32}],
      [{22_u32, 7_u32}, {22_u32, 6_u32}, {22_u32, 5_u32}, {22_u32, 4_u32}, {22_u32, 3_u32}, {22_u32, 2_u32}, {22_u32, 1_u32}, {26_u32, 1_u32}, {26_u32, 2_u32}, {26_u32, 3_u32}],
    ],
    [
      [true, true, false, false, false, true, false, true, false, false],
      [true, true, false, true, true, true, false, true, true, false],
      [true, true, false, true, true, true, false, true, true, false],
      [false, false, false, true, true, false, false, false, true, false],
      [false, true, true, true, true, true, false, false, false, false],
      [true, true, true, true, true, true, true, true, false, false],
      [true, false, false, false, false, true, false, false, false, false],
      [false, false, true, true, true, true, true, true, false, true],
      [true, true, false, false, true, true, true, true, false, true],
      [false, false, false, false, false, true, true, true, false, false],
    ],
  },
]

describe Thermometer do
  CASES.each { |cols, rows, board, expected|
    it "#{cols}, #{rows}" do
      Thermometer.new(cols, rows, board).solve.should eq (expected)
    end
  }
end
