// *************************************************** //
// New Food Entry Page
//
// This page logs new food entries.
// The process will be handled by the page itself, it
// may call different sub pages or sheets to gather all
// the data, eg. the CaptureImage sheet.
// The new food item to enter will be held in the newFoodItem
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
import "../structures/fooditem.js" as FoodItemType
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
        // data is of type FoodItem()
        signal descriptionAdded(variant newFoodDescription)

        // the item object containing the data of the new item
        // this is of type FoodItem()
        property variant newFoodItem

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
                        // this is a work around because requestFocus only works after page is visible in stack
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
                        console.log("# Favorited food item: " + newFoodDescription.description);

                        // update food item in database
                        var foundFoodItems = FoodDatabase.fooddb.updateFavoriteState(newFoodDescription);
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
                    if ((typeof newFoodEntryPage.newFoodItem !== "undefined") && (newFoodEntryPage.newFoodItem.healthRating != intImmediateValue)) {
                        // note that a temp item is needed because the children of the page variant are read only
                        var tempItem = new FoodItemType.FoodItem();
                        tempItem = newFoodEntryPage.newFoodItem;

                        // update values and write back the data
                        label = Copytext.foodcompanionHealthValues[intImmediateValue];
                        tempItem.healthRating = intImmediateValue;
                        newFoodEntryPage.newFoodItem = tempItem;
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
                        if (! newFoodEntryPage.newFoodItem.imageFile) {
                            foodcompanionToast.body = Copytext.foodcompanionNoFoodImageEntered;
                            foodcompanionToast.show();
                            return;
                        }

                        // add to entry database
                        EntryDatabase.entrydb.addEntry(newFoodEntryPage.newFoodItem);

                        foodcompanionToast.body = Copytext.foodcompanionFoodItemSaved;
                        foodcompanionToast.show();

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

            // store the image file to the page food item
            // note that a temp item is needed because the children of the page variant are read only
            var tempItem = new FoodItemType.FoodItem();
            tempItem = newFoodEntryPage.newFoodItem;
            tempItem.imageFile = imageName;
            newFoodEntryPage.newFoodItem = tempItem;

            // show camera thumbnail
            cameraImageContainer.visible = true;
        }

        // signal that description has been added
        // hide call to action and show thumbnail
        onDescriptionAdded: {
            // store the image file to the page food item
            // note that a temp item is needed because the children of the page variant are read only
            var tempItem = new FoodItemType.FoodItem();
            tempItem = newFoodEntryPage.newFoodItem;
            tempItem.id = newFoodDescription.id;
            tempItem.description = newFoodDescription.description;
            tempItem.calories = newFoodDescription.calories;
            tempItem.portionSize = newFoodDescription.portionSize;
            newFoodEntryPage.newFoodItem = tempItem;

            // hide call to action
            descriptionCallToAction.visible = false;

            // fill in new data
            descriptionLabelContainer.description = newFoodDescription.description;
            var foodPortionAndCalories = Copytext.foodcompanionPortionValues[newFoodDescription.portionSize] + " portion, ";
            foodPortionAndCalories += newFoodDescription.portion + " with " + newFoodDescription.calories;
            descriptionLabelContainer.portion = foodPortionAndCalories;
            descriptionLabelContainer.favorite = newFoodDescription.favorite;

            // show description
            descriptionLabelContainer.visible = true;

        }

        onCreationCompleted: {
            // initialize the new food item object
            var newFoodItem = new FoodItemType.FoodItem();
            newFoodEntryPage.newFoodItem = newFoodItem;

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