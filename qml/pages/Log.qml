import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property alias logArea:logArea

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Log")
            }

            Item {
                width: page.width
                height: Theme.paddingLarge
            }

            Rectangle {
                width: page.width * 0.9
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TextArea {
                id: logArea
                font.italic: true
                readOnly: true
                horizontalAlignment: TextInput.AlignHCenter
                wrapMode: TextInput.Wrap
                font.pixelSize: Theme.fontSizeSmall
           }

           Rectangle {
               width: page.width * 0.9
               height: 1
               anchors.horizontalCenter: parent.horizontalCenter
           }

           Item {
               width: page.width
               height: Theme.paddingLarge
           }

        }
    }
}
