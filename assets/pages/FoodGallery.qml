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

// this is a page that is available from the main tab, thus it has to be a navigation pane
// note that the id is always "navigationPane"
NavigationPane {
    id: navigationPane

    // signal that page should be reset
    // this will be handed over to the page event
    // to reset / reload data
    signal resetPage()
    onResetPage: {
        foodGalleryPage.reloadData();
    }

    Page {
        id: foodGalleryPage

        // signal that data should be reloaded
        signal reloadData()

        Container {
            // layout orientation
            layout: DockLayout {
            }

            // food gallery component
            // this contains the food entry items
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

            // info message container
            Container {
                // layout definition
                verticalAlignment: VerticalAlignment.Center
                leftPadding: 10
                rightPadding: 10

                // info message
                InfoMessage {
                    id: infoMessage

                    onMessageClicked: {
                        // jump to the food entry tab
                        tabbedPane.activeTab = newFoodEntryTab;
                    }
                }
            }
        }

        // creation complete
        onCreationCompleted: {
            // load the data once page is initialized
            foodGalleryPage.reloadData();
        }

        // gallery data should be reloaded
        onReloadData: {
            // clear current list items
            foodGalleryList.clearList();

            // get food entries from database
            var foundFoodItems = EntryDatabase.entrydb.getEntries();

            // check if they are entries in the database
            // if so, show the logged entries
            if (foundFoodItems.length > 0) {
                // iterate through item data objects and add to list
                for (var index in foundFoodItems) {
                    foodGalleryList.addToList(foundFoodItems[index]);
                }

                foodGalleryList.visible = true;
                infoMessage.hideMessage();
            } else {
                infoMessage.showMessage(Copytext.noFoodEntriesFoundText, Copytext.noFoodEntriesFoundHeadline);
            }
        }
    }

    // destroy pages after use
    onPopTransitionEnded: {
        page.destroy();
    }
}
