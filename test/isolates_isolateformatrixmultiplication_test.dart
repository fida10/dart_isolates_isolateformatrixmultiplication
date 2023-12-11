import 'package:isolates_isolateformatrixmultiplication/isolates_isolateformatrixmultiplication.dart';
import 'package:test/test.dart';

void main() {
  test('multiplyMatricesInIsolate multiplies matrices correctly', () async {
    var matrix1 = [
      [1, 2],
      [3, 4]
    ];
    var matrix2 = [
      [5, 6],
      [7, 8]
    ];
    var expected = [
      [19, 22],
      [43, 50]
    ];
    expect(await multiplyMatricesInIsolate(matrix1, matrix2), equals(expected));
  });

  test('multiplyMatricesInIsolate handles empty matrices', () async {
    expect(await multiplyMatricesInIsolate([], []), isEmpty);
  });

  test('multiplyMatricesInIsolate handles non-square matrices', () async {
    var matrix1 = [
      [1, 2, 3],
      [4, 5, 6]
    ];
    var matrix2 = [
      [7, 8],
      [9, 10],
      [11, 12]
    ];
    var expected = [
      [58, 64],
      [139, 154]
    ];
    expect(await multiplyMatricesInIsolate(matrix1, matrix2), equals(expected));
  });
}
