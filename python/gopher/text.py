"""Contains functions to handle text items."""

import os

def read_text(request):
    """Reads a text item identified by a Request and returns the content.

    Line seperators are replaced by the local systems native line separators.
    """
    lines = []

    for line in request.get_text_data().splitlines():
        if line == '.':
            break
        lines.append(line)

    return os.linesep.join(lines)

