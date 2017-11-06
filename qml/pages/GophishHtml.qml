import QtQuick 2.2
import Sailfish.Silica 1.0

GophishPage {
	id: gophishHtml

	BusyIndicator {
		running: gophishHtml.loading || gophishWebView.loading
		anchors.centerIn: parent
		size: BusyIndicatorSize.Large
	}

	SilicaWebView {
		PullDownMenu {
			MenuItem {
				text: 'Open in external browser'
				onClicked: Qt.openUrlExternally(gophishWebView.url)
				enabled: gophishWebView.url != 'about:blank'
			}

			MenuItem {
				text: 'Back'
				onClicked: gophishWebView.goBack()
				enabled: gophishWebView.canGoBack
			}
		}

		id: gophishWebView
		anchors.fill: parent
		visible: !(gophishHtml.loading || loading)

		Component.onCompleted: {
			gophishHtml.readHtml();
		}

		VerticalScrollDecorator { flickable: gophishWebView }
		HorizontalScrollDecorator { flickable: gophishWebView }
	}

	function readHtml() {
		gophishHtml.loading = true;

		if (!python.initialized) {
			return;
		}

		if (isUrlSelector()) {
			gophishWebView.url = selector.substring(4, selector.length);
			gophishHtml.loading = false;
			return;
		}

		python.read_text(url, function(html) {
			gophishWebView.loadHtml(html, "");
			gophishHtml.loading = false;
		});
	}

	function isUrlSelector() {
		return ((selector.length > 4) && (selector.substring(0, 4) == 'URL:'));
	}

	Connections {
		target: python

		onInitializedChanged: {
			if (python.initialized) {
				gophishHtml.readHtml();
			}
		}
	}
}
