// *************************************************** //
// New Food Item Page
//
// This page allows the user to add a new food item
// to the database.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../classes/itemdatabase.js" as ItemDatabase

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
            imageSource: "asset:///images/header_background.png"
        }

        Container {
            // layout definition
            leftPadding: 5
            rightPadding: 5

            // item name
            TextField {
                id: foodItemName

                // configure text field
                hintText: "Enter food name"
                clearButtonVisible: true
                inputMode: TextFieldInputMode.Text
            }

        }

        onCreationCompleted: {
        }
    }
}
