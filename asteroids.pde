import java.util.Iterator;

int currentTime;
int previousTime;
int deltaTime;
int direction;
int randomSize;
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
  
  //background = new Background("imgPlanete.png");

  particles = new ArrayList<Particle>();
  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    randomSize = int(map(abs(randomGaussian() * 2 + 15), -1,1, -2,2));
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)), int(random(3,15)), randomSize, 0, true);
    m.couleurFond = color (random (0, 255), random (0, 255), random (0, 255));
    m.angleRotation = TWO_PI / 360 * random(-10, 10);
    m.alpha = int(random (25, 255));
    flock.add(m);
    m.life = randomSize/10;
  }

  spaceShip = new Mover(new PVector ((width/2), (700)), new PVector(0,0), 6, 40, 0, true);
  spaceShip.couleurFond = color(255);
  spaceShip.alpha = int (200);
  spaceShip.life = 5;
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
  //background.update(delta);
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
    if(m.IsColliding(spaceShip)){
      addParticules(5,spaceShip);
      spaceShip.life --;
      flockAsteroidIterator.remove();
      println("AYOYE!");
      if(spaceShip.life <= 0){
        println("KAPOW PIF PAF BOOM!");
        println("------------------GAME OVER------------------");
      }
    }
  }

if(keyPressed == true){
  if(keyCode == LEFT)
    spaceShip.location.x -= 1;
  if(keyCode == RIGHT)
    spaceShip.location.x += 1;
  if(keyCode == UP)
    spaceShip.location.y -= 1;
  if(keyCode == DOWN)
    spaceShip.location.y += 1;
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
    fire(spaceShip);
    fired = true;
  }
  if(key == 'r'){
    setup();
  }
}
/***

  The rendering should go here
*/
void display () {
  //background.display();
  
  for (Mover m : flock) {
    m.display();
  }
  if(spaceShip.life > 0)
    spaceShip.display();
  if(fired){
    for(Mover b : bullets)
      b.display();
  }

   for(Particle p : particles) 
    p.display();
}

void fire(Mover vaisseau){
  if(key == 'w')
    bullets.add(new Mover(new PVector ((vaisseau.location.x), (vaisseau.location.y)), new PVector(0,-500), 20, 10, 0, true));
  if(key == 'd')
    bullets.add(new Mover(new PVector ((vaisseau.location.x), (vaisseau.location.y)), new PVector(500,-250), 20, 10, 0, true));
  if(key == 'a')
    bullets.add(new Mover(new PVector ((vaisseau.location.x), (vaisseau.location.y)), new PVector(-500,-250), 20, 10, 0, true));
  if(key == 's')
    bullets.add(new Mover(new PVector ((vaisseau.location.x), (vaisseau.location.y)), new PVector(0,500), 20, 10, 0, true));
}
