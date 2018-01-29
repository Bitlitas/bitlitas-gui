// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.2
import QtGraphicalEffects 1.0
import bitlitasComponents.Wallet 1.0
import "components"

Rectangle {
    id: panel

    property alias unlockedBalanceText: unlockedBalanceText.text
    property alias balanceLabelText: balanceLabel.text
    property alias balanceText: balanceText.text
    property alias networkStatus : networkStatus
    property alias progressBar : progressBar
    property alias minutesToUnlockTxt: unlockedBalanceLabel.text

    signal dashboardClicked()
    signal historyClicked()
    signal transferClicked()
    signal receiveClicked()
    signal settingsClicked()
    signal addressBookClicked()
    signal miningClicked()
    signal keysClicked()

    function selectItem(pos) {
        menuColumn.previousButton.checked = false
        if(pos === "Dashboard") menuColumn.previousButton = dashboardButton
        else if(pos === "History") menuColumn.previousButton = historyButton
        else if(pos === "Transfer") menuColumn.previousButton = transferButton
        else if(pos === "Receive")  menuColumn.previousButton = receiveButton
        else if(pos === "AddressBook") menuColumn.previousButton = addressBookButton
        else if(pos === "Mining") menuColumn.previousButton = miningButton
        else if(pos === "TxKey")  menuColumn.previousButton = txkeyButton
        else if(pos === "Sign") menuColumn.previousButton = signButton
        else if(pos === "Settings") menuColumn.previousButton = settingsButton
        else if(pos === "Advanced") menuColumn.previousButton = advancedButton

        menuColumn.previousButton.checked = true
    }

    width: (isMobile)? appWindow.width : 260
    color: "#FFFFFF"
    anchors.bottom: parent.bottom
    anchors.top: parent.top

    // Item with bitlitas logo
    Item {
        visible: !isMobile
        id: logoItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (persistentSettings.customDecorations)? 66 : 36
        height: logo.implicitHeight

        Image {
            id: logo
            anchors.left: parent.left
            anchors.leftMargin: 50
            source: "images/bitlitasLogo.png"
        }

        Text {
            id: viewOnlyLabel
            visible: viewOnly
            text: qsTr("View Only") + translationManager.emptyString
            anchors.top: logo.bottom
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 50
            font.bold: true
            color: "blue"
        }

      /* Disable twitter/news panel
        Image {
            anchors.left: parent.left
            anchors.verticalCenter: logo.verticalCenter
            anchors.leftMargin: 19
            source: appWindow.rightPanelExpanded ? "images/expandRightPanel.png" :
                                                   "images/collapseRightPanel.png"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: appWindow.rightPanelExpanded = !appWindow.rightPanelExpanded
        }
      */
    }



    Column {
        visible: !isMobile
        id: column1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: logoItem.bottom
        anchors.topMargin: 26
        spacing: 5

        Label {
            visible: !isMobile
            id: balanceLabel
            text: qsTr("Balance") + translationManager.emptyString
            anchors.left: parent.left
            anchors.leftMargin: 50
        }

        Row {
            visible: !isMobile
            Item {
                anchors.verticalCenter: parent.verticalCenter
                height: 26 * scaleRatio
                width: 50 * scaleRatio

                Image {
                    anchors.centerIn: parent
                    source: "images/lockIcon.png"
                }
            }

            Text {
                visible: !isMobile
                id: balanceText
                anchors.verticalCenter: parent.verticalCenter
                font.family: "Arial"
                color: "#000000"
                text: "N/A"
                // dynamically adjust text size
                font.pixelSize: {
                    var digits = text.split('.')[0].length
                    var defaultSize = 25;
                    if(digits > 2) {
                        return defaultSize - 1.1*digits
                    }
                    return defaultSize;
                }
            }
        }

        Item { //separator
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
        }

        Label {
            id: unlockedBalanceLabel
            text: qsTr("Unlocked balance") + translationManager.emptyString
            anchors.left: parent.left
            anchors.leftMargin: 50
        }

        Text {
            id: unlockedBalanceText
            anchors.left: parent.left
            anchors.leftMargin: 50
            font.family: "Arial"
            color: "#000000"
            text: "N/A"
            // dynamically adjust text size
            font.pixelSize: {
                var digits = text.split('.')[0].length
                var defaultSize = 18;
                if(digits > 3) {
                    return defaultSize - 0.6*digits
                }
                return defaultSize;
            }
        }
    }


    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: menuRect.top
        width: 1
        color: "#DBDBDB"
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 1
        color: "#DBDBDB"
    }



    Rectangle {
        id: menuRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: (isMobile)? parent.top : column1.bottom
        anchors.topMargin: (isMobile)? 0 : 25
        color: "#092709"


        Flickable {
            id:flicker
            contentHeight: 500 * scaleRatio
            anchors.fill: parent
            clip: true


        Column {

            id: menuColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            clip: true
            property var previousButton: transferButton

            // ------------- Dashboard tab ---------------

            /*
            MenuButton {
                id: dashboardButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Dashboard") + translationManager.emptyString
                symbol: qsTr("D") + translationManager.emptyString
                dotColor: "#FFE00A"
                checked: true
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = dashboardButton
                    panel.dashboardClicked()
                }
            }


            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: dashboardButton.checked || transferButton.checked ? "#092709" : "#505050"
                height: 1
            }
            */


            // ------------- Transfer tab ---------------
            MenuButton {
                id: transferButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Send") + translationManager.emptyString
                symbol: qsTr("S") + translationManager.emptyString
                dotColor: "#499149"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = transferButton
                    panel.transferClicked()
                }
            }

            Rectangle {
                visible: transferButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#505050"
                height: 1
            }

            // ------------- AddressBook tab ---------------

            MenuButton {
                id: addressBookButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Address book") + translationManager.emptyString
                symbol: qsTr("B") + translationManager.emptyString
                dotColor: "#FF4F41"
                under: transferButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = addressBookButton
                    panel.addressBookClicked()
                }
            }

            Rectangle {
                visible: addressBookButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#505050"
                height: 1
            }

            // ------------- Receive tab ---------------
            MenuButton {
                id: receiveButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Receive") + translationManager.emptyString
                symbol: qsTr("R") + translationManager.emptyString
                dotColor: "#AAFFBB"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = receiveButton
                    panel.receiveClicked()
                }
            }
            Rectangle {
                visible: receiveButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#505050"
                height: 1
            }

            // ------------- History tab ---------------

            MenuButton {
                id: historyButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("History") + translationManager.emptyString
                symbol: qsTr("H") + translationManager.emptyString
                dotColor: "#6B0072"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = historyButton
                    panel.historyClicked()
                }
            }
            Rectangle {
                visible: historyButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#505050"
                height: 1
            }

            // ------------- Mining tab ---------------
            MenuButton {
                id: miningButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Mining") + translationManager.emptyString
                symbol: qsTr("M") + translationManager.emptyString
                dotColor: "#FFD781"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = miningButton
                    panel.miningClicked()
                }
            }

            Rectangle {
                visible: miningButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#505050"
                height: 1
            }

            // ------------- Settings tab ---------------
            MenuButton {
                id: settingsButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Settings") + translationManager.emptyString
                symbol: qsTr("E") + translationManager.emptyString
                dotColor: "#36B25C"
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = settingsButton
                    panel.settingsClicked()
                }
            }
            Rectangle {
                visible: settingsButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#505050"
                height: 1
            }
            // ------------- Sign/verify tab ---------------
            MenuButton {
                id: keysButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Seed & Keys") + translationManager.emptyString
                symbol: qsTr("Y") + translationManager.emptyString
                dotColor: "#FFD781"
                under: settingsButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = keysButton
                    panel.keysClicked()
                }
            }
            Rectangle {
                visible: settingsButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16
                color: "#505050"
                height: 1
            }

        } // Column

        } // Flickable

        NetworkStatusItem {
            id: networkStatus
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: (progressBar.visible)? progressBar.top : parent.bottom;
            connected: Wallet.ConnectionStatus_Disconnected
            height: 58 * scaleRatio
        }

        ProgressBar {
            id: progressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 35 * scaleRatio
        }
    } // menuRect



    // indicate disabled state
//    Desaturate {
//        anchors.fill: parent
//        source: parent
//        desaturation: panel.enabled ? 0.0 : 1.0
//    }


}
