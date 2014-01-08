/*
 * Copyright (c) 2011-2013 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

    Tab { //Second tab
        title: qsTr("Gallery") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/icons/icon_gallery.png"
        Page {
            Container {
                Label {
                    text: qsTr("Gallery") + Retranslate.onLocaleOrLanguageChanged
                }
            }
        }
    } //End of second tab

    Tab { //Second tab
        title: qsTr("Statistics") + Retranslate.onLocaleOrLanguageChanged
        imageSource: "asset:///images/icons/icon_statistics.png"
        Page {
            Container {
                Label {
                    text: qsTr("Statistics") + Retranslate.onLocaleOrLanguageChanged
                }
            }
        }
    } //End of second tab

    Tab {
        id: addItemTab
        title: "Add entry"
        imageSource: "asset:///images/icons/icon_add.png"

        // note that the page is bound to the component every time it loads
        // this is because the page needs to be created as tapped
        // if created on startup it does not work immediately after login
        onTriggered: {
            addItemComponent.source = "pages/AddItem.qml";
            var addItemPage = addItemComponent.createObject();
            addItemTab.setContent(addItemPage);
        }

        // attach a component for the user feed page
        // this is bound to the content property later on onCreationCompleted()
        attachedObjects: [
            ComponentDefinition {
                id: addItemComponent
            }
        ]
    }

    // main logic on startup
    onCreationCompleted: {
        // check on startup for introduction sheet
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
        // sheet for shooting images
        Sheet {
            id: captureImageSheet

            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: captureImageComponent
                    source: "sheets/CaptureImage.qml"
                }
            ]
        },
        // sheet to select food for an item
        Sheet {
            id: foodSelectorSheet
            
            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: foodSelectorComponent
                    source: "sheets/FoodSelector.qml"
                }
            ]
        },
        // sheet while importing database
        Sheet {
            id: firstStartupSheet
            
            // attach a component for the about page
            attachedObjects: [
                ComponentDefinition {
                    id: firstStartupComponent
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
            id: foodcompanionTopToast
            position: SystemUiPosition.TopCenter
        },
        // system toast used globally by all pages and components
        SystemToast {
            id: foodcompanionToast
            position: SystemUiPosition.MiddleCenter
        },
        DataSource {
            id: dataSource
            source: "asset:///database/food_db.json"
            onDataLoaded: {
                // console.log("# Food DB loaded, found " + data.food.length + " items");

				// check database state and reimport if necessary
                // FoodDatabase.fooddb.resetDatabase();
                var dbstate = FoodDatabase.fooddb.checkDatabaseState(data);
                if (!dbstate) {
                    console.log("# Database is not up to date & needs reimport");
                    var firstStartupContent = firstStartupComponent.createObject();
                    firstStartupContent.importData = data;
                    firstStartupSheet.setContent(firstStartupContent);
                    firstStartupSheet.open();
                }        
            }
        }
    ]
}
