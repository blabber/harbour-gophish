import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
	property string url
	property bool loading: true

	id: gophishMenu
	allowedOrientations: Orientation.All

	BusyIndicator {
		running: gophishMenu.loading
		anchors.centerIn: parent
		size: BusyIndicatorSize.Large
	}

	SilicaListView {
		id: menuList
		anchors.fill: parent

		Component.onCompleted: {
			gophishMenu.populateList();
		}

		model: ListModel { id: menuListModel }

		delegate: ListItem {
			id: menuListItem
			contentHeight: Theme.fontSizeTiny + Theme.paddingSmall
			enabled: typeLabel.text != '   '

			Row {
				width: parent.width
				spacing: Theme.paddingMedium

				anchors {
					verticalCenter: parent.verticalCenter
					left: parent.left
					leftMargin: Theme.horizontalPageMargin
				}

				Label {
					id: typeLabel

					text: {
						if (type == '1') {
							return 'DIR';
						}

						return '   ';
					}

					color: {
						return menuListItem.highlighted ?
							Theme.secondaryHighlightColor :
							Theme.secondaryColor;
					}

					font {
						pixelSize: Theme.fontSizeTiny
						family: 'monospace'
					}
				}

				Label {
					text: user_name

					color: {
						if (typeLabel.text == '   ') {
							return menuListItem.highlighted ?
								Theme.secondaryHighlightColor :
								Theme.secondaryColor;
						}

						return menuListItem.highlighted ?
							Theme.highlightColor :
							Theme.primaryColor;
					}

					font {
						pixelSize: Theme.fontSizeTiny
						family: 'monospace'
					}
				}
			}

			onClicked: pageStack.push('GophishMenu.qml', {'url': url})
		}

		VerticalScrollDecorator { flickable: menuList }
	}

	function populateList() {
		gophishMenu.loading = true;

		if (!python.initialized) {
			return;
		}

		python.read_menu(url, function(items) {
			items.forEach(function(item) {
				menuListModel.append(item);
			});

			gophishMenu.loading = false;
		});
	}

	Connections {
		target: python

		onInitializedChanged: {
			if (python.initialized) {
				gophishMenu.populateList();
			}
		}
	}
}
