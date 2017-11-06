import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
	property string url
	property string selector
	property string host
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
		contentHeight: menuList.height + Theme.paddingLarge

		ListView {
			property real itemWidth: 0

			id: menuList
			interactive: false
			width: menuList.itemWidth < gophishMenu.width ? gophishMenu.width : menuList.itemWidth;
			height: contentItem.childrenRect.height

			Component.onCompleted: {
				gophishMenu.populateList();
			}

			header: PageHeader {
				title: gophishMenu.host
				description: gophishMenu.selector
				visible: !gophishMenu.loading
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

						if (w > menuList.itemWidth) {
							menuList.itemWidth = w;
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
								return Theme.highlightColor
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
					var params = {'url': url, 'selector': selector, 'host': host};
					if (type == '0') {
						pageStack.push('GophishText.qml', params)
					} else if (type == '1') {
						pageStack.push('GophishMenu.qml', params)
					}
				}
			}
		}

		VerticalScrollDecorator { flickable: menuFlickable }
		HorizontalScrollDecorator { flickable: menuFlickable }
	}

	function populateList() {
		menuList.itemWidth  = 0;
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
