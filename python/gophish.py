"""Contains the glue code, that allows the QML components to use the gopher
module.
"""

import os
import sys
import traceback
import pyotherside
import gopher.request
import gopher.menu
import gopher.text

def read_menu(url):
    """Reads the menu identifed by a gopher URL and returns a list of
    dictionaries, representing the menu items.

    The keys of a menu item dictionary corresponds to the menu item components
    described in RFC1436: type, user_name, selector, host and port.
    
    An additional key url is provided for convenience. It contains the gopher
    URL locating the menu item.
    """
    items = []

    try:
        r = gopher.request.request_from_url(url)

        for i in gopher.menu.read_menu(r):
            items.append({'type':i.type, 'user_name':i.user_name,
                'selector':i.selector, 'host':i.host, 'port':i.port,
                'url':i.url()})

        return(items)
    except:
        send_gophish_error(sys.exc_info(), url)
    finally:
        return items

def read_text(url):
    """Reads a text item identifed by a gopher URL and returns the content.

    Line separators are replaces with the local systems native line separator.
    """
    text = ''

    try:
        r = gopher.request.request_from_url(url)
        text = gopher.text.read_text(r)
    except:
        send_gophish_error(sys.exc_info(), url)
    finally:
        return text

def send_gophish_error(ex, info=''):
    """Formats exception info in a string and sends it via the
    'gophishError' signal.

    ex is an exception info tuple as returned by sys.exc_info().

    Additional information to be displayed in the UI can be passed
    as info.

    As a side effect, the exception and a traceback are printed
    on the console.
    """
    traceback.print_exception(*ex)

    e = traceback.format_exception_only(ex[0], ex[1])
    if info != '':
        e = [info, ''] + e

    pyotherside.send('gophishError', os.linesep.join(e))

def parse_url(url):
    """Parses a gopher URL and returns a dictionary.

    The returned dictionary contains 'type', 'host', 'port', 'selector'.
    """
    r = gopher.request.request_from_url(url)
    return {'type': r.type, 'host': r.host, 'port': r.port,
        'selector': r.selector}
