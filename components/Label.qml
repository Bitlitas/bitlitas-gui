// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    id: item
    property alias text: label.text
    property alias color: label.color
    property alias textFormat: label.textFormat
    property string tipText: ""
    property int fontSize: 16 * scaleRatio
    property alias wrapMode: label.wrapMode
    property alias horizontalAlignment: label.horizontalAlignment
    signal linkActivated()
    width: icon.x + icon.width * scaleRatio
    height: icon.height * scaleRatio
    Layout.topMargin: 10 * scaleRatio

    Text {
        id: label
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2 * scaleRatio
        anchors.left: parent.left
        font.family: "Arial"
        font.pixelSize: fontSize
        color: "#555555"
        onLinkActivated: item.linkActivated()
    }

    Image {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: label.right
        anchors.leftMargin: 5 * scaleRatio
        source: "../images/whatIsIcon.png"
        visible: appWindow.whatIsEnable
    }

//    MouseArea {
//        anchors.fill: icon
//        enabled: appWindow.whatIsEnable
//        hoverEnabled: true
//        onEntered: {
//            icon.visible = false
//            var pos = appWindow.mapFromItem(icon, 0, -15)
//            tipItem.text = item.tipText
//            tipItem.x = pos.x
//            if(tipItem.height > 30)
//                pos.y -= tipItem.height - 28
//            tipItem.y = pos.y
//            tipItem.visible = true
//        }
//        onExited: {
//            icon.visible = Qt.binding(function(){ return appWindow.whatIsEnable; })
//            tipItem.visible = false
//        }
//    }
}
