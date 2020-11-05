import java.util.Iterator;

int currentTime;
int previousTime;
int deltaTime;
int randomSize = int(map(abs(randomGaussian() * 2 + 15), -1,1, -2,2));
int direction;

boolean fired = false;
Mover spaceShip;
ArrayList<Mover> bullets = new ArrayList<Mover>();
ArrayList<Mover> flock; // les astéroids
int flockSize = 25;
ArrayList<Particle> particles;

void setup () {
  size (900, 700);
  currentTime = millis();
  previousTime = millis();
  
  particles = new ArrayList<Particle>();
  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)), int(random(3,15)), randomSize, 0);
    m.couleurFond = color (random (0, 255), random (0, 255), random (0, 255));
    m.angleRotation = TWO_PI / 360 * random(-10, 10);
    m.alpha = int(random (25, 255));
    flock.add(m);
    m.life = randomSize;
  }

  spaceShip = new Mover(new PVector ((width/2), (660)), new PVector(0,0), 6, 40, 0);
  spaceShip.couleurFond = color(255);
  spaceShip.alpha = int (200);
  print("Fire with A, W or D");
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  display();  
}

/***
  The calculations should go here
*/
void update(int delta) {
  
  for (Mover m : flock) {
    m.flock(flock);
    m.update(delta);
    Iterator<Mover> it = bullets.iterator();
    while(it.hasNext()){
      Mover b = it.next();
      if (m.isColliding(b)){
        for(int i=0; i<2;i++){
          particles.add(new Particle(new PVector (b.location.x, b.location.y)));
        }
        print("Target hit");
        it.remove();
        b.alpha = 0;
        b.couleurBordure = 0;
      }
    }
  }
  spaceShip.update(delta);
  if(fired){
    for(Mover b : bullets)
      b.update(delta);
  }
   for(Particle p : particles)
      p.update(delta);
}

void keyPressed() {
  if(key == 'a' || key == 's'|| key == 'd' || key == 'w'){
    fire();
    fired = true;
  }
}
/***

  The rendering should go here
*/
void display () {
  background(0);
  
  for (Mover m : flock) {
    m.display();
  }
  spaceShip.display();
  if(fired){
    for(Mover b : bullets)
      b.display();
  }

   for(Particle p : particles) 
    p.display();
}

void fire(){
  if(key == 'w')
    bullets.add(new Mover(new PVector ((width/2), (660)), new PVector(0,-500), 20, 10, 0));
  if(key == 'd')
    bullets.add(new Mover(new PVector ((width/2), (660)), new PVector(500,-250), 20, 10, 0));
  if(key == 'a')
    bullets.add(new Mover(new PVector ((width/2), (660)), new PVector(-500,-250), 20, 10, 0));
}
