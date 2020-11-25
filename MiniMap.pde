class MiniMap {

ArrayList<Mover> flock;
ArrayList<Mover> movers;
int w, h;

    MiniMap(){
        movers = new ArrayList<Mover>();
        w = width/5;
        h = height/7;
        background(0);
    }

    public void update(int delta){
        
    }

    public void setObjects(ArrayList<Mover> flock) {
        this.flock = flock;
    }

    public void addObject(Mover m) {
        movers.add(m);
    }

    public void display(){
        pushMatrix();
            rect(700, 625, w, h);
            for(Mover f : flock){
                point(f.location.x/5, f.location.y/7);
            }
        popMatrix();
    }
}