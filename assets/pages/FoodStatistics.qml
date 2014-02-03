// *************************************************** //
// Food Statistics Page
//
// This page shows the aggregated statistics of all the
// logged food entries.
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
    id: foodStatisticsPage

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
            
            onMessageClicked: {
                // jump to the food entry tab
                tabbedPane.activeTab = newFoodEntryTab;
            }
        }
    }

    onCreationCompleted: {
        var foundFoodItems = EntryDatabase.entrydb.getEntries();

        // check if they are entries in the database
        // if so, show the logged entries
        if (foundFoodItems.length > 0) {
            // iterate through item data objects and add to list
            for (var index in foundFoodItems) {
            }
        } else {
            // if no food items have been logged yet, show note
            infoMessage.showMessage(Copytext.noFoodEntriesFoundText, Copytext.noFoodEntriesFoundHeadline);
        }
    }
}
