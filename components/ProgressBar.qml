// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import bitlitasComponents.Wallet 1.0

Rectangle {
    id: item
    property int fillLevel: 0
    visible: false
    color: "#092709"

    function updateProgress(currentBlock,targetBlock, blocksToSync, statusTxt){
        if(targetBlock == 1) {
            fillLevel = 0
            progressText.text = qsTr("Establishing connection...");
            progressBar.visible = true
            return
        }

        if(targetBlock > 0) {
            var remaining = targetBlock - currentBlock
            // wallet sync
            if(blocksToSync > 0)
                var progressLevel = (100*(blocksToSync - remaining)/blocksToSync).toFixed(0);
            // Daemon sync
            else
                var progressLevel = (100*(currentBlock/targetBlock)).toFixed(0);
            fillLevel = progressLevel
            if(typeof statusTxt != "undefined" && statusTxt != "") {
                progressText.text = statusTxt + (" %1").arg(remaining.toFixed(0));
            } else {
                progressText.text = qsTr("Blocks remaining: %1").arg(remaining.toFixed(0));
            }



            progressBar.visible = currentBlock < targetBlock
        }
    }

    Item {
        anchors.leftMargin: 15 * scaleRatio
        anchors.rightMargin: 15 * scaleRatio
        anchors.fill: parent
        Rectangle {
            id: bar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 22 * scaleRatio
            radius: 2 * scaleRatio
            color: "#FFFFFF"

            Rectangle {
                id: fillRect
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: 2 * scaleRatio
                height: bar.height
                property int maxWidth: parent.width - 4 * scaleRatio
                width: (maxWidth * fillLevel) / 100
                color: {
                   if(item.fillLevel < 99 ) return "#499149"
                   //if(item.fillLevel < 99) return "#FFE00A"
                    return "#36B25C"
                }

            }

            Rectangle {
                color:"#333"
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 8 * scaleRatio

                Text {
                    id:progressText
                    anchors.bottom: parent.bottom
                    font.family: "Arial"
                    font.pixelSize: 12 * scaleRatio
                    color: "#000"
                    text: qsTr("Synchronizing blocks")
                    height:18 * scaleRatio
                }
            }
        }

    }



}
