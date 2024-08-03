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
        console.log("visible: " + fileDialog.visible + ", " + invalidRoot.visible)
        fileDialog.open();
        console.log("__________________ ater open visible: " + fileDialog.visible + ", " + invalidRoot.visible)
    }


    Connections{
        target: Backend
        function onInvalidSelectedFile()
        {
            invalidRoot.visible = true;
            console.log("visible: " + fileDialog.visible + ", " + invalidRoot.visible)
        }

        function onValidSelectedFile()
        {
            validRoot.visible = true;
        }
    }

    FileDialog {
        id: fileDialog
        title: "Wybierz plik"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            console.log("Wybrany plik: " + fileDialog.selectedFile)
            Backend.setSelectedFile(fileDialog.selectedFile)
            root.visible = true;

            // move window to top
            root.raise();
            root.requestActivate();
            console.log("visible: " + fileDialog.visible + ", " + invalidRoot.visible)
        }
        onRejected: {
            console.log("Dialog został zamknięty bez wyboru pliku")
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
            root.visible = false;
            invalidRoot.visible = false;

            fileDialog.open();
            console.log("__________________ ater open visible: " + fileDialog.visible + ", " + invalidRoot.visible)
        }

        onExited: {
            console.log("user choosed exit")
            Qt.quit()
        }
    }


}
