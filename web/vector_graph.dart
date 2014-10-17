part of vector_combiner;

class VectorGraph extends ScalableCanvas {
  num get arrowSize => pixelRatio * 10;
  
  num visibleUnits = 11;
  num get unitSize => canvasWidth / visibleUnits;
  CanvasRenderingContext2D context;
  
  String vector1Style = '#36F';
  String vector2Style = '#E22';
  
  VectorGraph(CanvasElement canvas) : super(canvas);
  
  Vector2 convertToCanvas(Vector2 point) {
    return new Vector2(canvasWidth / 2 + point.x * unitSize,
                       canvasHeight / 2 - point.y * unitSize);
  }
  
  void draw() {
    context = canvas.getContext('2d');
    
    context.clearRect(0, 0, canvasWidth, canvasHeight);
    
    drawGrid();
    drawAxes();
    
    if (vector1 == null || vector2 == null || vector3 == null) {
      drawRegularVectors();
    } else {
      drawSolutionVectors();
    }
  }
  
  void drawRegularVectors() {
    drawVector(vector2Style, new Vector2.zero(), vector2);
    drawVector(vector1Style, new Vector2.zero(), vector1);
  }
  
  void drawSolutionVectors() {
    var mat = new Matrix2.columns(vector1, vector2);
    if (mat.invert().abs() < 0.0001) {
      // TODO: figure out something to do here
      return;
    }
    var coefficients = mat.transform(vector3);
    var s1 = vector1 * coefficients.x;
    var s2 = vector2 * coefficients.y;
    drawVector(vector2Style, new Vector2.zero(), s2);
    drawVector(vector1Style, new Vector2.zero(), s1);
    var oldAlpha = context.globalAlpha;
    context.globalAlpha = oldAlpha / 2;
    drawVector(vector2Style, s1, s1 + s2);
    drawVector(vector1Style, s2, s2 + s1);
    context.globalAlpha = oldAlpha;
  }
  
  void drawGrid() {
    context..lineWidth = 1
           ..strokeStyle = '#AAA'
           ..beginPath();
    // Add vertical lines
    for (var i = 1; i <= (visibleUnits / 2).floor(); ++i) {
      var positiveX = 0.5 + ((canvasWidth / 2) + (i * unitSize)).floor();
      context..moveTo(positiveX, 0)
             ..lineTo(positiveX, canvasHeight);
      var negativeX = 0.5 + ((canvasWidth / 2) - (i * unitSize)).floor();
      context..moveTo(negativeX, 0)
             ..lineTo(negativeX, canvasHeight);
    }
    // Add horizontal lines
    var verticalCount = visibleUnits * (canvasHeight / canvasWidth);
    for (var i = 1; i <= (verticalCount / 2).floor(); ++i) {
      var positiveY = 0.5 + ((canvasHeight / 2) + (i * unitSize)).floor();
      context..moveTo(0, positiveY)
             ..lineTo(canvasWidth, positiveY);
      var negativeY = 0.5 + ((canvasHeight / 2) - (i * unitSize)).floor();
      context..moveTo(0, negativeY)
             ..lineTo(canvasWidth, negativeY);
    }
    context..stroke()
           ..closePath();
  }
  
  void drawAxes() {
    // Draw axis lines
    context..strokeStyle = '#555'
           ..lineWidth = 2
           ..beginPath()
           ..moveTo(canvasWidth / 2, arrowSize)
           ..lineTo(canvasWidth / 2, canvasHeight - arrowSize)
           ..moveTo(arrowSize, canvasHeight / 2)
           ..lineTo(canvasWidth - arrowSize, canvasHeight / 2)
           ..stroke()
           ..closePath();
    // Draw arrows at the ends of the lines
    var arrowWidth = arrowSize / 2;
    context..fillStyle = '#555'
           ..beginPath()
           ..moveTo(canvasWidth / 2, 0)
           ..lineTo(canvasWidth / 2 - arrowWidth, arrowSize)
           ..lineTo(canvasWidth / 2 + arrowWidth, arrowSize)
           ..moveTo(canvasWidth / 2, canvasHeight)
           ..lineTo(canvasWidth / 2 - arrowWidth, canvasHeight - arrowSize)
           ..lineTo(canvasWidth / 2 + arrowWidth, canvasHeight - arrowSize)
           ..moveTo(0, canvasHeight / 2)
           ..lineTo(arrowSize, canvasHeight / 2 - arrowWidth)
           ..lineTo(arrowSize, canvasHeight / 2 + arrowWidth)
           ..moveTo(canvasWidth, canvasHeight / 2)
           ..lineTo(canvasWidth - arrowSize, canvasHeight / 2 - arrowWidth)
           ..lineTo(canvasWidth - arrowSize, canvasHeight / 2 + arrowWidth)
           ..fill()
           ..closePath();
  }
  
  void drawVector(String style, Vector2 absStart, Vector2 absEnd) {
    if (absStart == null || absEnd == null) {
      return;
    }
    
    var start = convertToCanvas(absStart);
    var end = convertToCanvas(absEnd);
    var lineEnd;
    var hasArrow = false;
    if ((end - start).length < arrowSize) {
      lineEnd = end;
    } else {
      hasArrow = true;
      lineEnd = end - (end - start).normalize().scale(arrowSize.toDouble());
    }
    context..strokeStyle = style
           ..lineWidth = 4
           ..beginPath()
           ..moveTo(start.x, start.y)
           ..lineTo(lineEnd.x, lineEnd.y)
           ..stroke()
           ..closePath();
    if (hasArrow) {
      var normalized = (end - start).normalize();
      var arrowBase = new Vector2(normalized.y, -normalized.x);
      arrowBase.scale(arrowSize / 2);
      var point1 = lineEnd + arrowBase;
      var point2 = lineEnd - arrowBase;
      context..fillStyle = style
             ..beginPath()
             ..moveTo(end.x, end.y)
             ..lineTo(point1.x, point1.y)
             ..lineTo(point2.x, point2.y)
             ..fill()
             ..closePath();
    }
  }
}
