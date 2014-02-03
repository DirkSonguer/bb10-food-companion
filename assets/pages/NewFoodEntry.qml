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

            // scroll view as the page might not fit on the Q10 / Q5 screen
            ScrollView {
                // only vertical scrolling is needed
                scrollViewProperties {
                    scrollMode: ScrollMode.Vertical
                    pinchToZoomEnabled: false
                }

                // layout definition
                verticalAlignment: VerticalAlignment.Bottom

                // wrapper for controls
                // this is needed for the scroll view
                Container {
                    // layout definition
                    topPadding: 5
                    bottomPadding: 5

                    // recapture the image
                    CustomButton {
                        id: captureImageButton

                        // content
                        narrowText: "Capture image"
                        iconSource: "asset:///images/icons/icon_camera.png"

                        // layout definition
                        alignText: HorizontalAlignment.Center
                        backgroundColor: Color.create(Globals.greenBackgroundColor)
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
                        narrowText: "Add a description"
                        iconSource: "asset:///images/icons/icon_description.png"

                        // layout definition
                        topMargin: 10
                        alignText: HorizontalAlignment.Center
                        backgroundColor: Color.create(Globals.greenBackgroundColor)
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

                    FoodEntryDescription {
                        id: foodEntryDescription

                        // layout definition
                        topMargin: 10
                        background: Color.create(Globals.greenBackgroundColor)
                        preferredWidth: DisplayInfo.width
                        opacity: 0.85

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
                            foodEntryDescription.background = Color.create(Globals.healthRatingColors[tempEntry.rating]);
                        }
                        
                        onClicked: {
                            // this shuld open the food item selection page
                            // basically the same as with pressing the call to action
                            selectFoodItemButton.clicked();
                        }
                    }

                    // confirmation button
                    CustomButton {
                        id: addEntryButton

                        // layout definition
                        topMargin: 10
                        bottomMargin: 10
                        alignText: HorizontalAlignment.Center
                        backgroundColor: Color.create(Globals.greenBackgroundColor)
                        preferredWidth: DisplayInfo.width
                        opacity: 0.85

                        // confirmation text
                        boldText: "Store food entry"
                        iconSource: "asset:///images/icons/icon_add.png"

                        // add food item clicked
                        // this will stored in the entry database
                        onClicked: {
                            // check if picture is available
                            if (! newFoodEntryPage.newFoodEntry.imageFile) {
                                foodcompanionToast.body = Copytext.noFoodImageTaken;
                                foodcompanionToast.show();

                                // WARNING: Activate this in productive version!
                                // return;

                                // this is only valid in debug environment
                                var tempEntry = new FoodEntryType.FoodEntry();
                                tempEntry = newFoodEntryPage.newFoodEntry;
                                tempEntry.imageFile = "accounts/1000/shared/photos/IMG_00000470.jpg";
                                newFoodEntryPage.newFoodEntry = tempEntry;
                            }

                            // add to entry database
                            EntryDatabase.entrydb.addEntry(newFoodEntryPage.newFoodEntry);

                            // show confirmation toast
                            foodcompanionToast.body = Copytext.foodEntrySaved;
                            foodcompanionToast.show();
                            
                            // send signal to reload data
                            foodGalleryTab.content.reloadData();
                            
                            // jump back to the gallery tab
                            tabbedPane.activeTab = foodGalleryTab;
                        }
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