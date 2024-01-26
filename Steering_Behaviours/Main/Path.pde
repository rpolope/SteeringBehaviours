
class Path{
  
  PVector start; //A Path is only two points, start and end.
  PVector end;
  float radius;
  int _id;
  Path(float startx,float starty, float endx, float endy, int id){
    radius = 20;
    start = new PVector(startx,starty);
    end = new PVector(endx,endy);
    _id = id;
  }
  
  void display() { // Display the path.
    strokeWeight(radius*2);
    stroke(0,100);
    line(start.x,start.y,end.x,end.y);
    strokeWeight(1);
    stroke(0);
    line(start.x,start.y,end.x,end.y);
  }
}
