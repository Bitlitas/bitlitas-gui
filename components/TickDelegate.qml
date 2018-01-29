// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0

Item {
    id: delegateItem
    width: 1
    height: 48
    property bool mainTick: false
    property int currentIndex
    property int currentX

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        visible: parent.mainTick
        source: "../images/privacyTick.png"

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            font.family: "Arial"
            font.bold: true
            font.pixelSize: 12 * scaleRatio
            color: "#4A4949"
            text: {
                if(currentIndex === 0) return qsTr("Default") + translationManager.emptyString
                if(currentIndex === 13) return qsTr("High") + translationManager.emptyString
                return ""
            }
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 14
        width: 1
        color: "#DBDBDB"
        height:  8
        visible: !parent.mainTick
    }
}
