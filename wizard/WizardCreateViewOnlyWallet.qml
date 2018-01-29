// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import bitlitasComponents.WalletManager 1.0
import QtQuick 2.2
import QtQuick.Layouts 1.1
import "../components"
import "utils.js" as Utils

ColumnLayout {

    id: passwordPage
    opacity: 0
    visible: false

    Behavior on opacity {
        NumberAnimation { duration: 100; easing.type: Easing.InQuad }
    }

    onOpacityChanged: visible = opacity !== 0


    function onPageOpened(settingsObject) {
        wizard.nextButton.enabled = true
        wizard.nextButton.visible = true
    }

    function onPageClosed(settingsObject) {      
        var walletFullPath = wizard.createWalletPath(uiItem.walletPath,uiItem.accountNameText);
        settingsObject['view_only_wallet_path'] = walletFullPath
        console.log("wallet path", walletFullPath)
        return wizard.walletPathValid(walletFullPath);
    }

    ListModel {
        id: dotsModel
        ListElement { dotColor: "#36B05B" }
        ListElement { dotColor: "#DBDBDB" }
    }

    WizardManageWalletUI {
        id: uiItem
        titleText: qsTr("Create view only wallet") + translationManager.emptyString
        wordsTextItem.visible: false
        restoreHeightVisible:false
        walletName: appWindow.walletName + "-viewonly"
        progressDotsModel: dotsModel
        recoverMode: false
    }

    Component.onCompleted: {
        //parent.wizardRestarted.connect(onWizardRestarted)
    }
}
