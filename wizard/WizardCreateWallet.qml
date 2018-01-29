// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.2
import bitlitasComponents.WalletManager 1.0
import bitlitasComponents.Wallet 1.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import 'utils.js' as Utils

ColumnLayout {
    opacity: 0
    visible: false

    Behavior on opacity {
        NumberAnimation { duration: 100; easing.type: Easing.InQuad }
    }


    onOpacityChanged: visible = opacity !== 0

    function onWizardRestarted() {
        // reset account name field
        uiItem.accountNameText = defaultAccountName
    }

    //! function called each time we display this page

    function onPageOpened(settingsOblect) {
        checkNextButton()
    }

    function onPageClosed(settingsObject) {
        settingsObject['account_name'] = uiItem.accountNameText
        settingsObject['words'] = uiItem.wordsTexttext
        settingsObject['wallet_path'] = uiItem.walletPath
        console.log("path " +uiItem.walletPath);
        var walletFullPath = wizard.createWalletPath(uiItem.walletPath,uiItem.accountNameText);
        return wizard.walletPathValid(walletFullPath);
    }

    function checkNextButton() {
        var wordsArray = Utils.lineBreaksToSpaces(uiItem.wordsTextItem.memoText).split(" ");
        wizard.nextButton.enabled = wordsArray.length === 25;
    }

    //! function called each time we hide this page
    //


    function createWallet(settingsObject) {
        // TODO: create wallet in temporary filename and a) move it to the path specified by user after the final
        // page submitted or b) delete it when program closed before reaching final page

        // Always delete the wallet object before creating new - we could be stepping back from recovering wallet
        if (typeof m_wallet !== 'undefined') {
            walletManager.closeWallet()
            console.log("deleting wallet")
        }

        var tmp_wallet_filename = oshelper.temporaryFilename();
        console.log("Creating temporary wallet", tmp_wallet_filename)
        var testnet = appWindow.persistentSettings.testnet;
        var wallet = walletManager.createWallet(tmp_wallet_filename, "", settingsObject.wallet_language,
                                                testnet)
        uiItem.wordsTextItem.memoText = wallet.seed
        // saving wallet in "global" settings object
        // TODO: wallet should have a property pointing to the file where it stored or loaded from
        m_wallet = wallet;
        settingsObject['tmp_wallet_filename'] = tmp_wallet_filename
    }

    WizardManageWalletUI {
        id: uiItem
        titleText: qsTr("Create a new wallet") + translationManager.emptyString
        wordsTextItem.clipboardButtonVisible: true
        wordsTextItem.tipTextVisible: true
        wordsTextItem.memoTextReadOnly: true
        restoreHeightVisible:false
        recoverMode: false
    }

    Component.onCompleted: {
        parent.wizardRestarted.connect(onWizardRestarted)
    }
}
