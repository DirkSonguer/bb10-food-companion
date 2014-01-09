// *************************************************** //
// Food List Component
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
    id: foodListComponent

    // signal if gallery is scrolled to start or end
    signal listBottomReached()
    signal listTopReached()
    signal listIsScrolling()

    // signal if food item was clicked
    signal itemClicked(variant foodData)

    // property that holds the current index
    // this is incremented as new items are added
    // to the list a provides the order the items were
    // added to the data model
    property int currentItemIndex: 0

    // properties to define how the list should be sorted
    property string listSortingKey: "currentIndex"
    property alias listSortAscending: foodListDataModel.sortedAscending

    // signal to clear the gallery contents
    signal clearList()
    onClearList: {
        foodListDataModel.clear();
    }

    // signal to add a new item
    // item is given as type InstagramCommentData
    signal addToList(variant item)
    onAddToList: {
        // console.log("# Adding item with ID " + item.commentId + " to comment list data model");
        foodListComponent.currentItemIndex += 1;
        foodListDataModel.insert({
                "foodData": item,
                "currentIndex": foodListComponent.currentItemIndex
            });
    }

    // this is a workaround to make the signals visible inside the listview item scope
    // see here for details: http://supportforums.blackberry.com/t5/Cascades-Development/QML-Accessing-variables-defined-outside-a-list-component-from/m-p/1786265#M641
    onCreationCompleted: {
        Qt.itemClicked = foodListComponent.itemClicked;
        Qt.DisplayInfo = DisplayInfo;
    }

    // layout orientation
    layout: DockLayout {
    }

    // list of Instagram popular media
    ListView {
        id: foodList

        // associate the data model for the list view
        dataModel: foodListDataModel

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
                    
                    FoodDescription {
                        description: ListItemData.foodData.description
                        favorite: ListItemData.foodData.favorite
                    }

                    bottomPadding: 5
                }
            }
        ]

        // add action for loading additional data after scrolling to bottom
        attachedObjects: [
            ListScrollStateHandler {
                id: scrollStateHandler
                onAtBeginningChanged: {
                    // console.log("# onAtBeginningChanged");
                    if (scrollStateHandler.atBeginning) {
                        foodListComponent.listTopReached();
                    }
                }
                onAtEndChanged: {
                    // console.log("# onAtEndChanged");
                    if (scrollStateHandler.atEnd) {
                        foodListComponent.listBottomReached();
                    }
                }
                onScrollingChanged: {
                    // console.log("# List is scrolling: " + scrollStateHandler.toDebugString());
                    if (! scrollStateHandler.atBeginning) {
                        foodListComponent.listIsScrolling();
                    }
                }
            }
        ]
    }

    // attached objects
    attachedObjects: [
        // this will be the data model for the popular media list view
        GroupDataModel {
            id: foodListDataModel
            sortedAscending: false
            sortingKeys: [ listSortingKey ]

            // items are grouped by the view and transformators
            // no need to set a behaviour by the data model
            grouping: ItemGrouping.None
        }
    ]
}
