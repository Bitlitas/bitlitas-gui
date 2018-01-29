// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import bitlitasComponents.Clipboard 1.0

ListView {
    id: listView
    clip: true
    boundsBehavior: ListView.StopAtBounds

    footer: Rectangle {
        height: 127
        width: listView.width
        color: "#FFFFFF"

        Text {
            anchors.centerIn: parent
            font.family: "Arial"
            font.pixelSize: 14
            color: "#545454"
            text: qsTr("No more results") + translationManager.emptyString
        }
    }

    property var previousItem
    delegate: Rectangle {
        id: delegate
        height: 64
        width: listView.width
        color: index % 2 ? "#F8F8F8" : "#FFFFFF"
        z: listView.count - index
        function collapseDropdown() { dropdown.expanded = false }

        Text {
            id: descriptionText
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 12
            width: text.length ? (descriptionArea.containsMouse ? dropdown.x - x - 12 : 139) : 0
            font.family: "Arial"
            font.bold: true
            font.pixelSize: 19
            color: "#444444"
            elide: Text.ElideRight
            text: description

            MouseArea {
                id: descriptionArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        TextEdit {
            id: addressText
            selectByMouse: true
            anchors.bottom: descriptionText.bottom
            anchors.left: descriptionText.right
            anchors.right: dropdown.left
            anchors.leftMargin: description.length > 0 ? 12 : 0
            anchors.rightMargin: 40
            font.family: "Arial"
            font.pixelSize: 16
            color: "#545454"
            text: address
        }

        Text {
            id: paymentLabel
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12

            width: 139
            font.family: "Arial"
            font.pixelSize: 12
            color: "#535353"
            text: qsTr("Payment ID:") + translationManager.emptyString
        }

        TextEdit {
            selectByMouse: true;
            anchors.bottom: paymentLabel.bottom
            anchors.left: paymentLabel.right
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.right: dropdown.left


            font.family: "Arial"
            font.pixelSize: 13
            color: "#545454"
            text: paymentId
        }

        ListModel {
            id: dropModel
            ListElement { name: "<b>Copy address to clipboard</b>"; icon: "../images/dropdownCopy.png" }
            ListElement { name: "<b>Send to this address</b>"; icon: "../images/dropdownSend.png" }
//            ListElement { name: "<b>Find similar transactions</b>"; icon: "../images/dropdownSearch.png" }
            ListElement { name: "<b>Remove from address book</b>"; icon: "../images/dropdownDel.png" }
        }

        Clipboard { id: clipboard }
        TableDropdown {
            id: dropdown
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 5
            dataModel: dropModel
            z: 1
            onExpandedChanged: {
                if(expanded) {
                    listView.previousItem = delegate
                    listView.currentIndex = index
                }
            }
            onOptionClicked: {
                // Ensure tooltip is closed
                appWindow.toolTip.visible = false;
                if(option === 0) {
                    clipboard.setText(address)
                    appWindow.showStatusMessage(qsTr("Address copied to clipboard"),3)
                }
                else if(option === 1){
                   console.log("Sending to: ", address +" "+ paymentId);
                   middlePanel.sendTo(address, paymentId, description);
                   leftPanel.selectItem(middlePanel.state)
                } else if(option === 2){
                    console.log("Delete: ", rowId);
                    currentWallet.addressBookModel.deleteRow(rowId);
                }
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
}
