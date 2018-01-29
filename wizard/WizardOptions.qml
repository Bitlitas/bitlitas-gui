// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.2
import QtQml 2.2
import QtQuick.Layouts 1.1
import "../components"

ColumnLayout {
    id: page
    signal createWalletClicked()
    signal recoveryWalletClicked()
    signal openWalletClicked()
    opacity: 0
    visible: false
    property int buttonSize: (isMobile) ? 80 * scaleRatio : 190 * scaleRatio
    property int buttonImageSize: (isMobile) ? buttonSize - 10 * scaleRatio : buttonSize - 30 * scaleRatio

    function onPageClosed() {
        // Save settings used in open from file.
        // other wizard settings are saved on last page in applySettings()
        appWindow.persistentSettings.language = wizard.settings.language
        appWindow.persistentSettings.locale   = wizard.settings.locale

        return true;
    }

    Behavior on opacity {
        NumberAnimation { duration: 100; easing.type: Easing.InQuad }
    }

    onOpacityChanged: visible = opacity !== 0

    ColumnLayout {
        id: headerColumn
        Layout.leftMargin: wizardLeftMargin
        Layout.rightMargin: wizardRightMargin
        Layout.bottomMargin: (!isMobile) ? 40 * scaleRatio : 20
        spacing: 30 * scaleRatio

        Text {
            Layout.fillWidth: true
            font.family: "Arial"
            font.pixelSize: 28 * scaleRatio
            //renderType: Text.NativeRendering
            color: "#3F3F3F"
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Welcome to BitLitas!") + translationManager.emptyString
        }

        Text {
            Layout.fillWidth: true
            font.family: "Arial"
            font.pixelSize: 18 * scaleRatio
            //renderType: Text.NativeRendering
            color: "#4A4646"
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Please select one of the following options:") + translationManager.emptyString
        }
    }

    GridLayout {
        Layout.leftMargin: wizardLeftMargin
        Layout.rightMargin: wizardRightMargin
        Layout.alignment: Qt.AlignCenter
        id: actionButtons
        columnSpacing: 40 * scaleRatio
        rowSpacing: 10 * scaleRatio
        Layout.fillWidth: true
        Layout.fillHeight: true
        flow: isMobile ? GridLayout.TopToBottom : GridLayout.LeftToRight

        GridLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            flow: !isMobile ? GridLayout.TopToBottom : GridLayout.LeftToRight
            rowSpacing: 20 * scaleRatio
            columnSpacing: 10 * scaleRatio

            Rectangle {
                Layout.preferredHeight: page.buttonSize
                Layout.preferredWidth: page.buttonSize
                radius: page.buttonSize
                color: createWalletArea.containsMouse ? "#DBDBDB" : "#FFFFFF"


                Image {
                    width: page.buttonImageSize
                    height: page.buttonImageSize
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignRight
                    verticalAlignment: Image.AlignTop
                    anchors.centerIn: parent
                    source: "qrc:///images/createWallet.png"
                }

                MouseArea {
                    id: createWalletArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        page.createWalletClicked()
                    }
                }
            }

            Text {
                Layout.preferredWidth: page.buttonSize
                font.family: "Arial"
                font.pixelSize: 16 * scaleRatio
                color: "#4A4949"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: qsTr("Create a new wallet") + translationManager.emptyString
            }
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            flow: !isMobile ? GridLayout.TopToBottom : GridLayout.LeftToRight
            rowSpacing: 20 * scaleRatio
            columnSpacing: 10 * scaleRatio

            Rectangle {
                Layout.preferredHeight: page.buttonSize
                Layout.preferredWidth:  page.buttonSize
                radius: page.buttonSize
                color: recoverWalletArea.containsMouse ? "#DBDBDB" : "#FFFFFF"

                Image {
                    width: page.buttonImageSize
                    height: page.buttonImageSize
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    source: "qrc:///images/recoverWallet.png"
                }

                MouseArea {
                    id: recoverWalletArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        page.recoveryWalletClicked()
                    }
                }
            }

            Text {
                Layout.preferredWidth: page.buttonSize
                font.family: "Arial"
                font.pixelSize: 16 * scaleRatio
                color: "#4A4949"
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Restore wallet from keys or mnemonic seed") + translationManager.emptyString
                width:page.buttonSize
                wrapMode: Text.WordWrap
            }
        }

        GridLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            flow: !isMobile ? GridLayout.TopToBottom : GridLayout.LeftToRight
            rowSpacing: 20 * scaleRatio
            columnSpacing: 10 * scaleRatio

            Rectangle {
                Layout.preferredHeight: page.buttonSize
                Layout.preferredWidth:  page.buttonSize
                radius: page.buttonSize
                color: openWalletArea.containsMouse ? "#DBDBDB" : "#FFFFFF"

                Image {
                    width: page.buttonImageSize
                    height: page.buttonImageSize
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                    source: "qrc:///images/openAccount.png"
                }

                MouseArea {
                    id: openWalletArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        page.openWalletClicked()
                    }
                }
            }

            Text {
                Layout.preferredWidth: page.buttonSize
                font.family: "Arial"
                font.pixelSize: 16 * scaleRatio
                color: "#4A4949"
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Open a wallet from file") + translationManager.emptyString
                wrapMode: Text.WordWrap
            }
        }



    }
}

