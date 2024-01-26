
class Multiple_Path{

  ArrayList<Path> paths;
  Multiple_Path() {
    paths = new ArrayList<Path>();
  }
  
  //This function allows us to add points to the path.
  void addPath(float x1, float y1, float x2, float y2) { 
    Path path = new Path(x1,y1,x2,y2,paths.size() + 1 );
    paths.add(path);
  }
  
  void clear()
  {
    paths.clear();
  }
  
  //Display the path as a series of points.
  void display() { 
        
    for (Path p : paths) {
      p.display();
    }
  }
}
