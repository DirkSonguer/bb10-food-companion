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

// set import directory for pages
import "pages"

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
            id: foodcompanionCenterToast
            position: SystemUiPosition.MiddleCenter
        }
    ]
}
