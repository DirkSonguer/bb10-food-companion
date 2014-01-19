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
        signal imageCaptured(string imageName)

        // signal that the description has been added
        // this will be called by the addDescriptionPage
        // data is of type FoodEntry()
        signal descriptionAdded(variant foodEntry)

        // the object containing the data of the new entry
        // this is of type FoodEntry()
        property variant newFoodEntry

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
                        var captureImagePageObject = captureImagePageComponent.createObject();
                        captureImagePageObject.callingPage = newFoodEntryPage;
                        captureImageSheet.setContent(captureImagePageObject);
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
                                var captureImagePageObject = captureImagePageComponent.createObject();
                                captureImagePageObject.callingPage = newFoodEntryPage;
                                captureImageSheet.setContent(captureImagePageObject);
                                captureImageSheet.open();
                            }
                        }
                    ]
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

                    // call to action clicked
                    // open food selection sheet
                    onClicked: {
                        // create and open food selection sheet
                        var searchFoodItemPageObject = searchFoodItemPageComponent.createObject();
                        navigationPane.push(searchFoodItemPageObject);

                        // indicate that page is now visible
                        // this is a workaround because requestFocus only works after page is visible in stack
                        // see: http://supportforums.blackberry.com/t5/Native-Development/problems-with-request-focus-for-a-textfield/m-p/2652023#M51962
                        searchFoodItemPageObject.pageLoadedInNavigationStack = true;
                    }
                }

                // food description
                // this is filled by the add food description page when user entered something
                FoodItemDescription {
                    id: descriptionLabelContainer

                    // layout definition
                    preferredWidth: DisplayInfo.width

                    // set initial visibility to false
                    // this will be changed when description data has been added by the user
                    visible: false

                    // food favorite icon clicked
                    // Change favorite state for food item
                    onFavoriteClicked: {
                        console.log("# Favorited food item: " + newFoodEntry.description);

                        // update food item in database
                        var foundFoodItems = FoodDatabase.fooddb.updateFavoriteState(newFoodEntry);
                    }

                    // food description clicked
                    // open food selection sheet
                    onDescriptionClicked: {
                        // create and open food selection sheet
                        var searchFoodItemPageObject = searchFoodItemPageComponent.createObject();
                        navigationPane.push(searchFoodItemPageObject);
                    }
                }
            }

            // health rating slider
            CustomSlider {
                // layout definition
                topPadding: 15

                // slider range definition
                fromValue: 0
                toValue: 2
                value: 2

                // initial health rating and description
                label: "Healthy"
                description: "Rate this item:"

                // add logic to change rating on slider movement
                onValueChanged: {
                    var intImmediateValue = Math.round(immediateValue);

                    // if the slider value has changed, show the according text
                    if ((typeof newFoodEntryPage.newFoodEntry !== "undefined") && (newFoodEntryPage.newFoodEntry.rating != intImmediateValue)) {
                        // note that a temp entry is needed because the children of the page variant are read only
                        var tempEntry = new FoodEntryType.FoodEntry();
                        tempEntry = newFoodEntryPage.newFoodEntry;

                        // update values and write back the data
                        label = Copytext.foodcompanionHealthValues[intImmediateValue];
                        tempEntry.rating = intImmediateValue;
                        newFoodEntryPage.newFoodEntry = tempEntry;
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

                    // set button background color to call to action green
                    backgroundColor: Color.create(Globals.foodcompanionButtonBackgroundColor)

                    // confirmation text
                    boldText: "Add food entry"

                    // add food item clicked
                    // this will stored in the entry database
                    onClicked: {
                        // check if picture is available
                        if (! newFoodEntryPage.newFoodEntry.imageFile) {
                            foodcompanionToast.body = Copytext.foodcompanionNoFoodImageEntered;
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
                        foodcompanionToast.body = Copytext.foodcompanionFoodItemSaved;
                        foodcompanionToast.show();

                        // jump back to the gallery tab
                        tabbedPane.activeTab = foodEntryGalleryTab;
                    }
                }
            }
        }

        // signal that image has been captured with according file name
        // hide call to action and show thumbnail
        onImageCaptured: {
            // hide call to action component
            cameraCallToAction.visible = false;

            // add image to thumbnail component
            cameraImagePreview.imageSource = "file:///" + imageName;

            // store the image file to the page food entry
            // note that a temp entry is needed because the children of the page variant are read only
            var tempEntry = new FoodEntryType.FoodEntry();
            tempEntry = newFoodEntryPage.newFoodEntry;
            tempEntry.imageFile = imageName;
            newFoodEntryPage.newFoodEntry = tempEntry;

            // show camera thumbnail
            cameraImageContainer.visible = true;
        }

        // signal that description has been added
        // hide call to action and show thumbnail
        onDescriptionAdded: {
            // store the image file to the page food entry
            // note that a temp entry is needed because the children of the page variant are read only
            var tempEntry = new FoodEntryType.FoodEntry();
            tempEntry = newFoodEntryPage.newFoodEntry;
            tempEntry.foodid = foodEntry.foodid;
            tempEntry.description = foodEntry.description;
            tempEntry.calories = foodEntry.calories;
            tempEntry.size = foodEntry.size;
            newFoodEntryPage.newFoodEntry = tempEntry;

            // hide call to action
            descriptionCallToAction.visible = false;

            // fill in new data
            descriptionLabelContainer.description = foodEntry.description;
            var foodPortionAndCalories = Copytext.foodcompanionPortionValues[foodEntry.size] + " portion, ";
            foodPortionAndCalories += foodEntry.portion + " with " + foodEntry.calories + " calories";
            descriptionLabelContainer.portion = foodPortionAndCalories;

            // show description
            descriptionLabelContainer.visible = true;
        }

        onCreationCompleted: {
            // initialize the new food entry object
            var newEntry = new FoodEntryType.FoodEntry();
            newFoodEntryPage.newFoodEntry = newEntry;

            // TODO: automatically open camera capture sheet
            /*
             * // create and open capture image sheet
             * var captureImagePageObject = captureImagePageComponent.createObject();
             * captureImagePageObject.callingPage = newFoodEntryPage;
             * captureImageSheet.setContent(captureImagePageObject);
             * captureImageSheet.open();
             */
        }
    }

    // attach components
    attachedObjects: [
        // page to select food for an item
        // will be called if user clicks on add description
        ComponentDefinition {
            id: searchFoodItemPageComponent
            source: "SearchFoodItem.qml"
        }
    ]

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}