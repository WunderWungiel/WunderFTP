import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("WunderFTP")
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: settingsPage.running === true ? "image://theme/icon-m-cancel" : "image://theme/icon-cover-play"
            onTriggered: settingsPage.running === true ? mainPage.stop() : mainPage.start()
        }
    }
}
