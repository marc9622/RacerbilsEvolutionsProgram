class Car {  
  final float maxTurnAngle = 0.3;
  final float maxVelChange = 0.3;
  final float minVel = 1;
  final float maxVel = 20;
  
  PVector pos = new PVector(60, 232);
  PVector vel;
  
  Car() {
    this.vel = new PVector(0, 5);
  }
  
  void turnCar(float turnAngle){
    turnAngle = turnAngle > maxTurnAngle
                ? maxTurnAngle
                : turnAngle < -maxTurnAngle
                  ? -maxTurnAngle
                  : turnAngle;
    vel.rotate(turnAngle);
  }
  
  void changeVel(float velChange) {
    velChange = velChange > maxTurnAngle
                ? maxTurnAngle
                : velChange < -maxTurnAngle
                  ? -maxTurnAngle
                  : velChange;
    vel.add(PVector.mult(vel, velChange));
    vel.limit(maxVel);
    if(vel.magSq() < pow(minVel, 2))
      vel.normalize().mult(minVel);
  }
  
  void display() {
    fill(255, 150, 50, 150);
    displayCar();
  }

  void display(int index) {
    //stroke(100);
    index = index > 50 ? 50 : index;
    fill(150, 255, 50, 255 - index);
    displayCar();
  }
  
  void displayCar() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading() - PI/2);
    triangle( 0,  5,
              3, -5,
             -3, -5);
    popMatrix();
  }
  
  void update() {
    pos.add(vel);
  }
  
}
