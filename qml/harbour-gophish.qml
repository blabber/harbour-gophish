import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

import "pages"

ApplicationWindow {
	cover: Component {
		CoverBackground {
			CoverPlaceholder {
				text: 'gophish'
			}
		}
	}

	initialPage: Component {
		GophishMenu {
			url: 'gopher://floodgap.com'
			host: 'floodgap.com'
			selector: ''
		}
	}

	Python {
		id: controller

		property bool initialized: false

		Component.onCompleted: {
			setHandler('gophishError', function(error) {
				pageStack.completeAnimation();
				pageStack.replace('pages/ErrorPage.qml', { 'error': error });
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

		function open_url(url) {
			console.log('open_url', url);

			var r = parse_url(url);
			var params = {'url': url, 'selector': r.selector, 'host': r.host};

			if (r.type == '0') {
				pageStack.push('pages/GophishText.qml', params);
			} else if (r.type == '1') {
				pageStack.push('pages/GophishMenu.qml', params);
			} else if (r.type == '7') {
				pageStack.push('pages/GophishQuery.qml', params);
			} else if (r.type.toLowerCase() == 'h') {
				pageStack.push('pages/GophishHtml.qml', params);
			}
		}

		function parse_url(url) {
			return call_sync('gophish.parse_url', [url]);
		}
	}
}
