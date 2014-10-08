// *************************************************** //
// Food Gallery List Component
//
// This component shows a list of food entries.
// Note that the component also handles possible click
// and delete events.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: foodGalleryListComponent

    // signal if food item was clicked
    signal itemClicked(variant foodData)

    // signal if food item was deleted
    signal itemDeleted(variant foodData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "foodDate"
    property alias listSortAscending: foodGalleryListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        foodGalleryListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.commentId + " to comment list data model");
        foodGalleryListComponent.currentItemIndex += 1;
        foodGalleryListDataModel.insert({
                "foodDate": item.date,
                "foodData": item,
                "currentIndex": foodGalleryListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.foodGalleryListDataModel = foodGalleryListDataModel;
        Qt.itemClicked = foodGalleryListComponent.itemClicked;
        Qt.itemDeleted = foodGalleryListComponent.itemDeleted;
        Qt.DisplayInfo = DisplayInfo;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: foodGalleryList

        // associate the data model for the list view
        dataModel: foodGalleryListDataModel

        // layout orientation
        layout: StackListLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
        // accessibility
        accessibility.name: "Food gallery list"

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "header"

                Container {
                    // layout definition
                    topMargin: 30
                    leftPadding: 15

                    // date label
                    Label {
                        // content is handed over in ListItemData
                        text: ListItemData

                        // layout definition
                        bottomMargin: 0
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 10
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.fontStyle: FontStyle.Italic
                        
                        onCreationCompleted: {
                            var textSplit = text.split("#");
                            text = textSplit[1];
                        }
                    }

                    // divider component
                    Divider {
                        topMargin: 0

                        // accessibility
                        accessibility.name: ""
                    }
                }
            },
            ListItemComponent {
                type: "item"

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    // layout definitions
                    bottomPadding: 5

                    // individual food gallery item
                    FoodGalleryItem {
                        // set food data
                        foodEntryData: ListItemData.foodData

                        // this sets the component width to the full device width
                        preferredWidth: Qt.DisplayInfo.width
                        
                        // food entry was clicked
                        // hand the event back to the calling page 
                        onClicked: {
                            Qt.itemClicked(ListItemData.foodData);
                        }
                        
                        // food entry should be deleted
                        // note that this will only remove the item from the list, not from the database
                        // the calling page is responsible for this
                        onDeleteFoodEntry: {
                            // get the data model, containing all gallery items
                            var tempDataModel = Qt.foodGalleryListDataModel;
                            
                            // iterate through all gallery items
                            // first order is the date, second order the actual food entry data
                            for (var iFirstOrder = 0; iFirstOrder < tempDataModel.size(); iFirstOrder ++) {
                                for (var iSecondOrder = 0; iSecondOrder < tempDataModel.size(); iSecondOrder ++) {
                                    var indexPath = new Array();
                                    indexPath[0] = iFirstOrder;
                                    indexPath[1] = iSecondOrder;
                                    var childEntry = tempDataModel.data(indexPath);
                                    
                                    // only act if the child has data
                                    if (typeof childEntry !== "undefined") {
                                        // check if the current child is the one that sent the signal
                                        // if so, then remove it from the data model
                                        if (childEntry.foodData.timestamp == ListItemData.foodData.timestamp) {
                                            // console.log("# Child entry foodData: " + childEntry.foodData.description);
                                            tempDataModel.removeAt(indexPath);
                                        }
                                    }
                                }
                                
                                // hand over the delete signal to the calling page
                                Qt.itemDeleted(ListItemData.foodData);
                            }
                        }                        
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: foodGalleryListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.ByFullValue
        }
    ]
}
