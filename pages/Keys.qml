// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2

import "../components"
import bitlitasComponents.Clipboard 1.0

Rectangle {
    property bool viewOnly: false
    id: page

    color: "#F0EEEE"

    Clipboard { id: clipboard }

    ColumnLayout {
        id: mainLayout
        anchors.margins: 17 * scaleRatio
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        spacing: 20 * scaleRatio
        Layout.fillWidth: true

        //! Manage wallet
        ColumnLayout {
            Layout.fillWidth: true
            Label {
                Layout.fillWidth: true
                text: qsTr("Mnemonic seed") + translationManager.emptyString
            }
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#DEDEDE"
            }
            TextEdit {
                id: seedText
                wrapMode: TextEdit.Wrap
                Layout.fillWidth: true;
                font.pixelSize: 14 * scaleRatio
                readOnly: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appWindow.showStatusMessage(qsTr("Double tap to copy"),3)
                    }
                    onDoubleClicked: {
                        parent.selectAll()
                        parent.copy()
                        parent.deselect()
                        console.log("copied to clipboard");
                        appWindow.showStatusMessage(qsTr("Seed copied to clipboard"),3)
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Label {
                Layout.fillWidth: true
                text: qsTr("Keys") + translationManager.emptyString
            }
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#DEDEDE"
            }
            TextEdit {
                id: keysText
                wrapMode: TextEdit.Wrap
                Layout.fillWidth: true;
                font.pixelSize: 14 * scaleRatio
                textFormat: TextEdit.RichText
                readOnly: true
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appWindow.showStatusMessage(qsTr("Double tap to copy"),3)
                    }
                    onDoubleClicked: {
                        parent.selectAll()
                        parent.copy()
                        parent.deselect()
                        console.log("copied to clipboard");
                        appWindow.showStatusMessage(qsTr("Keys copied to clipboard"),3)
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Label {
                Layout.fillWidth: true
                text: qsTr("Export wallet") + translationManager.emptyString
            }
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#DEDEDE"
            }


            RowLayout {
                StandardButton {
                    enabled: !fullWalletQRCode.visible
                    id: showFullQr
                    text: qsTr("Spendable Wallet") + translationManager.emptyString
                    onClicked: {
                        viewOnlyQRCode.visible = false
                    }
                }
                StandardButton {
                    enabled: fullWalletQRCode.visible
                    id: showViewOnlyQr
                    text: qsTr("View Only Wallet") + translationManager.emptyString
                    onClicked: {
                        viewOnlyQRCode.visible = true
                    }
                }
                Layout.bottomMargin: 30 * scaleRatio
            }


            Image {
                visible: !viewOnlyQRCode.visible
                id: fullWalletQRCode
                Layout.fillWidth: true
                Layout.minimumHeight: 180 * scaleRatio
                smooth: false
                fillMode: Image.PreserveAspectFit
            }

            Image {
                visible: false
                id: viewOnlyQRCode
                Layout.fillWidth: true
                Layout.minimumHeight: 180 * scaleRatio
                smooth: false
                fillMode: Image.PreserveAspectFit
            }

            Text {
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: 16 * scaleRatio
                text: (viewOnlyQRCode.visible) ? qsTr("View Only Wallet") + translationManager.emptyString : qsTr("Spendable Wallet") + translationManager.emptyString
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // fires on every page load
    function onPageCompleted() {
        console.log("keys page loaded");

        keysText.text = "<b>" + qsTr("Secret view key") + ":</b> " + currentWallet.secretViewKey
        keysText.text += "<br><br><b>" + qsTr("Public view key") + ":</b> " + currentWallet.publicViewKey
        keysText.text += (!currentWallet.viewOnly) ? "<br><br><b>" + qsTr("Secret spend key") + ":</b> " + currentWallet.secretSpendKey : ""
        keysText.text += "<br><br><b>" + qsTr("Public spend key") + ":</b> " + currentWallet.publicSpendKey

        seedText.text = currentWallet.seed

        if(typeof currentWallet != "undefined") {
            viewOnlyQRCode.source = "image://qrcode/bitlitas:" + currentWallet.address+"?secret_view_key="+currentWallet.secretViewKey+"&restore_height="+currentWallet.restoreHeight
            fullWalletQRCode.source = viewOnlyQRCode.source +"&secret_spend_key="+currentWallet.secretSpendKey

            if(currentWallet.viewOnly) {
                viewOnlyQRCode.visible = true
                showFullQr.visible = false
                showViewOnlyQr.visible = false
                seedText.text = qsTr("(View Only Wallet -  No mnemonic seed available)") + translationManager.emptyString
            }
        }
    }

    // fires only once
    Component.onCompleted: {

    }

}





