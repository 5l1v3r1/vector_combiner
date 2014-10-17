library vector_combiner;

import 'package:vector_math/vector_math.dart';
import 'package:crystal/crystal.dart';
import 'dart:html';

part 'vector_graph.dart';

Vector2 getInputVector(int idx) {
  try {
    var values = ['x', 'y'].map((axis) {
      var input = querySelector('#v$idx-$axis');
      return double.parse(input.value);
    });
    return new Vector2(values.first, values.last);
  } catch (_) {
    return null;
  }
}

Vector2 get vector1 => getInputVector(1);
Vector2 get vector2 => getInputVector(2);
Vector2 get vector3 => getInputVector(3);
VectorGraph graph;

void main() {
  var canvas = querySelector('#graph');
  graph = new VectorGraph(canvas)..draw();
  for (var i = 1; i <= 3; ++i) {
    for (var axis in ['x', 'y']) {
      var input = querySelector('#v$i-$axis');
      input.onChange.listen((_) => graph.draw());
    }
  }
  
  initControlButtons();
}

void initControlButtons() {
  querySelector('#clear-point-button').onClick.listen((_) {
    for (var axis in ['x', 'y']) {
      var input = querySelector('#v3-$axis');
      input.value = '';
    }
    graph.draw();
  });
  querySelector('#zoom-out-button').onClick.listen((_) {
    graph.visibleUnits += 2;
    if (graph.visibleUnits > 21) {
      graph.visibleUnits = 21;
    }
    graph.draw();
  });
  querySelector('#zoom-in-button').onClick.listen((_) {
    graph.visibleUnits -= 2;
    if (graph.visibleUnits < 3) {
      graph.visibleUnits = 3;
    }
    graph.draw();
  });
}
