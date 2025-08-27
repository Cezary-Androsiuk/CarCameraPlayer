import QtQuick
import QtQuick.Controls.Material
import QtQuick.Dialogs


ApplicationWindow {
    id: root
    width: 720
    height: 480
    visible: false

    Material.theme: Material.Dark
    minimumWidth: 400
    minimumHeight: 300

    function rgb(r, g, b, a = 255)
    {
        return Qt.rgba(r/255, g/255, b/255, a/255);
    }

    Component.onCompleted: {
        fileDialog.open();
    }


    Connections{
        target: Backend
        function onInvalidSelectedFile(reason)
        {
            mainLoader.setSource(
                        "InvalidRoot.qml",
                        {
                            "filePath": fileDialog.selectedFile,
                            "reason": reason,
                        })
        }

        function onValidSelectedFile()
        {
            mainLoader.setSource("ValidRoot.qml")
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select Front or Back video"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            Backend.setSelectedFile(fileDialog.selectedFile)
            // root.visible = true;
            root.showMaximized();

            // move window to top
            root.raise();
            root.requestActivate();
        }
        onRejected: {
            Qt.quit()
        }
    }

    Loader{
        id: mainLoader
        anchors.fill: parent
        source: ""
        onLoaded: {
            // if loader contains item
            if(mainLoader.item){
                // if that item contains signals "retried" and "exited"
                if(mainLoader.item.retried && mainLoader.item.exited){
                    // connect slots to them
                    mainLoader.item.retried.connect(function(){
                        console.log("user choosed retry")
                        root.hide()
                        fileDialog.open();
                    })
                    mainLoader.item.exited.connect(function(){
                        console.log("user choosed exit")
                        Qt.quit()
                    })
                }
                // if that item contains signals "retried" and "exited"
            }

        }
    }


}
