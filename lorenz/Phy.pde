class Phy{

  PVector phyPos;
  int n = 0;
  int nStart = 0;;
  float scale;
  float d;
  float z;
  float size;
  PImage img;
  float start = 0;
  //color setup
  
  color from1 = color(211, 88, 74);
  color to1 = color(79, 24, 18);
  color from2 = color(74, 127, 221);
  color to2 = color(13, 32, 66);
  color from3 = color(91, 206, 168);
  color to3 = color(16, 66, 49);
  

  
  //location
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  //iterations
  float stepSize;
  int curIter;
  int maxIter;
  
  boolean invert;
  
  
  //lerping
  boolean useLerping;
  boolean isLerping;
  PVector startPos;
  PVector endPos;
  
  //audio
  float freq;

  Phy(){

    nStart = 0;
    z = 0;
    stepSize = 1;
    n = nStart;
    size = 4;
    //scale = 4;
  }
  

  PVector calcPhy(float scale, int n){
    float a = n * d;
    float r = scale * sqrt(n);
    float x = r * cos(a);
    float y = r * sin(a);
    
    float z = stepSize*1.5;
    PVector vec = new PVector(x, y, z);
    return vec;
}

void update(int colorMode, float expand, float threshold){
  rotate(n * 0.3);
  int loop = 2;
  float windowSize = 300;
    if (n >= windowSize) {
      loop = int(n) - int(windowSize); 
    }
    if (n >= 1000){    
      n = int(windowSize);
    }
    PVector loc = calcPhy(scale, 0);
    points.add(loc);
    for (int i = loop; i < n; i++) {
      float hu = n+start;//sin(start + i * 0.5);
      noStroke();
      float value = map(stepSize, 0, 50, 0, 1);
      //println(stepSize, value);
      switch(colorMode){
      case 0:
        color interA = lerpColor(from1, to1, value);
        //hu = i/4.0 % 360;
        fill(interA);
        break;
      case 1:
        color interB = lerpColor(from2, to2, value);
        hu = i/4.0 % 360;
        //fill(255, hu, 255);
        fill(interB);
        break;
      
      case 2:
        color interC = lerpColor(from3, to3, value);
        //hu = i/4.0 % 360;
        //fill(255, 255, hu);
        fill(interC);
        break;
      }
      
      float percentage = map(scale, -5, 5, 0, 1);
     // println(expand, percentage);
      PVector lerping = PVector.lerp(points.get(0), calcPhy((scale+1), i) , percentage);
      //println("dx: ", points.get(0).x, calcPhy(4, i).x);
      points.remove(0);
      if (scale >= threshold){
        //beginShape();
        pushMatrix();
        translate(lerping.x, lerping.y, lerping.z);
        box(random(1, percentage*expand*4));
        popMatrix();
        //endShape();
      }
      points.add(calcPhy((scale+1), i));
  }
  n += stepSize;
  start += stepSize;
}
}