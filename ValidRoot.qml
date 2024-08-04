import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Imagine

import QtMultimedia

Item {
    id: validRoot
    anchors.fill: parent

    property bool frontIsMainCamera: true
    property int viewType: 0

    /// decide what video is main, and what is alternative one
    readonly property string mainVideoPath: frontIsMainCamera ? VideoPath.frontVideoFile : VideoPath.backVideoFile
    readonly property string alternativeVideoPath: frontIsMainCamera ? VideoPath.backVideoFile : VideoPath.frontVideoFile

    property bool playing: false
    onPlayingChanged: {
        if(playing){
            mainVideo.play();
            alternativeVideo.play();
        }
        else{
            mainVideo.pause();
            alternativeVideo.pause();
        }

    }

    property bool stoppedBySlider: false

    Item{
        id: footer
        anchors{
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        height: {
            var h = parent.height * 0.1;
            h < 75 ? 75 : h
        }

        Rectangle{
            anchors.fill: parent
            color: Qt.rgba(28/255, 27/255, 31/255)
        }

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

            ControlsPanel{

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
                bottomMargin: 5
            }
            height: parent.height * 0.4

            Slider{
                id: slider
                anchors.fill: parent

                from: 0
                to: 1//backend.player.duration
                onPressedChanged: {
                    if(!playing)
                        return;

                    // mute only audio instead
                    // if(pressed)
                    // {
                    //     pagePlayer.stoppedBySlider = true;
                    //     backend.player.play();
                    // }
                    // else
                    // {
                    //     if(pagePlayer.stoppedBySlider)
                    //     {
                    //         pagePlayer.stoppedBySlider = false;
                    //         backend.player.play();
                    //     }
                    // }
                }
                onMoved: {
                    // backend.player.position = value
                }

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


        /// smooth controls
        MouseArea {
            anchors.fill: parent
            onClicked: {
                validRoot.playing = !validRoot.playing
            }
        }

        Item{
            id: mainVideoContainer
            anchors.fill: {
                if(false);
                else if(viewType === 0) mainVideoArea1
                else if(viewType === 1) mainVideoArea1
            }
            clip: true

            Video{
                id: mainVideo
                anchors.fill: parent
                source: mainVideoPath

            }

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
                // else if(viewType === 2) alternativeVideoArea3;
                // else if(viewType === 3) alternativeVideoArea4;
            }
            clip: true

            Video{
                id: alternativeVideo
                anchors.fill: parent
                source: alternativeVideoPath
                muted: true
            }

            Text{
                anchors.fill: parent
                text: alternativeVideoPath
                wrapMode: Text.Wrap
            }
        }
    }

}
