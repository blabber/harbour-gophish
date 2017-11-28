import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
	property alias url: urlField.text

	id: gotoUrlDialog
	canAccept: urlField.text.length > 0
	allowedOrientations: Orientation.All

	Column {
		width: parent.width

		DialogHeader {
			acceptText: 'Goto URL'
			cancelText: 'Cancel'
		}

		TextField {
			id: urlField
			width: parent.width
			placeholderText: 'gopher://'
			label: 'URL'
			focus: true
			inputMethodHints: {
				return Qt.ImhUrlCharactersOnly
					| Qt.ImhNoAutoUppercase
					| Qt.ImhNoPredictiveText;
			}

			Component.onCompleted: urlField.selectAll()

			EnterKey.enabled: gotoUrlDialog.canAccept
			EnterKey.iconSource: 'image://theme/icon-m-enter-accept'
			EnterKey.onClicked: gotoUrlDialog.accept()
		}
	}

	onAccepted: {
		var u = urlField.text
		if (u.length < 9 ||
			((u.length >= 9) &&
			(u.substring(0, 9).toLowerCase() != 'gopher://'))) {
			u = 'gopher://' + u;
		}

		pageStack.clear();
		controller.open_url(u);
	}
}
