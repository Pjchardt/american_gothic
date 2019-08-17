import processing.net.*; 
import gohai.glvideo.*;

Client myClient;
GLMovie video;

PFont font;
WordVis word_vis = new WordVis();

void setup() {
  noCursor();
  size(640,480,P2D);
  //fullScreen(P2D);
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  font = loadFont("Broadway-256.vlw");
  word_vis = new WordVis();
  word_vis.setup("hello world");
  
  video = new GLMovie(this, "a_m_video_2.mp4");
  video.loop();
}

void draw() {
  
  if (video.available()) {
    video.read();
  }
 
  image(video, 0, 0, width, height);
  word_vis.update();
  
  PollServer();
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
    String s = json.getString("ears_1");
    println("new data");
    word_vis.setup(s);
  }
}

class WordVis {
  StringList words = new StringList();
  float time_elapsed;
  int last_millis;

  void setup(String sentence) {
    String[] temp = split(sentence, " ");
    for (int i = 0; i < temp.length; i++) {
      words.append(temp[i]);
    }
    words.shuffle();
    
    new_word();
  }
  
  void update() {
   if (words.size() < 1) {
     return;
   }
   
   textFont(font, 32);
   textAlign(CENTER,CENTER);
   textSize(200);
   fill(250,50,50);
   text(words.get(0), -10, -10, width+20, height+20);
   time_elapsed += (millis() - last_millis) / 1000.0;
   last_millis = millis();
   if (time_elapsed > 3) {
     words.remove(0);
     new_word();
   } 
  }
  
  void new_word() {
    time_elapsed = 0;
    last_millis = millis();
  }
}
