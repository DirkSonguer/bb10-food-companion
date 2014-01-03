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
            title: "Capture image"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_camera.png"
            
            // snap image when pressed
            onTriggered: {
                cameraComponent.capturePhoto();
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
