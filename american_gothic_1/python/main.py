import subprocess
import platform
import time

import server as SRV
import database as DB
import input_commands as IC

class Main(object):
    def __init__(self):
        #Setup server to communicate with Processing
        self.server_thread = SRV.ServerThread()
        self.server_thread.start()
        #Launch processing
        self.pro = self.load_processing()
        #Connect to firebase
        self.db = DB.PyrebaseDatabase()
        self.db.start("american_gothic")
        self.db.new_data_listener(self.new_data)
        #Setup input events
        IC.InputCommands(self.shutdown)

    def start(self):
        self.run()

    def run(self):
        self.run_loop = True
        #Loop until 'esc' pressed
        while self.run_loop:
            time.sleep(1)

    def new_data(self, args):
        print('send data to server: ', args)
        self.server_thread.send_data(args)

    def shutdown(self):
        print('stopping application')
        self.run_loop = False
        self.db.stop()
        try:
            self.server_thread.shutdown()
        except NameError:
            pass
        try:
            if platform.system() == "Windows":
                subprocess.call(["taskkill", "/F", "/T", "/PID", str(pro.pid)], shell = True)
            else:
                self.pro.kill()
        except NameError:
            pass

    def load_processing(self):
        if platform.system() == "Windows":
            process = subprocess.Popen('C:/Program Files/processing-3.3.5/processing-java --sketch="C:/Personal/AmericanGothic/americanGothic_1/americanGothic_1" --force --run')
        elif platform.system() == "Linux":
            process = subprocess.Popen('/home/...finish the path .../processing-3.3.5/processing-java', ['--sketch=/home/...finish the path.../pi_pyrebase_processing_template/Processing/client', '--force', '--run'])
        else:
            print("Whatever platform you are on this prject doesn't support it :(")
        return process

m = Main()
m.start()
