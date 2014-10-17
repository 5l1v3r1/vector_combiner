part of vector_combiner;

class VectorPreview extends ScalableCanvas {
  final int index;
  num arrowSize = 10;
  String style;
  
  VectorPreview(int index, this.style)
      : index = index,
        super(querySelector('#v$index-preview'));
  
  void draw() {
    var context = canvas.getContext('2d');
    
    context.clearRect(0, 0, canvasWidth, canvasHeight);
    
    var vector = getInputVector(index);
    var center = new Vector2(canvasWidth / 2, canvasHeight / 2);
    if (vector == null || vector.length < 0.0001) {
      context..fillStyle = style
             ..beginPath()
             ..arc(center.x, center.y, canvasWidth / 6, 0, PI * 2)
             ..fill()
             ..closePath();
    } else {
      vector.y *= -1;
      var scaled = vector.normalize().scale((canvasWidth - 5).toDouble());
      var start = center - (scaled / 2.0);
      var end = center + (scaled / 2.0);
      drawVectorInContext(context, start, end, arrowSize, style);
    }
  }
}