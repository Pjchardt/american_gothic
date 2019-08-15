import processing.net.*; 
import gohai.glvideo.*;

Client myClient;
GLMovie video;

JSONObject json;

final float BUFFER_UPDATE_DELAY = 5;
float buffer_timer = 0;
int last_time;

void setup() {
  noCursor();
  size(640,480,P2D);
  //fullScreen(P2D);
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  video = new GLMovie(this, "launch1.mp4");
  video.loop();
  
  last_time = millis();
}

void draw() {
  
  json = PollServer();
  
  if (video.playing() && video.available()) {
    if (json != null) {
      float time = json.getFloat("time_1") * video.duration();
      video.jump(time);
      json = null;
    }
     
    video.read();
  }
 
  image(video, 0, 0, width, height);
  
  buffer_timer += (millis() - last_time) / 1000.0;
  last_time = millis();
  if (buffer_timer > BUFFER_UPDATE_DELAY) {
    myClient.write(Float.toString(video.time() / video.duration()));
    buffer_timer -= BUFFER_UPDATE_DELAY;
  }
}

JSONObject PollServer() {
  JSONObject json = null;
  if (myClient.available() > 0) { 
    String inString = myClient.readString(); 
    println("New data: " +inString); 
    if (inString.contains("time_1") == false){
      return json;
    }
    json = parseJSONObject(inString);
    if (json == null) {
      println("JSONObject could not be parsed");
    } 
  }
  return json;
}
