import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:rankers_institute/globals.dart' as g;

class MLHelper {
  final dataFrame = DataFrame(<Iterable>[
    ['doubt', 'test_total', 'category'],
    [0, 0, 1],
    [1, 100, 2],
    [5, 90, 3],
    [9, 89, 4],
    [10, 20, 2],
    [3, 66, 3],
    [6, 48, 3],
    [2, 50, 2],
    [7, 50, 3],
    [8, 20, 2],
    [9, 20, 2],
    [5, 100, 4],
    [5, 100, 4],
    [0, 20, 1],
    [1, 66, 2],
    [5, 83, 3],
    [9, 83, 4],
    [10, 48, 3],
    [3, 89, 2],
    [6, 10, 2],
    [2, 10, 1],
    [7, 23, 2],
    [8, 32, 2],
    [9, 44, 3],
    [5, 50, 3],
    [5, 100, 3],
    [0, 100, 3],
    [1, 99, 3],
    [1, 20, 1],
    [5, 30, 2],
    [9, 80, 4]
  ], headerExists: true);

  void train() {
    g.model = KnnClassifier(dataFrame, 'category', 3);
  }

  int studentSide(List input) {
    var c = g.model
        .predict(DataFrame(<Iterable>[
          ['doubt', 'test_total'],
          input,
        ], headerExists: true))
        .rows
        .toList();
    return c[0].toList()[0].round();
  }
}
