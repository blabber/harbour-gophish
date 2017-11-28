import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
	property string url
	property string selector
	property string host

	id: gophishQuery
	canAccept: queryField.text.length > 0
	allowedOrientations: Orientation.All

	Column {
		width: parent.width

		DialogHeader { }

		TextField {
			id: queryField
			width: parent.width
			placeholderText: 'Your query'
			label: 'Query'

			Component.onCompleted: queryField.forceActiveFocus()

			EnterKey.enabled: gophishQuery.canAccept;
			EnterKey.iconSource: 'image://theme/icon-m-search'
			EnterKey.onClicked: gophishQuery.accept();
		}
	}

	onAccepted: {
		var r = controller.parse_url(gophishQuery.url);
		var u = 'gopher://' + r['host'] + ':' + r['port'] + '/1' +
			r['selector'] + '\t' + queryField.text;

		pageStack.completeAnimation();
		pageStack.pop();
		pageStack.completeAnimation();
		controller.open_url(u);
	}
}
