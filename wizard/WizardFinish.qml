// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.2
import QtQuick.Layouts 1.1


ColumnLayout {
    Layout.leftMargin: wizardLeftMargin
    Layout.rightMargin: wizardRightMargin
    opacity: 0
    visible: false
    Behavior on opacity {
        NumberAnimation { duration: 100; easing.type: Easing.InQuad }
    }

    onOpacityChanged: visible = opacity !== 0

    function buildSettingsString() {
        var trStart = '<tr><td style="padding-top:5px;"><b>',
            trMiddle = '</b></td><td style="padding-left:10px;padding-top:5px;">',
            trEnd = "</td></tr>",
            autoDonationEnabled = wizard.settings['auto_donations_enabled'] === true,
            autoDonationText = autoDonationEnabled ? qsTr("Enabled") : qsTr("Disabled"),
            autoDonationAmount = wizard.settings["auto_donations_amount"] + " %",
            backgroundMiningEnabled = wizard.settings["allow_background_mining"] === true,
            backgroundMiningText = backgroundMiningEnabled ? qsTr("Enabled") : qsTr("Disabled"),
            testnetEnabled = appWindow.persistentSettings.testnet,
            testnetText = testnetEnabled ? qsTr("Enabled") : qsTr("Disabled"),
            restoreHeightEnabled = wizard.settings['restore_height'] !== undefined;

        return "<table>"
            + trStart + qsTr("Language") + trMiddle + wizard.settings["language"] + trEnd
            + trStart + qsTr("Wallet name") + trMiddle + wizard.settings["account_name"] + trEnd
            + trStart + qsTr("Backup seed") + trMiddle + wizard.settings["wallet"].seed + trEnd
            + trStart + qsTr("Wallet path") + trMiddle + wizard.settings["wallet_path"] + trEnd
            // + trStart + qsTr("Auto donations") + trMiddle + autoDonationText + trEnd
            // + (autoDonationEnabled
                // ? trStart + qsTr("Donation amount") + trMiddle + autoDonationAmount + trEnd
                // : "")
            // + trStart + qsTr("Background mining") + trMiddle + backgroundMiningText + trEnd
            + trStart + qsTr("Daemon address") + trMiddle + persistentSettings.daemon_address + trEnd
            + trStart + qsTr("Testnet") + trMiddle + testnetText + trEnd
            + (restoreHeightEnabled
                ? trStart + qsTr("Restore height") + trMiddle + wizard.settings['restore_height'] + trEnd
                : "")
            + "</table>"
            + translationManager.emptyString;
    }

    function updateSettingsSummary() {
        if (!isMobile){
            settingsText.text = qsTr("New wallet details:") + translationManager.emptyString
                                + "<br>"
                                + buildSettingsString();
        } else {
            settingsText.text = qsTr("Don't forget to write down your seed. You can view your seed and change your settings on settings page.")
        }


    }

    function onPageOpened(settings) {
        updateSettingsSummary();
        wizard.nextButton.visible = false;
    }


    RowLayout {
        id: dotsRow
        Layout.alignment: Qt.AlignRight

        ListModel {
            id: dotsModel
            ListElement { dotColor: "#36B05B" }
            ListElement { dotColor: "#36B05B" }
            ListElement { dotColor: "#36B05B" }
            ListElement { dotColor: "#FFE00A" }
        }

        Repeater {
            model: dotsModel
            delegate: Rectangle {
                width: 12; height: 12
                radius: 6
                color: dotColor
            }
        }
    }

    ColumnLayout {
        id: headerColumn
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            font.family: "Arial"
            font.pixelSize: 28 * scaleRatio
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            //renderType: Text.NativeRendering
            color: "#3F3F3F"
            text: qsTr("You’re all set up!") + translationManager.emptyString
        }

        Text {
            Layout.fillWidth: true
            id: settingsText
            font.family: "Arial"
            font.pixelSize: 16 * scaleRatio
            wrapMode: Text.Wrap
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignHLeft
            //renderType: Text.NativeRendering
            color: "#4A4646"
        }
    }
}
