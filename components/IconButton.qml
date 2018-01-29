// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0

Item {
    property alias imageSource : buttonImage.source

    signal clicked(var mouse)


    id: button
    width: parent.height
    height: parent.height
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    Image {
        id: buttonImage
        source: ""
        x : (parent.width - width) / 2
        y : (parent.height - height)  /2
        z: 100
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent


        onPressed: {
            buttonImage.x = buttonImage.x + 2
            buttonImage.y = buttonImage.y + 2
        }
        onReleased: {
            buttonImage.x = buttonImage.x - 2
            buttonImage.y = buttonImage.y - 2
        }

        onClicked: {
            parent.clicked(mouse)
        }
    }

}
