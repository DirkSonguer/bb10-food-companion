// *************************************************** //
// Food Selector Sheet
//
// This sheet contains the procedures to select a specific
// food for a new item. The sheet also handles adding new
// foods and marking / selecting favorites.
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
import "../classes/fooddatabase.js" as FoodDatabase
import "../structures/fooditem.js" as FoodItemType

Page {
    id: addDescriptionPage

    // signal that food has been selected
    // this will be captured by the calling page
    signal descriptionAdded(variant foodData);

    // the item object containing the data of the selected item
    // this will be handed back to the calling page via descriptionAdded()
    // this is of type FoodItem()
    property variant selectedFoodItem

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        // page header
        PageHeader {
            headline: "Select food item"
            imageSource: "asset:///images/header_background.png"

            // layout definition
            bottomPadding: 10
        }

        // small headline describing the slider feature
        Container {
            id: foodDescriptionContainer

            // layout definition
            preferredWidth: DisplayInfo.width
            topPadding: 20
            bottomPadding: 25
            leftPadding: 10
            rightPadding: 10

            // set initial background color
            // can be changed via the componentBackground property
            background: Color.create(Globals.foodcompanionDefaultBackgroundColor)

            Label {
                id: foodDescription

                // layout definition
                horizontalAlignment: HorizontalAlignment.Left

                // text style definition
                textStyle.base: SystemDefaults.TextStyles.BodyText
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left

                multiline: true
            }
        }

        // small headline describing the slider feature
        Container {
            id: foodCaloriesContainer

            // layout definition
            preferredWidth: DisplayInfo.width
            topMargin: 5
            topPadding: 20
            bottomPadding: 25
            leftPadding: 10
            rightPadding: 10

            // set initial background color
            // can be changed via the componentBackground property
            background: Color.create(Globals.foodcompanionDefaultBackgroundColor)

            Label {
                id: foodCalories

                // layout definition
                horizontalAlignment: HorizontalAlignment.Left

                // text style definition
                textStyle.base: SystemDefaults.TextStyles.BodyText
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left

                multiline: true
            }
        }

        // food portion size selector
        CustomSlider {
            id: foodPortionSize

            // layout definition
            topPadding: 15

            // slider range definition
            fromValue: 0
            toValue: 2
            value: 1

            // initial health rating and description
            label: "Normal"
            description: "Portion size:"

            // add logic to change rating on slider movement
            onValueChanged: {
                if ((typeof addDescriptionPage.selectedFoodItem !== "undefined") && (addDescriptionPage.selectedFoodItem.portionSize != Math.round(immediateValue))) {
                    // set label based on slider value
                    var intImmediateValue = Math.round(immediateValue);
                    label = Copytext.foodcompanionPortionValues[intImmediateValue];

                    console.log("Ding: " + intImmediateValue);

                    // store portion size in local food object
                    var tempItem = new FoodItemType.FoodItem();
                    tempItem = addDescriptionPage.selectedFoodItem;
                    tempItem.portionSize = intImmediateValue;
                    addDescriptionPage.selectedFoodItem = tempItem;

                    // set new calory value based on portion size
                    var caloryModulation = parseInt(addDescriptionPage.selectedFoodItem.calories) + Math.round(((intImmediateValue - 1) / 2) * parseInt(addDescriptionPage.selectedFoodItem.calories));
                    foodCalories.text = "Calories: " + caloryModulation;
                }
            }
        }

        // confirmation button
        Container {
            id: addDescriptionContainer

            // layout definition
            horizontalAlignment: HorizontalAlignment.Center
            topPadding: 50

            // confirmation button
            CustomButton {
                id: addDescriptionButton

                // layout definition
                preferredWidth: DisplayInfo.width - 20

                // set button background color to call to action green
                backgroundColor: Color.create(Globals.foodcompanionButtonBackgroundColor)

                // confirmation text
                boldText: "Add food description"

                onClicked: {
                    newFoodEntryPage.descriptionAdded(selectedFoodItem);
                    navigationPane.navigateTo(newFoodEntryPage);
                }
            }
        }

        // info message
        InfoMessage {
            id: infoMessage

            // layout definition
            leftPadding: 10
            rightPadding: 10
        }
    }

    onSelectedFoodItemChanged: {
        foodDescription.text = selectedFoodItem.description;
        foodCalories.text = "Calories: " + selectedFoodItem.calories
    }
}
