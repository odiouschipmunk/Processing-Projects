import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

float rectv1 = 0;
float recth1 = 0;


int hardness = 10000;
Box2DProcessing box2d;
ArrayList<Boundary> boundaries;
ArrayList<BoxVertical> boxesv;
ArrayList<BoxHorizontal> boxesh;

Box box;
// The Spring that will attach to the box from the mouse
Spring spring;

void setup(){
  size(600, 600);
 box2d = new Box2DProcessing(this);
 box2d.createWorld();
 box2d.setGravity(0, -12.2);
   box = new Box(20, height-20);
  box2d.listenForCollisions();

   boundaries = new ArrayList<Boundary>();
  boundaries.add(new Boundary(width,0,50,height*height));
  boundaries.add(new Boundary(0 , height , height*height , 50));
    boundaries.add(new Boundary(0 , 0 , 50 , height*height));
  boxesv = new ArrayList<BoxVertical>();
  boxesh = new ArrayList<BoxHorizontal>();
  
  // Make the spring (it doesn't really get initialized until the mouse is clicked)
  spring = new Spring();

}

void mouseReleased() {
  spring.destroy();
}

// When the mouse is pressed we. . .
void mousePressed() {
  // Check to see if the mouse was clicked on the box
  if (box.contains(mouseX, mouseY)) {
    // And if so, bind the mouse position to the box with a spring
    spring.bind(mouseX,mouseY,box);
  }
}

