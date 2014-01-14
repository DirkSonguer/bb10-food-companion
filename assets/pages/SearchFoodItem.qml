// *************************************************** //
// Search Food Item Page
//
// This page contains the procedures to search and select
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
import "../classes/fooddatabase.js" as FoodDatabase
import "../structures/fooditem.js" as FoodItemType

Page {
    id: searchFoodItemPage

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // page header
        PageHeader {
            headline: "Search food item"
            imageSource: "asset:///images/header_background.png"
        }

        // food input container
        // this is the input field with associated logic
        FoodInput {
            id: foodInput

            // layout definition
            topMargin: 5

            // user entered new input
            // this will be sent for every character the user enters
            // minimum number of characters is 3
            onChanged: {
                // console.log("# Food search input changed: " + text);

                // clear the current food list
                foodItemList.clearList();

                // search food items from database for search term
                var foundFoodItems = FoodDatabase.fooddb.searchDatabase(text);

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
                    // no items found for search
                    // show message and hide list
                    infoMessage.showMessage(Copytext.foodcompanionNoFoodItemsFoundText, Copytext.foodcompanionNoFoodItemsFoundHeadline);
                    foodItemList.visible = false;
                }
            }
        }

        // list of food items
        // this is filled by the user search via foodInput
        FoodItemList {
            id: foodItemList

            // layout definition
            topMargin: 5

            onItemClicked: {
                console.log("# Selected food item: " + foodData.description);

                // create and open food selection sheet
                var addFoodDescriptionPageObject = addFoodDescriptionPageComponent.createObject();
                addFoodDescriptionPageObject.selectedFoodItem = foodData;
                navigationPane.push(addFoodDescriptionPageObject);
            }
        }

        // info message
        InfoMessage {
            id: infoMessage

            // layout definition
            leftPadding: 10
            rightPadding: 10
        }
    }

    // attach components
    attachedObjects: [
        // page to add the description for the food entry
        // will be called if user selects an entry
        ComponentDefinition {
            id: addFoodDescriptionPageComponent
            source: "AddFoodDescription.qml"
        }
    ]
}
