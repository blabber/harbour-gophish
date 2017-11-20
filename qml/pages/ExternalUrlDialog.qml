import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
	property alias url: urlLabel.text

	id: externalUrlDialog
	allowedOrientations: Orientation.All

	Column {
		spacing: Theme.paddingLarge
		width: parent.width

		DialogHeader { }

		Label {
			anchors {
				left: parent.left
				right: parent.right
				margins: Theme.horizontalPageMargin
			}

			width: parent.width
			color: Theme.secondaryHighlightColor
			wrapMode: Text.Wrap
			text: 'gophish will invoke the default handler for the following URL:'
		}

		Label {
			anchors {
				left: parent.left
				right: parent.right
				margins: Theme.horizontalPageMargin
			}

			width: parent.width
			id: urlLabel
			color: Theme.highlightColor
			wrapMode: Text.Wrap
		}

		Label {
			anchors {
				left: parent.left
				right: parent.right
				margins: Theme.horizontalPageMargin
			}

			width: parent.width
			color: Theme.secondaryHighlightColor
			wrapMode: Text.Wrap
			text: 'If nothing happens, there is probably  no handler for the URL scheme istalled.'
		}
	}

	onDone: {
		if (result == DialogResult.Accepted) {
			Qt.openUrlExternally(externalUrlDialog.url)
			pageStack.completeAnimation();
			pageStack.pop();
		}
	}
}
