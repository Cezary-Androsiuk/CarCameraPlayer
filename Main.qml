import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: false
    title: qsTr("Hello World")

    function rgb(r, g, b, a = 255)
    {
        return Qt.rgba(r/255, g/255, b/255, a/255);
    }

    Component.onCompleted: {
        fileDialog.open();
    }


    Connections{
        target: Backend
        function onInvalidSelectedFile()
        {
            validRoot.visible = false;
            invalidRoot.visible = true;
        }

        function onValidSelectedFile()
        {
            invalidRoot.visible = false;
            validRoot.visible = true;
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select Front or Back video"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            Backend.setSelectedFile(fileDialog.selectedFile)
            root.visible = true;

            // move window to top
            root.raise();
            root.requestActivate();
        }
        onRejected: {
            Qt.quit()
        }
    }

    Item{
        id: validRoot
        anchors.fill: parent
        visible: false
        Item{
            id: lbContainer
            anchors{
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            width: parent.width * 0.1
            BetterButtonText{
                text: "<"
                onClicked:{
                    Backend.goToPrevVideo()
                }
            }
        }
        Item{
            id: rbContainer
            anchors{
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }
            width: parent.width * 0.1

            BetterButtonText{
                text: ">"
                onClicked:{
                    Backend.goToNextVideo()
                }
            }
        }
    }

    InvalidRoot{
        id: invalidRoot
        visible: false
        filePath: fileDialog.selectedFile

        onRetried: {
            console.log("user choosed retry")
            root.hide()
            fileDialog.open();
        }

        onExited: {
            console.log("user choosed exit")
            Qt.quit()
        }
    }


}
