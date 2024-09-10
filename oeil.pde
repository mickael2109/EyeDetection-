import gab.opencv.*;
import processing.video.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import jp.nyatla.nyar4psg.*;
import java.awt.Rectangle;

OpenCV opencv;
Capture cam;
MultiMarker nya;

void setup() {
  size(640, 480, P3D);
  colorMode(RGB, 100);
  
  cam = new Capture(this, 640, 480);
  cam.start();
  
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade("haarcascade_frontalface_default.xml");
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  
  opencv.loadImage(cam);
  
  Rectangle[] faces = opencv.detect();
  
  image(cam, 0, 0);
  
  for (int i = 0; i < faces.length; i++) {
    noFill();
    stroke(0, 255, 0);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    
    OpenCV faceCV = new OpenCV(this, faces[i].width, faces[i].height);
    faceCV.loadImage(cam.get(faces[i].x, faces[i].y, faces[i].width, faces[i].height));
    faceCV.loadCascade("haarcascade_eye.xml");
    
    Rectangle[] eyes = faceCV.detect();
    
    for (int j = 0; j < eyes.length; j++) {
      float eyeCenterX = faces[i].x + eyes[j].x + eyes[j].width / 2;
      float eyeCenterY = faces[i].y + eyes[j].y + eyes[j].height / 2;
      
      fill(255, 0, 0);
      noStroke();
      ellipse(eyeCenterX, eyeCenterY, 10, 10);
    }
  }
}
