// *************************************************** //
// Add Item Page
//
// This page is the main page to log new food entries.
// The process will be handled by the page itself
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
    id: addItemPage

    // signal that image has been captured
    // this will be called by the CaptureImage sheet
    signal imageCaptured(string imageName)

    // property that holds the current health rating for the item
    // this is manipulated by the healt rating slider
    property int currentHealthRating: 0

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // page header
        PageHeader {
            headline: "Add item"
            imageSource: "asset:///images/header_background.png"
        }

        // food image or call to action
        Container {
            // layout definiton
            topMargin: 5

            // call to action
            // this is visible when no image has been taken yet
            CustomButton {
                id: cameraCallToAction

                // layout definition
                preferredWidth: DisplayInfo.width
                preferredHeight: 350

                // call to action message
                iconSource: "asset:///images/icons/icon_camera.png"
                narrowText: "Tap to add image"

                // call to action clicked
                // open capture image sheet
                onClicked: {
                    // create and open capture image sheet
                    var captureImageContent = captureImageComponent.createObject();
                    captureImageContent.callingPage = addItemPage;
                    captureImageSheet.setContent(captureImageContent);
                    captureImageSheet.open();
                }
            }

            // captured image thumbnail view
            Container {
                id: cameraImageContainer

                // layout orientation
                layout: DockLayout {
                }

                // layout definition
                preferredWidth: DisplayInfo.width
                preferredHeight: 350

                // set initial visibility to false
                // this will be set by the camera sheet
                visible: false

                // camera image
                // this is filled by the camera control when the image has been taken
                ImageView {
                    id: cameraImagePreview

                    // layout definition
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    scalingMethod: ScalingMethod.AspectFill
                }

                // call to action to recapture image
                Container {
                    // layout definition
                    preferredWidth: DisplayInfo.width
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Right
                    topPadding: 5
                    leftPadding: 10
                    rightPadding: 10
                    bottomPadding: 5

                    // background definition
                    background: Color.create(Globals.foodcompanionDefaultBackgroundColor)
                    opacity: 0.75

                    // call to action label
                    Label {
                        // style defintion
                        textStyle.base: SystemDefaults.TextStyles.BodyText
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left

                        // text content
                        text: "Thumbnail view, tap to recapture image"
                    }
                }

                // handle tap on existing image
                gestureHandlers: [
                    TapHandler {
                        onTapped: {
                            // create and open capture image sheet
                            var captureImageContent = captureImageComponent.createObject();
                            captureImageContent.callingPage = addItemPage;
                            captureImageSheet.setContent(captureImageContent);
                            captureImageSheet.open();
                        }
                    }
                ]
            }

            // camera info message
            // this will contain any camera related info / error messages
            InfoMessage {
                id: cameraInfoMessage

                // layout definition
                leftPadding: 0
                rightPadding: 0
            }
        }

        // food description call to action
        Container {
            // layout definiton
            topMargin: 5

            // call to action
            // this is visible when no description has been added yet
            CustomButton {
                id: descriptionCallToAction

                // layout definition
                preferredWidth: DisplayInfo.width
                preferredHeight: 150

                // call to action message
                iconSource: "asset:///images/icons/icon_description.png"
                narrowText: "Tap to add description"
            }
        }

        // health rating slider
        Container {
            // layout definition
            leftPadding: 10
            rightPadding: 10
            topPadding: 10

            // small headline describing the slider feature
            Container {
                // layout definition
                leftPadding: 25

                Label {
                    // layout definition
                    horizontalAlignment: HorizontalAlignment.Left

                    // description text
                    text: "Rate this item:"

                    // text style definition
                    textStyle.base: SystemDefaults.TextStyles.SmallText
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                }
            }

            // health rating description
            Label {
                id: healthRating

                // layout definition
                horizontalAlignment: HorizontalAlignment.Center

                // initial health rating
                text: "Healthy"

                // text style definition
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 12
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Right
                textStyle.color: Color.White
            }

            // health rating slider
            Slider {
                // slider range definition
                fromValue: 0
                toValue: 2
                value: 2

                // add logic to change rating on slider movement
                onImmediateValueChanged: {
                    var intImmediateValue = Math.round(immediateValue);

                    // if the slider value has changed, show the according text
                    if (addItemPage.currentHealthRating != intImmediateValue) {
                        healthRating.text = Copytext.foodcompanionHealthValues[intImmediateValue];
                        addItemPage.currentHealthRating = intImmediateValue
                    }
                }
            }
        }

        // confirmation button
        Container {
            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topPadding: 50

            // confirmation button
            CustomButton {
                id: addEntryButton

                // layout definition
                preferredWidth: DisplayInfo.width - 20

                // confirmation text
                boldText: "Add entry"
            }
        }
    }

    onImageCaptured: {
        cameraCallToAction.visible = false;
        cameraImagePreview.imageSource = "file:///" + imageName;
        cameraImageContainer.visible = true;
    }
}