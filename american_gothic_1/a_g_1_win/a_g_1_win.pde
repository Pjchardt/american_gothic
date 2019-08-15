import processing.net.*; 
import processing.video.*;

Client myClient;
Movie myMovie;

PFont font;
WordVis word_vis;

void setup() {
  noCursor();
  size(640,480,P2D);
  //fullScreen(P2D);
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  font = loadFont("Broadway-256.vlw");
  word_vis = new WordVis();
  
  myMovie = new Movie(this, "test1.mp4");
  myMovie.loop();
  
  word_vis.setup("test setup system ha ha");
}

void draw() {
  
  image(myMovie, 0, 0);
  word_vis.update();
 
  PollServer();
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
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
   textSize(300);
   fill(250,50,50);
   text(words.get(0), -25, -25, width+50, height+50);
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