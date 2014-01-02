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

    signal captureImage()

    property string cameraRollPath

    // This is the camera control that is defined in the cascades multimedia library.
    Camera {
        id: customCamera

        onTouch: {
            if (event.isDown()) {
                // Take photo
                capturePhoto();
            }
        }

        onCameraOpened: {
            var supportedResolutionsArray = new Array();
            supportedResolutionsArray = customCamera.supportedCaptureResolutions(CameraMode.Photo);
            console.log("# Found " + supportedResolutionsArray.length + " resolutions");
            
            for (var index in supportedResolutionsArray) {
                console.log("# Resolution: " + supportedResolutionsArray[index].toString());
            }
            
            // Additional camera settings, setting focus mode and stabilization
            getSettings(customCameraSettings)
            customCameraSettings.focusMode = CameraFocusMode.ContinuousAuto
            customCameraSettings.shootingMode = CameraShootingMode.Stabilization
            customCameraSettings.flashMode = CameraFlashMode.Off
            customCameraSettings.cameraRollPath = "/accounts/1000/shared/photos/";
            applySettings(customCameraSettings)
            customCamera.startViewfinder();
        }

        // There are loads of messages we could listen to here.
        // onPhotoSaved and onShutterFired are taken care of in the C++ code.
        onCameraOpenFailed: {
            console.log("# onCameraOpenFailed signal received with error " + error);
            toast.show();
        }
        onViewfinderStartFailed: {
            console.log("# viewfinderStartFailed signal received with error " + error);
            toast.show();
        }
        onViewfinderStopFailed: {
            console.log("# viewfinderStopFailed signal received with error " + error);
        }
        onPhotoCaptureFailed: {
            console.log("# photoCaptureFailed signal received with error " + error);
        }
        onPhotoSaveFailed: {
            console.log("# photoSaveFailed signal received with error " + error);
        }
        onPhotoSaved: {
            console.log("# photoSaved to " + fileName);
        }
        onShutterFired: {
            console.log("# shutterFired");
            // A cool trick here to play a sound. There are legal requirements in many countries to have a shutter-sound when
            // taking pictures. So we need this shutter sound if you are planning to submit you're app to app world.
            // So we play the shutter-fire sound when the onShutterFired event occurs.
            cameraSound.play();
        }
        onCameraResourceAvailable: {
            // This signal handler is triggered when the Camera resource becomes available to app
            // after being lost by for example putting the phone to sleep, once it has been received
            // it is possible to start the viewfinder again.
            customCamera.startViewfinder()
        }

        onCreationCompleted: {
            // Open the front facing camera.
            customCamera.open(CameraUnit.Rear);
        }

        attachedObjects: [
            CameraSettings {
                id: customCameraSettings
            },
            SystemSound {
                id: cameraSound
                sound: SystemSound.CameraShutterEvent
            },
            SystemToast {
                id: toast
                body: qsTr("An error occurred. Make sure no other camera applications are running, then try again.")
            }
        ]
    }
}