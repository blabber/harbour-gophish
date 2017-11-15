gophish
=======

gophish is a native gopher client for SailfishOS.

Supported item types
--------------------

* `0` - text files
* `1` - gopher directories
* `h` - HTML documents
  * traditional `GET` requests
  * `URL:` links

Encoding
--------

[RFC 1436](https://www.ietf.org/rfc/rfc1436.txt) defines ASCII as the encoding
used by the gopher protocol, but this seems to be outdated by now. Being a
modern client, gophish supports two supersets of the ASCII encoding:

* UTF-8 (preferred)
* Latin-1

When first contacting a server, gophish will send a UTF-8 encoded selector.
This should be no problem, as long as the server is not using non-ASCII
characters in selectors (which is a bad idea anyway).

gophish tries to decode the data retrieved from the server using UTF-8 and if
that fails, it falls back to Latin-1. Once gophish had to fall back to Latin-1,
the server is marked as being Latin-1 encoded internally and all following
communication, including the selectors, will be encoded in Latin-1.

