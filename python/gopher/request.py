"""Contains functions and classes to generate and perform gopher requests."""

import socket
from urllib.parse import urlparse

class Request:
    """Represents a gopher request.

    The request can be performed using the get_raw_data method.
    """

    def __init__(self, type, host, port='70', selector=''):
        """Initialized a new Request instance."""
        self.type = type
        self.host= host
        self.port = port
        self.selector = selector

    def get_raw_data(self, timeout=3.0):
        """Performs the gopher requests and returns the raw data as provided by
        the gopher server.

        The request will time out if no connection can be established in
        timeout seconds.

        Selectors are send as UTF-8 encoded strings. Data is read as binary
        data and then decoded into a UTF-8 string. If the decoding of the data
        fails, it is interpreted as Latin-1.
        """
        b = b''
        with socket.create_connection((self.host, self.port), timeout) as s:
            s.settimeout(None)
            with s.makefile(mode='brw') as f:
                f.write((self.selector+'\r\n').encode('utf-8'))
                f.flush()
                b =f.read()

        try:
            bs = str(b, encoding='utf-8')
            print('encoding: utf-8')
            return bs
        except UnicodeDecodeError:
            bs = str(b, encoding='latin-1')
            print('encoding: latin-1')
            return bs

    def __eq__(self, other):
        """Returns True if the other Request represents the same request."""
        return self.__dict__ == other.__dict__

    def __repr__(self):
        """Returns a string representation of the Request."""
        return "Request('{type}', '{host}', {port}, '{selector}')".format(
            **self.__dict__)

def request_from_url(url):
    """Parses a gopher URL and returns the corresponding Request instance."""
    pu = urlparse(url, scheme='gopher', allow_fragments=False)

    t = '1'
    s = ''
    if len(pu.path) > 2:
        t = pu.path[1]
        s = pu.path[2:]
    if len(pu.query) > 0:
        s = s + '?' + pu.query

    p = '70'
    if pu.port:
        p = str(pu.port)

    return Request(t, pu.hostname, p, s)

