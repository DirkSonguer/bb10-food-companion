// *************************************************** //
// Capture Image Sheet
//
// This sheet acts as a camera control, similar to the
// camera invocation sheet, however more tightly
// integrated.
// It also allows to set the target directory for images
// (which the invocation sheet does not).
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
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
    // this page will receive the addCapturedImage() signal
    property variant callingPage

    // flag if flash is active
    property bool cameraFlashState: false

    Container {
        // layout orientation
        layout: DockLayout {
        }

        // custom camera control
        // this will take care of most of the logic
        CustomCamera {
            id: cameraComponent

            // photo has been captured
            // close sheet and hand over data
            onPhotoCaptured: {
                // return the file name of the captured image back to the calling page
                callingPage.addCapturedImage(imageName);

                // stop the camera control
                cameraComponent.stopCamera();

                // close the sheet, thus going back to the calling page
                captureImageSheet.close();
            }
        }
    }

    actions: [
        // change flash state
        // this is basically a toggle buttom
        ActionItem {
            id: cameraFlashAction
            ActionBar.placement: ActionBarPlacement.OnBar
            
            // flash is initially off, show respective text and icon
            title: "Flash is off"            
            imageSource: "asset:///images/icons/icon_notavailable.png"

            // edit flash mode
            onTriggered: {
                if (! captureImagePage.cameraFlashState) {
                    // turn on flash mode and edit action item accordingly
                    captureImagePage.cameraFlashState = true;
                    cameraComponent.cameraFlashMode = CameraFlashMode.On
                    cameraFlashAction.title = "Flash is on";
                    cameraFlashAction.imageSource = "asset:///images/icons/icon_flash.png"
                } else {
                    // turn off flash mode and edit action item accordingly
                    captureImagePage.cameraFlashState = false;
                    cameraComponent.cameraFlashMode = CameraFlashMode.Off
                    cameraFlashAction.title = "Flash is off";
                    cameraFlashAction.imageSource = "asset:///images/icons/icon_notavailable.png"
                }
            }
        },
        // close action for the sheet
        // note that no data is handed over in this case
        ActionItem {
            title: "Close"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_close.png"

            // close sheet when pressed
            onTriggered: {
                // camera control needs to be stopped first
                // otherwise it will block the camera
                cameraComponent.stopCamera();
                captureImageSheet.close();
            }
        }
    ]
}
