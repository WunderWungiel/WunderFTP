import os # for os.path.isdir
import threading
from io import StringIO
from contextlib import redirect_stderr
import re
from getpass import getuser # for getting user
import socket

from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import ThreadedFTPServer
import pyotherside

class Stream(StringIO):
    def __init__(self):
        super().__init__()
    def send(self, string):
        string = re.sub("^\[.+\]", "", string)
        string = re.sub("\s550\s\'.+\'", "", string)
        string = string.strip()
        if string:
            pyotherside.send("log", string)
    def write(self, string):
        super().write(string)
        self.send(string)
    def flush(self):
        pass

stream = Stream()

class FTPServerManager:
    def __init__(self):

        self.user = getuser()

        self.server = None
        self.thread = None

    def _run(self, directory, port):
        authorizer = DummyAuthorizer()
        try:
            authorizer.add_anonymous(directory, perm='elradfmwMT')
        except RuntimeWarning:
            pass

        handler = FTPHandler
        handler.authorizer = authorizer

        self.server = ThreadedFTPServer(("0.0.0.0", port), handler)
        with redirect_stderr(stream):
            self.server.serve_forever()

    def start(self, directory, port):
        if self.thread is not None and self.thread.is_alive():
            return
        self.thread = threading.Thread(target=self._run, args=(directory, port))
        self.thread.start()

    def stop(self):
        if self.server is not None:
            self.server.close_all()
            self.thread.join()
            self.server = None
            self.thread = None

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(0)
    s.connect(("8.8.8.7", 1))
    ip = s.getsockname()[0]

    return ip

ftp_server = FTPServerManager()
