"""Contains the glue code, that allows the QML components to use the gopher
module.
"""

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
    r = gopher.request.request_from_url(url)

    items = []
    for i in gopher.menu.read_menu(r):
        items.append({'type':i.type, 'user_name':i.user_name, 'selector':i.selector,
            'host':i.host, 'port':i.port, 'url':i.url()})

    return(items)

def read_text(url):
    """Reads a text item identifed by a gopher URL and returns the content.

    Line separators are replaces with the local systems native line separator.
    """
    r = gopher.request.request_from_url(url)
    return gopher.text.read_text(r)

