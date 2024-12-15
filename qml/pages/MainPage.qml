import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    function start() {
        python.call("server.os.path.isdir", [settingsPage.directory], function (result) {
            if (result !== true) {
                Notices.show(qsTr("Invalid directory selected!"), Notice.Short, Notice.Center)
                return
            }

            logArea.text = "\nWunderFTP v" + settingsPage.version + "\n"
            clear_log()
            quick_log(qsTr("Started"))
            python.call("server.ftp_server.start", [settingsPage.directory, settingsPage.port], function(result) {
                settingsPage.running = true
                python.call("server.get_ip", [], function (result) {
                    addressField.text = result + ":" + settingsPage.port
                })
            })
        })
    }

    function stop() {
        python.call("server.ftp_server.stop", [], function(result) {
            logArea.text = "\nWunderFTP v" + settingsPage.version + "\n"
            clear_log()
            quick_log(qsTr("Stopped"))
            settingsPage.running = false
        })
    }

    function get_clock() {
        var now = new Date()
        var hours = now.getHours()
        var minutes = now.getMinutes()
        var seconds = now.getSeconds()
        if (hours < 10) hours = "0" + hours
        if (minutes < 10) minutes = "0" + minutes
        if (seconds < 10) seconds = "0" + seconds

        var clock = hours + ":" + minutes + ":" + seconds
        return clock
    }

    function quick_log(line) {
        var time = get_clock()
        logArea.text += "\n[" + time + "] " + line
    }

    function log(line) {
        var time = get_clock()
        logPage.logArea.text += "\n[" + time + "] " + line
    }

    function clear_log() {
        logPage.logArea.text = ""
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(aboutPage)
            }

            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(settingsPage)
            }

            MenuItem {
                text: qsTr("Start")
                onClicked: start()
                visible: settingsPage.running === false
            }

            MenuItem {
                text: qsTr("Stop")
                onClicked: stop()
                visible: settingsPage.running === true
            }

            MenuItem {
                text: qsTr("Full log")
                onClicked: pageStack.push(logPage)
                visible: settingsPage.running === true
            }

        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("WunderFTP")
            }

            TextField {
                id: addressField
                label: "Address"
                visible: settingsPage.running === true
                readOnly: true
                anchors.horizontalCenter: parent.horizontalCenter
                width: page.width
            }

            Label {
                text: qsTr("Log")
                x: Theme.horizontalPageMargin
                color: Theme.highlightColor
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeLarge
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

                Component.onCompleted: {
                    text = "\n" + qsTr("WunderFTP") + " v" + settingsPage.version
                }
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

           Button {
               text: qsTr("Start")
               anchors.horizontalCenter: parent.horizontalCenter
               onClicked: page.start()
               visible: settingsPage.running === false
           }

           Button {
               text: qsTr("Stop")
               anchors.horizontalCenter: parent.horizontalCenter
               onClicked: page.stop()
               visible: settingsPage.running === true
           }

           Item {
               width: page.width
               height: Theme.paddingLarge
           }

           VerticalScrollDecorator { }
        }
    }
}
