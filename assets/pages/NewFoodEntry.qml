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
import "../classes/entrydatabase.js" as EntryDatabase

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    // signal that page should be reset
    // this will be handed over to the page event
    // to reset / reload data
    signal resetPage()
    onResetPage: {
        newFoodEntryPage.resetPage();
    }

    Page {
        id: newFoodEntryPage

        // signal that page should be reset
        signal resetPage()

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

            // background image slot
            // this just shows the wooden background
            ImageView {
                id: backgroundImage

                // layout definition
                verticalAlignment: VerticalAlignment.Top
                preferredWidth: DisplayInfo.width
                preferredHeight: DisplayInfo.height

                // image scaling and opacity
                scalingMethod: ScalingMethod.AspectFill

                // accessibility
                accessibility.name: ""
                
                // set initial visibility to false
                visible: false
            }

            Container {
                // layout definition
                verticalAlignment: VerticalAlignment.Bottom
                leftPadding: 10
                rightPadding: 10
                bottomPadding: 10

                // recapture the image
                CustomButton {
                    id: captureImageButton

                    // content
                    narrowText: "Capture image"
                    iconSource: "asset:///images/icons/icon_camera.png"

                    // layout definition
                    alignText: HorizontalAlignment.Center
                    backgroundColor: Color.create(Globals.defaultBackgroundColor)
                    preferredWidth: DisplayInfo.width
                    opacity: 0.95

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
                    narrowText: "Add a description"
                    iconSource: "asset:///images/icons/icon_description.png"

                    // layout definition
                    topMargin: 5
                    alignText: HorizontalAlignment.Center
                    backgroundColor: Color.create(Globals.defaultBackgroundColor)
                    preferredWidth: DisplayInfo.width
                    opacity: 0.95

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

                FoodEntryDescription {
                    id: foodEntryDescription

                    // layout definition
                    topMargin: 5
                    preferredWidth: DisplayInfo.width
                    opacity: 0.95

                    // set initial visibility to false
                    // will be set visible when a food item has been selected
                    visible: false

                    // food entry description changed
                    onFoodDescriptionChanged: {
                        // store the food entry data to the page food entry
                        // note that a temp entry is needed because the children of the page variant are read only
                        var tempEntry = new FoodEntryType.FoodEntry();
                        tempEntry = newFoodEntryPage.newFoodEntry;
                        tempEntry.size = foodEntryData.size;
                        tempEntry.rating = foodEntryData.rating;
                        newFoodEntryPage.newFoodEntry = tempEntry;

                        // changing background color according to health rating
                        addEntryButton.background = Color.create(Globals.healthRatingColors[tempEntry.rating]);
                    }

                    onClicked: {
                        // this should open the food item selection page
                        // basically the same as with pressing the call to action
                        selectFoodItemButton.clicked();
                    }
                }

                // confirmation button
                CustomButton {
                    id: addEntryButton

                    // content
                    boldText: "Store food entry"
                    iconSource: "asset:///images/icons/icon_add.png"
                    backgroundColor: Color.create(Globals.healthRatingColors[2])

                    // layout definition
                    topMargin: 5
                    alignText: HorizontalAlignment.Center
                    preferredWidth: DisplayInfo.width
                    opacity: 0.95

                    // add food item clicked
                    // this will stored in the entry database
                    onClicked: {
                        // check if description is available
                        if (! newFoodEntryPage.newFoodEntry.description) {
                            foodcompanionToast.body = Copytext.noFoodDescription;
                            foodcompanionToast.show();

                            // WARNING: Activate this in productive version!
                            return;
                        }

                        // add to entry database
                        EntryDatabase.entrydb.addEntry(newFoodEntryPage.newFoodEntry);

                        // show confirmation toast
                        foodcompanionToast.body = Copytext.foodEntrySaved;
                        foodcompanionToast.show();

                        // send signal to reload data
                        foodGalleryTab.content.resetPage();

                        // jump back to the gallery tab
                        tabbedPane.activeTab = foodGalleryTab;
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

        // camera image has been captured
        // this will be called by the CaptureImage sheet
        // data will be the path to the captured image
        onAddCapturedImage: {
            console.log("# Updating new food item image: " + imageName);

            // add image to thumbnail component
            backgroundImage.imageSource = "file:///" + imageName;
            backgroundImage.visible = true;

            // store the image file to the page food entry
            // note that a temp entry is needed because the children of the page variant are read only
            var tempEntry = new FoodEntryType.FoodEntry();
            tempEntry = newFoodEntryPage.newFoodEntry;
            tempEntry.imageFile = imageName;
            newFoodEntryPage.newFoodEntry = tempEntry;
        }

        // food description has been added or changed
        // this is originally entered by the SelectFoodItem page
        // data will later be changed by the FoodEntryDescription component
        onAddFoodItem: {
            // console.log("# Updating new food item data: " + foodItemData.description);

            // store the food item data to the page food entry
            // note that a temp entry is needed because the children of the page variant are read only
            var tempEntry = new FoodEntryType.FoodEntry();
            tempEntry = newFoodEntryPage.newFoodEntry;
            tempEntry.foodid = foodItemData.foodid;
            tempEntry.description = foodItemData.description;
            tempEntry.portion = foodItemData.portion;
            tempEntry.calories = foodItemData.calories;
            newFoodEntryPage.newFoodEntry = tempEntry;

            // show food description details
            foodEntryDescription.foodEntryData = newFoodEntryPage.newFoodEntry;
            foodEntryDescription.visible = true;

            // show / hide other elements
            selectFoodItemButton.visible = false;
        }

        // signal that page should be reset
        // image should be reset, food description cleared
        // and buttons should be shown in original form
        onResetPage: {
            // reset image
            backgroundImage.visible = false;
            
            // reset new food entry object
            var tempEntry = new FoodEntryType.FoodEntry();
            newFoodEntryPage.newFoodEntry = tempEntry;

            // reset description component
            foodEntryDescription.foodEntryData = newFoodEntryPage.newFoodEntry;

            // show / hide elements
            selectFoodItemButton.visible = true;
            foodEntryDescription.visible = false;
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
    }

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}