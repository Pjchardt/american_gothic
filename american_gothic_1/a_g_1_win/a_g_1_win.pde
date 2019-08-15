import processing.net.*; 
import processing.video.*;

Client myClient;
Movie myMovie;

void setup() {
  noCursor();
  size(640,480,P2D);
  //fullScreen(P2D);
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  myMovie = new Movie(this, "test1.mp4");
  myMovie.loop();
}

void draw() {
  
  JSONObject json = PollServer();
  if (json == null) 
  {
    println("JSONObject could not be parsed");
  } 
  else 
  {
    float str_2 = json.getFloat("strength_2");
  }
  
  image(myMovie, 0, 0);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
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