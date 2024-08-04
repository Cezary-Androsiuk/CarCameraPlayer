import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Imagine

Item {
    id: validRoot
    anchors.fill: parent

    property bool frontIsMainCamera: true
    property int viewType: 0

    /// decide what video is main, and what is alternative one
    readonly property string mainVideoPath: frontIsMainCamera ? VideoPath.frontVideoFile : VideoPath.backVideoFile
    readonly property string alternativeVideoPath: frontIsMainCamera ? VideoPath.backVideoFile : VideoPath.frontVideoFile

    property bool playing: false

    // Backend.goToPrevVideo()

    // Backend.goToNextVideo()

    Item{
        id: footer
        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: {
            var h = parent.height * 0.1;
            if(h < 60) 60;
            else h;
        }
        onHeightChanged: console.log(height)

        Item{
            id: buttonsContainer
            anchors{
                top: parent.top
                leftMargin: 20
                left: parent.left
                rightMargin: 20
                right: parent.right
                bottom: sliderContainer.top
            }
            Rectangle{anchors.fill: parent; color: "blue"}

            Button{
                id: switchCamerasButton
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: rowLayout.left
                    rightMargin: 20
                }
                height: buttonsContainer.height * 0.9
                width: height

                icon.source: Qt.resolvedUrl("assets/icons/switch.svg")

                onClicked: validRoot.frontIsMainCamera = !validRoot.frontIsMainCamera;

                display: AbstractButton.IconOnly
            }

            Row{
                id: rowLayout
                anchors.centerIn: parent
                spacing: 2
                Button {
                    height: buttonsContainer.height * 0.9
                    width: height
                    Component.onCompleted: console.log("h:" + height + " w:" + width)
                }

                Button {
                    id: playButton
                    height: buttonsContainer.height * 0.9
                    width: height

                    icon.source: {
                        if(validRoot.playing)
                            Qt.resolvedUrl("assets/icons/pause.svg")
                        else
                            Qt.resolvedUrl("assets/icons/play.svg")
                    }
                    icon.height: height *2
                    icon.width: width *2

                    onClicked: validRoot.playing = !validRoot.playing

                    display: AbstractButton.IconOnly
                }

                Button {
                    height: buttonsContainer.height * 0.9
                    width: height
                }
            }

            Button{
                id: viewTypeButton
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: rowLayout.right
                    leftMargin: 20
                }
                height: buttonsContainer.height * 0.9
                width: height

                icon.source: {
                    if(false);
                    else if(validRoot.viewType === 0) Qt.resolvedUrl("assets/icons/1.svg");
                    else if(validRoot.viewType === 1) Qt.resolvedUrl("assets/icons/2.svg");
                    // else if(validRoot.viewType === 2) Qt.resolvedUrl("assets/icons/3.svg");
                    // else if(validRoot.viewType === 3) Qt.resolvedUrl("assets/icons/4.svg");
                }

                onClicked:{
                    if(false);
                    else if(validRoot.viewType === 0) validRoot.viewType = 1;
                    else if(validRoot.viewType === 1) validRoot.viewType = 0;
                }

                display: AbstractButton.IconOnly
            }
        }

        Item{
            id: sliderContainer
            anchors{
                left: parent.left
                leftMargin: 20
                right: parent.right
                rightMargin: 20
                bottom: parent.bottom
            }
            height: parent.height * 0.4
            Rectangle{anchors.fill: parent; color: "red"}

            Slider{
                id: slider
                anchors.fill: parent

            }
        }
    }

    Item{
        id: videoContainer
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footer.top
        }

        /// main areas to atach videos
        Item{
            id: mainVideoArea1
            anchors.fill: parent
        }

        /// alternative areas to atach videos
        Item{
            id: alternativeVideoArea1
            anchors{
                right: parent.right
                bottom: parent.bottom
            }
            width: parent.width * 0.2
            height: parent.height * 0.2
        }
        Item{
            id: alternativeVideoArea2
            anchors{
                left: parent.left
                top: parent.top
            }
            width: parent.width * 0.2
            height: parent.height * 0.2
        }



        Rectangle{
            anchors.fill: parent
            color: "orange"
        }


        Item{
            id: mainVideoContainer
            anchors.fill: {
                if(false);
                else if(viewType === 0) mainVideoArea1
                else if(viewType === 1) mainVideoArea1
            }
            clip: true

            Text{
                anchors.fill: parent
                text: mainVideoPath
                wrapMode: Text.Wrap
            }

        }

        Item{
            id: alternativeVideoContainer
            anchors.fill: {
                if(false);
                else if(viewType === 0) alternativeVideoArea1;
                else if(viewType === 1) alternativeVideoArea2;
            }
            clip: true

            Text{
                anchors.fill: parent
                text: alternativeVideoPath
                wrapMode: Text.Wrap
            }

        }
    }

}
