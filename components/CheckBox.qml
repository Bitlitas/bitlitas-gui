// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Layouts 1.1

RowLayout {
    id: checkBox
    property alias text: label.text
    property string checkedIcon
    property string uncheckedIcon
    property bool checked: false
    property alias background: backgroundRect.color
    property int fontSize: 14 * scaleRatio
    property alias fontColor: label.color
    signal clicked()
    height: 25 * scaleRatio

    function toggle(){
        checkBox.checked = !checkBox.checked
        checkBox.clicked()
    }

    RowLayout {
        Layout.fillWidth: true
        Rectangle {
            anchors.left: parent.left
            width: 25 * scaleRatio
            height: checkBox.height - 1
            //radius: 4
            y: 0
            color: "#DBDBDB"
        }

        Rectangle {
            id: backgroundRect
            anchors.left: parent.left
            width: 25 * scaleRatio
            height: checkBox.height - 1
            //radius: 4
            y: 1
            color: "#FFFFFF"

            Image {
                anchors.centerIn: parent
                source: checkBox.checked ? checkBox.checkedIcon :
                                           checkBox.uncheckedIcon
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    toggle()
                }
            }
        }

        Text {
            id: label
            font.family: "Arial"
            font.pixelSize: checkBox.fontSize
            color: "#525252"
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    toggle()
                }
            }
        }
    }
}
