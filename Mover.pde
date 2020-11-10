class Mover extends GraphicObject implements ICollidable{
  float topSpeed = 2;
  float topSteer = 0.03;  
  float theta = 0;
  float r = 10; // Rayon du boid 
  float radiusSeparation = 10 * r;
  float mass = 1.0; 
  float angle;
  float time = 0;  
  int nbCotes;
  int rayon;  
  color couleurBordure = color (200, 0, 0);
  color couleurFond = color (0, 200, 0);  
  float angleRotation = 0;
  int alpha = 255;
  int life;
  boolean isCollidable;
  
  Mover () {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }
  
   float getRadius() {
    return r;
  }

   boolean IsColliding(Mover other) {
    boolean result = false;
    
    float distance = PVector.dist(this.location, other.location);
    
    if ((this.getRadius() + other.getRadius())*2 >= distance) {
      result = true;
    }
    return result;
   }

  Mover (PVector loc, PVector vel, int _nbCotes, int _rayon, float _angle, boolean isCollidable) {
    this.nbCotes = _nbCotes;
    this.rayon = _rayon;
    this.angle = _angle;
    
    this.location = loc;
    this.velocity = vel;
    this.acceleration = new PVector (0 , 0);
    this.isCollidable = isCollidable;
  }
  
  void checkEdges() {
    if (location.x < 0) {
      location.x = width - r;
    } else if (location.x + r> width) {
      location.x = 0;
    }
    
    if (location.y < 0) {
      location.y = height - r;
    } else if (location.y + r> height) {
      location.y = 0;
    }
  }
  
  void flock (ArrayList<Mover> boids) {
    PVector separation = separate(boids);    
    applyForce(separation);
  }

  void update(float deltaTime) {
    //checkEdges();
    
    velocity.add (acceleration);
    velocity.limit(topSpeed);
    location.add (velocity);

    acceleration.mult (0);      
  }
  
  void display() {
    fill (color (red(couleurFond), green(couleurFond), blue(couleurFond), alpha));
    stroke (couleurBordure);
    
    theta = velocity.heading() + radians(90);
    
    pushMatrix();
    translate(location.x, location.y);
    rotate (theta);
    
    beginShape();
    
    float angleIncrement = TWO_PI / (float) nbCotes;
    for (float a = 0; a < TWO_PI; a += angleIncrement) {
      float sx = cos (a) * rayon;
      float sy = sin (a) * rayon;
      
      vertex (sx, sy);
    }
    
    endShape (CLOSE);
    
    popMatrix();  
  }
  
  PVector separate (ArrayList<Mover> boids) {
    PVector steer = new PVector(0, 0, 0);
    
    int count = 0;
    
    for (Mover other : boids) {
      float d = PVector.dist(location, other.location);
      
      if (d > 25 && d < radiusSeparation) {
        PVector diff = PVector.sub(location, other.location);
        
        diff.normalize(); // Ramène à une longueur de 1
        
        // Division par la distance pour pondérer.
        // Plus qu'il est loin, moins qu'il a d'effet
        diff.div(d); 
        
        // Force de braquage
        steer.add(diff);
        
        count++;
      }
    }
    
    if (count > 0) {
      steer.div(count);
    }
    
    if (steer.mag() > 0) {
      steer.setMag(topSpeed);
      steer.sub(velocity);
      steer.limit(topSteer);
    }
    
    return steer;
  }

  void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);    
  }
}