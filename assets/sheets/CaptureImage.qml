// *************************************************** //
// Shoot Image Sheet
//
// This sheet acts as a camera control, similar to the
// camera invocation sheet, however more tightly
// integrated.
// It also allows to set the target directory for images
// (which the invocation sheet does not).
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.cascades.multimedia 1.0
import bb.multimedia 1.0

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Page {
    id: captureImagePage

    // property that holds the calling page
    // this page will receive the imageCaptured() signal
    property variant callingPage

    // flag if flash is active
    property bool cameraFlashState: false
    
    Container {
        // layout orientation
        layout: DockLayout {
        }

        CustomCamera {
            id: cameraComponent

            // photo has been captured
            // close sheet and hand over data
            onPhotoCaptured: {
                callingPage.imageCaptured(imageName);
                cameraComponent.stopCamera();
                captureImageSheet.close();
            }
        }

        InfoMessage {
            id: infoMessage

            leftPadding: 0
            rightPadding: 0
        }
    }

    // close action for the sheet
    actions: [
        ActionItem {
            id: cameraFlashAction
            title: "Flash is off"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_notavailable.png"

            // edit flash mode
            onTriggered: {
                if (!captureImagePage.cameraFlashState) {
                    captureImagePage.cameraFlashState = true;
                    cameraComponent.cameraFlashMode = CameraFlashMode.On
                    cameraFlashAction.title = "Flash is on";
                    cameraFlashAction.imageSource = "asset:///images/icons/icon_flash.png"
                } else {                    
                    captureImagePage.cameraFlashState = false;
                    cameraComponent.cameraFlashMode = CameraFlashMode.Off
                    cameraFlashAction.title = "Flash is off";
                    cameraFlashAction.imageSource = "asset:///images/icons/icon_notavailable.png"
                }
            }
        },
        ActionItem {
            title: "Close"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_close.png"

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                cameraComponent.stopCamera();
                captureImageSheet.close();
            }
        }
    ]
}
