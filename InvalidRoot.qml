import QtQuick 2.15
import QtQuick.Controls

Item {
    id: invalidRoot
    anchors.fill: parent

    signal retried()
    signal exited()

    readonly property bool showFields: false
    required property var filePath

    Item{
        id: center
        anchors.centerIn: parent
        width: 10
        height: 10

        Rectangle{
            anchors.fill: parent
            color: "black"
            visible: invalidRoot.showFields
        }
    }

    Item{
        id: textContainer
        height: parent.height/2
        width: parent.width
        anchors{
            bottom: center.top
            horizontalCenter: center.horizontalCenter
        }
        Rectangle{
            anchors.fill: parent
            color: "red"
            visible: invalidRoot.showFields
        }

        Text{
            anchors.centerIn: parent
            width: parent.width * 1/2
            height: parent.height * 2/3
            text: "file " + invalidRoot.filePath + " is not valid, are you want to retry?"
            wrapMode: Text.WordWrap
        }
    }

    Item{
        id: lbContainer
        anchors{
            top: center.bottom
            right: center.left
        }
        width: parent.width/2
        height: parent.height/2
        Rectangle{
            anchors.fill: parent
            color: "green"
            visible: invalidRoot.showFields
        }

        Button{
            id: lbButton
            text: "Retry"
            anchors{
                top: parent.top
                right: parent.right
                margins: 20
            }
            onClicked: {
                invalidRoot.retried();
            }
            width: 40*2
            height: 25*2
        }
    }

    Item{
        id: rbContainer
        anchors{
            top: center.bottom
            left: center.right
        }
        width: parent.width/2
        height: parent.height/2
        Rectangle{
            anchors.fill: parent
            color: "blue"
            visible: invalidRoot.showFields
        }

        Button{
            id: rbButton
            text: "Exit"
            anchors{
                top: parent.top
                left: parent.left
                margins: 20
            }
            onClicked: {
                invalidRoot.exited();
            }
            width: 40*2
            height: 25*2
        }
    }


}
