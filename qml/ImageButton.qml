import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import Qt5Compat.GraphicalEffects

Item{
    id: imageButton
    anchors.fill: parent

    property string dltDescription: ""
    required property string dltImageIdle
    required property string dltImageHover
    property bool dltBackgroundVisible: false
    property bool dltUsePopupColor: false
    property double dltImageMarginsRatio: 0.2
    onDltImageIdleChanged: {
        img.source = dltImageIdle // sometimes was not refresh it self
    }

    opacity: enabled ? 1.0 : 0.2

    // text colors
    property color dltTextIdleColor: Qt.rgba(230/255, 230/255, 230/255)
    property color dltTextHoverColor: Qt.rgba(180/255, 180/255, 180/255)
    property color dltTextPressColor: Qt.rgba(120/255, 120/255, 120/255)

    readonly property color fixedTextIdleColor: dltTextIdleColor
    readonly property color fixedTextHoverColor: dltBackgroundVisible ? dltTextIdleColor : dltTextHoverColor
    readonly property color fixedTextPressColor: dltTextPressColor

    // background colors
    property color dltBacgroundIdleColor: Qt.rgba(28/255, 27/255, 31/255)
    property color dltBackgroundHoverColor: Qt.rgba(48/255, 47/255, 51/255)

    property color dltBacgroundIdleColorPopup: Qt.rgba(66/255, 66/255, 66/255)
    property color dltBackgroundHoverColorPopup: Qt.rgba(96/255, 96/255, 96/255)

    readonly property color fixedBackgroundIdleColor: dltUsePopupColor ? dltBacgroundIdleColorPopup : dltBacgroundIdleColor
    readonly property color fixedBackgroundHoverColor: dltUsePopupColor ? dltBackgroundHoverColorPopup : dltBackgroundHoverColor

    readonly property color fixedBackgroundColor:
        msArea.containsMouse ? fixedBackgroundHoverColor : fixedBackgroundIdleColor





    property bool dltDarkThemeRefresh: true
    onDltDarkThemeRefreshChanged: {
        // force to refresh because can't find reason why this isn't
        //    allways refreshing after changing dark_theme state
        // i think that is caused by some interaction with containsMouse
        colorOverlay.color = fixedTextIdleColor
    }

    Rectangle{
        id: background
        anchors.fill: parent
        visible: dltBackgroundVisible
        color: fixedBackgroundColor
    }

    signal userClicked()
    Image{
        id: img
        fillMode: Image.PreserveAspectFit
        anchors{
            fill: parent
            margins: {
                var pw = parent.width * imageButton.dltImageMarginsRatio;
                var ph = parent.height * imageButton.dltImageMarginsRatio;

                (pw < ph) ? pw : ph;
            }
        }
        mipmap: true // smooths image

        source: dltImageIdle
    }

    ColorOverlay {
        id: colorOverlay
        anchors.fill: img
        source: img
        color: fixedTextIdleColor
    }


    // below mouse area need to be copied to every component that emulate button
    // extracting it to the new component might now workout
    MouseArea{
        id: msArea
        anchors.fill: parent
        hoverEnabled: parent.enabled ? true : false

        onContainsMouseChanged: {
            // console.log("new contains mouse: " + "" + (msArea.containsMouse && (dltDescription !== "")) + "" + msArea.containsMouse + "" + (dltDescription !== ""))
            // tooltip.
        }

        // following code is emulating button fine and don't need any changes
        onEntered: {
            // change image to hover
            img.source = dltImageHover;

            // change color to hover or to press color, if following action happend:
            // button was pressed, left area, and enter area again (constantly being pressed)
            colorOverlay.color = msArea.containsPress ? fixedTextPressColor : fixedTextHoverColor
        }
        onExited: {
            // change image to idle
            img.source = dltImageIdle;

            // change color to idle
            colorOverlay.color = fixedTextIdleColor
        }
        onPressed: {
            // change color to press
            colorOverlay.color = fixedTextPressColor
        }
        onReleased: {
            // change color to hover if mouse was relesed on area or if was relesed
            //     outside area to the idle color
            colorOverlay.color = msArea.containsMouse ? fixedTextHoverColor : fixedTextIdleColor

            // if was relesed, still containing the mouse activate click
            if(msArea.containsMouse)
            {
                tooltip.visible = false // cause sometimes in popup, tooltip doesn't turn off
                userClicked()
            }
        }

        ToolTip{
            id: tooltip
            visible: msArea.containsMouse && (dltDescription !== "") // && Backend.personalization.showTooltips
            // onVisibleChanged: {
            //     console.log("new visible: " + visible)
            // }

            text: dltDescription
            delay: 800
        }
    }

}
