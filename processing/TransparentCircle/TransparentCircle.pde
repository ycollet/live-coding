import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
int index = 0;
float radius = 100;
int transp = 0;

void setup() {
  size(400,400);
  frameRate(10);
  oscP5 = new OscP5(this,8060);
  myRemoteLocation = new NetAddress("127.0.0.1",8060);
}

void draw() {
  color(0);
  fill(0);
  strokeWeight(10);
  circle(width / 2, height / 2, radius);
  //fill(0, 0, 255, 255*cos(radians(index)));
  fill(0, 0, 255, transp);
  strokeWeight(10);
  circle(width / 2, height / 2, radius);
  //index = index + 20;
  
  // // Pour envoyer un message Osc:
  // OscMessage myMessage = new OscMessage("/transparent");
  // // et on ajoute la valeur de la poisition X et position Y du curseur de la souris sur la scene du sketch au message
  // myMessage.add(transp); 
  // myMessage.add(transp2);
}

void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: " + theOscMessage.addrPattern());
  
  // si l'applet reçoit un messag OSC avec l'address pattern "/positionsCurseur"
  if (theOscMessage.checkAddrPattern("/transparent")==true) {
    //on assigne les valeurs de l'index 0, de type integer (.intValue)  du message OSC 
    //à la variable positionX que l'on assignera à la coordonnée x de notre cercle
    print("### received an osc message.");
    
    transp = theOscMessage.get(0).intValue();
    ////on assigne les valeurs de l'index 1, de type integer (.intValue)  du message OSC 
    ////à la variable positionY que l'on assignera à la coordonnée y de notre cercle
    //transp2 = theOscMessage.get(1).intValue();
  }
}
