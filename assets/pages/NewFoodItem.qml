// *************************************************** //
// New Food Item Page
//
// This page allows the user to add a new food item
// to the database.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../classes/itemdatabase.js" as ItemDatabase
import "../structures/fooditem.js" as FoodItemType

Page {
    id: newFoodItemPage

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // page header
        CustomHeader {
            id: foodItemHeader

            headline: "Add item to database"
        }

        // scroll view as the page might not fit on the Q10 / Q5 screen
        ScrollView {
            // only vertical scrolling is needed
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical
                pinchToZoomEnabled: false
            }

            // accessibility
            accessibility.name: "New food item"

            Container {
                // layout definition
                topMargin: 5
                leftPadding: 10
                rightPadding: 10

                Label {
                    text: "The name of the food item.\nExample: \"My own chicken and ham sandwich\""

                    // layout definition
                    bottomMargin: 5
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }

                // item description
                TextField {
                    id: foodItemDescription

                    // layout definition
                    topMargin: 0

                    // configure text field
                    hintText: "Enter food name"
                    clearButtonVisible: false
                    inputMode: TextFieldInputMode.Text
                }

                Label {
                    text: "The portion description.\nExample: \"serving\", \"cup\" or \"slice\""

                    // layout definition
                    bottomMargin: 5
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }

                // item description
                TextField {
                    id: foodItemPortion

                    // layout definition
                    topMargin: 0

                    // configure text field
                    hintText: "Enter food portion description"
                    clearButtonVisible: false
                    inputMode: TextFieldInputMode.Text
                }

                Label {
                    text: "The estimated amount of calories per portion\nExample: \"250\""

                    // layout definition
                    bottomMargin: 5
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true
                }

                // item description
                TextField {
                    id: foodItemCalories

                    // layout definition
                    topMargin: 0

                    // configure text field
                    hintText: "Enter food portion description"
                    clearButtonVisible: false
                    inputMode: TextFieldInputMode.NumbersAndPunctuation
                }

                CustomButton {
                    id: foodItemBookmark

                    // property to store bookmark state
                    property int bookmarked: 0

                    // layout definition
                    topMargin: 10
                    bottomMargin: 10
                    alignText: HorizontalAlignment.Left
                    preferredWidth: DisplayInfo.width
                    backgroundColor: Color.create(Globals.defaultBackgroundColor)

                    // bookmark text
                    iconSource: "asset:///images/icons/icon_notbookmarked.png"
                    narrowText: "Tap to add as favorite"

                    onClicked: {
                        if (bookmarked == 0) {
                            iconSource = "asset:///images/icons/icon_bookmarked.png";
                            narrowText = "Item will be added as favorite";
                            bookmarked = 1;
                        } else {
                            iconSource = "asset:///images/icons/icon_notbookmarked.png";
                            narrowText = "Tap to add as favorite";
                            bookmarked = 0;
                        }
                    }
                }

                // confirmation button
                CustomButton {
                    id: addItemButton

                    // layout definition
                    topMargin: 10
                    bottomMargin: 10
                    alignText: HorizontalAlignment.Center
                    backgroundColor: Color.create(Globals.greenBackgroundColor)
                    preferredWidth: DisplayInfo.width

                    // confirmation text
                    boldText: "Add new food item to database"
                    iconSource: "asset:///images/icons/icon_add.png"

                    // add food item clicked
                    // this will stored in the item database
                    onClicked: {
                        // create and fill new food item
                        var foodItem = new FoodItemType.FoodItem();
                        foodItem.foodid = Math.round(new Date().getTime() / 1000);
                        foodItem.description = foodItemDescription.text;
                        foodItem.portion = foodItemPortion.text;
                        foodItem.calories = foodItemCalories.text;
                        foodItem.bookmark = foodItemBookmark.bookmarked;
                        foodItem.usergen = 1;

                        // add item data to database
                        ItemDatabase.itemdb.addItem(foodItem);

                        // show confirmation toast
                        foodcompanionToast.body = Copytext.foodItemSaved;
                        foodcompanionToast.show();

                        // close page
                        navigationPane.pop();
                    }
                }
            }
        }

        onCreationCompleted: {
        }
    }
}
