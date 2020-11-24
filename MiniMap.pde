class MiniMap {

ArrayList<Mover> flock;
ArrayList<Mover> movers;
int w, h;

    MiniMap(){
        movers = new ArrayList<Mover>();
        w = width/10;
        h = height/10;
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
            rect(0, 0, w, h);
            for(Mover f : flock){
                point(f.location.x/10, f.location.y/10);
            }
        popMatrix();
    }
}