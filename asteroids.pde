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

Background background;

void setup () {
  size (900, 750, P2D);
  
  currentTime = millis();
  previousTime = millis();
  
  background = new Background("imgPlanete.png");

  particles = new ArrayList<Particle>();
  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)), int(random(3,15)), randomSize, 0, true);
    m.couleurFond = color (random (0, 255), random (0, 255), random (0, 255));
    m.angleRotation = TWO_PI / 360 * random(-10, 10);
    m.alpha = int(random (25, 255));
    flock.add(m);
    m.life = 2;
  }

  spaceShip = new Mover(new PVector ((width/2), (700)), new PVector(0,0), 6, 40, 0, true);
  spaceShip.couleurFond = color(255);
  spaceShip.alpha = int (200);
  println("Fire with A, W or D");
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
  background.update(delta);
  Iterator<Mover> flockAsteroidIterator = flock.iterator();
  while(flockAsteroidIterator.hasNext()){
    Mover m = flockAsteroidIterator.next();
    m.flock(flock);
    m.update(delta);

    Iterator<Mover> it = bullets.iterator();

    while(it.hasNext()){
      Mover b = it.next();
      if (m.IsColliding(b)){
        addParticules(3, b);
        println("POW!");
        it.remove();
        m.life--; 
        if(m.life <= 0){
          addParticules(50, m);
          flockAsteroidIterator.remove();
          println("KAPOW!");
        }      
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

  void addParticules(int nbrParticules, Mover b){
    for(int i=0; i< nbrParticules;i++){
      particles.add(new Particle(new PVector (b.location.x, b.location.y)));
    }
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
  background.display();
  
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
    bullets.add(new Mover(new PVector ((width/2), (660)), new PVector(0,-500), 20, 10, 0, true));
  if(key == 'd')
    bullets.add(new Mover(new PVector ((width/2), (660)), new PVector(500,-250), 20, 10, 0, true));
  if(key == 'a')
    bullets.add(new Mover(new PVector ((width/2), (660)), new PVector(-500,-250), 20, 10, 0, true));
}
