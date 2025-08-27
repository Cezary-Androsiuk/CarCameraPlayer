import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material

Item{
    id: betterButtonText
    anchors.fill: parent

    required property string text
    property int fontSize: 14
    property bool borderVisible: false
    property double borderOpacity: 0.3


    property color elementIdleColor: root.rgb(255-48,255-47,255-48)
    onElementIdleColorChanged: {
        text.color = elementIdleColor
    }
    property color elementHoverColor: root.rgb(255-58,255-58,255-58)
    property color elementPressColor: root.rgb(255-68,255-68,255-68)

    property color backgroundIdleColor: root.rgb(48,47,48)
    property color backgroundHoverColor: root.rgb(58,58,58)
    property color backgroundPressColor: root.rgb(68,68,68)

    signal clicked()

    opacity: enabled ? 1.0 : 0.3

    Component.onCompleted: {
        background.color = backgroundIdleColor
        text.color = elementIdleColor
    }

    Rectangle{
        id: background
        anchors.fill: parent
        // radius: 4
    }

    Item{
        id: textContainer
        anchors{
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }
        clip: true

        Text{
            id: text
            width: parent.width
            height: parent.height

            text: betterButtonText.text
            font.pixelSize: betterButtonText.fontSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle{
        id: border
        anchors.fill: parent

        visible: betterButtonText.borderVisible
        color: "transparent"
        border.color: root.rgb(255, 255, 255)
        border.width: 1
        opacity: betterButtonText.borderOpacity
    }


    // below mouse area need to be copied to every component that emulate button
    // extracting it to the new component might now workout
    MouseArea{
        id: msArea
        anchors.fill: parent
        hoverEnabled: parent.enabled ? true : false

        // following code is emulating button fine and don't need any changes
        onEntered: {
            // change color to hover or to press color, if following action happend:
            // button was pressed, left area, and enter area again (constantly being pressed)
            text.color = msArea.containsPress ? betterButtonText.elementPressColor : betterButtonText.elementHoverColor
            background.color = msArea.containsPress ? betterButtonText.backgroundPressColor : betterButtonText.backgroundHoverColor
        }
        onExited: {
            // change color to idle
            text.color = betterButtonText.elementIdleColor
            background.color = betterButtonText.backgroundIdleColor
        }
        onPressed: {
            // change color to press
            text.color = betterButtonText.elementPressColor
            background.color = betterButtonText.backgroundPressColor
        }
        onReleased: {
            // change color to hover if mouse was relesed on area or if was relesed
            //     outside area to the idle color
            text.color = msArea.containsMouse ? betterButtonText.elementHoverColor : betterButtonText.elementIdleColor
            background.color = msArea.containsMouse ? betterButtonText.backgroundHoverColor : betterButtonText.backgroundIdleColor

            // if was relesed, still containing the mouse activate click
            if(msArea.containsMouse)
            {
                betterButtonText.clicked()
            }
        }
    }
}
