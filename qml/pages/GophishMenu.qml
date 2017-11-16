import QtQuick 2.2
import Sailfish.Silica 1.0

GophishPage {
	id: gophishMenu

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

		PullDownMenu {
			MenuItem {
				text: 'Goto URL'
				onClicked: {
					pageStack.push('GotoUrlDialog.qml',
						{'url': gophishMenu.url});
				}
				enabled: !gophishMenu.loading
			}
		}

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
							} else if (type.toLowerCase() == 'h') {
								return 'HTM';
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

				onClicked: controller.open_url(url)
			}
		}

		VerticalScrollDecorator { flickable: menuFlickable }
		HorizontalScrollDecorator { flickable: menuFlickable }
	}

	function populateList() {
		menuList.itemWidth  = 0;
		gophishMenu.loading = true;

		if (!controller.initialized) {
			return;
		}

		controller.read_menu(url, function(items) {
			items.forEach(function(item) {
				menuListModel.append(item);
			});

			gophishMenu.loading = false;
		});
	}

	Connections {
		target: controller

		onInitializedChanged: {
			if (controller.initialized) {
				gophishMenu.populateList();
			}
		}
	}
}
