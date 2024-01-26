static float dt = 0.2;
static int N = 20;
Vehicle[] boids;
Vehicle v;
Prey p;
Path path;
Multiple_Path mult_path;
PVector mouse;

enum MODE{
  SEEK,
  FLEE,
  SEEK_ARRIVE,
  MULTIPLE_PREDATOR,
  BORDERS,
  PATH_FOLLOWING,
  MULTIPLE_PATH_FOLLOWING
};

MODE mode;

void setup(){
  size(600,600);
  mode = MODE.MULTIPLE_PATH_FOLLOWING;
  mouse = new PVector(mouseX, mouseY);
  path = new Path(0,height/3,width,2*height/3, 1);
  mult_path = new Multiple_Path();
  
  switch(mode)
  {
    case MULTIPLE_PREDATOR:
      boids = new Vehicle[N];
      p = new Prey(boids);
      for(int i = 0; i < N; i++){
          boids[i] = new Vehicle(random(600),random(600));
      }
     break;
     case PATH_FOLLOWING:
       v = new Vehicle(random(600), random(600));
     break;
     case MULTIPLE_PATH_FOLLOWING:
        println("Inicio en multiple path");
        mult_path.clear();
        v = new Vehicle(50.0,height*0.1);
        createMultiplePath();
      
     break;
     default:
       v = new Vehicle(random(600), random(600));
      break;
  }
  
}

void draw(){
  
  background(100);
  
  switch(mode)
  {
    case SEEK:
      mouse.set(mouseX, mouseY);
      v.display();
      v.update();
      v.seek(mouse);
    break;
    
    case SEEK_ARRIVE:
      mouse.set(mouseX, mouseY);
      v.display();
      v.update();
      v.arrive(mouse);
    break;
    
    case FLEE:
      mouse.set(mouseX, mouseY);
      v.display();
      v.update();
      v.flee(mouse);
    break;
    
    case MULTIPLE_PREDATOR:
      p.display();
      p.update();
      
      for(int i = 0; i<N; i++){
        boids[i].display();
        boids[i].update();
        boids[i].seek(p.position);
        boids[i].flock(boids);
        
        p.cohesion();
      }
    break;
    
    case BORDERS:
      v.display();
      v.update();
      v.borders();
    break;
    
    case PATH_FOLLOWING:
    
      path.display();
      v.path_following(path);
      v.update();
      v.display();
     break;
     
     case MULTIPLE_PATH_FOLLOWING:
      mult_path.display();
      v.update();
      v.multiple_path_following(mult_path);
      v.display();
    break;
  }
  
}

void draw_borders(){
  line(50,50,width-50, 50);
  line(width-50, 50,width-50, height-50);
  line(width-50, height-50,50, height-50);
  line(50, height-50,50,50);
}

void createMultiplePath() {
  float pathLength = 150.0; // Longitud deseada para todos los caminos
  mult_path.addPath(50.0, height * 0.1, 50.0 + pathLength, height / 3.0);
  v.position.set(50.0, height * 0.1);

  for (int i = 1; i < 3; i++) {
    PVector prevPathPos = new PVector(mult_path.paths.get(i - 1).end.x, mult_path.paths.get(i - 1).end.y);
    float angle = random(TWO_PI); // Ángulo aleatorio
    float dx = cos(angle) * pathLength;
    float dy = sin(angle) * pathLength;
    mult_path.addPath(prevPathPos.x, prevPathPos.y, prevPathPos.x + dx, prevPathPos.y + dy);
  }
}

void keyPressed(){

  switch(keyCode)
  {
    case '1':
      println("Cambio a modo seek");
      mode = MODE.SEEK;
    break;
    case '2':
      println("Cambio a modo arrive");
      mode = MODE.SEEK_ARRIVE;
    break;
    case '3':
      mode = MODE.FLEE;
    break;
    case '4':
      println("Cambio a modo borders");
      mode = MODE.BORDERS;
    break;
    case '5':
      println("Cambio a modo borders");
      mode = MODE.MULTIPLE_PREDATOR;
      
      boids = new Vehicle[N];
      p = new Prey(boids);
      for(int i = 0; i < N; i++){
          boids[i] = new Vehicle(random(600),random(600));
      }
    break;
    case '6':
      mode = MODE.PATH_FOLLOWING;
    break;
    case '7':
      mode = MODE.MULTIPLE_PATH_FOLLOWING;
      createMultiplePath();
     
    break;
  }
}
