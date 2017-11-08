import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
	property alias error: errorLabel.text

	allowedOrientations: Orientation.All

	SilicaFlickable {
		id: errorFlickable

		anchors.fill: parent
		contentHeight: errorColumn.height

		PullDownMenu {
			MenuItem {
				text: 'Goto URL'
				onClicked: {
					pageStack.push('GotoUrlDialog.qml');
				}
			}
		}

		Column {
			id: errorColumn

			anchors {
				left: parent.left
				right: parent.right
				margins: Theme.horizontalPageMargin
			}

			PageHeader {
				title: 'Error'
				description: 'Something went wrong'
			}

			Label {
				id: errorLabel

				width: parent.width
				wrapMode: Text.Wrap
				color: Theme.highlightColor
			}
		}

		VerticalScrollDecorator { flickable: errorFlickable }
	}
}
