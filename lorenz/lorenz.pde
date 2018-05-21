import peasy.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import com.hamoid.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
ddf.minim.analysis.FFT fft;

int form;
float x = 0.01;
float y = 0;
float z = 0;

float a = 10;
float b = 28;
float c = 8.0/3.0;
//star
float speed;
Star[] stars = new Star[500];


PeasyCam cam;

float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

Phy phy1;
Phy phy2;
Phy phy3;
Phy phy4;
float deg;

color[] blueColors = {#000000, #22223a,#202535,#210a33,#330a5b,#0d3e49, #4c0c15};
color bgc;
float time;
int colorCount = 0;



void setup() {
  fullScreen(P3D);
  //size(800, 800, P3D);
  scale(1);
  colorMode(HSB, 100, 100, 100);
  smooth(4);
  blendMode(LIGHTEST);
 // lights();
  
  cam = new PeasyCam(this, 500);
  minim = new Minim(this);
  song = minim.loadFile("TakeItBack.mp3", 128);
  song.play();
  beat = new BeatDetect();
  fft = new ddf.minim.analysis.FFT(song.bufferSize(), song.sampleRate());
  phy1 = new Phy();
  phy2 = new Phy();
  phy3 = new Phy();
  phy4 = new Phy();
  deg = 51;
  
  //set up star
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
}

void draw() {

  
  fft.forward(song.right);
  beat.detect(song.mix);
  lights();
  pointLight(51, 102, 126, 35, 40, 36);


  
  if (millis()% 10 == 0 && beat.isOnset()){
    colorCount++;
  }
  background(blueColors[colorCount % 7]);
  

  phy1.d =radians(-51);
  phy2.d = radians(51);
  phy3.d = radians(137.5);
  phy4.d = radians(deg++);
  
  if (deg >= 180){
    deg = 30;
  }
  for (int i = 0; i < fft.specSize(); i++)
  {
    speed = map(fft.getBand(i)*200, 0, width, 0, 200);
  }
  
   translate(0, 0, 0);
   
   //println(speed, angle);
  // rotate around the center of the sketch
   rotateX(radians(frameCount));
   rotateY(radians(frameCount/2));

  
  for (int i = 0; i < stars.length; i++) {
    stars[i].hu += 0.1;
    stars[i].update();
    stars[i].show();
  }
   

  for (int i = 0; i < fft.specSize()*specLow; i++)
  {
    phy1.stepSize = int(fft.getFreq(i));
    phy2.stepSize = int(fft.getFreq(i));
    
    phy1.scale = int(fft.getBand(i)/4);
    phy2.scale = int(fft.getBand(i)/4);
    //println("1: ", phy1.scale);
    
  }
  //phy1.newUpdate();
  phy1.update(0, 0.5, 0);
  phy2.update(0, 0.5, 0);
  
  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    phy3.stepSize = int(fft.getFreq(i));
    phy3.scale = int(fft.getBand(i));
    //println("2: ", phy2.scale); 
  }
  phy3.update(1, 1.5, 0);
  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    phy4.stepSize = int(fft.getFreq(i));
    phy4.scale = int(fft.getBand(i));
    //println("3: ", phy3.scale);
  }
    phy4.update(2, 1, 2);

}