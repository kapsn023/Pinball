ArrayList<Ball> balls = new ArrayList<Ball>();

ArrayList<Sphere2> spheres = new ArrayList<Sphere2>();
ArrayList<Ball> particles = new ArrayList<Ball>();
ArrayList<Integer> indicesToRemove = new ArrayList<Integer>();

float grav = 150.0;
//int height = 600;
//int width = 600;
int score = 0;
int numBalls = 15;
int numParticles = 25;

PImage img;
String[] rows;
boolean isPaused = true;

color lerpMax = color(0, 255, 255);
color sphereColor = color(0, 51, 150);
color ballColor = color(15, 25, 40);

void fileSelected(File selection){
  if (selection == null){
    println("No file selected.");
  }
  else {
    rows = loadStrings(selection.getAbsolutePath());
    String[] tokens = splitTokens(rows[0]);
    numBalls = Integer.parseInt(tokens[0]);
    numParticles = Integer.parseInt(tokens[1]);
    for (int i = 1; i < rows.length; i++){
      tokens = splitTokens(rows[i]);
      spheres.add(new Sphere2(new Vec2(Float.parseFloat(tokens[0]), Float.parseFloat(tokens[1])), Float.parseFloat(tokens[2])));
    }
    for (int i = 0; i < numBalls; i++){
      balls.add(new Ball(new Vec2(random(0.1, 600), random(-500, 0)), 10.0, new Vec2(random(0, 10), random(-10, 0)), 10.0));
    }
    isPaused = false;
  }
}

void setup() {
  size(600, 600, P3D); //<>//
  noStroke();
  img = loadImage("Constellation Cepheus.jpg");
  selectInput("Select a file to load:", "fileSelected");
}

void computePhysics(float dt){
  for (int i = 0; i < balls.size()-1; i++){
    for (int j = i+1; j < balls.size(); j++){
      ballOnBall(balls.get(i), balls.get(j));
    }
  }
  
  for (Ball ball : balls){
    ball.vel = new Vec2(ball.vel.x, ball.vel.y + (grav * dt));
    for (Sphere2 sphere : spheres){
      if (ball.cent.distanceTo(sphere.cent) < (ball.r + sphere.r)){
        Vec2 normal = (ball.cent.new_sub(sphere.cent)).new_normalize();
        ball.cent = sphere.cent.new_add(normal.new_mul(sphere.r + ball.r).new_mul(1.01));
        Vec2 velNormal = normal.new_mul(dot(ball.vel,normal));
        ball.vel.subtract(velNormal.new_mul(1.8));
       
        // Updating score
        score += 100;
        
        // Starting color lerp
        sphere.time = 1.0;
      }
      //Bottom
      if (ball.cent.y > 600 + ball.r){
        for (int i = 0; i < numParticles; i++){
          Ball particle = new Ball(new Vec2(ball.cent.x,600), 2.0, new Vec2(random(80)-40, random(-100)), 0.0);
          particles.add(particle);
          particle.time = 1;
        }
        ball.cent.y = ball.r;
        //ball.vel.y *= -0.8;
      }
      //Top
      //if (ball.cent.y < ball.r){
      //  ball.cent.y = ball.r;
      //  ball.vel.y *= -0.8;
      //}
      //Right
      if (ball.cent.x > 600 - ball.r){
        ball.cent.x = 600 - ball.r;
        ball.vel.x *= -0.8;
      }
      //Left
      if (ball.cent.x < ball.r){
        ball.cent.x = ball.r;
        ball.vel.x *= -0.8;
      }
    }
    if (ball.vel.length() >= 400){
      ball.vel.normalize();
      ball.vel.mul(400);
    }
    ball.cent.add(ball.vel.new_mul(dt));
  }
  //for (Ball particle : particles){
  //  particle.cent.add(particle.vel.new_mul(dt));
  //  particles.remove(particle.idx);
  //}
  for (int i = particles.size() - 1; i >= 0; i--){
    Ball particle = particles.get(i); //<>//
    particle.cent.add(particle.vel.new_mul(dt));
    particle.time -= dt;
    
    if (particle.time <= 0){
      particles.remove(i);
    }
  }
}

void draw(){
  if (!isPaused){
    computePhysics(1.0/60.0);

    ////draw
    background(img);
    //lights();
    textSize(15);
    fill(255, 255, 255);
    text(score, 300, 20);
    fill(ballColor); 
    ambientLight(102, 102, 102);
    lightSpecular(204, 204, 204);
    directionalLight(102, 102, 102, -1, 1, -1);
    specular(255, 255, 255);
    shininess(1.0);
    for (Ball ball : balls){
      translate(ball.cent.x, ball.cent.y, 0);
      fill(ballColor);
      sphere(ball.r);
      translate(-ball.cent.x, -ball.cent.y, 0);
    }
    for (Sphere2 sphere : spheres){
      translate(sphere.cent.x, sphere.cent.y, 0);
      fill(lerpColor(sphereColor, lerpMax, sphere.time));
      if (sphere.time > 0.0){
        sphere.time -= 2.0/frameRate;
      }
      sphere(sphere.r);
      translate(-sphere.cent.x, -sphere.cent.y, 0);
    }
    for (Ball particle : particles){
      translate(particle.cent.x, particle.cent.y, 0);
      fill(ballColor, particle.time * 2 * 255);
      sphere(particle.r);
      translate(-particle.cent.x, -particle.cent.y, 0);
    }
  }
}
