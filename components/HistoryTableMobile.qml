// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Layouts 1.1
import bitlitasComponents.Clipboard 1.0
import bitlitasComponents.AddressBookModel 1.0

ListView {
    id: listView
    clip: true
    boundsBehavior: ListView.StopAtBounds
    property var previousItem
    property var addressBookModel: null

    function buildTxDetailsString(tx_id, paymentId, tx_key,tx_note, destinations) {
        var trStart = '<tr><td width="85" style="padding-top:5px"><b>',
            trMiddle = '</b></td><td style="padding-left:10px;padding-top:5px;">',
            trEnd = "</td></tr>";

        return '<table border="0">'
            + (tx_id ? trStart + qsTr("Tx ID:") + trMiddle + tx_id + trEnd : "")
            + (paymentId ? trStart + qsTr("Payment ID:") + trMiddle + paymentId  + trEnd : "")
            + (tx_key ? trStart + qsTr("Tx key:") + trMiddle + tx_key + trEnd : "")
            + (tx_note ? trStart + qsTr("Tx note:") + trMiddle + tx_note  + trEnd : "")
            + (destinations ? trStart + qsTr("Destinations:") + trMiddle + destinations + trEnd : "")
            + "</table>"
            + translationManager.emptyString;
    }

    function lookupPaymentID(paymentId) {
        if (!addressBookModel)
            return ""
        var idx = addressBookModel.lookupPaymentID(paymentId)
        if (idx < 0)
            return ""
        idx = addressBookModel.index(idx, 0)
        return addressBookModel.data(idx, AddressBookModel.AddressBookDescriptionRole)
    }


    footer: Rectangle {
        height: 127 * scaleRatio
        width: listView.width
        color: "#FFFFFF"

        Text {
            anchors.centerIn: parent
            font.family: "Arial"
            font.pixelSize: 14 * scaleRatio
            color: "#545454"
            text: qsTr("No more results") + translationManager.emptyString
        }
    }

    delegate: Rectangle {
        id: delegate
        height: tableContent.height + 20 * scaleRatio
        width: listView.width
        color: index % 2 ? "#F8F8F8" : "#FFFFFF"
        Layout.leftMargin: 10 * scaleRatio
        z: listView.count - index
        function collapseDropdown() { dropdown.expanded = false }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                var tx_key = currentWallet.getTxKey(hash)
                var tx_note = currentWallet.getUserNote(hash)

                informationPopup.title = qsTr("Transaction details") + translationManager.emptyString;
                informationPopup.text = buildTxDetailsString(hash,paymentId,tx_key,tx_note,destinations);
                informationPopup.open();
                informationPopup.onCloseCallback = null
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 15 * scaleRatio
            anchors.top: parent.top
            anchors.topMargin: parent.height/2 - this.height/2
            width: 30 * scaleRatio; height: 30 * scaleRatio
            radius: 25
            color: "#306d30"

            Image {
                width: 20 * scaleRatio
                height: 20 * scaleRatio
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
                source: "qrc:///images/nextPage.png"
            }
        }

        ColumnLayout {
            id: tableContent
            // Date
            RowLayout {
                Layout.topMargin: 20 * scaleRatio
                Layout.leftMargin: 10 * scaleRatio
                Text {
                    font.family: "Arial"
                    font.pixelSize: 14 * scaleRatio
                    color: "#555555"
                    text: date
                }

                Text {
                    font.family: "Arial"
                    font.pixelSize: 14 * scaleRatio
                    color: "#555555"
                    text: time
                }

                // Show confirmations
                Text {
                    visible: confirmations < confirmationsRequired || isPending
                    Layout.leftMargin: 5 * scaleRatio
                    font.family: "Arial"
                    font.pixelSize: 14 * scaleRatio
                    color:  (confirmations < confirmationsRequired)? "#499149" : "#545454"
                    text: {
                        if (!isPending)
                            if(confirmations < confirmationsRequired)
                                return qsTr("(%1/%2 confirmations)").arg(confirmations).arg(confirmationsRequired)
                        if (!isOut)
                            return qsTr("UNCONFIRMED") + translationManager.emptyString
                        if (isFailed)
                            return qsTr("FAILED") + translationManager.emptyString
                        return qsTr("PENDING") + translationManager.emptyString

                    }
                }
            }


            // Amount & confirmations
            RowLayout {
                Layout.leftMargin: 10 * scaleRatio
                spacing: 2
                Text {
                    font.family: "Arial"
                    font.pixelSize: 14 * scaleRatio
                    color: isOut ? "#FF4F41" : "#36B05B"
                    text: isOut ? "↓" : "↑"
                }

                Text {
                    id: amountText
                    font.family: "Arial"
                    font.pixelSize: 18 * scaleRatio
                    color: isOut ? "#FF4F41" : "#36B05B"
                    text:  displayAmount
                }
            }
        }
    }

    ListModel {
        id: dropModel
        ListElement { name: "<b>Copy address to clipboard</b>"; icon: "../images/dropdownCopy.png" }
        ListElement { name: "<b>Add to address book</b>"; icon: "../images/dropdownAdd.png" }
        ListElement { name: "<b>Send to this address</b>"; icon: "../images/dropdownSend.png" }
        ListElement { name: "<b>Find similar transactions</b>"; icon: "../images/dropdownSearch.png" }
    }

    Clipboard { id: clipboard }
}
