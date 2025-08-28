import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Imagine

import QtMultimedia

Item {
    id: validRoot
    anchors.fill: parent

    property bool frontIsMainCamera: true
    property int viewType: 1
    property bool playing: false
    property real volume: 1.0
    onPlayingChanged: {
        if(!frontVideoLoader.item)
        {
            console.warn("front video is reloading... please wait")
            return;
        }

        if(playing){
            frontVideoLoader.item.frontVideoAlias.play();
            backVideo.play();
        }
        else{
            frontVideoLoader.item.frontVideoAlias.pause();
            backVideo.pause();
        }
    }
    property bool mutedBySlider: false
    property bool alternativeVisible: true

    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(28/255, 27/255, 31/255)
    }


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
                to: frontVideoLoader.item ? frontVideoLoader.item.frontVideoAlias.duration : 1
                value: frontVideoLoader.item ? frontVideoLoader.item.frontVideoAlias.position : 1
                onPressedChanged: {
                    if(!frontVideoLoader.item)
                    {
                        console.warn("front video is reloading... please wait")
                        return;
                    }

                    if(!playing)
                        return;

                    // mute only audio while seek
                    if(pressed)
                    {
                        validRoot.mutedBySlider = true;
                        frontVideoLoader.item.frontVideoAlias.muted = true
                    }
                    else
                    {
                        if(validRoot.mutedBySlider)
                        {
                            validRoot.mutedBySlider = false;
                            frontVideoLoader.item.frontVideoAlias.muted = false
                        }
                    }
                }
                onMoved: {
                    if(!frontVideoLoader.item)
                    {
                        console.warn("front video is reloading... please wait")
                        return;
                    }

                    frontVideoLoader.item.frontVideoAlias.position = value
                    backVideo.position = value
                }

            }
        }

        Rectangle{
            anchors{
                top: parent.top
                left: parent.left
                // leftMargin: 20
                right: parent.right
                // rightMargin: 20
            }
            height: 1
            color: Qt.rgba(230/255, 230/255, 230/255)
        }
    }

    Item{
        id: videoContainer
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footer.top
            bottomMargin: 2
        }

        Rectangle{
            anchors.fill: parent
            color: Qt.rgba(28/255, 27/255, 31/255)
        }

        /// decide what area should be used by main, and what by alternative
        readonly property var mainVideoAreaByType: {
            if(false);
            else if(viewType === 0) mainVideoArea1;
            else if(viewType === 1) mainVideoArea1;
            else if(viewType === 2) mainVideoArea1;
            else if(viewType === 3) mainVideoArea1;
        }
        readonly property var alternativeVideoAreaByType: {
            if(false);
            else if(viewType === 0) alternativeVideoArea0;
            else if(viewType === 1) alternativeVideoArea1;
            else if(viewType === 2) alternativeVideoArea2;
            else if(viewType === 3) alternativeVideoArea3;
        }

        /// decide what area is for front, and what is back one
        readonly property var frontVideoFill: frontIsMainCamera ? mainVideoAreaByType : alternativeVideoAreaByType
        readonly property var backVideoFill: frontIsMainCamera ? alternativeVideoAreaByType : mainVideoAreaByType

        /// main areas to atach videos
        Item{
            id: mainVideoArea1
            anchors.fill: parent
        }

        /// alternative areas to atach videos
        Item{
            id: alternativeVideoArea0
            anchors{
                left: parent.left
                top: parent.top
            }
            width: parent.width * 0.4
            height: parent.height * 0.4
        }
        Item{
            id: alternativeVideoArea1
            anchors{
                right: parent.right
                top: parent.top
            }
            width: parent.width * 0.4
            height: parent.height * 0.4
        }
        Item{
            id: alternativeVideoArea2
            anchors{
                right: parent.right
                bottom: parent.bottom
            }
            width: parent.width * 0.4
            height: parent.height * 0.4
        }
        Item{
            id: alternativeVideoArea3
            anchors{
                left: parent.left
                bottom: parent.bottom
            }
            width: parent.width * 0.4
            height: parent.height * 0.4
        }


        /// smooth controls
        MouseArea {
            anchors.fill: parent
            onClicked: {
                validRoot.playing = !validRoot.playing
            }
        }

        Item{
            id: frontVideoContainer
            anchors.fill: parent.frontVideoFill
            clip: true
            z: frontIsMainCamera ? 0 : 1 // if is alternative set on top
            visible: frontIsMainCamera ? true : alternativeVisible

            // Rectangle{anchors.fill: parent; color: "blue"}

            /*
              Due to only one video component playing sound, when audioOutputDevice change only this one will be recreated
            */

            Connections{
                target: AudioMonitor
                function onMainAudioDeviceChanged(){
                    console.log("main audio device changed")

                    if(!frontVideoLoader.item)
                    {
                        console.warn("front video is reloading... please wait")
                        return;
                    }

                    // get informations to restore player
                    let wasPlaying = frontVideoLoader.item.frontVideoAlias.playing
                    let playerLastPosition = frontVideoLoader.item.frontVideoAlias.position

                    // pause player
                    playing = false;
                    frontVideoLoader.item.frontVideoAlias.pause()
                    backVideo.pause()
                    console.log(frontVideoLoader.item.frontVideoAlias.status)

                    // remove old video component
                    frontVideoLoader.sourceComponent = null;

                    // after loader load it's item and after video was loaded restore player informations:
                    // let videoLoadedFunction = function(){
                    //     // no documentation about playbackState nor playbackStateChanged inside Video
                    //     // console.log("Playing state: ", MediaPlayer.PlayingState)
                    //     // console.log("Paused state: ", MediaPlayer.PausedState)
                    //     // console.log("Stopped state: ", MediaPlayer.StoppedState)
                    //     // console.log("playback state changed to: ", frontVideoLoader.item.frontVideoAlias.playbackState )

                    //     console.log("video loaded")

                    //     frontVideoLoader.item.frontVideoAlias.position = playerLastPosition
                    //     backVideo.position = playerLastPosition

                    //     if(wasPlaying)
                    //     {
                    //         frontVideoLoader.item.frontVideoAlias.play()
                    //         backVideo.play()
                    //     }
                    // }
                    // let loaderLoadedFunction = function(){
                    //     frontVideoLoader.item.frontVideoAlias.playbackStateChanged.connect(videoLoadedFunction)
                    // }

                    // frontVideoLoader.loaded.connect(loaderLoadedFunction)

                    // set new video component
                    frontVideoLoader.sourceComponent = frontVideoComponent;
                    let loadingCounter = 0
                    while(frontVideoLoader.status === Loader.Loading)
                    {
                        loadingCounter++;
                    }

                    console.log("loader loaded with counter: ", loadingCounter)

                    loadingCounter = 0
                    while(frontVideoLoader.item.frontVideoAlias.status === MediaPlayer.LoadingMedia)
                    {
                        loadingCounter++;
                    }
                    console.log("loader video with counter: ", loadingCounter, "status: ", frontVideoLoader.item.frontVideoAlias.status)

                    // disconnect ?
                }
            }

            Loader{
                id: frontVideoLoader
                anchors.fill: parent
                sourceComponent: frontVideoComponent

                Component{
                    id: frontVideoComponent
                    Item{
                        // without an item object anchors might freak out
                        anchors.fill: parent
                        property alias frontVideoAlias: frontVideo
                        Video{
                            id: frontVideo
                            anchors.fill: parent
                            source: VideoPath.frontVideoFile
                            onSourceChanged: { // buffer
                                play();
                                pause();
                                // frontVideo.pl
                            }

                            volume: validRoot.volume
                        }
                    }
                }
            }

        }

        Item{
            id: backVideoContainer
            anchors.fill: parent.backVideoFill
            clip: true
            z: frontIsMainCamera ? 1 : 0 // if is alternative set on top
            visible: frontIsMainCamera ? alternativeVisible : true

            // Rectangle{anchors.fill: parent; color: "red"}

            Video{
                id: backVideo
                anchors.fill: parent
                source: VideoPath.backVideoFile
                muted: true
                onSourceChanged: { // buffer
                    play();
                    pause()
                }
            }
        }
    }

}
