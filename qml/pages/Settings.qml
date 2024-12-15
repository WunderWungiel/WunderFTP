import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page {

    id: page

    property int port
    property string directory
    property bool running
    property string version: "0.2-1"
    property string user

    signal userReady()

    function save() {
        settings.port = port
        settings.directory = directory
    }

    function load() {

        if (settings.port === 0) {
            settings.port = 8080
        }
        if (settings.directory === undefined || settings.directory === "") {
            settings.directory = "/home/" + user
        }

        port = settings.port
        directory = settings.directory

    }

    function get_user() {
        python.call("server.getuser", [], function (result) {
            user = result
            userReady()
        })
    }

    Component.onCompleted: {
        get_user()
        userReady.connect(function () {
            load()
        })
    }

    SilicaFlickable {

        anchors.fill: parent
        contentHeight: column.height

        Column {

            id: column
            width: page.width

            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Settings")
            }

            TextField {
                id: portField
                text: String(page.port)

                property var pattern: new RegExp(/^\d{4,5}$/)
                label: qsTr("Port (4/5 digits long)")

                inputMethodHints: Qt.ImhDigitsOnly
                acceptableInput: pattern.test(text)

                onTextChanged: {
                    saveButton.enabled = (pattern.test(text))
                }
            }

            ValueButton {
                id: directoryField
                anchors.horizontalCenter: parent.horizontalCenter
                value: page.directory
                onClicked: pageStack.push(folderPickerPage)
            }

            Button {
                id: saveButton
                text: qsTr("Save")
                onClicked: {
                    page.port = Number(portField.text)
                    page.save()
                    pageStack.pop(mainPage)
                }
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: false
            }

        }

    }

    ConfigurationGroup {
        id: settings
        path: "/apps/wunderftp"

        property int port
        property string directory
    }

}
