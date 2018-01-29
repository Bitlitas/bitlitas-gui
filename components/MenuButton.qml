// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0

Rectangle {
    id: button
    property alias text: label.text
    property bool checked: false
    property alias dotColor: dot.color
    property alias symbol: symbolText.text
    property int numSelectedChildren: 0
    property var under: null
    signal clicked()

    function doClick() {
        // Android workaround
        releaseFocus();
        clicked();
    }


    function getOffset() {
        var offset = 0
        var item = button
        while (item.under) {
            offset += 20 * scaleRatio
            item = item.under
        }
        return offset
    }

    color: checked ? "#FFFFFF" : "#092709"
    property bool present: !under || under.checked || checked || under.numSelectedChildren > 0
    height: present ? ((appWindow.height >= 800) ? 48 * scaleRatio  : 36 * scaleRatio ) : 0

    transform: Scale {
        yScale: button.present ? 1 : 0

        Behavior on yScale {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    Behavior on height {
        SequentialAnimation {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    Behavior on checked {
        // we get the value of checked before the change
        ScriptAction { script: if (under) under.numSelectedChildren += checked > 0 ? -1 : 1 }
    }

    Item {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.getOffset()
        width: 50 * scaleRatio

        Rectangle {
            id: dot
            anchors.centerIn: parent
            width: 14 * scaleRatio
            height: width
            radius: height / 2

            Rectangle {
                anchors.centerIn: parent
                width: 10 * scaleRatio
                height: width
                radius: height / 2
                color: "#092709"
                visible: !button.checked && !buttonArea.containsMouse
            }
        }

        Text {
            id: symbolText
            anchors.centerIn: parent
            font.pixelSize: 11 * scaleRatio
            font.bold: true
            color: button.checked || buttonArea.containsMouse ? "#FFFFFF" : dot.color
            visible: appWindow.ctrlPressed
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: "#DBDBDB"
        visible: parent.checked
    }

    Image {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20 * scaleRatio
        anchors.leftMargin: parent.getOffset()
        source: "../images/menuIndicator.png"
    }

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.getOffset() + 50 * scaleRatio
        font.family: "Arial"
        font.pixelSize: 16 * scaleRatio
        color: parent.checked ? "#000000" : "#FFFFFF"
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if(parent.checked)
                return
            button.doClick()
            parent.checked = true
        }
    }
}
