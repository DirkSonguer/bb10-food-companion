// *************************************************** //
// Food Entry Database Page
//
// This page shows the gallery of logged food items.
// It also contains the logic to handle and delete the
// items.
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
    id: foodGalleryPage

    Container {
        // layout orientation
        layout: DockLayout {
        }
        
        FoodGalleryList {
            id: foodGalleryList
            
            // set initial definition to false
            // this will be set true once the data has been loaded
            visible: false
            
            // item has been deleted
            // note that by this point it has only been removed from the list
            // now it needs to be removed from the database
            onItemDeleted: {
                EntryDatabase.entrydb.deleteEntry(foodData.timestamp);
                
                // show confirmation toast
                foodcompanionToast.body = Copytext.foodEntryDeleted + foodData.description + ")";
                foodcompanionToast.show();
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
        var foundFoodItems = EntryDatabase.entrydb.getEntries();

        // check if they are entries in the database
        // if so, show the logged entries
        if (foundFoodItems.length > 0) {
            // iterate through item data objects and add to list
            for (var index in foundFoodItems) {
                foodGalleryList.addToList(foundFoodItems[index]);
            }

            // show list
            foodGalleryList.visible = true;
        } else {
            // if no food items have been logged yet, show note
            infoMessage.showMessage(Copytext.noFoodEntriesFoundText, Copytext.noFoodEntriesFoundHeadline);
        }
    }
}
