class Background {
    PImage background;
    float scale = 0.1;
    PVector position;
    PVector velocity;
    boolean isParallax = false;

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
        position.x = position.x % width;
    }

    void display() {
        image (background, position.x, position.y, background.width, background.height);
        if (isParallax) {
            if(position.x < 0){
                image(background, position.x + background.width, position.y, background.width * scale, background.height * scale);
            }
            else if((position.x + background.width) > width)
                image(background, position.x - background.width, position.y, background.width*scale, background.height*scale);
        }
    }


}