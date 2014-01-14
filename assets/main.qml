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
import "classes/fooddatabase.js" as FoodDatabase

TabbedPane {
    // pane definition
    showTabsOnActionBar: true
    //    activeTab: popularMediaTab

    Tab {
        title: qsTr("Gallery") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/icons/icon_gallery.png"
        Page {
            Container {
                Label {
                    text: qsTr("Gallery") + Retranslate.onLocaleOrLanguageChanged
                }
            }
        }
    }

    Tab {
        title: qsTr("Statistics") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/icons/icon_statistics.png"
        Page {
            Container {
                Label {
                    text: qsTr("Statistics") + Retranslate.onLocaleOrLanguageChanged
                }
            }
        }
    }

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
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: newFoodEntryPageComponent
            }
        ]
    }

    // main logic on startup
    onCreationCompleted: {
        // check on startup if this is the first start of the application
        var configurationData = Configuration.conf.getConfiguration("introduction");
        if (configurationData.length < 1) {
            // console.log("# Introduction not shown yet. Open intro sheet");

            Configuration.conf.setConfiguration("introduction", "1");
        }

        // load database content from local JSON file
        // note that the dataSource will check the food db if it has been imported correctly
        dataSource.load();
    }

    // attached objects
    // this contains the sheets which are used for general page based popupos
    attachedObjects: [
        // sheet for shooting images via the camera
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
        // invocation for bb world
        // used by the action menu to switch to bb world
        Invocation {
            id: rateAppLink
            query {
                mimeType: "application/x-bb-appworld"
                uri: "appworld://content/24485875"
            }
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

                // WARNING: Do not activate this in productive version!
                // WARNING: this will reset the database and wipe any entries on startup!
                FoodDatabase.fooddb.resetDatabase();

                // check database state and reimport if necessary
                var dbstate = FoodDatabase.fooddb.checkDatabaseState(data);
                if (! dbstate) {
                    console.log("# Database is not up to date & needs reimport");

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
