// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

import "../components" as BitlitasComponents

Rectangle {
    id: root
    color: "white"
    visible: false
    property alias title: dialogTitle.text
    property alias text: dialogContent.text
    property alias content: root.text
    property alias cancelVisible: cancelButton.visible
    property alias okVisible: okButton.visible
    property alias textArea: dialogContent
    property alias okText: okButton.text
    property alias cancelText: cancelButton.text

    property var icon

    // same signals as Dialog has
    signal accepted()
    signal rejected()
    signal closeCallback();

    // Make window draggable
    MouseArea {
        anchors.fill: parent
        property point lastMousePos: Qt.point(0, 0)
        onPressed: { lastMousePos = Qt.point(mouseX, mouseY); }
        onMouseXChanged: root.x += (mouseX - lastMousePos.x)
        onMouseYChanged: root.y += (mouseY - lastMousePos.y)
    }

    function open() {
        // Center
        if(!isMobile) {
            root.x = parent.width/2 - root.width/2
            root.y = screenHeight/2 - root.height/2
        }
        show()
        root.z = 11
        root.visible = true;
    }

    function close() {
        root.visible = false;
        closeCallback();
    }

    // TODO: implement without hardcoding sizes
    width: isMobile ? screenWidth : 480
    height: isMobile ? screenHeight : 280

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
                font.pixelSize: 18 * scaleRatio
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
                font.pixelSize: 12 * scaleRatio
                selectByMouse: false
                wrapMode: TextEdit.Wrap

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
                        appWindow.showStatusMessage(qsTr("Content copied to clipboard"),3)
                    }
                }
            }
        }

        // Ok/Cancel buttons
        RowLayout {
            id: buttons
            spacing: 60
            Layout.alignment: Qt.AlignHCenter

            BitlitasComponents.StandardButton {
                id: cancelButton
                shadowReleasedColor: "#306d30"
                shadowPressedColor: "#B32D00"
                releasedColor: "#499149"
                pressedColor: "#306d30"
                text: qsTr("Cancel") + translationManager.emptyString
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
                text: qsTr("OK")
                KeyNavigation.tab: cancelButton
                onClicked: {
                    root.close()
                    root.accepted()

                }
            }
        }
    }

}