void draw(){
  background(100);
 box2d.step(); 
   for (Boundary wall : boundaries) {
    wall.display();
  }
    spring.update(mouseX,mouseY);

  if(rectv1<1){
    boxesv.add(new BoxVertical(width/2-25, height-25));
    boxesv.add(new BoxVertical(width/2-35, height-25));
    boxesv.add(new BoxVertical(width/2-25, height-75));
    boxesv.add(new BoxVertical(width/2-35, height-75));
    boxesv.add(new BoxVertical(width/2-25, height-125));
    boxesv.add(new BoxVertical(width/2-35, height-125));
    boxesv.add(new BoxVertical(width/2-25, height-175));
    boxesv.add(new BoxVertical(width/2-35, height-175));
    boxesv.add(new BoxVertical(width/2+27, height-25));
    boxesv.add(new BoxVertical(width/2+37, height-25));
    boxesv.add(new BoxVertical(width/2+27, height-75));
    boxesv.add(new BoxVertical(width/2+37, height-75));
    boxesv.add(new BoxVertical(width/2+27, height-125));
    boxesv.add(new BoxVertical(width/2+37, height-125));
    boxesv.add(new BoxVertical(width/2+27, height-175));
    boxesv.add(new BoxVertical(width/2+37, height-175));
    boxesv.add(new BoxVertical(width/2, height-25));
    boxesv.add(new BoxVertical(width/2 - 10, height-25));
    boxesv.add(new BoxVertical(width/2, height-75));
    boxesv.add(new BoxVertical(width/2 - 10, height-75));
    boxesv.add(new BoxVertical(width/2, height-125));
    boxesv.add(new BoxVertical(width/2 - 10, height-125));
    boxesv.add(new BoxVertical(width/2, height-175));
    boxesv.add(new BoxVertical(width/2 - 10, height-175));
    boxesv.add(new BoxVertical(width/2-50, height-25));
    boxesv.add(new BoxVertical(width/2-60, height-25));
    boxesv.add(new BoxVertical(width/2-50, height-75));
    boxesv.add(new BoxVertical(width/2-60, height-75));
    boxesv.add(new BoxVertical(width/2-50, height-125));
    boxesv.add(new BoxVertical(width/2-60, height-125));
    boxesv.add(new BoxVertical(width/2-50, height-175));
    boxesv.add(new BoxVertical(width/2-60, height-175));
    boxesv.add(new BoxVertical(width/2+50, height-25));
    boxesv.add(new BoxVertical(width/2+60, height-25));
    boxesv.add(new BoxVertical(width/2+60, height-75));
    boxesv.add(new BoxVertical(width/2+50, height-75));
    boxesv.add(new BoxVertical(width/2+60, height-125));
    boxesv.add(new BoxVertical(width/2+50, height-125));
    boxesv.add(new BoxVertical(width/2+60, height-175));
    boxesv.add(new BoxVertical(width/2+50, height-175));
    boxesv.add(new BoxVertical(width/2-100, height-25));
    boxesv.add(new BoxVertical(width/2-110, height-25));
    boxesv.add(new BoxVertical(width/2-110, height-75));
        boxesv.add(new BoxVertical(width/2-100, height-75));
    boxesv.add(new BoxVertical(width/2-110, height-125));
        boxesv.add(new BoxVertical(width/2-100, height-125));
    boxesv.add(new BoxVertical(width/2-110, height-175));
        boxesv.add(new BoxVertical(width/2-100, height-175));
        boxesv.add(new BoxVertical(width/2+100, height-25));
    boxesv.add(new BoxVertical(width/2+110, height-25));
        boxesv.add(new BoxVertical(width/2+100, height-75));
    boxesv.add(new BoxVertical(width/2+110, height-75));
            boxesv.add(new BoxVertical(width/2+100, height-125));
    boxesv.add(new BoxVertical(width/2+110, height-125));
            boxesv.add(new BoxVertical(width/2+100, height-175));
    boxesv.add(new BoxVertical(width/2+110, height-175));
    boxesv.add(new BoxVertical(width/2-150, height-25));
    boxesv.add(new BoxVertical(width/2-140, height-25));
    boxesv.add(new BoxVertical(width/2-150, height-75));
    boxesv.add(new BoxVertical(width/2-140, height-75));
        boxesv.add(new BoxVertical(width/2-150, height-125));
    boxesv.add(new BoxVertical(width/2-140, height-125));
        boxesv.add(new BoxVertical(width/2-150, height-175));
    boxesv.add(new BoxVertical(width/2-140, height-175));
    boxesv.add(new BoxVertical(width/2+140, height-25));
    boxesv.add(new BoxVertical(width/2+150, height-25));
    boxesv.add(new BoxVertical(width/2+140, height-75));
    boxesv.add(new BoxVertical(width/2+150, height-75));
        boxesv.add(new BoxVertical(width/2+140, height-125));
    boxesv.add(new BoxVertical(width/2+150, height-125));
        boxesv.add(new BoxVertical(width/2+140, height-175));
    boxesv.add(new BoxVertical(width/2+150, height-175));


    rectv1++;
  }
    if(recth1<1){
    boxesh.add(new BoxHorizontal(width/2-5, height-50));
    boxesh.add(new BoxHorizontal(width/2-5, height-100));
    boxesh.add(new BoxHorizontal(width/2-5, height-150));
    boxesh.add(new BoxHorizontal(width/2-5, height-200));
    boxesh.add(new BoxHorizontal(width/2-55, height-50));
    boxesh.add(new BoxHorizontal(width/2-55, height-100));
    boxesh.add(new BoxHorizontal(width/2-55, height-150));
    boxesh.add(new BoxHorizontal(width/2+55, height-50));
    boxesh.add(new BoxHorizontal(width/2+55, height-100));
    boxesh.add(new BoxHorizontal(width/2+55, height-150));
    boxesh.add(new BoxHorizontal(width/2+55, height-200));
    boxesh.add(new BoxHorizontal(width/2-55, height-200));
    boxesh.add(new BoxHorizontal(width/2-105, height-50));
//    boxesh.add(new BoxHorizontal(width/2-105, height-100));
    boxesh.add(new BoxHorizontal(width/2-105, height-150));
    boxesh.add(new BoxHorizontal(width/2-105, height-200));
  boxesh.add(new BoxHorizontal(width/2+105, height-150));
  boxesh.add(new BoxHorizontal(width/2+105, height-200));
        boxesh.add(new BoxHorizontal(width/2+105, height-50));
        boxesh.add(new BoxHorizontal(width/2+105, height-100));
    boxesh.add(new BoxHorizontal(width/2-105, height-100));
    boxesh.add(new BoxHorizontal(width/2+145, height-50));
    boxesh.add(new BoxHorizontal(width/2+145, height-100));
    boxesh.add(new BoxHorizontal(width/2+145, height-150));
    boxesh.add(new BoxHorizontal(width/2+145, height-200));
        boxesh.add(new BoxHorizontal(width/2-145, height-50));
    boxesh.add(new BoxHorizontal(width/2-145, height-100));
    boxesh.add(new BoxHorizontal(width/2-145, height-150));
    boxesh.add(new BoxHorizontal(width/2-145, height-200));
    //boxesh.add(new BoxHorizontal(width/2+145, height-50));
    boxesh.add(new BoxHorizontal(width/2-30, height-50));
    boxesh.add(new BoxHorizontal(width/2-30, height-100));
    boxesh.add(new BoxHorizontal(width/2-30, height-150));
    boxesh.add(new BoxHorizontal(width/2-30, height-200));
    boxesh.add(new BoxHorizontal(width/2+32, height-50));
    boxesh.add(new BoxHorizontal(width/2+32, height-100));
    boxesh.add(new BoxHorizontal(width/2+32, height-150));
    boxesh.add(new BoxHorizontal(width/2+32, height-200));
    
   recth1++; 
  }
    for (BoxVertical b : boxesv) {
    b.display();
  }
    for (BoxHorizontal b : boxesh) {
    b.display();
  }
box.display();


if(mousePressed){
 if(hardness>0){
   if (mousePressed) {
     box.attract(mouseX,mouseY);
  } 
 }
hardness++;
}
hardness = constrain(hardness, 0, 500);
fill(255, 0, 0);
text(hardness + " attraction points left...", 100, 10);
spring.display();
}

 




//boundaries

