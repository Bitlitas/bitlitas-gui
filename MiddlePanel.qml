// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQml 2.0
import QtQuick 2.2
// QtQuick.Controls 2.0 isn't stable enough yet. Needs more testing.
//import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import bitlitasComponents.Wallet 1.0

import "./pages"

Rectangle {
    id: root

    property Item currentView
    property Item previousView
    property bool basicMode : isMobile
    property string balanceLabelText: qsTr("Balance") + translationManager.emptyString
    property string balanceText
    property string unlockedBalanceLabelText: qsTr("Unlocked Balance") + translationManager.emptyString
    property string unlockedBalanceText
    property int minHeight: (appWindow.height > 800) ? appWindow.height : 800 * scaleRatio
//    property int headerHeight: header.height

    property Transfer transferView: Transfer { }
    property Receive receiveView: Receive { }
    property History historyView: History { }
    property Settings settingsView: Settings { }
    property Mining miningView: Mining { }
    property AddressBook addressBookView: AddressBook { }
    property Keys keysView: Keys { }


    signal paymentClicked(string address, string paymentId, string amount, int mixinCount, int priority, string description)
    signal generatePaymentIdInvoked()
    signal getProofClicked(string txid, string address, string message);
    signal checkProofClicked(string txid, string address, string message, string signature);

    color: "#F0EEEE"

    onCurrentViewChanged: {
        if (previousView) {
            if (typeof previousView.onPageClosed === "function") {
                previousView.onPageClosed();
            }
        }
        previousView = currentView
        if (currentView) {
            stackView.replace(currentView)
            // Component.onCompleted is called before wallet is initilized
            if (typeof currentView.onPageCompleted === "function") {
                currentView.onPageCompleted();
            }
        }
    }

    function updateStatus(){
        transferView.updateStatus();
    }

    // send from AddressBook
    function sendTo(address, paymentId, description){
        root.state = "Transfer";
        transferView.sendTo(address, paymentId, description);
    }

        states: [
            State {
                name: "Dashboard"
                PropertyChanges {  }
            }, State {
                name: "History"
                PropertyChanges { target: root; currentView: historyView }
                PropertyChanges { target: historyView; model: appWindow.currentWallet ? appWindow.currentWallet.historyModel : null }
                PropertyChanges { target: mainFlickable; contentHeight: minHeight }
            }, State {
                name: "Transfer"
                PropertyChanges { target: root; currentView: transferView }
                PropertyChanges { target: mainFlickable; contentHeight: 1000 * scaleRatio }
            }, State {
               name: "Receive"
               PropertyChanges { target: root; currentView: receiveView }
               PropertyChanges { target: mainFlickable; contentHeight: minHeight }
            }, State {
                name: "AddressBook"
                PropertyChanges {  target: root; currentView: addressBookView  }
                PropertyChanges { target: mainFlickable; contentHeight: minHeight }
            }, State {
                name: "Settings"
               PropertyChanges { target: root; currentView: settingsView }
               PropertyChanges { target: mainFlickable; contentHeight: 1200 * scaleRatio }
            }, State {
                name: "Mining"
                PropertyChanges { target: root; currentView: miningView }
                PropertyChanges { target: mainFlickable; contentHeight: minHeight  }
            }, State {
                name: "Keys"
                PropertyChanges { target: root; currentView: keysView }
                PropertyChanges { target: mainFlickable; contentHeight: minHeight  + 200 * scaleRatio }
            }
        ]

    // color stripe at the top
    Row {
        id: styledRow
        height: 4
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right


        Rectangle { height: 4; width: parent.width / 5; color: "#FFE00A" }
        Rectangle { height: 4; width: parent.width / 5; color: "#6B0072" }
        Rectangle { height: 4; width: parent.width / 5; color: "#499149" }
        Rectangle { height: 4; width: parent.width / 5; color: "#FFD781" }
        Rectangle { height: 4; width: parent.width / 5; color: "#FF4F41" }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 2
        anchors.topMargin: appWindow.persistentSettings.customDecorations ? 30 : 0
        spacing: 0

        Flickable {
            id: mainFlickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            onFlickingChanged: {
                releaseFocus();
            }

            // Disabled scrollbars, gives crash on startup on windows
//            ScrollIndicator.vertical: ScrollIndicator { }
//            ScrollBar.vertical: ScrollBar { }       // uncomment to test

            // Views container
            StackView {
                id: stackView
                initialItem: transferView
                anchors.fill:parent
                clip: true // otherwise animation will affect left panel

                delegate: StackViewDelegate {
                    pushTransition: StackViewTransition {
                        PropertyAnimation {
                            target: enterItem
                            property: "x"
                            from: 0 - target.width
                            to: 0
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                        PropertyAnimation {
                            target: exitItem
                            property: "x"
                            from: 0
                            to: target.width
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

        }// flickable
    }
    // border
    Rectangle {
        anchors.top: styledRow.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 1
        color: "#DBDBDB"
    }

    Rectangle {
        anchors.top: styledRow.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 1
        color: "#DBDBDB"
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: "#DBDBDB"

    }

    /* connect "payment" click */
    Connections {
        ignoreUnknownSignals: false
        target: transferView
        onPaymentClicked : {
            console.log("MiddlePanel: paymentClicked")
            paymentClicked(address, paymentId, amount, mixinCount, priority, description)
        }
    }
}
