// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

import QtQuick 2.0
import QtMultimedia 5.4
import QtQuick.Dialogs 1.2
import bitlitasComponents.QRCodeScanner 1.0

Rectangle {
    id : root

    x: 0
    y: 0
    z: parent.z+1
    width: parent.width
    height: parent.height

    visible: false
    color: "black"
    state: "Stopped"

    signal qrcode_decoded(string address, string payment_id, string amount, string tx_description, string recipient_name, var extra_parameters)

    states: [
        State {
            name: "Capture"
            StateChangeScript {
                script: {
		    root.visible = true
                    camera.captureMode = Camera.CaptureStillImage
                    camera.start()
                    finder.enabled = true
                }
            }
        },
        State {
            name: "Stopped"
            StateChangeScript {
                script: {
                    camera.stop()
		    root.visible = false
                    finder.enabled = false
                }
            }
        }
    ]

    Camera {
        id: camera
        objectName: "qrCameraQML"
        captureMode: Camera.CaptureStillImage

        focus {
            focusMode: Camera.FocusContinuous
        }
    }
    QRCodeScanner {
        id : finder
        objectName: "QrFinder"
        onDecoded : {
            root.qrcode_decoded(address, payment_id, amount, tx_description, recipient_name, extra_parameters)
            root.state = "Stopped"
	}
        onNotifyError : {
            if( warning )
                messageDialog.icon = StandardIcon.Critical
            else {
                messageDialog.icon = StandardIcon.Warning
                root.state = "Stopped"
            }
            messageDialog.text = error
            messageDialog.visible = true
        }
    }

    VideoOutput {
        id: viewfinder
        visible: root.state == "Capture"

        x: 0
        y: 0
        z: parent.z+1
        width: parent.width
        height: parent.height

        source: camera
        autoOrientation: true

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onPressAndHold: {
                if (camera.lockStatus == Camera.locked)camera.unlock()
                camera.searchAndLock()
            }
            onDoubleClicked: {
                root.state = "Stopped"
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("QrCode Scanned")  + translationManager.emptyString
        onAccepted: {
            root.state = "Stopped"
        }
    }

    Component.onCompleted: {
        if( QtMultimedia.availableCameras.length == 0) {
            console.log("No camera available. Disable qrScannerEnabled");
            appWindow.qrScannerEnabled = false;
        }
    }
}
