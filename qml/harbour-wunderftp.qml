import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import io.thp.pyotherside 1.5
import "pages"

ApplicationWindow {

    About {
        id: aboutPage
    }

    Log {
        id: logPage
    }

    MainPage {
        id: mainPage
    }

    Settings {
        id: settingsPage
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl("python/."))
            importModule("server", function() {})
            setHandler("log", function(log) {
                mainPage.log(log)
            })
        }
    }

    Component {
        id: folderPickerPage
        FolderPickerPage {
            dialogTitle: "Select path"
            onSelectedPathChanged: settingsPage.directory = selectedPath
        }
    }

    Component.onDestruction: mainPage.stop()

    initialPage: mainPage
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
