import json
import pyrebase
import re

from pymitter import EventEmitter

class PyrebaseDatabase(object):
    def __init__(self):
        with open('/home/pi/Documents/american_gothic/american_gothic_1/python/pyrebase_config.json') as f:
            config = json.load(f)
            #print()

        self.firebase = pyrebase.initialize_app(config)
        self.db = self.firebase.database()

    def start(self, node):
        self.ee = EventEmitter()
        self.new_data_listener(self.new_data_handler)
        self.my_stream = self.db.child(node).stream(self.stream_handler)

    def stop(self):
        print('closing stream to firebase')
        self.my_stream.close()

    def stream_handler(self, message):
            print(message["event"]) # put
            print(message["path"]) # /-K7yGTTEp7O549EzTYtI
            print(message["data"]) # {'title': 'Pyrebase', "body": "etc..."}
            s = json.dumps(message["data"])
            self.ee.emit("new_data_event", s)

    def new_data_handler(self, args):
        print(args)

    def new_data_listener(self, func):
        self.ee.on("new_data_event", func)
        
    def send_data(self, data):
        self.db.child("american_gothic").update({"buffer_1":data});
