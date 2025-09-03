import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Imagine

Item {
    id: controlsPanel
    anchors.fill: parent

    property double playbackSpeed: 1.0

    Rectangle{
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: switchButtonContainer.left
            right: alternativeVisibleButtonContainer.right
        }
        z: 2
        color: Qt.rgba(28/255, 27/255, 31/255)
    }

    Item{
        id: switchButtonContainer
        anchors{
            verticalCenter: parent.verticalCenter
            right: rowLayout.left
            rightMargin: 20
        }
        height: buttonsContainer.height
        width: height
        z: 2

        ImageButton{
            dltImageIdle: Qt.resolvedUrl("../assets/icons/replace.svg")
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
        z: 2

        Item{
            height: buttonsContainer.height
            width: height

            ImageButton{
                dltImageIdle: Qt.resolvedUrl("../assets/icons/prev.svg")
                dltImageHover: dltImageIdle
                onUserClicked: {
                    validRoot.playing = false
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
                        Qt.resolvedUrl("../assets/icons/pause.svg")
                    else
                        Qt.resolvedUrl("../assets/icons/play.svg")
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
                dltImageIdle: Qt.resolvedUrl("../assets/icons/next.svg")
                dltImageHover: dltImageIdle
                onUserClicked: {
                    validRoot.playing = false
                    Backend.goToNextVideo()
                }
            }
        }
    }

    Item{
        id: typeButtonContainer
        anchors{
            verticalCenter: parent.verticalCenter
            left: rowLayout.right
            leftMargin: 20
        }
        height: buttonsContainer.height
        width: height
        z: 2

        ImageButton{
            dltImageIdle: {
                if(false);
                else if(validRoot.viewType === 0) Qt.resolvedUrl("../assets/icons/0.svg");
                else if(validRoot.viewType === 1) Qt.resolvedUrl("../assets/icons/1.svg");
                else if(validRoot.viewType === 2) Qt.resolvedUrl("../assets/icons/2.svg");
                else if(validRoot.viewType === 3) Qt.resolvedUrl("../assets/icons/3.svg");
            }
            dltImageHover: dltImageIdle
            onUserClicked: {
                if(false);
                else if(validRoot.viewType === 0) validRoot.viewType = 1;
                else if(validRoot.viewType === 1) validRoot.viewType = 2;
                else if(validRoot.viewType === 2) validRoot.viewType = 3;
                else if(validRoot.viewType === 3) validRoot.viewType = 0;
            }
        }
    }

    Item{
        id: alternativeVisibleButtonContainer
        anchors{
            verticalCenter: parent.verticalCenter
            left: typeButtonContainer.right
            leftMargin: 20
        }
        height: buttonsContainer.height
        width: height
        z: 2

        ImageButton{
            dltImageIdle: {
                if(validRoot.alternativeVisible)
                    Qt.resolvedUrl("../assets/icons/visible.svg");
                else
                    Qt.resolvedUrl("../assets/icons/invisible.svg");
            }
            dltImageHover: dltImageIdle
            onUserClicked: validRoot.alternativeVisible = !validRoot.alternativeVisible
        }
    }

    Item{
        z: 1
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 20
        }
        height: buttonsContainer.height
        width: height

        Image{
            id: volumeIcon
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            height: buttonsContainer.height * 0.5
            width: height
            source: {
                if(validRoot.volume === 0) Qt.resolvedUrl("../assets/icons/volume_0.svg");
                else if(validRoot.volume > 0.0 && validRoot.volume <= 0.2) Qt.resolvedUrl("../assets/icons/volume_1.svg");
                else if(validRoot.volume > 0.2 && validRoot.volume <= 0.9) Qt.resolvedUrl("../assets/icons/volume_2.svg");
                else if(validRoot.volume > 0.9) Qt.resolvedUrl("../assets/icons/volume_3.svg");
            }
        }

        Slider{
            id: volumeSlider
            anchors{
                verticalCenter: parent.verticalCenter
                right: volumeIcon.left
                rightMargin: 10
            }
            height: buttonsContainer.height
            width: height*3

            from: 0
            to: 1
            value: 1
            onMoved: {
                validRoot.volume = value
            }
        }
    }

    Item{
        z: 1
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 20
        }
        height: buttonsContainer.height
        width: height

        Label{
            id: playbackSpeedLabel
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom

            font.bold: true
            font.pixelSize: 18

            height: parent.height * 0.5
            width: height * 2
            text: {
                var strPlaybackSpeed = controlsPanel.playbackSpeed.toString();
                var spsLength = strPlaybackSpeed.length;
                if(spsLength === 0) { // empty string
                    return "0.00" // exception case
                }
                else if(spsLength === 1) { // single number
                    return strPlaybackSpeed + ".00"
                }
                else if(spsLength === 3) { // one digit precision
                    return strPlaybackSpeed + "0";
                }
                else { // double digit precision
                    return strPlaybackSpeed;
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    playbackSpeedSlider.value = 1.0
                    controlsPanel.playbackSpeed = 1.0
                    console.log(buttonsContainer.height)
                }
            }

        }

        Label{
            anchors{
                top: parent.top
                topMargin: 4
                horizontalCenter: parent.horizontalCenter
            }
            visible: parent.height > 50
            font.pixelSize: 11
            opacity: 0.7
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            text: "Playback Speed"
        }

        Slider{
            id: playbackSpeedSlider
            anchors{
                verticalCenter: parent.verticalCenter
                left: playbackSpeedLabel.right
                leftMargin: 10
            }
            height: parent.height
            width: height*3

            from: 0.25
            to: 4 // realistic is 6
            value: 1
            stepSize: 0.25
            onMoved: {
                // above 2.0 step will be 0.5 not 0.25
                let modifiedValue = value
                if(modifiedValue >= 2.0)
                {
                    // double only values above 2.0
                    modifiedValue -= 2.0;
                    modifiedValue *= 2;
                    modifiedValue += 2.0;
                }

                controlsPanel.playbackSpeed = modifiedValue
            }
        }
    }

}
