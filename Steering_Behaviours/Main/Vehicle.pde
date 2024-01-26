

// The "Vehicle" class

class Vehicle {
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float u;           //Treshold for reducing velocity while aproching the target
  
  Vehicle(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(1,-2);
    position = new PVector(x,y);
    r = 6;
    maxspeed = 8;
    maxforce = 2.6;
    u = 10;
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

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    
    println("Entro a seek");
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    
    // Scale to maximum speed
    desired.setMag(maxspeed);

    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    applyForce(steer);
  }
  
  // Arrive
  void arrive(PVector target) {
    PVector desired = PVector.sub(target,position);  // A vector pointing from the position to the target
    float sigma;
    if(desired.mag() <= u){
      sigma = desired.mag()/u;
      desired.setMag(sigma);
    }else{
      // Scale to maximum speed
      desired.setMag(maxspeed);
    }

    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    applyForce(steer);
  }
  
  
  //FLEE
  void flee(PVector target){
  
    PVector desired = PVector.sub(position,target);  // A vector pointing from the position to the target
    
    // Scale to maximum speed
    desired.setMag(maxspeed);

    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    applyForce(steer);
  }
  
  //BORDER
  void borders(){
    
    draw_borders();
    
    PVector desired = velocity.copy();
    
    if(position.x < 50)
    {
      desired = new PVector(maxspeed, velocity.y);
      desired.setMag(maxspeed);
      // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired,velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      applyForce(steer);
      
    }else if(position.x > width -50){
      
      desired.set(-maxspeed, velocity.y);  
      desired.setMag(maxspeed);
      // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired,velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      applyForce(steer);
    }
    else if(position.y < 50){
      desired.set(velocity.x, maxspeed);
      desired.setMag(maxspeed);
      // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired,velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      applyForce(steer);
      
    }else if(position.y > height -50){
      desired.set(velocity.x, -maxspeed);
      desired.setMag(maxspeed);
      // Steering = Desired minus velocity
      PVector steer = PVector.sub(desired,velocity);
      steer.limit(maxforce);  // Limit to maximum steering force
      applyForce(steer);
   }
    
  }
  
  
  void flock(Vehicle[] boids)
  {
    PVector sep = separate(boids); // separación
    PVector ali = align(boids);    // alineamiento
    
    // darle un peso arbitrario a las fuerzas
    sep.mult(2.5);
    ali.mult(1.0);
    
    // añade los vectores de fuerza a la aceleración
    applyForce(sep);
    applyForce(ali);
  }
  
  PVector separate(Vehicle[] boids) {
    
    float desiredseparation = 25.0;
    PVector steer = new PVector(0, 0);
    int count = 0;
    // por cada boid en el sistema, revisar si está muy cerca
    for (int i = 0; i < boids.length; i++) {
      float d = PVector.dist(this.position, boids[i].position);
      // si la distancia es mayor a 0 y menor que un tamaño arbitrario (0 cuando es sí mismo)
      if ((d > 0) && (d < desiredseparation)) {
        // calcular vector apuntando para alejarse del vecino
        PVector diff = PVector.sub(this.position, boids[i].position);
        diff.normalize();
        diff.div(d); // peso según distancia
        steer.add(diff);
        count++; // contar cuántos
      }
    }
    // promedio -- dividir por la cantidad
    if (count > 0) {
      steer.div(count);
    }

    // mientas el vector sea mayor que 0
    if (steer.mag() > 0) {
      // implementar Reynolds: viraje = deseado - velocidad
      steer.normalize();
      steer.mult(this.maxspeed);
      steer.sub(this.velocity);
      steer.limit(this.maxforce);
    }
    return steer;
  }

  // alineamiento
  // por cada boid cercano en el sistema, calcular la velocidad promedio
  PVector align(Vehicle[] boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (int i = 0; i < boids.length; i++) {
      float d = PVector.dist(this.position, boids[i].position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(boids[i].velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(this.maxspeed);
      PVector steer = PVector.sub(sum, this.velocity);
      steer.limit(this.maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }
  
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    PVector ap = PVector.sub(p, a); //PVector that points from a to p
    PVector ab = PVector.sub(b, a); //PVector that points from a to b
    ab.normalize(); //Using the dot product for scalar projection
    ab.mult(ap.dot(ab));
    //Finding the normal point along the line segment
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }

  void path_following(Path p) {
    PVector predict = PVector.mult(velocity, dt);
    predict.normalize();
    predict.mult(maxspeed);
    PVector predictLoc = PVector.add(position, predict);

    PVector normalPoint = getNormalPoint(predictLoc, p.start, p.end);

    PVector dir = PVector.sub(p.end, p.start);
    dir.normalize();
    dir.mult(10);
    PVector target = PVector.add(normalPoint, dir);

    float distance = PVector.dist(normalPoint, predictLoc);
    if (distance > p.radius) {
      seek(target);
    }

    stroke(0);
    fill(0);
    line(position.x, position.y, predictLoc.x, predictLoc.y);
    ellipse(predictLoc.x, predictLoc.y, 4, 4);

    stroke(0);
    fill(0);
    ellipse(normalPoint.x, normalPoint.y, 4, 4);
    line(predictLoc.x, predictLoc.y, normalPoint.x, normalPoint.y);
  }
  
  void multiple_path_following(Multiple_Path mp) {
  Path path;
  float worldRecord = 100000;
  PVector target = new PVector(0.0, 0.0);

  for (int i = 0; i < mp.paths.size(); i++) {
    path = mp.paths.get(i);

    PVector predict = PVector.mult(velocity, dt);
    predict.normalize();
    predict.mult(maxspeed);
    PVector predictLoc = PVector.add(position, predict);

    PVector a = path.start;
    PVector b = path.end;

    PVector normalPoint = getNormalPoint(predictLoc, a, b);

    if (normalPoint.x < a.x || normalPoint.x > b.x) {
      normalPoint = b.copy();
    }

    float distance = PVector.dist(predictLoc, normalPoint);

    if (distance < worldRecord) {
      worldRecord = distance;
      target = normalPoint.copy();
    }

    if (distance > path.radius) {
      seek(target);
    }

    // Visualización
    stroke(0);
    fill(0);
    line(position.x, position.y, predictLoc.x, predictLoc.y);
    ellipse(predictLoc.x, predictLoc.y, 4, 4);

    // Dibujar la posición normal
    stroke(0);
    fill(0);
    ellipse(normalPoint.x, normalPoint.y, 4, 4);
    // Dibujar el objetivo real (rojo si se dirige hacia él)
    line(predictLoc.x, predictLoc.y, normalPoint.x, normalPoint.y);
  }
}


   
    void wraparound() {
      if (position.x < -r) position.x = width+r;
      if (position.y < -r) position.y = height+r;
      if (position.x > width+r) position.x = -r;
      if (position.y > height+r) position.y = -r;
    }
  
    
  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(127);
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
