
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
Box2DProcessing box2d;

ArrayList<Circle> circles;
ArrayList<Boundary> boundaries;
boolean clicking=false;
void setup() {
  size(640,360);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -10);

  // Create the empty list
  circles = new ArrayList<Circle>();
  boundaries=new ArrayList<Boundary>();
}

void draw() {
  // If the mouse is pressed, we make new circles
  if (keyPressed) {
    circles.add(new Circle(mouseX,mouseY,10));
  }
  
  if(mousePressed){
    boundaries.add(new Boundary(mouseX, mouseY, 10, 10)); 
  }
  

  // We must always step through time!
  box2d.step();

  background(255);


  // Draw all circles
  for (Circle c: circles) {
    c.display();
  }
  
  for(Boundary b: boundaries){
   b.display(); 
  }
  // circles that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = circles.size()-1; i >= 0; i--) {
    Circle p = circles.get(i);
    if (p.done()) {
      circles.remove(i);
    }
  }
}

class Circle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  Circle(float x, float y, float r_) {
    r = r_;
    // This function puts the circle in the Box2d world
    makeBody(x,y,r);
  }

  // This function removes the circle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the circle ready for deletion?
  boolean done() {
    // Let's find the screen position of the circle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(127);
    stroke(0);
    strokeWeight(2);
    ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    line(0,0,r,0);
    popMatrix();
  }

  // Here's our function that adds the circle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;
    
    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    body.setAngularVelocity(random(-10,10));
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
