class Background {
    PImage background;
    float scale = 0.33;
    PVector position;
    PVector velocity;

    Background (String imgPath){
        background = loadImage(imgPath);
        initValues();
    }

    private void initValues() {
        position = new PVector();
        velocity = new PVector();
    }

    void update(int deltaTime) {
        position.add(velocity);
    }

    void display() {
        image(background, position.x, position.y, background.width * scale, background.height * scale);
    }
}