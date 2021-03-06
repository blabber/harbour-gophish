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
				text: 'Goto URL'
				onClicked: {
					pageStack.push('GotoUrlDialog.qml');
				}
				enabled: !gophishHtml.loading
			}
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

		if (!controller.initialized) {
			return;
		}

		controller.read_text(url, function(html) {
			gophishWebView.loadHtml(html, "");
			gophishHtml.loading = false;
		});
	}

	Connections {
		target: controller

		onInitializedChanged: {
			if (controller.initialized) {
				gophishHtml.readHtml();
			}
		}
	}
}
