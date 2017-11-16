import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
	property alias url: urlField.text

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
			inputMethodHints: {
				return Qt.ImhUrlCharactersOnly
					| Qt.ImhNoAutoUppercase
					| Qt.ImhNoPredictiveText;
			}

			Component.onCompleted: urlField.forceActiveFocus()
		}
	}

	onDone: {
		if (result == DialogResult.Accepted) {
			var u = urlField.text
			if (u.length < 9 || 
				((u.length >= 9) &&
					(u.substring(0, 9).toLowerCase() != 'gopher://'))) {
				u = 'gopher://' + u;
			}

			pageStack.clear();
			python.open_url(u);
		}
	}
}
