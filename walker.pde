Walker w;
void setup(){
  size(600, 600);
  w=new Walker();
}

void draw(){
  w.step();
  w.display();
}

class Walker{
 int x;
 int y;
 
 Walker(){
  x=width/2;
  y=height/2;
 }
 
 void display(){
  stroke(0);
  point(x, y);
 }
 
 void step(){
   int choice=int(random(4));
   if(choice==0){
    x=x+1; 
   }
   if(choice==1){
     x=x-1;
   }
   if(choice==2){
    y=y+1; 
   }
   if(choice==3){
    y=y-1; 
   }
 }
}
