library vector_combiner;

import 'package:vector_math/vector_math.dart';
import 'package:crystal/crystal.dart';
import 'dart:html';
import 'dart:math';

part 'vector_graph.dart';
part 'draw_vector.dart';
part 'vector_preview.dart';

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
VectorPreview preview1;
VectorPreview preview2;

void main() {
  graph = new VectorGraph(querySelector('#graph'));
  preview1 = new VectorPreview(1, graph.vector1Style);
  preview2 = new VectorPreview(2, graph.vector2Style);
  
  redraw();
  
  for (var i = 1; i <= 3; ++i) {
    for (var axis in ['x', 'y']) {
      var input = querySelector('#v$i-$axis');
      input.onChange.listen((_) => redraw());
    }
  }
  
  initControlButtons();
  initDrag();
}

void initControlButtons() {
  querySelector('#clear-point-button').onClick.listen((_) {
    for (var axis in ['x', 'y']) {
      var input = querySelector('#v3-$axis');
      input.value = '';
    }
    redraw();
  });
  querySelector('#zoom-out-button').onClick.listen((_) {
    graph.visibleUnits = min(21, graph.visibleUnits + 2);
    redraw();
  });
  querySelector('#zoom-in-button').onClick.listen((_) {
    graph.visibleUnits = max(3, graph.visibleUnits - 2);
    redraw();
  });
}

void initDrag() {
  if (TouchEvent.supported) {
    graph.canvas.onTouchMove.listen((TouchEvent evt) {
      if (evt.touches.length != 1) {
        return;
      }
      evt.preventDefault();
      var touch = evt.touches.first;
      var point = touch.page - graph.canvas.offset.topLeft;
      userSelectedPoint(point * graph.pixelRatio);
    });
  } else {
    bool dragging = false;
    graph.canvas.onMouseDown.listen((_) {
      dragging = true;
    });
    graph.canvas.onMouseUp.listen((_) {
      dragging = false;
    });
    graph.canvas.onMouseOut.listen((_) {
      dragging = false;
    });
    graph.canvas.onMouseMove.listen((MouseEvent evt) {
      if (dragging) {
        userSelectedPoint(evt.offset * graph.pixelRatio);
      }
    });
  }
}

void redraw() {
  preview1.draw();
  preview2.draw();
  graph.draw();
}

void userSelectedPoint(Point p) {
  Vector2 vector = new Vector2(p.x.toDouble(), p.y.toDouble());
  Vector2 point = graph.convertFromCanvas(vector);
  (querySelector('#v3-x') as InputElement).value = '${point.x}';
  (querySelector('#v3-y') as InputElement).value = '${point.y}';
  redraw();
}
