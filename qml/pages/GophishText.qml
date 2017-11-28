import QtQuick 2.2
import Sailfish.Silica 1.0

GophishPage {
	id: gophishText

	ProgressBar {
		anchors.centerIn: parent
		width: parent.width - 2*Theme.horizontalPageMargin
		label: 'loading'
		indeterminate: true
		visible: gophishText.loading
	}

	SilicaFlickable {
		id: textFlickable
		anchors.fill: parent
		contentWidth: textColumn.width
		contentHeight: textColumn.height + Theme.paddingLarge

		PullDownMenu {
			MenuItem {
				text: 'Goto URL'
				onClicked: {
					pageStack.push('GotoUrlDialog.qml',
						{'url': gophishText.url});
				}
				enabled: !gophishText.loading
			}
		}

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

		if (!controller.initialized) {
			return;
		}

		controller.read_text(url, function(text) {
			textLabel.text = text
			gophishText.loading = false;
		});
	}

	Connections {
		target: controller

		onInitializedChanged: {
			if (controller.initialized) {
				gophishText.readText();
			}
		}
	}
}
