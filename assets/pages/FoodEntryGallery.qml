// *************************************************** //
// Food Entry Database Page
//
// This page shows the gallery of logged food items.
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
import "../classes/entrydatabase.js" as EntryDatabase

Page {
    id: foodEntryGalleryPage

    signal reloadGalleryContent()

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // page header
        PageHeader {
            headline: "Your food gallery"
            imageSource: "asset:///images/header_background.png"
        }

        // list of food items
        // this is filled by the user search via foodInput
        FoodEntryList {
            id: foodItemList

            // layout definition
            topMargin: 1
            
            onItemDeleted: {
                EntryDatabase.entrydb.deleteEntry(foodData.timestamp);
                
            }
        }
    }

    onCreationCompleted: {
        var foundFoodItems = EntryDatabase.entrydb.getEntries();

        // iterate through item data objects and add to list
        for (var index in foundFoodItems) {
            foodItemList.addToList(foundFoodItems[index]);
        }
    }
    
    onReloadGalleryContent: {
        console.log("reload, please");
    }
}
