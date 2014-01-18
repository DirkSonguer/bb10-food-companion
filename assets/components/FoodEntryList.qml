// *************************************************** //
// Food Item List Component
//
// This component shows a list of food items for a given
// keyword. Note that the component also handles the
// search / filter mechanism
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: foodEntryListComponent

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
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: foodEntryListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        foodEntryListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.commentId + " to comment list data model");
        foodEntryListComponent.currentItemIndex += 1;
        foodEntryListDataModel.insert({
                "foodData": item,
                "currentIndex": foodEntryListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.foodEntryListDataModel = foodEntryListDataModel;
        Qt.itemClicked = foodEntryListComponent.itemClicked;
        Qt.itemDeleted = foodEntryListComponent.itemDeleted;
        Qt.DisplayInfo = DisplayInfo;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: foodEntryList

        // associate the data model for the list view
        dataModel: foodEntryListDataModel

        leadingVisual: Container {
            id: foodHeaderContainer
        }

        // layout orientation
        layout: StackListLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // define component which will represent list item GUI appearence
        listItemComponents: [
            ListItemComponent {
                type: "item"

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }

                    FoodEntryDescription {
                        foodEntryData: ListItemData.foodData
                        
                        preferredWidth: Qt.DisplayInfo.width
                        
                        onDeleteFoodEntry: {
                            var foodEntryListDataModel = Qt.foodEntryListDataModel;
                            for (var i = 0; i < foodEntryListDataModel.size(); i ++) {
                                var indexPath = new Array();
                                indexPath[0] = i;
                                var childEntry = foodEntryListDataModel.data(indexPath);
                                
                                if (childEntry.foodData.timestamp == ListItemData.foodData.timestamp) {
                                    console.log("# Child entry foodData: " + childEntry.foodData.description);
                                    foodEntryListDataModel.removeAt(indexPath);
                                }
                            }

                            Qt.itemDeleted(ListItemData.foodData);
                        }
                    }

                    bottomPadding: 5
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: foodEntryListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
