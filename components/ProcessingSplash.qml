// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

Rectangle {
    id: root
    color: "white"
    visible: false
    z:11
    property alias messageText: messageTitle.text
    property alias heightProgressText : heightProgress.text

    width: 200 * scaleRatio
    height: 100 * scaleRatio
    opacity: 0.7

    function show() {
        root.visible = true;
    }

    function close() {
        root.visible = false;
    }

    ColumnLayout {
        id: rootLayout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        anchors.leftMargin: 30 * scaleRatio
        anchors.rightMargin: 30 * scaleRatio

        BusyIndicator {
            running: parent.visible
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }

        Text {
            id: messageTitle
            text: "Please wait..."
            font {
                pixelSize: 22 * scaleRatio
            }
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillWidth: true
        }


        Text {
            id: heightProgress
            font {
                pixelSize: 18 * scaleRatio
            }
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.fillWidth: true
        }
    }
}
