// *************************************************** //
// Food Selector Sheet
//
// This sheet contains the procedures to select a specific
// food for a new item. The sheet also handles adding new
// foods and marking / selecting favorites.
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

Page {
    id: foodSelectorPage

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // page header
        PageHeader {
            headline: "Select food item"
            imageSource: "asset:///images/header_background.png"
            
            bottomPadding: 10
        }
        
        // comment input container
        FoodInput {
            id: foodSelectorInput
            
            bottomPadding: 10
            
            onChanged: {
                console.log("# Food search input changed: " + text);
                foodSelectorList.clearList();
                var foundFoodItems = FoodDatabase.fooddb.searchDatabase(text); 
                
                // iterate through item data objects
                for (var index in foundFoodItems) {
                    foodSelectorList.addToList(foundFoodItems[index]);
                }                                       
            }
        }

        FoodList {
            id: foodSelectorList

        }

        InfoMessage {
            id: infoMessage

            leftPadding: 0
            rightPadding: 0
        }
    }
}
