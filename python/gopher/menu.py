"""Contains functions and classes for the interaction with gopher menus and its
items.
"""

class MenuItem:
    """Represents an item in a gopher menu."""

    def __init__(self, type, user_name, selector, host, port):
        """Initializes a new MenuItem instance.

        The parameters correspond to the menu item components described in
        RFC1436.
        """
        self.type = type
        self.user_name = user_name
        self.selector = selector
        self.host = host
        self.port = port

    def url(self):
        """Returns a URL locating the menu item."""
        return str(self)

    def __eq__(self, other):
        """Returns True if the ManuItem other represents the same menu item."""
        return self.__dict__ == other.__dict__

    def __str__(self):
        """Returns a human readable representation of the MenuItem.

        At the moment, this method returns the gopher URL locating the menu
        item.
        """
        return 'gopher://{host}:{port}/{type}{selector}'.format(
            **self.__dict__)

    def __repr__(self):
        """Returns a string representation of the MenuItem."""
        return ("MenuItem('{type}', '{user_name}', '{selector}', '{host}', "
            "'{port}')").format(**self.__dict__)

def menuitem_from_raw_line(line):
    """Reads a line from a raw gopher menu and returns the corresponding
    MenuItem instance.

    As a special case, lines containing no '\t' seperators are interpreted as
    informational messages (item type 'i').
    """
    p = line.split('\t')

    if len(p) == 1:
        return MenuItem('i', p[0], '', 'fake', '70')

    return MenuItem(p[0][0], p[0][1:], p[1], p[2], p[3])

def read_menu(request):
    """Reads a gopher menu and returns a list of MenuItems.

    The menu that should be read is identified by request, a Request instance.
    """
    items = []

    for line in request.get_text_data().splitlines():
        if line == '.':
            break
        items.append(menuitem_from_raw_line(line))

    return items

