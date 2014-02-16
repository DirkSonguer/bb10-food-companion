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

    // signal that data should be reloaded
    signal reloadData()

    Container {
        // layout orientation
        layout: DockLayout {
        }

        // background image slot
        // this just shows the green food companion background
        ImageView {
            id: backgroundImage

            // layout definition
            verticalAlignment: VerticalAlignment.Top
            preferredWidth: DisplayInfo.width
            preferredHeight: DisplayInfo.height

            // image scaling and opacity
            scalingMethod: ScalingMethod.AspectFill
            opacity: 0.75

            // image file
            imageSource: "asset:///images/page_background.png"
        }

        FoodGalleryList {
            id: foodGalleryList

            // set initial definition to false
            // this will be set true once the data has been loaded
            visible: false

            // list sorting
            listSortAscending: false

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

    onCreationCompleted: {
        foodGalleryPage.reloadData();
    }

    onReloadData: {
        var foundFoodItems = EntryDatabase.entrydb.getEntries();

        // check if they are entries in the database
        // if so, show the logged entries
        if (foundFoodItems.length > 0) {
            // iterate through item data objects and add to list
            for (var index in foundFoodItems) {
                foodGalleryList.addToList(foundFoodItems[index]);
            }

            // show list, hide everything else
            foodGalleryList.visible = true;
            backgroundImage.visible = false;
            infoMessage.hideMessage();
        } else {
            // if no food items have been logged yet, show note
            infoMessage.showMessage(Copytext.noFoodEntriesFoundText, Copytext.noFoodEntriesFoundHeadline);
        }
    }
}
