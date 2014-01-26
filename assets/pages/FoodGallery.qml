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
                // foodItemList.addToList(foundFoodItems[index]);
            }

            // show list
            foodItemList.visible = true;
        } else {
            // if no food items have been logged yet, show note
            infoMessage.showMessage(Copytext.noFoodEntriesFoundText, Copytext.noFoodEntriesFoundHeadline);
        }
    }
}
