import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

import "pages"

ApplicationWindow
{
	initialPage: Component {
		GophishMenu {
			url: 'gopher://bitreich.org/1/lawn'
			host: 'bitreich.org'
			selector: '/lawn'
		}
	}

	Python {
		id: python

		property bool initialized: false

		Component.onCompleted: {
			setHandler('gophishError', function(error) {
				pageStack.completeAnimation();
				pageStack.replace('pages/ErrorPage.qml', { 'error': error});
			});			

			addImportPath(Qt.resolvedUrl('../python'));
			importModule('gophish', function () { initialized = true } );
		}

		onError: {
			console.log('got unhandled python error:', traceback);
		}

		onReceived: {
			console.log('got unhandled message from python', data)
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
