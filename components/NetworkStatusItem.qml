// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import bitlitasComponents.Wallet 1.0

Rectangle {
    id: item
    property var connected: Wallet.ConnectionStatus_Disconnected

    function getConnectionStatusImage(status) {
        if (status == Wallet.ConnectionStatus_Connected)
            return "../images/statusConnected.png"
        else
            return "../images/statusDisconnected.png"
    }

    function getConnectionStatusColor(status) {
        if (status == Wallet.ConnectionStatus_Connected)
            return "#FF6C3B"
        else
            return "#AAAAAA"
    }

    function getConnectionStatusString(status) {
        if (status == Wallet.ConnectionStatus_Connected) {
            if(!appWindow.daemonSynced)
                return qsTr("Synchronizing")
            if(appWindow.remoteNodeConnected)
                return qsTr("Remote node")
            return qsTr("Connected")
        }
        if (status == Wallet.ConnectionStatus_WrongVersion)
            return qsTr("Wrong version")
        if (status == Wallet.ConnectionStatus_Disconnected)
            return qsTr("Disconnected")
        return qsTr("Invalid connection status")
    }


    color: "#092709"
    Row {
        height: 60 * scaleRatio
        Item {
            id: iconItem
            anchors.bottom: parent.bottom
            width: 50 * scaleRatio
            height: 50 * scaleRatio

            Image {
                anchors.centerIn: parent
                source: getConnectionStatusImage(item.connected)
            }
        }

        Column {
            anchors.bottom: parent.bottom
            height: 53 * scaleRatio
            spacing: 3 * scaleRatio

            Text {
                anchors.left: parent.left
                font.family: "Arial"
                font.pixelSize: 12 * scaleRatio
                color: "#545454"
                text: qsTr("Network status") + translationManager.emptyString
            }

            Text {
                anchors.left: parent.left
                font.family: "Arial"
                font.pixelSize: 18 * scaleRatio
                color: getConnectionStatusColor(item.connected)
                text: getConnectionStatusString(item.connected) + translationManager.emptyString
            }
        }
    }


}
