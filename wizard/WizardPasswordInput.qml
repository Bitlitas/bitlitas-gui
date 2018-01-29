// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

ColumnLayout {
    property alias password: password.text
    property alias placeholderText: password.placeholderText
    signal changed(string password)


    TextField {
        Layout.fillWidth: true
        id : password
        focus:true
        font.family: "Arial"
        font.pixelSize: (isMobile) ? 25 * scaleRatio : 26 * scaleRatio
        echoMode: TextInput.Password
        style: TextFieldStyle {
            renderType: Text.NativeRendering
            textColor: "#35B05A"
            passwordCharacter: "•"
            background: Rectangle {
                radius: 0
                border.width: 0
            }
        }
        onTextChanged: changed(text)

        Keys.onReleased: {
            changed(text)
        }
    }

    Rectangle {
        Layout.fillWidth:true
        height: 1
        color: "#DBDBDB"
    }
}
