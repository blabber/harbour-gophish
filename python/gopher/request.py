"""Contains functions and classes to generate and perform gopher requests."""

import socket
from urllib.parse import urlparse

class Request:
    """Represents a gopher request.

    The request can be performed using the get_raw_data method.
    """

    def __init__(self, host, port=70, selector=''):
        """Initialized a new Request instance."""
        self.host= host
        self.port = port
        self.selector = selector

    def get_raw_data(self):
        """Performs the gopher requests and returns the raw data as provided by
        the gopher server.
        """
        with socket.create_connection((self.host, self.port)) as s:
            with s.makefile(mode='rw') as f:
                print(self.selector, end='\r\n', file=f, flush=True)
                return f.read()

    def __eq__(self, other):
        """Returns True if the other Request represents the same request."""
        return self.__dict__ == other.__dict__

    def __repr__(self):
        """Returns a string representation of the Request."""
        return "Request('{host}', {port}, '{selector}')".format(
            **self.__dict__)

def request_from_url(url):
    """Parses a gopher URL and returns the corresponding Request instance."""
    pu = urlparse(url, scheme='gopher', allow_fragments=False)

    s = ''
    if len(pu.path) > 2:
        s = pu.path[2:]

    p = pu.port
    if not p:
        p = 70

    return Request(pu.hostname, p, s)

