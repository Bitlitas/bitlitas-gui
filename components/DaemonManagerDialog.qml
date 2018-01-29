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
    property int countDown: 10;
    signal rejected()
    signal started();

    function open() {
        show()
        countDown = 10;
        timer.start();
    }

    // TODO: implement without hardcoding sizes
    width: 480
    height: 200

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

        ColumnLayout {
            id: column
            //anchors {fill: parent; margins: 16 }
            Layout.alignment: Qt.AlignHCenter

            Timer {
                id: timer
                interval: 1000;
                running: false;
                repeat: true
                onTriggered: {
                    countDown--;
                    if(countDown < 0){
                        running = false;
                        // Start daemon
                        root.close()
                        appWindow.startDaemon(persistentSettings.daemonFlags);
                        root.started();
                    }
                }
            }

            Text {
                text: qsTr("Jungtis bus paleista po %1").arg(countDown);
                font.pixelSize: 18
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

        }

        RowLayout {
            id: buttons
            spacing: 60
            Layout.alignment: Qt.AlignHCenter

            BitlitasComponents.StandardButton {
                id: okButton
                visible:false
                fontSize: 14
                shadowReleasedColor: "#306d30"
                shadowPressedColor: "#B32D00"
                releasedColor: "#499149"
                pressedColor: "#306d30"
                text: qsTr("Start daemon (%1)").arg(countDown)  + translationManager.emptyString
                KeyNavigation.tab: cancelButton
                onClicked: {
                    timer.stop();
                    root.close()
                    appWindow.startDaemon(persistentSettings.daemonFlags);
                    root.started()
                }
            }

            BitlitasComponents.StandardButton {
                id: cancelButton
                fontSize: 14
                shadowReleasedColor: "#306d30"
                shadowPressedColor: "#B32D00"
                releasedColor: "#499149"
                pressedColor: "#306d30"
                text: qsTr("Use custom settings") + translationManager.emptyString

                onClicked: {
                    timer.stop();
                    root.close()
                    root.rejected()
                }
            }
        }
    }
}



