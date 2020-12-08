import java.util.Iterator;
import processing.sound.*;

int currentTime;
int previousTime;
int deltaTime;
int direction;
int randomSize;
int vitesseDeplacement = 2;
boolean fired = false;
boolean showMiniMap = true;
boolean showControls = false;
Mover spaceShip;
ArrayList<Mover> bullets = new ArrayList<Mover>();
ArrayList<Mover> flock; // les astéroids
int flockSize = 25;
ArrayList<Particle> particles;
PFont spaceShipLifeBar;
PFont controllers;
PFont controls;
SoundFile itemDestroyed;
SoundFile targetHit;

ArrayList<Background> background;

void setup () {
  size (1000, 850, P2D);
  loadBackgroundLayers();
  spaceShipLifeBar = createFont("Verdana", 18, true);
  controllers = createFont("Verdana", 18, true);
  controls = createFont("Verdana", 18, true);

  currentTime = millis();
  previousTime = millis();

  itemDestroyed = new SoundFile(this, "destroyed.aiff");
  targetHit = new SoundFile(this, "targetHit.aiff");

  particles = new ArrayList<Particle>();
  flock = new ArrayList<Mover>();
  
  for (int i = 0; i < flockSize; i++) {
    randomSize = int(map(abs(randomGaussian() * 2 + 15), -1,1, -2,2));
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-5, 5), random(-5, 5)), int(random(3,15)), randomSize, 0, true); //Les astéroïdes sont Collidable
    m.couleurFond = color (random (0, 255), random (0, 255), random (0, 255));
    m.angleRotation = TWO_PI / 360 * random(-10, 10);
    m.alpha = int(random (25, 255));
    flock.add(m);
    m.life = randomSize/10; //Vie de chaque astéroïdes en fonction de sa taille (entre 1 et 3)

  }

  spaceShip = new Mover(new PVector ((width/2), (800)), new PVector(0,0), 6, 40, 0, true);
  spaceShip.couleurFond = color(255);
  spaceShip.alpha = int (200);
  spaceShip.life = 5;
}

void loadBackgroundLayers() { //Implémentation du parallax
    background = new ArrayList<Background>();
    background.add(new Background("imgPlanete.png"));
    background.add(new Background("stars.png"));

    float speedIncrement = 0.5;
    float currentSpeed = 1;

      for (int i = 0; i < background.size(); i++) {
        Background current = background.get(i);
    
        if (i > 0) {      
          current.isParallax = true;
          current.velocity.x = currentSpeed;
          currentSpeed += speedIncrement;
        } 
    
    current.scale = 0.5;
  }
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime; 
  
  update(deltaTime);
  display();  
  textFont(spaceShipLifeBar, 24);
  fill(175,0,0);
  text("Vies: " + spaceShip.life, 25, 50);
  
  textFont(controllers, 24);
  fill(255);
  text("Appuyez sur ctrl pour afficher les contrôles " , width/3, 50);
}

/***
  The calculations should go here
*/
void update(int delta) {
 for (Background bg : background) {
    bg.update(delta);
}
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
        targetHit.play();
        it.remove();
        m.life--; 
        if(m.life <= 0){ //Si l'astéroïdes n'a plus de vie
          addParticules(50, m);
          flockAsteroidIterator.remove(); //destruction et on retire l'astéroïde du jeu
          println("KAPOW!");
          itemDestroyed.play();
        }      
      }
    }
    if(m.IsColliding(spaceShip)){
      addParticules(5,spaceShip);
      spaceShip.life --;
      flockAsteroidIterator.remove(); //destruction et on retire l'astéroïde du jeu
      println("AYOYE!");
      targetHit.play();
      if(spaceShip.life <= 0){ //Si le vaisseau n'a plus de vie
        println("KAPOW PIF PAF BOOM!");
        println("------------------GAME OVER------------------");
        itemDestroyed.play();
      }
    }
  }

if(keyPressed == true){
  if(keyCode == LEFT) //1 vitesse lente, difficulté plus élevé, 2 vitesse rapide
    spaceShip.location.x -= vitesseDeplacement;
  if(keyCode == RIGHT)
    spaceShip.location.x += vitesseDeplacement;
  if(keyCode == UP)
    spaceShip.location.y -= vitesseDeplacement;
  if(keyCode == DOWN)
    spaceShip.location.y += vitesseDeplacement;
}

  spaceShip.update(delta);
  
  if(fired){
    for(Mover b : bullets)
      b.update(delta);
  }
   for(Particle p : particles)
      p.update(delta);

}

  void addParticules(int nbrParticules, Mover b){ //Fonction qui ajoute les particules lors des impacts
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
    showControls = false;
    vitesseDeplacement = 2;
  }
  if(keyCode == CONTROL){
    if(showControls)
      showControls = false;
    else
      showControls = true;
  }
  if(key == '1')
    vitesseDeplacement = 1;
  if(key == '2')
    vitesseDeplacement = 2;

}
/***

  The rendering should go here
*/
void display () {
  for (Background bg : background) {
    bg.display();
  }  

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
  
  if(showControls){
    textFont(controls, 24);
    fill(255);
    text("Déplacement avec les flèches \n A,S,D,W pour tirer \n R pour redémarrer la partie \n 1 ou 2 pour changer la difficultée", width/2, height/2);
  }
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
