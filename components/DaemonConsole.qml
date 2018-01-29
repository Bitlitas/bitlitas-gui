// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

import "../components" as BitlitasComponents

Window {
    id: root
    modality: Qt.ApplicationModal
    flags: Qt.Window | Qt.FramelessWindowHint
    property alias title: dialogTitle.text
    property alias text: dialogContent.text
    property alias content: root.text
    property alias okVisible: okButton.visible
    property alias textArea: dialogContent
    property var icon

    // same signals as Dialog has
    signal accepted()
    signal rejected()


    function open() {
        show()
    }

    // TODO: implement without hardcoding sizes
    width:  480
    height: 280

    // Make window draggable
    MouseArea {
        anchors.fill: parent
        property point lastMousePos: Qt.point(0, 0)
        onPressed: { lastMousePos = Qt.point(mouseX, mouseY); }
        onMouseXChanged: root.x += (mouseX - lastMousePos.x)
        onMouseYChanged: root.y += (mouseY - lastMousePos.y)
    }

    ColumnLayout {
        id: mainLayout
        spacing: 10
        anchors { fill: parent; margins: 35 }

        RowLayout {
            id: column
            //anchors {fill: parent; margins: 16 }
            Layout.alignment: Qt.AlignHCenter

            Label {
                id: dialogTitle
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 32
                font.family: "Arial"
                color: "#555555"
            }

        }

        RowLayout {
            TextArea {
                id : dialogContent
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.family: "Arial"
                textFormat: TextEdit.AutoText
                readOnly: true
                font.pixelSize: 12
            }
        }

        // Ok/Cancel buttons
        RowLayout {
            id: buttons
            spacing: 60
            Layout.alignment: Qt.AlignHCenter

            BitlitasComponents.StandardButton {
                id: okButton
                width: 120
                fontSize: 14
                shadowReleasedColor: "#306d30"
                shadowPressedColor: "#B32D00"
                releasedColor: "#499149"
                pressedColor: "#306d30"
                text: qsTr("Close") + translationManager.emptyString
                onClicked: {
                    root.close()
                    root.accepted()

                }
            }

            BitlitasComponents.LineEdit {
                id: sendCommandText
                width: 300
                placeholderText: qsTr("command + enter (e.g help)") + translationManager.emptyString
                onAccepted: {
                    if(text.length > 0)
                        daemonManager.sendCommand(text,currentWallet.testnet);
                    text = ""
                }
            }

            // Status button
//            BitlitasComponents.StandardButton {
//                id: sendCommandButton
//                enabled: sendCommandText.text.length > 0
//                fontSize: 14
//                shadowReleasedColor: "#306d30"
//                shadowPressedColor: "#B32D00"
//                releasedColor: "#499149"
//                pressedColor: "#306d30"
//                text: qsTr("Send command")
//                onClicked: {
//                    daemonManager.sendCommand(sendCommandText.text,currentWallet.testnet);
//                }
//            }
        }
    }

}



