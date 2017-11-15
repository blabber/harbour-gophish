"""Contains functions and classes to generate and perform gopher requests."""

import socket
from urllib.parse import urlparse

class Request:
    """Represents a gopher request.

    The request can be performed using the get_raw_data method.
    """

    encodings = {}

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

        Communication with the server is encoded in UTF-8. If the received
        data can't be decoded using UTF-8, it is interpreted as Latin-1
        encoded. If the dara can be decoded using Latin-1, all further
        communication with the server will be encoded in Latin-1 (That implies,
        that the first selector send to any server is always encoded as UTF-8).
        """
        b = b''
        with socket.create_connection((self.host, self.port), timeout) as s:
            s.settimeout(None)
            with s.makefile(mode='brw') as f:
                f.write((self.selector+'\r\n').encode(self.encoding()))
                f.flush()
                b = f.read()

        try:
            bs = str(b, encoding=self.encoding())
            return bs
        except UnicodeDecodeError:
            bs = str(b, encoding='latin-1')
            self.override_encoding('latin-1')
            return bs

    def encoding(self):
        """Returns the encoding used in communication with the server.

        By default the communication is UTF-8 encoded, but the encoding can be
        overriden, using the override_encoding method.
        """
        key = '{0}:{1}'.format(self.host, self.port)

        if not key in Request.encodings:
            print('Default encoding for {0}: utf-8'.format(key))
            return 'utf-8'

        e = Request.encodings[key]
        print('Registered encoding for {0}: {1}'.format(key, e))
        return e

    def override_encoding(self, encoding):
        """Overrides the encoding used in communication with the server.

        All following communication with the server, by this or any other
        Request instances, will use the new encoding.
        """
        old = self.encoding()
        if old != encoding:
            key = '{0}:{1}'.format(self.host, self.port)
            Request.encodings[key] = encoding
            print('Override encoding for {0}: {1} -> {2}'.format(
                key, old, encoding))

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

