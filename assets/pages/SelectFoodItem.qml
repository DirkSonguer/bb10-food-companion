// *************************************************** //
// Select Food Item Page
//
// This page contains the procedures to select and select
// a specific food item from the database.
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
import "../classes/itemdatabase.js" as ItemDatabase

Page {
    id: selectFoodItemPage

    // property that holds the calling page
    // this page will receive the addFoodItem() signal
    property variant callingPage

    // property to indicate that page is visible in navigation stack
    // this will be set by calling page after calling show()
    property bool pageLoadedInNavigationStack: false

    Container {
        // layout orientation
        layout: DockLayout {
        }

        // actual content
        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // food search input field
            FoodInput {
                id: selectFoodInput

                // user entered new input
                // this will be sent for every character the user enters
                // minimum number of characters is 3
                onChanged: {
                    // console.log("# Food search input changed: " + text);

                    // clear the current food list
                    foodItemList.clearList();

                    // search food items from database for search term
                    var foundFoodItems = ItemDatabase.itemdb.searchDatabase(text);

                    // if there are results, fill the food list
                    // otherwise show the info message
                    if (foundFoodItems.length > 0) {
                        // iterate through item data objects and add to list
                        for (var index in foundFoodItems) {
                            foodItemList.addToList(foundFoodItems[index]);
                        }

                        // hide possible info message and show list
                        infoMessage.hideMessage();
                        foodItemList.visible = true;
                    } else {
                        // show message and hide list
                        infoMessage.showMessage(Copytext.noFoodItemsFoundText, Copytext.noFoodItemsFoundHeadline);
                        foodItemList.visible = false;
                    }
                }

                // user entered input or interacted but nothing should be displayed
                onCleared: {
                    if (foodItemList.visible) {
                        infoMessage.showMessage(Copytext.enterFoodItemText, Copytext.enterFoodItemHeadline);
                        foodItemList.visible = false;
                    }
                }
            }

            // list of food items
            // this is filled by the user search via foodInput
            FoodItemList {
                id: foodItemList

                // layout definition
                topMargin: 1

                // set initial visibility to false
                // this will be changed if search data has been loaded
                visible: false

                onItemDescriptionClicked: {
                    // console.log("# Selected food item: " + foodItemData.description);

                    // return the food item back to the calling page
                    callingPage.addFoodItem(foodItemData);

                    // close page
                    navigationPane.pop();
                }

                onItemBookmarkClicked: {
                    console.log("# Bookmarked food item: " + foodItemData.description);

                    // search food items from database for search term
                    var foundFoodItems = ItemDatabase.itemdb.updateBookmarkState(foodItemData);
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

    onPageLoadedInNavigationStackChanged: {
        // This focus request sets the focus on the input field once the page is visible
        if (pageLoadedInNavigationStack) {
            infoMessage.showMessage(Copytext.enterFoodItemText, Copytext.enterFoodItemHeadline);
            selectFoodInput.focus();
        }
    }

    actions: [
        // add new food item
        ActionItem {
            id: addItemAction
            ActionBar.placement: ActionBarPlacement.Signature

            title: "Add item to database"
            imageSource: "asset:///images/icons/icon_add.png"

            // add item
            onTriggered: {
                var newFoodItemPageObject = newFoodItemPageComponent.createObject();
                navigationPane.push(newFoodItemPageObject);
            }
        }
    ]

    // attach components
    attachedObjects: [
        // page to add a new food item
        // will be called if user clicks on add description
        ComponentDefinition {
            id: newFoodItemPageComponent
            source: "NewFoodItem.qml"
        }
    ]
}
