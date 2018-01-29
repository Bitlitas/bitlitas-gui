// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick 2.2
import QtQuick.Layouts 1.1

GridLayout {
    columns: (isMobile) ? 1 : 2
    id: root
    property alias daemonAddrText: daemonAddr.text
    property alias daemonPortText: daemonPort.text

    signal editingFinished()

    function getAddress() {
        return daemonAddr.text.trim() + ":" + daemonPort.text.trim()
    }

    LineEdit {
        id: daemonAddr
        Layout.fillWidth: true
        placeholderText: qsTr("Remote Node Hostname / IP") + translationManager.emptyString
        onEditingFinished: root.editingFinished()
    }


    LineEdit {
        id: daemonPort
        Layout.fillWidth: true
        placeholderText: qsTr("Port") + translationManager.emptyString
        onEditingFinished: root.editingFinished()
    }
}
