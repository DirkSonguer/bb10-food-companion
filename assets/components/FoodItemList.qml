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
    id: foodItemListComponent

    // signal if food item was clicked
    signal itemDescriptionClicked(variant foodItemData)

    // signal if food bookmark state was clicked
    signal itemBookmarkClicked(variant foodItemData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: foodItemListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        foodItemListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.commentId + " to comment list data model");
        foodItemListComponent.currentItemIndex += 1;
        foodItemListDataModel.insert({
                "foodItemData": item,
                "currentIndex": foodItemListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.foodItemListDataModel = foodItemListDataModel;
        Qt.itemDescriptionClicked = foodItemListComponent.itemDescriptionClicked;
        Qt.itemBookmarkClicked = foodItemListComponent.itemBookmarkClicked;
        Qt.DisplayInfo = DisplayInfo;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: foodItemList

        // associate the data model for the list view
        dataModel: foodItemListDataModel

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

                    // actual food item
                    FoodItem {
                        foodItemData: ListItemData.foodItemData

                        // layout definition
                        preferredWidth: Qt.DisplayInfo.width
                        topPadding: 5
                        opacity: 0.9

                        // description of item has been clicked
                        // hand over click to parent page
                        onItemClicked: {
                            Qt.itemDescriptionClicked(ListItemData.foodItemData);
                        }

                        // signal that bookmark state of item should be changed
                        onBookmarkClicked: {
                            var foodItemListDataModel = Qt.foodItemListDataModel;

                            // iterate through all data items
                            for (var i = 0; i < foodItemListDataModel.size(); i ++) {
                                // get current child food item
                                var indexPath = new Array();
                                indexPath[0] = i;
                                var childItem = foodItemListDataModel.data(indexPath);

                                // check if food item in list is the selected one
                                if (childItem.foodItemData.foodid == ListItemData.foodItemData.foodid) {
                                    // console.log("# Child item foodItemData: " + childItem.foodItemData.description);
                                    childItem.foodItemData.bookmark = (childItem.foodItemData.bookmark * (-1)) + 1;
                                    foodItemListDataModel.updateItem(indexPath, childItem);
                                    break;
                                }
                            }

                            // send signal that item has been bookmarked
                            Qt.itemBookmarkClicked(ListItemData.foodItemData);
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
            id: foodItemListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
