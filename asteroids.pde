int currentTime;
int previousTime;
int deltaTime;
int randomSize = int(map(abs(randomGaussian() + 2 + 15), -1,1, -2,2));

ArrayList<Mover> flock; // les astéroids
int flockSize = 10;

void setup () {
  size (900, 700);
  currentTime = millis();
  previousTime = millis();
  
  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)), int(random(1,15)), randomSize, 0);
    m.couleurFond = color (random (0, 255), random (0, 255), random (0, 255));
    m.angleRotation = TWO_PI / 360 * random(-10, 10);
    m.alpha = int(random (25, 255));
    flock.add(m);
  }
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
}