class Boundary {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);


    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    fill(0);
    stroke(255);
    rectMode(CENTER);
        strokeWeight(0);

    rect(x,y,w,h);
  }

}






//boxes


// A rectangular box
class BoxVertical {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  float r;
  float g;
  float b;
  color col;
  // Constructor
  BoxVertical(float x, float y) {
    w = 5;
    h = 15;
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h);
    r = random(0, 255);
    g = random(0, 255);
    b = random(0, 255);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
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
  void change() {
    col = color(255, 0, 0);
  }
  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(255);
    stroke(0);
        strokeWeight(0);

    rect(0, 0, w, h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    }
}









class BoxHorizontal {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  float r;
  float g;
  float b;
  color col;
  // Constructor
  BoxHorizontal(float x, float y) {
    w = 20;
    h = 5;
    // Add the box to the box2d world
    makeBody(new Vec2(x, y), w, h);
    r = random(0, 255);
    g = random(0, 255);
    b = random(0, 255);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
    void change() {
    col = color(255, 0, 0);
  }

  // Is the particle ready for deletion?
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

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(col);
    stroke(0);
    strokeWeight(0);
    rect(0, 0, w, h);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    }
}
























// A rectangular box

class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;
  public float speedX;
  public float speedY;
  public float angularVelocity;
  color col;
  // Constructor
  Box(float x_, float y_) {
    float x = x_;
    float y = y_;
    w = 24;
    h = 24;
    // Add the box to the box2d world
    makeBody(new Vec2(x,y),w,h);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  void change() {
    col = color(255, 0, 0);
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
 
    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(a);
    fill(col);
    //stroke(0);
    //strokeWeight(2);
    rect(0,0,w,h);
    popMatrix();
  }


  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);
    //body.setMassFromShapes();

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(speedX, speedY)); //new Vec2(random(-5, 5), random(2, 5))
    body.setAngularVelocity(angularVelocity);//random(-5, 5));
  }



  void attract(float x,float y) {
    // From BoxWrap2D example
    Vec2 worldTarget = box2d.coordPixelsToWorld(x,y);   
    Vec2 bodyVec = body.getWorldCenter();
    // First find the vector going from this body to the specified point
    worldTarget.subLocal(bodyVec);
    // Then, scale the vector to the specified force
//    worldTarget.normalize();
//you can also not do it for a more powerful force
    worldTarget.mulLocal((float) 50);
    // Now apply it to the body's center of mass.
    body.applyForce(worldTarget, bodyVec);
  }
  
    boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }
}






// Class to describe the spring joint (displayed as a line)

class Spring {

  // This is the box2d object we need to create
  MouseJoint mouseJoint;

  Spring() {
    // At first it doesn't exist
    mouseJoint = null;
  }

  // If it exists we set its target to the mouse position 
  void update(float x, float y) {
    if (mouseJoint != null) {
      // Always convert to world coordinates!
      Vec2 mouseWorld = box2d.coordPixelsToWorld(x,y);
      mouseJoint.setTarget(mouseWorld);
    }
  }

  void display() {
    if (mouseJoint != null) {
      // We can get the two anchor points
      Vec2 v1 = new Vec2(0,0);
      mouseJoint.getAnchorA(v1);
      Vec2 v2 = new Vec2(0,0);
      mouseJoint.getAnchorB(v2);
      // Convert them to screen coordinates
      v1 = box2d.coordWorldToPixels(v1);
      v2 = box2d.coordWorldToPixels(v2);
      // And just draw a line
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y);
    }
  }


  // This is the key function where
  // we attach the spring to an x,y position
  // and the Box object's position
  void bind(float x, float y, Box box) {
    // Define the joint
    MouseJointDef md = new MouseJointDef();
    // Body A is just a fake ground body for simplicity (there isn't anything at the mouse)
    md.bodyA = box2d.getGroundBody();
    // Body 2 is the box's boxy
    md.bodyB = box.body;
    // Get the mouse position in world coordinates
    Vec2 mp = box2d.coordPixelsToWorld(x,y);
    // And that's the target
    md.target.set(mp);
    // Some stuff about how strong and bouncy the spring should be
    md.maxForce = 1000.0 * box.body.m_mass;
    md.frequencyHz = 5.0;
    md.dampingRatio = 0.9;

    // Make the joint!
    mouseJoint = (MouseJoint) box2d.world.createJoint(md);
  }

  void destroy() {
    // We can get rid of the joint when the mouse is released
    if (mouseJoint != null) {
      box2d.world.destroyJoint(mouseJoint);
      mouseJoint = null;
    }
  }

}





void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  
  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
 // Object o3 = b3.getUserData();

  if (o1.getClass() == Box.class && o2.getClass() == BoxHorizontal.class ) {
    BoxVertical p1 = (BoxVertical) o1;
    p1.change();
    BoxHorizontal p2 = (BoxHorizontal) o2;
    p2.change();
  }

}

// Objects stop touching each other
void endContact(Contact cp) {
}
