
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to the box2d world
Box2DProcessing box2d;

// A list for use to track fixed objects
// A list for all of our rectangles
ArrayList<Box> boxes;
ArrayList<Boundary> boundaries;
boolean clicking = false;
boolean pressing = false;
boolean attract = false;
boolean adding=false;
void setup() {
  size(displayWidth, displayHeight);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -30);

  // Create ArrayLists  
  boxes = new ArrayList<Box>();
  boundaries =new ArrayList<Boundary>();
  boundaries.add(new Boundary(25, 0, 10, displayHeight*2));
  boundaries.add(new Boundary(0, displayHeight-25, displayWidth*2, 10));
  boundaries.add(new Boundary(displayWidth-26, displayHeight-25, 10, displayHeight*2));
}

void draw() {
  background(152);
  fill(0);
  textSize(16);
  text("Press any key to start the flow of squares(and press again to stop)", 66, 136);
  text("Click to add a boundary", 66, 186);
  text("And click again to stop", 66, 236);
  text("The red circle is where the squares will originate", 66, 286);
  textSize(14);
  text("Click ctrl to make the squares attract to your mouse, and click again to stop", 66, 336);
  text("Click b to start the flow of squares from your mouse", 66, 386);
  //Stepping through time... Like dr. strange
  box2d.step();
  if(keyPressed){
   if(key == 'b' || key == 'B'){
     Box p=new Box(mouseX, mouseY);
     boxes.add(p);
   }
  }

  // Display all the boxes
  for (Box b : boxes) {
    b.display();
  }

  for (Boundary b : boundaries) {
    b.display();
  }
  if (clicking) {
    boundaries.add(new Boundary(mouseX, mouseY, 10, 10));
  }
  if (pressing) {
    Box p=new Box(width/2, 30);
    boxes.add(p);
  }
  if(attract){
   for(Box b:boxes){
    b.attract(mouseX, mouseY); 
   }
  }
  fill(255, 0, 0);
  ellipse(width/2, 30, 10, 10);
  
    for (int i = boxes.size()-1; i >= 0; i--) {
    Box b = boxes.get(i);
    if (b.done()) {
      boxes.remove(i);
    }
  }
  System.out.println(boxes.size());
}

void mousePressed() {
  clicking=!clicking;
}

void keyPressed() {
   if(keyCode!=CONTROL){
    if (key == ' ' || key == ' ') {
  pressing=!pressing;
     }
  
   } else{
    attract=!attract; 
   }
   
    if (key == 'b' || key == 'B') {
     adding=!adding;
   }

}

// A rectangular box
class Box {
  Body body;      

  float w, h;
  float lifespan=1000;
  Box(float x, float y) {
    w = 16;
    h = 16;

    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);


    // Define a polygon (this is what we use for a rectangle)
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2); 
    ps.setAsBox(box2dW, box2dH);            
    //Box2D considers  
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.7;

    // Attach Fixture to Body               
    body.createFixture(fd);
  }

  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();
    lifespan--;
    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    rotate(-a);              // translate and rotate the rectangle
    fill(127);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    rect(0, 0, w, h);
    popMatrix();
  }
  
  void attract(float x, float y){
  Vec2 worldTarget=box2d.coordPixelsToWorld(x, y);
  Vec2 bodyVec=body.getWorldCenter();
  
  worldTarget.subLocal(bodyVec);
  worldTarget.normalize();
  worldTarget.mulLocal((float)500);
  
  body.applyForce(worldTarget, bodyVec);
 }
 
   void killBody() {
    box2d.destroyBody(body);
  } 
  
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);  
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }
}

class Boundary {
  Body b;
  float x, y;
  float w, h;
  Boundary(float x_, float y_, float w_, float h_) {
    x=x_;
    y=y_;
    w=w_;
    h=h_;

    BodyDef bd=new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    bd.type=BodyType.STATIC;
    b=box2d.createBody(bd);

    float box2dW=box2d.scalarPixelsToWorld(w/2);
    float box2dH=box2d.scalarPixelsToWorld(h/2);
    PolygonShape ps=new PolygonShape();
    ps.setAsBox(box2dW, box2dH);

    b.createFixture(ps, 1);
  }

  void display() {
    fill(0);
    stroke(0);
    rectMode(CENTER);
    rect(x, y, w, h);
  }
}
