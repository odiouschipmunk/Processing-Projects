import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

// An ArrayList to store information about the user-defined surface
ArrayList<Vec2> surface_vector;

// When the user is finished defining the surface, we will 
// change this to false
boolean definesurface = true;

// Particle properties
float particle_radius = 6.0;
float coeff_friction = 0.05;
float coeff_restitution = 0.3; // =1 for elastic collisions
                               // =0 for (almost) perfeclty inelastic collisions 

// For people with C++ experience, box2d is a class
Box2DProcessing box2d;

void setup() {
  size(600,400);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -9.8);

  // Create the empty list
  particles = new ArrayList<Particle>();

  surface_vector = new ArrayList<Vec2>();
}

void draw() {
  
  if (definesurface) 
  { 
   // Let the user define the surface
  
   display_while_drawing_surface();
  
   if (mousePressed) {
    // The position of the mouse on each click defines the surface
    surface_vector.add(new Vec2(mouseX,mouseY));
   }  
  
   // Define surface until spacebar is pressed
   if (keyPressed && (key == ' ')) {
    create_surface();
    definesurface = false;
   }
    
  } else {   
   // now we are finished defining the surface, let the fun begin!
    
   // If the mouse is pressed, we make new particles
   if (mousePressed) {
       particles.add(new Particle(mouseX,mouseY,particle_radius));
   }

   // We must always step through time!
   box2d.step();

   // Draw the user-defined surface
   display_surface();

   // Draw each particle
   for (int i = 0; i < particles.size() ; i++) {
      particles.get(i).display();
   }
  
   // Delete particles that are leaving the box 
   delete_leaving_particles();

  } //end if-else
} // end draw()













 
class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  Particle(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x,y,r);
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
    fill(175);
    stroke(0);
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    // Let's add a line so we can see the rotation
    line(0,0,r,0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
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
    fd.friction = coeff_friction;
    fd.restitution = coeff_restitution;
    
    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
//    body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
   body.setLinearVelocity(new Vec2(0.0,0.0));
    //body.setAngularVelocity(random(-10,10));
        body.setAngularVelocity(0.0);
  }

}

















void display_while_drawing_surface() {
    background(255);
    strokeWeight(2);
    stroke(0);
    noFill();
    beginShape();
    for (Vec2 v: surface_vector) {
      vertex(v.x,v.y);
    }
    endShape();  
    fill(0);
    textSize(20);
    text("Click the screen to define the surface",0.2*width,0.1*height);
    text("Press SPACEBAR when finished",0.25*width,0.15*height);
}

void  create_surface() {

    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();
    
    // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made
    Vec2[] vertices = new Vec2[surface_vector.size()];

    int counter = 0;
      for (int i = 0; i < (vertices.length-1); i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface_vector.get(i));
      Vec2 edge_next = box2d.coordPixelsToWorld(surface_vector.get(i+1)); 
       if ((edge.x != edge_next.x) && (edge.y != edge_next.y)) {
       vertices[counter] = edge;
       counter += 1;
       }
      }
      
      // Get the endpoint, assume it is unique
      vertices[counter] = box2d.coordPixelsToWorld(surface_vector.get(vertices.length-1));
      counter += 1;
      
    Vec2[] vertices_no_double_count = new Vec2[counter];
    for (int i = 0;i< counter; i++) {
    vertices_no_double_count[i] = vertices[i];
    }
        
    // Create the chain!
    chain.createChain(vertices_no_double_count,vertices_no_double_count.length);
    
    // The edge chain is now attached to a body via a fixture
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    Body body = box2d.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain,1);

  }

  // A simple function to just draw the edge chain as a series of vertex points
void display_surface() {
    background(255);
    strokeWeight(2);
    stroke(0);
    noFill();
    beginShape();
    for (Vec2 v: surface_vector) {
      vertex(v.x,v.y);
    }
    endShape();
    fill(0);
    textSize(20);
    text("Click anywhere to drop objects!",0.25*width,0.15*height);
}


void delete_leaving_particles() {

  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.done()) {
      particles.remove(i);
    }
  }  
}
