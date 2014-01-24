// *************************************************** //
// New Food Entry Page
//
// This page logs new food entries.
// The process will be handled by the page itself, it
// may call different sub pages or sheets to gather all
// the data, eg. the CaptureImage sheet.
// The new food entry to enter will be held in the newFoodEntry
// property.
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
import "../structures/foodentry.js" as FoodEntryType

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    Page {
        id: newFoodEntryPage

        // signal that image has been captured
        // this will be called by the CaptureImage sheet
        signal addCapturedImage(string imageName)

        // signal that food item has been selected
        // this will be called by the SelectFoodItem sheet
        signal addFoodItem(variant foodItemData)
        
        // the object containing the data of the new entry
        // this is of type FoodEntry()
        property variant newFoodEntry

        Container {
            // layout orientation
            layout: DockLayout {
            }

            // camera image
            // this is filled by the camera control when the image has been taken
            ImageView {
                id: foodCameraImage

                imageSource: "file:///accounts/1000/shared/photos/IMG_00000470.jpg"

                // layout definition
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                scalingMethod: ScalingMethod.AspectFill
            }

            // input controls
            Container {
                // layout definition
                verticalAlignment: VerticalAlignment.Bottom
                bottomPadding: 20

                // recapture the image
                CustomButton {
                    id: captureImageButton

                    // content
                    narrowText: "Tap to recapture image"
                    iconSource: "asset:///images/icons/icon_camera.png"

                    // layout definition
                    alignText: HorizontalAlignment.Center
                    backgroundColor: Color.create(Globals.transparentButtonBackgroundColor)
                    preferredWidth: DisplayInfo.width
                    opacity: 0.85

                    // call to action clicked
                    // open capture image sheet
                    onClicked: {
                        // create and open capture image sheet
                        var captureImagePageObject = captureImagePageComponent.createObject();
                        captureImagePageObject.callingPage = newFoodEntryPage;
                        captureImageSheet.setContent(captureImagePageObject);
                        captureImageSheet.open();
                    }
                }

                // add food item
                CustomButton {
                    id: selectFoodItemButton

                    // content
                    narrowText: "Tap to add a description"
                    iconSource: "asset:///images/icons/icon_description.png"

                    // layout definition
                    topMargin: 10
                    alignText: HorizontalAlignment.Center
                    backgroundColor: Color.create(Globals.transparentButtonBackgroundColor)
                    preferredWidth: DisplayInfo.width
                    opacity: 0.85

                    // call to action clicked
                    // open capture image sheet
                    onClicked: {
                        // create and open food selection sheet
                        var selectFoodItemPageObject = selectFoodItemPageComponent.createObject();
                        selectFoodItemPageObject.callingPage = newFoodEntryPage;
                        navigationPane.push(selectFoodItemPageObject);

                        // indicate that page is now visible
                        // this is a workaround because requestFocus only works after page is visible in stack
                        // see: http://supportforums.blackberry.com/t5/Native-Development/problems-with-request-focus-for-a-textfield/m-p/2652023#M51962
                        selectFoodItemPageObject.pageLoadedInNavigationStack = true;
                    }
                }
            }

            // info message
            InfoMessage {
                id: infoMessage

                // layout definition
                verticalAlignment: VerticalAlignment.Center
                leftPadding: 10
                rightPadding: 10
            }
        }

        onCreationCompleted: {
            // initialize the new food entry object
            var newEntry = new FoodEntryType.FoodEntry();
            newFoodEntryPage.newFoodEntry = newEntry;

            // create and open capture image sheet on creation
            // var captureImagePageObject = captureImagePageComponent.createObject();
            // captureImagePageObject.callingPage = newFoodEntryPage;
            // captureImageSheet.setContent(captureImagePageObject);
            // captureImageSheet.open();
        }
        
        onAddCapturedImage: {
            // add image to thumbnail component
            foodCameraImage.imageSource = "file:///" + imageName;
            
            // store the image file to the page food entry
            // note that a temp entry is needed because the children of the page variant are read only
            var tempEntry = new FoodEntryType.FoodEntry();
            tempEntry = newFoodEntryPage.newFoodEntry;
            tempEntry.imageFile = imageName;
            newFoodEntryPage.newFoodEntry = tempEntry;
        }
        
        onAddFoodItem: {
            // store the food item data to the page food entry
            // note that a temp entry is needed because the children of the page variant are read only
            var tempEntry = new FoodEntryType.FoodEntry();
            tempEntry = newFoodEntryPage.newFoodEntry;
            tempEntry.foodid = foodItemData.id;
            tempEntry.description = foodItemData.description;
            tempEntry.portion = foodItemData.portion;
            tempEntry.calories = foodItemData.calories;
            newFoodEntryPage.newFoodEntry = tempEntry;
        }
    }

    // attach components
    attachedObjects: [
        // page to select food for an item
        // will be called if user clicks on add description
        ComponentDefinition {
            id: selectFoodItemPageComponent
            source: "SelectFoodItem.qml"
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}