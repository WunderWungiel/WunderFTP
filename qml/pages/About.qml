import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width

            PageHeader {
                title: qsTr("About")
            }

            Text {
                anchors {
                    left: parent.left;
                    right: parent.right;
                    margins: Theme.horizontalPageMargin
                }
                horizontalAlignment: Text.AlignHCenter
                text: "Simple FTP server app\n\nVersion: " + settingsPage.version + "\n"
                color: Theme.highlightColor
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeMedium
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }

            Button {
                text: qsTr("Homepage")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally("http://wunderwungiel.pl")
            }
        }

    }
}
