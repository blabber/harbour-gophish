import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
	property string url
	property string selector
	property string host
	property bool loading: true

	allowedOrientations: Orientation.All
}
