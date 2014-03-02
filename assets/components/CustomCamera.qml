// *************************************************** //
// Custom Camera Component
//
// This component handles al the usual camera and
// capturing logic and wraps it conveniently
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.cascades.multimedia 1.0
import bb.multimedia 1.0
import bb.system 1.2

// import camera utilities
import CameraUtilities 1.0

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: customCameraComponent

    // external trigger to stop the camera
    signal stopCamera()

    // signal that an image has been captured and saved
    // this needs to be catched by the including page
    signal photoCaptured(string imageName)

    // signal that camera could not be started
    // errors are handled within the component
    signal errorOccured(string errorMessage)

    // path to store the captured images in
    property string cameraRollPath

    // flag if the camera is currently active
    property bool cameraActive: false

    // flag if the capture is currently in progress
    property bool captureInProgress: false

    // property that holds and changes the the flash mode
    property int cameraFlashMode: CameraFlashMode.Off

    // layout orientation
    layout: DockLayout {
    }

    // This is the camera control that is defined in the cascades multimedia library
    Camera {
        id: customCamera

        preferredHeight: DisplayInfo.height

        onCameraOpened: {
            // TODO: Check and iterate through all available camwera resolutions and set it accordingly
            cameraUtilities.selectAspectRatio(customCamera, DisplayInfo.width / DisplayInfo.height);

            // define additional camera settings, eg. setting focus mode and stabilization
            getSettings(customCameraSettings);
            customCameraSettings.focusMode = CameraFocusMode.ContinuousAuto
            customCameraSettings.shootingMode = CameraShootingMode.Stabilization
            customCameraSettings.flashMode = customCameraComponent.cameraFlashMode
            customCameraSettings.cameraRollPath = "/accounts/1000/shared/photos";
            applySettings(customCameraSettings)

            // start the viewfinder as soon as the camera is ready
            customCamera.startViewfinder();
        }

        // set active flag to true when viewfinder is started
        onViewfinderStarted: {
            customCameraComponent.cameraActive = true;
        }

        // set active flag to false when viewfinder is stopped
        onViewfinderStopped: {
            customCameraComponent.cameraActive = false;
        }

        // photo has been saved correctly
        onPhotoSaved: {
            // correct the orientation of the image to be upright
            // note that otherwise all images will be landscape
            cameraUtilities.correctImageOrientation(fileName);

            // send signal that image has been captured and stored
            customCameraComponent.photoCaptured(fileName);

            // reset capture flag
            customCameraComponent.captureInProgress = true;
        }

        // shutter has been triggered
        // play shutter sound accordingly
        onShutterFired: {
            console.log("# Image taken, play shutter sound");
            cameraSound.play();
        }

        // this signal handler is triggered when the camera resource becomes available to app
        // after being lost by for example putting the phone to sleep, once it has been received
        // it is possible to start the viewfinder again
        onCameraResourceAvailable: {
            customCamera.startViewfinder()
        }

        // open the rear facing camera on component creation
        onCreationCompleted: {
            customCamera.open(CameraUnit.Rear);
        }

        // handle all the different error cases and messages
        // camera could not be opened / object could not be created
        onCameraOpenFailed: {
            // console.log("# onCameraOpenFailed signal received with error " + error);
            customCameraComponent.errorOccured();
        }

        // camera could not be opened / object could not be created
        onViewfinderStartFailed: {
            // console.log("# viewfinderStartFailed signal received with error " + error);
            customCameraComponent.errorOccured(error);
        }

        // camera could not be stopped / object could not be destroyed
        onViewfinderStopFailed: {
            // console.log("# viewfinderStopFailed signal received with error " + error);
            customCameraComponent.errorOccured(error);
        }

        // photo could not be captured
        onPhotoCaptureFailed: {
            // console.log("# photoCaptureFailed signal received with error " + error);
            customCameraComponent.errorOccured(error);
        }

        // photo could not be saved
        onPhotoSaveFailed: {
            // console.log("# photoSaveFailed signal received with error " + error);
            customCameraComponent.errorOccured(error);
        }

        onFocusStateChanged: {
            if (state == CameraFocusState.Locked) {
                customCameraFocusIndicator.imageSource = "asset:///images/icons/icon_focussed.png";
            } else {
                customCameraFocusIndicator.imageSource = "asset:///images/icons/icon_focussing.png";
            }
        }

        attachedObjects: [
            CameraSettings {
                id: customCameraSettings
            },
            SystemSound {
                id: cameraSound
                sound: SystemSound.CameraShutterEvent
            },
            CameraUtilities {
                id: cameraUtilities
            }
        ]
    }

    // call to action container
    Container {
        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center

        ImageView {
            id: customCameraFocusIndicator
            preferredHeight: 162
            preferredWidth: 162
            imageSource: "asset:///images/icons/icon_focussing.png"
        }
    }

    // call to action container
    Container {
        // layout definition
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Bottom
        leftPadding: 10
        rightPadding: 10
        bottomPadding: 10

        Label {
            id: customCameraMessage

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BigText
            textStyle.fontSize: FontSize.PointValue
            textStyle.fontSizeValue: 14
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left

            // use multiline / line breaks
            multiline: true

            // text content
            text: "Tap here to capture the image. Use the buttons to toggle the flash or abort."
        }
    }

    // handle touch event on the camera component itself
    // this will trigger a capture photo event
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // check if capture is already in progress
                // if not, take new image
                if (! customCameraComponent.captureInProgress) {
                    customCameraComponent.captureInProgress = true;
                    customCameraMessage.text = "Capturing, please wait.";
                    customCamera.capturePhoto();
                }
            }
        }
    ]

    // change flash mode according to change
    onCameraFlashModeChanged: {
        customCamera.getSettings(customCameraSettings);
        customCameraSettings.flashMode = customCameraComponent.cameraFlashMode
        customCamera.applySettings(customCameraSettings)
    }

    // stop camera signal
    // this will stop the viewfinder and close the camera
    onStopCamera: {
        customCamera.close();
    }

    // error occured signal was sent
    // show the error message on the control
    onErrorOccured: {
        customCameraMessage.text = "Sorry, an error occured. The error ID is " + errorMessage + ", please restart the app and try again.";

        // stop camera control to reset states
        customCameraComponent.stopCamera();
    }
}