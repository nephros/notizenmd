import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import "pages"
import "components"

ApplicationWindow
{
    id: app
    //initialPage: Component { FirstPage { } }
    initialPage: Component{
        NotesBrowser {
            homePath: settings.notesLocation
            title: qsTr("Notes")
            nameFilters: settings.fileNameFilters.split(",")
            Component.onCompleted: {
                console.log(nameFilters, typeof nameFilters, nameFilters.length)

            }
        }
    }

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-notizenmd/settings"
        property string notesLocation: StandardPaths.documents
        property string fileNameFilters: ["*.md", "*.txt"].join(",")
        property int viewItemIndex: 0 //0: TextArea; 1: WebView
        property bool addExtensionOnCreate: false
        property bool editNoteOnCreate: false
    }

    // as ShareProvider is not supported on all SFOS releases the same way,
    // use a Loader for backwards compatability:
    property bool sharingAvailable: share.status === Loader.Ready
    onSharingAvailableChanged: {
        if (sharingAvailable) {
            console.info("Sharing activated.")
        }
    }
    Loader { id: share
        source: Qt.resolvedUrl("share/ShareComponent.qml")
    }

    FileIO {
        id: currentFile
    }

    Mistune {
        id: mistune
    }

}
