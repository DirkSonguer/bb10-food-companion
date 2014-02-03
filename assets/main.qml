// *************************************************** //
// Main
//
// This is the main entry point of the application.
// It provides the main navigation pane, menus and
// the components for the main pages.
// Note that the actual page content is defined in
// the /pages.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2
import bb.data 1.0

// set import directory for pages
import "pages"

// shared js files
import "classes/configurationhandler.js" as Configuration
import "classes/itemdatabase.js" as ItemDatabase
import "classes/entrydatabase.js" as EntryDatabase

TabbedPane {
    id: tabbedPane

    // pane definition
    showTabsOnActionBar: true

    // tab to show food gallery
    Tab {
        id: foodGalleryTab
        title: "Gallery"
        imageSource: "asset:///images/icons/icon_gallery.png"
        
        // note that the page is bound to the component every time it loads
        // TODO: how to update after a new entry has been added?
        onTriggered: {
            foodGalleryPageComponent.source = "pages/FoodGallery.qml";
            var foodGalleryPageObject = foodGalleryPageComponent.createObject();
            foodGalleryTab.setContent(foodGalleryPageObject);
        }
        
        // attach a component for the new food gallery page
        attachedObjects: [
            ComponentDefinition {
                id: foodGalleryPageComponent
            }
        ]
    }

    // tab to show food entry statistics
    Tab {
        id: foodStatisticsTab
        title: "Statistics"
        imageSource: "asset:///images/icons/icon_statistics.png"
        
        // note that the page is bound to the component every time it loads
        // TODO: how to update after a new entry has been added?
        onTriggered: {
            foodStatisticsPageComponent.source = "pages/FoodStatistics.qml";
            var foodStatisticsPageObject = foodStatisticsPageComponent.createObject();
            foodStatisticsTab.setContent(foodStatisticsPageObject);
        }
        
        // attach a component for the new food gallery page
        attachedObjects: [
            ComponentDefinition {
                id: foodStatisticsPageComponent
            }
        ]
    }

    // tab to add new food entry
    Tab {
        id: newFoodEntryTab
        title: "Add food entry"
        imageSource: "asset:///images/icons/icon_add.png"

        // note that the page is bound to the component every time it loads
        // this basically resets any pre given data and starts a new process
        onTriggered: {
            newFoodEntryPageComponent.source = "pages/NewFoodEntry.qml";
            var newFoodEntryPageObject = newFoodEntryPageComponent.createObject();
            newFoodEntryTab.setContent(newFoodEntryPageObject);
        }

        // attach a component for the new food item page
        attachedObjects: [
            ComponentDefinition {
                id: newFoodEntryPageComponent
            }
        ]
    }

    // main logic on startup
    onCreationCompleted: {
        // load database content from local JSON file
        // note that the dataSource will check the food db if it has been imported correctly
        dataSource.load();
                
        // load gallery page into tab
        foodGalleryPageComponent.source = "pages/FoodGallery.qml";
        var foodGalleryPageObject = foodGalleryPageComponent.createObject();
        foodGalleryTab.setContent(foodGalleryPageObject);
        
        // activate gallery tab
        tabbedPane.activeTab = newFoodEntryTab;
        tabbedPane.activeTab = foodGalleryTab;
    }

    // application menu (top menu)
    Menu.definition: MenuDefinition {
        id: mainMenu

        // application menu items
        actions: [
            // WARNING: Do not activate this in productive version!
            ActionItem {
                id: mainMenuClearDatabase
                title: "Clear Database"
                imageSource: "asset:///images/icons/icon_notavailable.png"
                onTriggered: {
                    ItemDatabase.itemdb.resetDatabase();
                    EntryDatabase.entrydb.resetDatabase();
                    Application.requestExit();
                }
            }
        ]
    }

    // attached objects
    // this contains the sheets which are used for general page based popups
    attachedObjects: [
        // sheet for shooting images via the camera component
        Sheet {
            id: captureImageSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: captureImagePageComponent
                    source: "sheets/CaptureImage.qml"
                }
            ]
        },
        // sheet shown on first startup
        // this also contains the loader while importing database
        Sheet {
            id: firstStartupSheet
            
            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: firstStartupPageComponent
                    source: "sheets/FirstStartup.qml"
                }
            ]
        },
        // system toast used globally by all pages and components
        SystemToast {
            id: foodcompanionToast
            position: SystemUiPosition.MiddleCenter
        },
        // the data source attached to the JSON database file
        // this is only used to check if the import has been done correctly
        DataSource {
            id: dataSource
            source: "asset:///database/food_db.json"
            onDataLoaded: {
                console.log("# Food DB loaded, found " + data.food.length + " items");

                // check database state and reimport if necessary
                var dbstate = ItemDatabase.itemdb.checkDatabaseState(data);
                if (! dbstate) {
                    console.log("# Database is not up to date & needs to be reimported");

                    // hand over the data to the first startup sheet and open it
                    // it will check if new data has been given and start the
                    // import progress accordingly
                    var firstStartupPageObject = firstStartupPageComponent.createObject();
                    firstStartupPageObject.foodData = data;
                    firstStartupSheet.setContent(firstStartupPageObject);
                    firstStartupSheet.open();
                }
            }
        }
    ]    
}
