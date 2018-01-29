// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.2
import QtQuick.Dialogs 1.2
import bitlitasComponents.Wallet 1.0
import QtQuick.Layouts 1.1
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
        // Empty seedText
        uiItem.wordsTextItem.memoText = ""
        uiItem.recoverFromKeysAddress = ""
        uiItem.recoverFromKeysSpendKey = ""
        uiItem.recoverFromKeysViewKey = ""
    }

    function onPageOpened(settingsObject) {
        console.log("on page opened")
        uiItem.checkNextButton();
    }

    function onPageClosed(settingsObject) {
        settingsObject['account_name'] = uiItem.accountNameText
        settingsObject['words'] = Utils.lineBreaksToSpaces(uiItem.wordsTextItem.memoText)
        settingsObject['wallet_path'] = uiItem.walletPath
        settingsObject['recover_address'] = uiItem.recoverFromKeysAddress
        settingsObject['recover_viewkey'] = uiItem.recoverFromKeysViewKey
        settingsObject['recover_spendkey'] = uiItem.recoverFromKeysSpendKey


        var restoreHeight = parseInt(uiItem.restoreHeight);
        settingsObject['restore_height'] = isNaN(restoreHeight)? 0 : restoreHeight
        var walletFullPath = wizard.createWalletPath(uiItem.walletPath,uiItem.accountNameText);
        if(!wizard.walletPathValid(walletFullPath)){
           return false
        }
        return recoveryWallet(settingsObject, uiItem.recoverFromSeedMode)
    }

    function recoveryWallet(settingsObject, fromSeed) {
        var testnet = appWindow.persistentSettings.testnet;
        var restoreHeight = settingsObject.restore_height;
        var tmp_wallet_filename = oshelper.temporaryFilename()
        console.log("Creating temporary wallet", tmp_wallet_filename)

        // delete the temporary wallet object before creating new
        if (typeof m_wallet !== 'undefined') {
            walletManager.closeWallet()
            console.log("deleting temporary wallet")
        }

        // From seed or keys
        if(fromSeed)
            var wallet = walletManager.recoveryWallet(tmp_wallet_filename, settingsObject.words, testnet, restoreHeight)
        else
            var wallet = walletManager.createWalletFromKeys(tmp_wallet_filename, settingsObject.wallet_language, testnet,
                                                            settingsObject.recover_address, settingsObject.recover_viewkey,
                                                            settingsObject.recover_spendkey, restoreHeight)


        var success = wallet.status === Wallet.Status_Ok;
        if (success) {
            m_wallet = wallet;
            settingsObject['is_recovering'] = true;
            settingsObject['tmp_wallet_filename'] = tmp_wallet_filename
        } else {
            console.log(wallet.errorString)
            walletErrorDialog.text = wallet.errorString;
            walletErrorDialog.open();
            walletManager.closeWallet();
        }
        return success;
    }



    WizardManageWalletUI {
        id: uiItem
        accountNameText: defaultAccountName
        titleText: qsTr("Restore wallet") + translationManager.emptyString
        wordsTextItem.clipboardButtonVisible: false
        wordsTextItem.tipTextVisible: false
        wordsTextItem.memoTextReadOnly: false
        wordsTextItem.memoText: ""
        wordsTextItem.visible: true
        restoreHeightVisible: true
        recoverMode: true
        wordsTextItem.onMemoTextChanged: {
            checkNextButton();
        }
    }

    Component.onCompleted: {
        parent.wizardRestarted.connect(onWizardRestarted)
    }
}
