/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'dart:async';
import 'dart:isolate';

export 'src/isolates_isolateformatrixmultiplication_base.dart';

/*
Practice Question 2: Isolate for Matrix Multiplication

Task:

Write a function multiplyMatricesInIsolate that performs 
matrix multiplication of two 2D lists (matrices) 
in a separate isolate. 
The function should return a Future<List<List<int>>> representing the product matrix.
 */

multiplyMatricesInIsolate(
    List<List<int>> matrixOne, List<List<int>> matrixTwo) async {
    // Check if multiplication is possible
  if(matrixOne.isEmpty || matrixTwo.isEmpty) {
    print('Empty matrices given! Returning empty result');
    return [];
  } else if (matrixOne[0].length != matrixTwo.length) {
    print('Matrix dimensions do not allow multiplication.');
    return [];
  }

  final completer = Completer();
  ReceivePort receivedFromWorker = ReceivePort();
  final workerIsolate = await Isolate.spawn(twoDMatrixMultiplication,
      [receivedFromWorker.sendPort, matrixOne, matrixTwo]);

  receivedFromWorker.listen((message) {
    print('Message: $message');
    if (message is List) {
      completer.complete(message);
      receivedFromWorker.close();
      workerIsolate.kill();
    }
  }, onError: (Object error) {
    print(
        "Error thrown while handling matrix! Completing matrix multipication with empty List. Error: $error");
    completer.complete([]);
  }, cancelOnError: true);

  return completer.future;
}

/*
      [1, 2],
      [3, 4]

      [5, 6],
      [7, 8]

      [1 * 5 + 2 * 7, 1 * 6 + 2 * 8],
      [3 * 5 + 4 * 7, 3 * 6 + 4 * 8]

      [19, 22],
      [43, 50]
*/

void twoDMatrixMultiplication(List<Object> params) {
  int numRows = (params[1] as List).length;
  int numCols = (params[2] as List)[0].length;
  int sumLength =
      (params[2] as List).length; // or matrixOne[0].length, as they are equal

  // Initialize the result matrix with zeros
  List<List<int>> result = List.generate(
    numRows,
    (_) => List.generate(numCols, (_) => 0),
  );

  // Perform multiplication
  for (var i = 0; i < numRows; i++) {
    for (var j = 0; j < numCols; j++) {
      for (var k = 0; k < sumLength; k++) {
        result[i][j] +=
            (params[1] as List)[i][k] * (params[2] as List)[k][j] as int;
      }
    }
  }

  (params[0] as SendPort).send(result);
}
