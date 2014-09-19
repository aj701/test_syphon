//Solar Winds Disturbing Migration 
//by AJ LeVine 2014

//thanks to the coding help session with ryan and mike for teaching us how to make rain
//thanks to João Pedro Gonçalves for helping explain minim to me

//initial variable setup

//import Minim
import ddf.minim.analysis.*; 
import ddf.minim.*;     
// import codeanticode.syphon.*;

// PGraphics canvas;
// SyphonServer server;

Minim minim;
AudioPlayer player;
AudioInput in;
FFT fft;

//numbers of raindrops and birds on screen
int numRain=200;
int numBirds= 100;

// Drop[] drops = new Drop[numRain];


//speed and rejuvination of raindrops
float x[] = new float[numRain];
float y[] = new float[numRain];
float speedY[] = new float [numRain];

//speed and rejuvination of birds
float xx[] = new float[numBirds];
float yy[] = new float[numBirds];
float speedXX[] = new float[numBirds];
float speedYY[] = new float [numBirds];

void setup () {
  //size of screen
  size (1200, 750, P3D);
  canvas = createGraphics(1200, 750, P3D);
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}
  
  // audio setup
  minim = new Minim(this);  //Create minim
  in = minim.getLineIn(Minim.STEREO, 512); //setting mic input
  fft = new FFT(in.bufferSize(), in.sampleRate()); //config FFT
  fft.linAverages(20); //divide frequencies into ranges
 
  //musicplayer
  player = minim.loadFile("exbirds.mp3", 2048);
  player.play();
  
  //setting up placement movement of initial raindrops
  for ( int i=0; i < numRain; i++) {
    x[i] = random(width);
    y[i] = random(height);
    speedY[i] = random( 5, 10 );
  }
  
  for ( int b=0; b < numBirds; b++) {
    xx[b] = random(width);
    yy[b] = random(height);
    speedXX[b] = random( 1, 3);
  }
  noStroke();
}

void draw() {
  canvas.beginDraw();
  //redraw background or maybe an image soon
  canvas.background(10);
  
  //setup audio
  fft.forward(in.mix);  //get mic audio
  
  float fft1 = map(fft.getAvg(1), 0, 20, 1, 20); //setting the mic input to eventually control speed of birds - what is getavg giving me?
  
  

  
  //place random raindrops on screen
  for ( int i=0; i < numRain; i++) {
    canvas.fill(random(60), random(60), random(120));
    canvas.ellipse( x[i], y[i], random(5, 10), random(15, 40) );
    
    //rays of light and bizarre solar wind giving our birds a difficult time during their migration
    canvas.fill(random(255), random(255), random(255), random(60));
    canvas.triangle(x[i], y[i], random(10, 20), random(10, 20), random(10, 20), random(10,20));
    
       if (y[i] > height) {
         y[i] = 10; //ensure that they start towards the top of the screen when regenerated
         x[i] = random(width);
         speedY[i] = random (5, 10); 
       } else { y[i]+=speedY[i];
       }
       
    
  }
    //place random birds on screen
  for ( int b=0; b< numBirds; b++) {  
    canvas.fill(random(255), random(255), random(255), random(255));
    canvas.rotate(0.9); //rotation not only rotates shape, but movement as well, it did what I wanted but when I tried to unrotate the movement it made things even weirder
    canvas.rect( xx[b], yy[b], random(10, 60), random(10, 60) );
         
         if ( xx[b] > width || yy[b] > height) {
           xx[b] = random(width);
           yy[b] = random(height);
           speedXX[b] = fft1; //random(1,5);
         } else { xx[b]+=speedXX[b];
         }
  }
 canvas.endDraw();   
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}
