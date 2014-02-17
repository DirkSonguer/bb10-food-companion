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

        // reload the gallery data
        onTriggered: {
            foodGalleryTab.content.reloadData();
        }
    }

    // tab to show food entry statistics
    Tab {
        id: foodStatisticsTab
        title: "You"
        imageSource: "asset:///images/icons/icon_statistics.png"
    }

    // tab to add new food entry
    Tab {
        id: newFoodEntryTab
        title: "Add food entry"
        imageSource: "asset:///images/icons/icon_addentry.png"
        
        // reset the page contents
        onTriggered: {
            newFoodEntryTab.content.resetPage();
        }
    }

    // main logic on startup
    onCreationCompleted: {
        // load database content from local JSON file
        // note that the dataSource will check the food db if it has been imported correctly
        dataSource.load();

        // load page contents into food gallery tab
        foodGalleryPageComponent.source = "pages/FoodGallery.qml";
        var foodGalleryPageObject = foodGalleryPageComponent.createObject();
        foodGalleryTab.setContent(foodGalleryPageObject);

        // load page contents into statistics tab
        foodStatisticsPageComponent.source = "pages/FoodStatistics.qml";
        var foodStatisticsPageObject = foodStatisticsPageComponent.createObject();
        foodStatisticsTab.setContent(foodStatisticsPageObject);

        // load page contents into new entry tab
        newFoodEntryPageComponent.source = "pages/NewFoodEntry.qml";
        var newFoodEntryPageObject = newFoodEntryPageComponent.createObject();
        newFoodEntryTab.setContent(newFoodEntryPageObject);

        // activate statistics tab
        tabbedPane.activeTab = foodStatisticsTab;
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
            },
            // action for ratinig the app
            ActionItem {
                id: mainMenuAbout
                title: "About"
                imageSource: "asset:///images/icons/icon_about.png"
                onTriggered: {
                    // create logout sheet
                    var aboutSheetPageObject = aboutPageComponent.createObject();
                    aboutSheet.setContent(aboutSheetPageObject);
                    aboutSheet.open();
                }
            },
            // action for rate sheet
            ActionItem {
                id: mainMenuRate
                title: "Update & Rate"
                imageSource: "asset:///images/icons/icon_bbworld.png"
                onTriggered: {
                    rateAppLink.trigger("bb.action.OPEN");
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
        // sheet for about page
        // this is used by the main menu about item
        Sheet {
            id: aboutSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: aboutPageComponent
                    source: "sheets/About.qml"
                }
            ]
        },
        // component for the food statistics page
        ComponentDefinition {
            id: foodStatisticsPageComponent
        },
        // component for the food gallery page
        ComponentDefinition {
            id: foodGalleryPageComponent
        },
        // component for the new food entry page
        ComponentDefinition {
            id: newFoodEntryPageComponent
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
