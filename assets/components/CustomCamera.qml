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

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: customCameraComponent

    // external trigger to capture a photo
    // TODO: Implement
    signal capturePhoto()

    // external trigger to stop the camera
    signal stopCamera()

    // signal that an image has been captured and saved
    signal photoCaptured(string imageName)

    // signal that camera could not be started
    signal errorOccured(string errorMessage)

    // path to store the captured images in
    property string cameraRollPath

    // flag if the camera is currently active
    property bool cameraActive: false

    // This is the camera control that is defined in the cascades multimedia library
    Camera {
        id: customCamera
        
        onCameraOpened: {
            // iterate through all available camwera resolutions
            var supportedResolutionsArray = new Array();
            supportedResolutionsArray = customCamera.supportedCaptureResolutions(CameraMode.Photo);
            console.log("# Found " + supportedResolutionsArray.length + " resolutions");

            // TODO: Check if the resolutions can actually be read
            /*
             * for (var index in supportedResolutionsArray) {
             * console.log("# Resolution: " + supportedResolutionsArray[index].toString());
             * }
             */

            // define additional camera settings, eg. setting focus mode and stabilization
            getSettings(customCameraSettings);
            customCameraSettings.focusMode = CameraFocusMode.ContinuousAuto
            customCameraSettings.shootingMode = CameraShootingMode.Stabilization
            customCameraSettings.flashMode = CameraFlashMode.Off
            customCameraSettings.cameraRollPath = "/accounts/1000/shared/photos/";
            applySettings(customCameraSettings)

            // start the viewfinder as soon as the camera is ready
            customCamera.startViewfinder();
        }

        // set active flag to true
        onViewfinderStarted: {
            customCameraComponent.cameraActive = true;
        }

        // set active flag to false
        onViewfinderStopped: {
            customCameraComponent.cameraActive = false;
        }

        // photo has been saved correctly
        onPhotoSaved: {
            customCameraComponent.photoCaptured(fileName);
        }

        // shutter has been triggered
        // play shutter sound accordingly
        onShutterFired: {
            cameraSound.play();
        }

        // this signal handler is triggered when the Camera resource becomes available to app
        // after being lost by for example putting the phone to sleep, once it has been received
        // it is possible to start the viewfinder again
        onCameraResourceAvailable: {
            customCamera.startViewfinder()
        }

        // open the rear facing camera
        onCreationCompleted: {
            customCamera.open(CameraUnit.Rear);
        }

        // handle touch event on the camera component itself
        // this will trigger a capture photo event
        onTouch: {
            if (event.isDown()) {
                customCamera.capturePhoto();
            }
        }

        // handle all the different error cases and messages
        // note that onPhotoSaved and onShutterFired are taken care of in the C++ code
        // camera could not be opened / object could not be created
        onCameraOpenFailed: {
            // console.log("# onCameraOpenFailed signal received with error " + error);
            customCameraComponent.errorOccured(error);
        }

        // camera could not be opened / object could not be created
        onViewfinderStartFailed: {
            // console.log("# viewfinderStartFailed signal received with error " + error);
            customCameraComponent.errorOccured(error);
        }

        // camera could not be ^stopped / object could not be destroyed
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

        attachedObjects: [
            CameraSettings {
                id: customCameraSettings
            },
            SystemSound {
                id: cameraSound
                sound: SystemSound.CameraShutterEvent
            }
        ]
    }
    
    // stop camera signal
    // this will stop the viewfinder and close the camera
    onStopCamera: {
        customCamera.stopViewfinder();
        customCamera.close();
    }
}