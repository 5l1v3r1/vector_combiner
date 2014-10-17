part of vector_combiner;

void drawVectorInContext(CanvasRenderingContext2D context, Vector2 start,
                        Vector2 end, num arrowSize, String style) {
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
