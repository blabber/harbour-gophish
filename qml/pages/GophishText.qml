import QtQuick 2.2
import Sailfish.Silica 1.0

GophishPage {
	id: gophishText

	BusyIndicator {
		running: gophishText.loading
		anchors.centerIn: parent
		size: BusyIndicatorSize.Large
	}

	SilicaFlickable {
		id: textFlickable
		anchors.fill: parent
		contentWidth: textColumn.width
		contentHeight: textColumn.height + Theme.paddingLarge

		Column {
			id: textColumn
			width: {
				var w = textLabel.width + 2*Theme.horizontalPageMargin;
				return w < gophishText.width ? gophishText.width : w;
			}

			PageHeader {
				title: gophishText.host
				description: gophishText.selector
				visible: !gophishText.loading
			}

			Row {
				Item {
					width: Theme.horizontalPageMargin
					height: 1
				}

				Label {
					id: textLabel
					color: Theme.highlightColor

					Component.onCompleted: {
						gophishText.readText();
					}

					font {
						pixelSize: Theme.fontSizeTiny
						family: 'monospace'
					}
				}
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
