// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0

Item {
    id: item
    property alias placeholderText: input.placeholderText
    property alias text: input.text
    property alias validator: input.validator
    property alias readOnly : input.readOnly
    property alias cursorPosition: input.cursorPosition
    property alias echoMode: input.echoMode
    property int fontSize: 18 * scaleRatio
    property bool error: false
    signal editingFinished()
    signal accepted();
    signal textUpdated();

    height: 37 * scaleRatio

    function getColor(error) {
      if (error)
        return "#FFDDDD"
      else
        return "#FFFFFF"
    }

    Rectangle {
        anchors.fill: parent
        anchors.bottomMargin: 1 * scaleRatio
        color: "#DBDBDB"
        //radius: 4
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 1 * scaleRatio
        color: getColor(error)
        //radius: 4
    }

    Input {
        id: input
        anchors.fill: parent
        anchors.leftMargin: 4 * scaleRatio
        anchors.rightMargin: 30 * scaleRatio
        font.pixelSize: parent.fontSize
        onEditingFinished: item.editingFinished()
        onAccepted: item.accepted();
        onTextChanged: item.textUpdated()
    }
}
