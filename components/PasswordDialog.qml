// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

import "../components" as BitlitasComponents

Item {
    id: root
    visible: false
    Rectangle {
        id: bg
        z: parent.z + 1
        anchors.fill: parent
        color: "white"
        opacity: 0.9
    }

    property alias password: passwordInput.text
    property string walletName

    // same signals as Dialog has
    signal accepted()
    signal rejected()
    signal closeCallback()

    function open(walletName) {
        root.walletName = walletName ? walletName : ""
        leftPanel.enabled = false
        middlePanel.enabled = false
        titleBar.enabled = false
        show()
        root.visible = true;
        passwordInput.focus = true
        passwordInput.text = ""
    }

    function close() {
        leftPanel.enabled = true
        middlePanel.enabled = true
        titleBar.enabled = true
        root.visible = false;
        closeCallback();
    }

    ColumnLayout {
        z: bg.z + 1
        id: mainLayout
        spacing: 10
        anchors { fill: parent; margins: 35 * scaleRatio }

        ColumnLayout {
            id: column
            //anchors {fill: parent; margins: 16 }
            Layout.alignment: Qt.AlignHCenter

            Label {
                text: root.walletName.length > 0 ? qsTr("Please enter wallet password for:<br>") + translationManager.emptyString + root.walletName : qsTr("Please enter wallet password") + translationManager.emptyString
                Layout.alignment: Qt.AlignHCenter
                Layout.columnSpan: 2
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18 * scaleRatio
                font.family: "Arial"
                color: "#555555"
            }

            TextField {
                id : passwordInput
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: 400 * scaleRatio
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                font.family: "Arial"
                font.pixelSize: 32 * scaleRatio
                echoMode: TextInput.Password
                KeyNavigation.tab: okButton

                style: TextFieldStyle {
                    renderType: Text.NativeRendering
                    textColor: "#35B05A"
                    passwordCharacter: "•"
                    // no background
                    background: Rectangle {
                        radius: 0
                        border.width: 0
                    }
                }
                Keys.onReturnPressed: {
                    root.close()
                    root.accepted()

                }
                Keys.onEscapePressed: {
                    root.close()
                    root.rejected()

                }


            }
            // underline
            Rectangle {
                height: 1
                color: "#DBDBDB"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                anchors.bottomMargin: 3
                Layout.maximumWidth: passwordInput.width

            }
        }
        // Ok/Cancel buttons
        RowLayout {
            id: buttons
            spacing: 60 * scaleRatio
            Layout.alignment: Qt.AlignHCenter
            
            BitlitasComponents.StandardButton {
                id: cancelButton
                shadowReleasedColor: "#306d30"
                shadowPressedColor: "#B32D00"
                releasedColor: "#499149"
                pressedColor: "#306d30"
                text: qsTr("Cancel") + translationManager.emptyString
                KeyNavigation.tab: passwordInput
                onClicked: {
                    root.close()
                    root.rejected()
                }
            }
            BitlitasComponents.StandardButton {
                id: okButton
                shadowReleasedColor: "#306d30"
                shadowPressedColor: "#B32D00"
                releasedColor: "#499149"
                pressedColor: "#306d30"
                text: qsTr("Continue") + translationManager.emptyString
                KeyNavigation.tab: cancelButton
                onClicked: {
                    root.close()
                    root.accepted()
                }
            }
        }
    }
}
