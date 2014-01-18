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
    signal itemClicked(variant foodData)

    // signal if food favorite state was clicked
    signal itemFavoriteClicked(variant foodData)

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
                "foodData": item,
                "currentIndex": foodItemListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.foodItemListDataModel = foodItemListDataModel;
        Qt.itemClicked = foodItemListComponent.itemClicked;
        Qt.itemFavoriteClicked = foodItemListComponent.itemFavoriteClicked;
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

                    FoodItemDescription {
                        description: ListItemData.foodData.description
                        portion: ListItemData.foodData.calories + " calories per " + ListItemData.foodData.portion
                        favorite: ListItemData.foodData.favorite
                        
                        preferredWidth: Qt.DisplayInfo.width

                        // description of item has been clicked
                        onDescriptionClicked: {
                            Qt.itemClicked(ListItemData.foodData);
                        }

                        onFavoriteClicked: {
                            var foodItemListDataModel = Qt.foodItemListDataModel;
                            for (var i = 0; i < foodItemListDataModel.size(); i ++) {
                                var indexPath = new Array();
                                indexPath[0] = i;
                                var childItem = foodItemListDataModel.data(indexPath);

                                if (childItem.foodData.id == ListItemData.foodData.id) {
                                    console.log("# Child item foodData: " + childItem.foodData.description);
                                    childItem.foodData.favorite = (childItem.foodData.favorite * (-1)) + 1;
                                    foodItemListDataModel.updateItem(indexPath, childItem);
                                }
                            }

                            Qt.itemFavoriteClicked(ListItemData.foodData);
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
            id: foodItemListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
