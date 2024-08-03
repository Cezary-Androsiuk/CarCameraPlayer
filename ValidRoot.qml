import QtQuick 2.15

Item {
    id: validRoot
    anchors.fill: parent

    property bool frontIsMainCamera: true

    Item{
        id: lbContainer
        anchors{
            top: parent.top
            bottom: footer.top
            left: parent.left
        }
        width: parent.width * 0.08
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
            bottom: footer.top
            right: parent.right
        }
        width: parent.width * 0.08

        BetterButtonText{
            text: ">"
            onClicked:{
                Backend.goToNextVideo()
            }
        }
    }

    Item{
        id: footer
        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: parent.height * 0.1

        Item{
            id: swCamButtonField
            anchors{
                centerIn: parent
            }
            height: parent.height * 0.9
            width: height

            BetterButtonText{
                text: "@"
                onClicked:{
                    validRoot.frontIsMainCamera = !validRoot.frontIsMainCamera;
                }
            }
        }
    }

    Item{
        id: videoContainer
        anchors{
            top: parent.top
            left: lbContainer.right
            right: rbContainer.left
            bottom: footer.top
        }

        Rectangle{
            anchors.fill: parent
            color: "orange"
        }
    }

}
