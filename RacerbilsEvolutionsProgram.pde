PImage trackImage;
int populationSize = 10000;
int framesPerGeneration = 1000;
CarSystem carSystem = new CarSystem();
static PApplet p;

void setup() {
  size(500, 600);
  trackImage = loadImage("track.png");
  p = this;
  noStroke();
  frameRate(60);
}

void draw() {
  clear();
  fill(255);
  rect(0,50,1000,1000);
  image(trackImage,0,80);  

  carSystem.updateAndDisplay();
  
  if (frameCount%100 == 0)
    carSystem.CarControllerList.removeIf(c -> c.sensorSystem.whiteSensorFrameCount > 0 || c.sensorSystem.clockWiseRotationFrameCounter < -10);
  
  if(carSystem.bestTime() < 500 && carSystem.CarControllerList.size() > 1000)
    for(int i = 0; i < 100; i++)
      carSystem.CarControllerList.remove(carSystem.CarControllerList.size() - 1);
  
  if (frameCount%framesPerGeneration == 0)
    carSystem.advanceGeneration();
      
  fill(0);
  text("Best time: " + carSystem.bestTime() +
       "\nGeneration: " + carSystem.generation +
       "\nFrames: " + frameCount%framesPerGeneration +
       "\nFramerate: " + (int)frameRate,
       10, height - 50);
}

static float randomFloat(float min, float max) {
  return p.random(min, max);
}
