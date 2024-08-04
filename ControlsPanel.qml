import QtQuick 2.15

Item {
    id: controlsPanel
    anchors.fill: parent

    Item{
        anchors{
            verticalCenter: parent.verticalCenter
            right: rowLayout.left
            rightMargin: 20
        }
        height: buttonsContainer.height
        width: height

        ImageButton{
            dltImageIdle: Qt.resolvedUrl("assets/icons/switch.svg")
            dltImageHover: dltImageIdle
            onUserClicked: {
                validRoot.frontIsMainCamera = !validRoot.frontIsMainCamera
            }
        }
    }

    Row{
        id: rowLayout
        anchors.centerIn: parent
        spacing: 2

        Item{
            height: buttonsContainer.height
            width: height

            ImageButton{
                dltImageIdle: Qt.resolvedUrl("assets/icons/prev.svg")
                dltImageHover: dltImageIdle
                onUserClicked: {
                    Backend.goToPrevVideo()
                }
            }
        }

        Item{
            height: buttonsContainer.height
            width: height

            ImageButton{
                dltImageIdle: {
                    if(validRoot.playing)
                        Qt.resolvedUrl("assets/icons/pause.svg")
                    else
                        Qt.resolvedUrl("assets/icons/play.svg")
                }
                dltImageHover: dltImageIdle
                onUserClicked: {
                    validRoot.playing = !validRoot.playing
                }
            }
        }

        Item{
            height: buttonsContainer.height
            width: height

            ImageButton{
                dltImageIdle: Qt.resolvedUrl("assets/icons/next.svg")
                dltImageHover: dltImageIdle
                onUserClicked: {
                    Backend.goToNextVideo()
                }
            }
        }
    }

    Item{
        anchors{
            verticalCenter: parent.verticalCenter
            left: rowLayout.right
            leftMargin: 20
        }
        height: buttonsContainer.height
        width: height

        ImageButton{
            dltImageIdle: {
                if(false);
                else if(validRoot.viewType === 0) Qt.resolvedUrl("assets/icons/1.svg");
                else if(validRoot.viewType === 1) Qt.resolvedUrl("assets/icons/2.svg");
                // else if(validRoot.viewType === 2) Qt.resolvedUrl("assets/icons/3.svg");
                // else if(validRoot.viewType === 3) Qt.resolvedUrl("assets/icons/4.svg");
            }
            dltImageHover: dltImageIdle
            onUserClicked: {
                if(false);
                else if(validRoot.viewType === 0) validRoot.viewType = 1;
                else if(validRoot.viewType === 1) validRoot.viewType = 0;
            }
        }
    }
}
