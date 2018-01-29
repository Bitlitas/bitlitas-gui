// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Controls 1.4
import bitlitasComponents.Wallet 1.0

Item {
    id: item
    property string message: ""
    property bool active: false
    height: 120
    width: 240
    property int margin: 15
    x: parent.width - width - margin
    y: parent.height - height * scale.yScale - margin * scale.yScale

    Rectangle {
        color: "#499149"
        border.color: "black"
        anchors.fill: parent

        TextArea {
            id:versionText
            readOnly: true
            backgroundVisible: false
            textFormat: TextEdit.AutoText
            anchors.fill: parent
            font.family: "Arial"
            font.pixelSize: 12
            textMargin: 20
            textColor: "white"
            text: item.message
        }
    }

    transform: Scale {
        id: scale
        yScale: item.active ? 1 : 0

        Behavior on yScale {
            NumberAnimation { duration: 500; easing.type: Easing.InOutCubic }
        }
    }

    Timer {
        id: hider
        interval: 12000; running: false; repeat: false
        onTriggered: { item.active = false }
    }

    function show(message) {
        item.visible = true
        item.message = message
        item.active = true
        hider.running = true
    }
}
