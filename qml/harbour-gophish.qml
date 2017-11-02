import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "pages"

ApplicationWindow
{
	initialPage: Component {
		GophishMenu { url: 'gopher://bitreich.org/1/lawn' }
	}

	Python {
		id: python

		property bool initialized: false

		Component.onCompleted: {
			addImportPath(Qt.resolvedUrl('../python'));
			importModule('gophish', function () { initialized = true } );
		}

		function read_menu(url, f) {
			if (!initialized) {
				console.log('skipped read_menu:', url);
				return;
			}

			call('gophish.read_menu', [url], f);
		}

		function read_text(url, f) {
			if (!initialized) {
				console.log('skipped read_text:', url);
				return;
			}

			call('gophish.read_text', [url], f);
		}
	}
}
