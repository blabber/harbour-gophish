import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
	property string url
	property bool loading: true

	id: gophishText
	allowedOrientations: Orientation.All

	BusyIndicator {
		running: gophishText.loading
		anchors.centerIn: parent
		size: BusyIndicatorSize.Large
	}

	SilicaFlickable {
		id: textFlickable
		anchors.fill: parent
		contentWidth: textLabel.width
		contentHeight: textLabel.height

		Label {
			id: textLabel
			color: Theme.secondaryColor

			anchors {
				top: parent.top
				left: parent.left
				leftMargin: Theme.horizontalPageMargin
			}

			Component.onCompleted: {
				gophishText.readText();
			}

			font {
				pixelSize: Theme.fontSizeTiny
				family: 'monospace'
			}
		}

		VerticalScrollDecorator { flickable: textFlickable }
		HorizontalScrollDecorator { flickable: textFlickable }
	}

	function readText() {
		gophishText.loading = true;

		if (!python.initialized) {
			return;
		}

		python.read_text(url, function(text) {
			textLabel.text = text
			gophishText.loading = false;
		});
	}

	Connections {
		target: python

		onInitializedChanged: {
			if (python.initialized) {
				gophishText.readText();
			}
		}
	}
}
