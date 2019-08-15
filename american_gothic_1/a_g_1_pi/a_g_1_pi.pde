import processing.net.*; 
import gohai.glvideo.*;

Client myClient;
GLMovie video;

float time_elapsed;
int last_millis;
String s;

void setup() {
  noCursor();
  size(640,480,P2D);
  //fullScreen(P2D);
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  video = new GLMovie(this, "test1.mp4");
  video.loop();
}

void draw() {
  
  if (video.available()) {
    video.read();
  }
 
  image(video, 0, 0, width, height);
  
  PollServer();
  
  if (s != null){
    textSize(300);
    fill(250,50,50);
    text(s, -25, -25, width+50, height+50);
    time_elapsed += (millis() - last_millis) / 1000.0;
    println(time_elapsed);
    last_millis = millis();
    if (time_elapsed > 1) {
      s = null;
    }
  }
}

void PollServer() {
  if (myClient.available() > 0) { 
    String inString = myClient.readString(); 
    println("New data: " + inString); 
    JSONObject json = parseJSONObject(inString);
    if (json == null) {
      println("JSONObject could not be parsed");
      return;
    }
    s = json.getString("ears_1");
    println("new data");
    time_elapsed = 0;
    last_millis = millis();
  }
}
