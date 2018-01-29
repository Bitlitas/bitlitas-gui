// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1

Rectangle {
    id: titleBar
    color: "#000000"
    property int mouseX: 0
    property bool containsMouse: false
    property alias basicButtonVisible: goToBasicVersionButton.visible
    property bool customDecorations: true
    signal goToBasicVersion(bool yes)
    height: customDecorations && !isMobile ? 30 : 0
    y: -height
    property string title
    property alias maximizeButtonVisible: maximizeButton.visible
    z: 1

    Text {
        anchors.centerIn: parent
        font.family: "Arial"
        font.pixelSize: 15
        color: "#FFFFFF"
        text: titleBar.title
        visible: customDecorations
    }

    Rectangle {

        id: goToBasicVersionButton
        property bool containsMouse: titleBar.mouseX >= x && titleBar.mouseX <= x + width
        property bool checked: false
        anchors.top: parent.top
        anchors.left: parent.left
        color:  "#FFE00A"
        height: 30 * scaleRatio
        width: height
        visible: isMobile

        Image {
            width: parent.width * 2/3;
            height: width;
            anchors.centerIn: parent
            source: "../images/menu.png"
        }

        MouseArea {
            id: basicMouseArea
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                releaseFocus()
                parent.checked = !parent.checked
                titleBar.goToBasicVersion(leftPanel.visible)
            }
        }
    }

    Row {
        id: row
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        visible: parent.customDecorations

        Rectangle {
            property bool containsMouse: titleBar.mouseX >= x + row.x && titleBar.mouseX <= x + row.x + width && titleBar.containsMouse
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            color: containsMouse ? "#6B0072" : "#000000"

            Image {
                anchors.centerIn: parent
                source: "../images/helpIcon.png"
            }

            MouseArea {
                id: whatIsArea
                anchors.fill: parent
                onClicked: {

                }
            }
        }

        Rectangle {
            property bool containsMouse: titleBar.mouseX >= x + row.x && titleBar.mouseX <= x + row.x + width && titleBar.containsMouse
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            color: containsMouse ? "#3665B3" : "#000000"

            Image {
                anchors.centerIn: parent
                source: "../images/minimizeIcon.png"
            }

            MouseArea {
                id: minimizeArea
                anchors.fill: parent
                onClicked: {
                    appWindow.visibility = Window.Minimized
                }
            }
        }

        Rectangle {
            id: maximizeButton
            property bool containsMouse: titleBar.mouseX >= x + row.x && titleBar.mouseX <= x + row.x + width && titleBar.containsMouse
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            color: containsMouse ? "#499149" : "#000000"

            Image {
                anchors.centerIn: parent
                source: appWindow.visibility === Window.FullScreen ?  "../images/backToWindowIcon.png" :
                                                                      "../images/maximizeIcon.png"

            }

            MouseArea {
                id: maximizeArea
                anchors.fill: parent
                onClicked: {
                    appWindow.visibility = appWindow.visibility !== Window.FullScreen ? Window.FullScreen :
                                                                                        Window.Windowed
                }
            }
        }

        Rectangle {
            property bool containsMouse: titleBar.mouseX >= x + row.x && titleBar.mouseX <= x + row.x + width && titleBar.containsMouse
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            color: containsMouse ? "#E04343" : "#000000"

            Image {
                anchors.centerIn: parent
                source: "../images/closeIcon.png"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: appWindow.close();
            }
        }
    }

}
