# Echo server program
import socket
import select

from threading import Thread

class ClientThread(Thread):
    def __init__(self,ip,port, conn):
        Thread.__init__(self)
        self.ip = ip
        self.port = port
        self.conn = conn
        self.run_thread = True
        print ("[+] New thread started for " + str(ip) + ":" +str(port))


    def run(self):
        while self.run_thread:
            print("running thread \n")
            try:
                data = self.conn.recv(2048)
            except:
                break
            if not data: break
            print ("received data:", data)
            self.conn.send("<Server> Got your data. Send some more\n")

    def close(self):
        print("closing thread")
        self.run_thread = False

    def send_data(self, data):
        self.conn.send(data.encode())

class ServerThread(Thread):

    TCP_IP = '127.0.0.1'
    TCP_PORT = 5005
    BUFFER_SIZE = 1024  # Normally 1024
    threads = []

    def __init__(self):
        Thread.__init__(self)
        self.run_server = True
        self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.server_socket.bind((self.TCP_IP, self.TCP_PORT))
        self.server_socket.listen(10)

    def run(self):
        read_sockets, write_sockets, error_sockets = select.select([self.server_socket], [], [])
        while self.run_server:
            print ("Waiting for incoming connections...")
            for sock in read_sockets:
                (conn, (ip,port)) = self.server_socket.accept()
                newthread = ClientThread(ip,port, conn)
                newthread.start()
                self.threads.append(newthread)

    def send_data(self, data):
        for t in self.threads:
            t.send_data(data)

    def shutdown(self):
        #shutdown clients
        for t in self.threads:
            t.close()
        #shitdown server
        self.run_server = False
        socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect( ('127.0.0.1', 5005))
        try:
            self.server_socket.shutdown(socket.SHUT_RDWR)
            self.server_socket.close()
        except:
            print("failed ot shutdown socket :(")
