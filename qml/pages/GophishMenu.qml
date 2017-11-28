import QtQuick 2.2
import Sailfish.Silica 1.0

GophishPage {
	id: gophishMenu

	ProgressBar {
		id: gophishMenuProgress

		anchors.centerIn: parent
		width: parent.width - 2*Theme.horizontalPageMargin
		label: 'loading'

		minimumValue: 0
		maximumValue: 0
		value: 0
		indeterminate: true

		visible: gophishMenu.loading
	}

	WorkerScript {
		id: gophishMenuWorker
		source: "listpopulator.js"

		onMessage: {
			gophishMenuProgress.maximumValue = messageObject.max;
			gophishMenuProgress.value = messageObject.current;
			gophishMenuProgress.indeterminate = false;
			gophishMenu.loading = !(messageObject.max == messageObject.current);
		}
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
			visible: !gophishMenu.loading

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
							} else if (type == '7') {
								return 'QRY';
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
			gophishMenuWorker.sendMessage({'model': menuListModel, 'items': items});
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
