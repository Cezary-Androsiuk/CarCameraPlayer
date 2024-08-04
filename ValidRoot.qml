import QtQuick 2.15

Item {
    id: validRoot
    anchors.fill: parent

    property bool frontIsMainCamera: true
    property int viewType: 0

    /// decide what video is main, and what is alternative one
    readonly property string mainVideoPath: frontIsMainCamera ? VideoPath.frontVideoFile : VideoPath.backVideoFile
    readonly property string alternativeVideoPath: frontIsMainCamera ? VideoPath.backVideoFile : VideoPath.frontVideoFile

    onFrontIsMainCameraChanged: {
        console.log(mainVideoPath, " ", alternativeVideoPath)
    }

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

        Item{
            id: changeViewButtonField
            anchors{
                left: swCamButtonField.right
                verticalCenter: swCamButtonField.verticalCenter
            }
            height: parent.height * 0.9
            width: height

            BetterButtonText{
                text: "change view"
                onClicked:{
                    if(validRoot.viewType === 0)
                        validRoot.viewType = 1;
                    else if(validRoot.viewType === 1)

                        validRoot.viewType = 0;
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
                if(viewType === 0)
                    mainVideoArea1
                else if(viewType === 1)
                    mainVideoArea1
            }

            Text{
                anchors.centerIn: parent
                text: mainVideoPath
            }

            Rectangle{
                anchors.fill: parent
                color: frontIsMainCamera ? "blue" : "green"
            }
        }

        Item{
            id: alternativeVideoContainer
            anchors.fill: {
                if(viewType === 0)
                    alternativeVideoArea1;
                else if(viewType === 1)
                    alternativeVideoArea2;
            }

            Text{
                anchors.centerIn: parent
                text: alternativeVideoPath
            }

            Rectangle{
                anchors.fill: parent
                color: frontIsMainCamera ? "green" : "blue"
            }
        }
    }

}
