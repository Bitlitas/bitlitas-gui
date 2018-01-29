// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import bitlitasComponents.WalletManager 1.0
import QtQuick 2.2
import QtQuick.Layouts 1.1
import "../components"
import "utils.js" as Utils

ColumnLayout {
    property alias password: passwordItem.password
    property alias confirmPassword: retypePasswordItem.password
    property bool passwordsMatch: passwordItem.password === retypePasswordItem.password

    function handlePassword() {
      // allow to forward step only if passwords match

      wizard.nextButton.enabled = passwordItem.password === retypePasswordItem.password

      // TODO: password strength meter segfaults on Android.
      if (!isAndroid) {
          // scorePassword returns value from 0 to... lots
          var strength = walletManager.getPasswordStrength(passwordItem.password);
          // consider anything below 10 bits as dire
          strength -= 10
          if (strength < 0)
              strength = 0
          // use a slight parabola to discourage short passwords
          strength = strength ^ 1.2 / 3
          // mapScope does not clamp
          if (strength > 100)
              strength = 100
          // privacyLevel component uses 1..13 scale
          privacyLevel.fillLevel = Utils.mapScope(1, 100, 1, 13, strength)
      }
    }

    function resetFocus() {
        passwordItem.focus = true
    }

    WizardPasswordInput {
        id: passwordItem
        Layout.fillWidth: true
        Layout.maximumWidth: 300 * scaleRatio
        Layout.minimumWidth: 200 * scaleRatio
        Layout.alignment: Qt.AlignHCenter
        placeholderText : qsTr("Password") + translationManager.emptyString;
        KeyNavigation.tab: retypePasswordItem
        onChanged: handlePassword()
        focus: true
    }

    WizardPasswordInput {
        id: retypePasswordItem
        Layout.fillWidth: true
        Layout.maximumWidth: 300 * scaleRatio
        Layout.minimumWidth: 200 * scaleRatio
        Layout.alignment: Qt.AlignHCenter
        placeholderText : qsTr("Confirm password") + translationManager.emptyString;
        KeyNavigation.tab: passwordItem
        onChanged: handlePassword()
    }

    PrivacyLevelSmall {
        visible: !isAndroid //TODO: strength meter doesnt work on Android
        Layout.topMargin: isAndroid ? 20 * scaleRatio : 40 * scaleRatio
        Layout.fillWidth: true
        id: privacyLevel
        background: "#F0EEEE"
        interactive: false
    }

    Component.onCompleted: {
        //parent.wizardRestarted.connect(onWizardRestarted)
    }
}
