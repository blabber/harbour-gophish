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

	SilicaFlickable{
		id: menuFlickable
		anchors.fill: parent
		contentWidth: menuList.width
		contentHeight: menuList.height

		ListView {
			id: menuList
			height: contentItem.childrenRect.height

			Component.onCompleted: {
				gophishMenu.populateList();
			}

			model: ListModel { id: menuListModel }

			delegate: ListItem {
				id: menuListItem
				contentHeight: Theme.fontSizeTiny + Theme.paddingSmall
				enabled: typeLabel.text != '   '

				Row {
					id: menuListItemRow
					spacing: Theme.paddingMedium

					Component.onCompleted: {
						var w = width + 2*Theme.horizontalPageMargin;
						if (w > menuList.width) {
							menuList.width = w;
						}
					}

					anchors {
						verticalCenter: parent.verticalCenter
						left: parent.left
						leftMargin: Theme.horizontalPageMargin
						rightMargin: Theme.horizontalPageMargin
					}

					Label {
						id: typeLabel

						text: {
							if (type == '0') {
								return 'TXT';
							} else if (type == '1') {
								return 'DIR';
							} else {
								return '   ';
							}
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

				onClicked: {
					if (type == '0') {
						pageStack.push('GophishText.qml', {'url': url})
					} else if (type == '1') {
						pageStack.push('GophishMenu.qml', {'url': url})
					}
				}
			}
		}

		VerticalScrollDecorator { flickable: menuFlickable }
		HorizontalScrollDecorator { flickable: menuFlickable }
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
