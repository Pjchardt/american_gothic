import processing.net.*; 
import gohai.glvideo.*;

Client myClient;
GLMovie video;
  
//import processing.video.*;
//Movie myMovie;

void setup() {
  noCursor();
  size(640,480,P2D);
  //fullScreen(P2D);
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  video = new GLMovie(this, "test1.mp4");
  video.loop();
}

void draw() {
  
  JSONObject json = PollServer();
  if (json == null) {
    println("JSONObject could not be parsed");
  } 
  else {
    float str_2 = json.getFloat("strength_2");
  }
  
  if (video.available()) {
   video.read(); 
  }
  image(video, 0, 0, width, height);
}

JSONObject PollServer() {
  JSONObject json = null;
  if (myClient.available() > 0) { 
    String inString = myClient.readString(); 
    println(inString); 
    json = parseJSONObject(inString);
  }
  return json;
}