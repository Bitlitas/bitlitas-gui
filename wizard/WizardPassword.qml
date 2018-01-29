// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import bitlitasComponents.WalletManager 1.0
import QtQuick 2.2
import QtQuick.Layouts 1.1
import "../components"
import "utils.js" as Utils

ColumnLayout {
    Layout.leftMargin: wizardLeftMargin
    Layout.rightMargin: wizardRightMargin

    id: passwordPage
    opacity: 0
    visible: false
    property alias titleText: titleText.text
    property alias passwordsMatch: passwordUI.passwordsMatch
    property alias password: passwordUI.password
    Behavior on opacity {
        NumberAnimation { duration: 100; easing.type: Easing.InQuad }
    }

    onOpacityChanged: visible = opacity !== 0


    function onPageOpened(settingsObject) {
        wizard.nextButton.enabled = true
        passwordUI.handlePassword();

        if (wizard.currentPath === "create_wallet") {
           passwordPage.titleText = qsTr("Give your wallet a password") + translationManager.emptyString
        } else {
           passwordPage.titleText = qsTr("Give your wallet a password") + translationManager.emptyString
        }

        passwordUI.resetFocus()
    }

    function onPageClosed(settingsObject) {
        // TODO: set password on the final page
        settingsObject['wallet_password'] = passwordUI.password
        return true
    }

    function onWizardRestarted(){
        // Reset password fields
        passwordUI.password = "";
        passwordUI.confirmPassword = "";
    }

    RowLayout {
        id: dotsRow
        Layout.alignment: Qt.AlignRight

        ListModel {
            id: dotsModel
            ListElement { dotColor: "#36B05B" }
            ListElement { dotColor: "#FFE00A" }
            ListElement { dotColor: "#DBDBDB" }
            ListElement { dotColor: "#DBDBDB" }
        }

        Repeater {
            model: dotsModel
            delegate: Rectangle {
                // Password page is last page when creating view only wallet
                // TODO: make this dynamic for all pages in wizard
                visible: (wizard.currentPath != "create_view_only_wallet" || index < 2)
                width: 12; height: 12
                radius: 6
                color: dotColor
            }
        }
    }

    ColumnLayout {
        id: headerColumn

        Text {
            Layout.fillWidth: true
            id: titleText
            font.family: "Arial"
            font.pixelSize: 28 * scaleRatio
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            //renderType: Text.NativeRendering
            color: "#3F3F3F"

        }

        Text {
            Layout.fillWidth: true
            Layout.bottomMargin: 30 * scaleRatio
            font.family: "Arial"
            font.pixelSize: 18 * scaleRatio
            wrapMode: Text.Wrap
            //renderType: Text.NativeRendering
            color: "#4A4646"
            horizontalAlignment: Text.AlignHCenter
            text: qsTr(" <br>Note: this password cannot be recovered. If you forget it then the wallet will have to be restored from its 25 word mnemonic seed.<br/><br/>
                        <b>Enter a strong password</b> (using letters, numbers, and/or symbols):")
                    + translationManager.emptyString
        }
    }

    ColumnLayout {
        Layout.fillWidth: true;
        WizardPasswordUI {
            id: passwordUI
        }
    }


    Component.onCompleted: {
        parent.wizardRestarted.connect(onWizardRestarted)
    }
}
