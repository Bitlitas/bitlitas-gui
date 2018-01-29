// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtGraphicalEffects 1.0
import "components"
import "pages"

// mbg033 @ 2016-10-08: Not used anymore, to be deleted

Rectangle {
    id: root
    width: 470
    // height: paymentId.y + paymentId.height + 12
    height: header.height + header.anchors.topMargin + transferBasic.height
    color: "#F0EEEE"

    border.width: 1
    border.color: "#DBDBDB"

    property alias balanceText : balanceText.text;
    property alias unlockedBalanceText : availableBalanceText.text;
    // repeating signal to the outside world
    signal paymentClicked(string address, string paymentId, string amount, int mixinCount,
                          int priority, string description)

    Connections {
        target: transferBasic
        onPaymentClicked: {
            console.log("BasicPanel: paymentClicked")
            root.paymentClicked(address, paymentId, amount, mixinCount, priority, description)
        }
    }


    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 1
        anchors.rightMargin: 1
        anchors.topMargin: 30
        height: 64
        color: "#FFFFFF"

        Image {
            id: logo
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -5
            anchors.left: parent.left
            anchors.leftMargin: 20
            source: "images/bitlitasLogo2.png"
        }

        Grid {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: 256
            columns: 3

            Text {

                width: 116
                height: 20
                font.family: "Arial"
                font.pixelSize: 12
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                color: "#535353"
                text: qsTr("Locked Balance:")
            }

            Text {
                id: balanceText
                width: 110
                height: 20
                font.family: "Arial"
                font.pixelSize: 18
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                color: "#000000"
                text: qsTr("78.9239845")
            }

            Item {
                height: 20
                width: 20

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    source: "images/lockIcon.png"
                }
            }

            Text {
                width: 116
                height: 20
                font.family: "Arial"
                font.pixelSize: 12
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                color: "#535353"
                text: qsTr("Available Balance:")
            }

            Text {
                id: availableBalanceText
                width: 110
                height: 20
                font.family: "Arial"
                font.pixelSize: 14
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignBottom
                color: "#000000"
                text: qsTr("2324.9239845")
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: "#DBDBDB"
        }
    }
    Item {
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Transfer {
            id : transferBasic
            anchors.fill: parent
        }
    }

    // indicate disabled state
//    Desaturate {
//        anchors.fill: parent
//        source: parent
//        desaturation: root.enabled ? 0.0 : 1.0
//    }


}
