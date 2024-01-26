
class Prey{
  
  private PVector position;
  private PVector velocity;
  private PVector acceleration;
  private float maxforce;    // Maximum steering force
  private float maxspeed;    // Maximum speed
  private float r;
  private Vehicle[] boids;
  
  Prey(Vehicle[] boids){
    //position = new PVector(random(600),random(600));
    position = new PVector(300,300);
    velocity = new PVector(1,1);
    acceleration = new PVector(0,0);
    maxspeed = 12;
    maxforce = .6;
    r = 6;
    this.boids = boids;
  }
  
  // Method to update position
  void update() {
    // Update velocity
    velocity.add(PVector.mult(acceleration, dt));
    // Limit speed
    velocity.limit(maxspeed);
    position.add(PVector.mult(velocity, dt));
    
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
    
    wraparound();
  }
  
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }
  
  // un método que aplica y calcula una fuera de viraje a un objetivo
  // viraje = deseado - velocidad
  PVector flee(PVector target) {
    PVector desired = PVector.sub(position, target); // un vector apuntanto desde la ubicación y hacia el objetivo
    // normalizar deseado y escalar a velocidad máxima
    desired.normalize();
    desired.mult(this.maxspeed);
    // viraje = deseado menos velocidad
    PVector steer = PVector.sub(desired, this.velocity);
    steer.limit(this.maxforce); // limitar a la fuerza máxima de viraje
    return steer;
  }
  
  //FLEE
  void cohesion(){
  
    float neighbordist = 50;
    PVector sum = new PVector(0, 0); // empezar con un vector vacío para acumular todas las ubicaciones
    int count = 0;
    for (int i = 0; i < boids.length; i++) {
      float d = PVector.dist(this.position, boids[i].position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(boids[i].position); // Agregar ubicación
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      applyForce(flee(sum)); // Virar hacia la ubicación
    } else {
      applyForce(new PVector(0, 0));
    }
  }
  
  PVector getPosition(){
    return position.copy();
  }
  
  // Wraparound
    void wraparound() {
      if (position.x < -r) position.x = width+r;
      if (position.y < -r) position.y = height+r;
      if (position.x > width+r) position.x = -r;
      if (position.y > height+r) position.y = -r;
    }
  
  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(255,0,0);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }

}
