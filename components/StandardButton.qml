// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    id: button
    height: 37 * scaleRatio
    property string shadowPressedColor: "#B32D00"
    property string shadowReleasedColor: "#306d30"
    property string pressedColor: "#306d30"
    property string releasedColor: "#499149"
    property string icon: ""
    property string textColor: "#FFFFFF"
    property int fontSize: 12 * scaleRatio
    property alias text: label.text
    signal clicked()

    // Dynamic label width
    Layout.minimumWidth: (label.contentWidth > 50)? label.contentWidth + 10 : 60

    function doClick() {
        // Android workaround
        releaseFocus();
        clicked();
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height - 1
        y: buttonArea.pressed ? 0 : 1
        //radius: 4
        color: {
            parent.enabled ? (buttonArea.pressed ? parent.shadowPressedColor : parent.shadowReleasedColor)
                           : Qt.lighter(parent.shadowReleasedColor)
        }
        border.color: Qt.darker(parent.releasedColor)
        border.width: parent.focus ? 1 : 0

    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height - 1
        y: buttonArea.pressed ? 1 : 0
        color: {
            parent.enabled ? (buttonArea.pressed ? parent.pressedColor : parent.releasedColor)
                           : Qt.lighter(parent.releasedColor)

        }
        //radius: 4


    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        font.family: "Arial"
        font.bold: true
        font.pixelSize: button.fontSize
        color: parent.textColor
        visible: parent.icon === ""
//        font.capitalization : Font.Capitalize
    }

    Image {
        anchors.centerIn: parent
        visible: parent.icon !== ""
        source: parent.icon
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        onClicked: doClick()
    }

    Keys.onSpacePressed: doClick()
    Keys.onReturnPressed: doClick()
}
