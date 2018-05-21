class Star {
  float x;
  float y;
  float z;
  float pz;
  float hu = 0;
  

  Star() {
    x = random(-width/2, width/2);
    y = random(-height/2, height/2);
    z = random(width/2);
    pz = z;
  }

  void update() {

    z = z - speed;

    if (z < -250) {
      z = width/2;
      x = random(-width/2, width/2);
      y = random(-height/2, height/2);
      pz = z;
    }
  }

  void show() {
    //strokeWeight(speed/10);
    
    hu += 0.2;
    if (hu > 255) {
      hu = 0;
    }

    fill(hu, 255, 255);
    float sx = map(x / z, 0, 1, 0, width/2);
    float sy = map(y / z, 0, 1, 0, height/2);;
    float r = map(z, 0, width/2, 16, 0);
    //ellipse(sx, sy, r, r);
    pushMatrix();
    translate(sx, sy, z-200);
    sphere(r/4);
    popMatrix();

  }
}