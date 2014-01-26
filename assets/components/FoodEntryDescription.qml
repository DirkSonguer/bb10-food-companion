// *************************************************** //
// Food Entry Description Component
//
// This component shows all the data for a new food entry.
// It shows the food data like description and calories
// but also contains the logic for setting health and
// portion values.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../structures/foodentry.js" as FoodEntryType

Container {
    id: foodEntryDescriptionComponent

    // signal that the item has been clicked
    signal clicked()
    
    // signal that food description data has been changed
    signal foodDescriptionChanged(variant foodEntryData)

    // data for the food entry
    property variant foodEntryData

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    leftPadding: 10
    rightPadding: 10
    bottomPadding: 10

    // wrapper container for description labels
    Container {
        // image caption label
        Label {
            id: foodItem

            bottomMargin: 0

            // layout definition
            textStyle.fontSize: FontSize.PointValue
            textStyle.fontSizeValue: 12
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            textStyle.lineHeight: 0.75
            multiline: true
        }

        // image caption label
        Label {
            id: foodItemPortion

            topMargin: 0

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            multiline: true
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    foodEntryDescriptionComponent.clicked();
                }
            }
        ]
    }

    // slider to select food portion size
    // not that this will only visible if a food item has been selected
    CustomSlider {
        id: foodPortionSize

        // slider range definition
        fromValue: 0
        toValue: 2
        value: 1

        // initial health rating and description
        label: "Normal portion"

        // add logic to change rating on slider movement
        onValueChanged: {
            if ((typeof foodEntryDescriptionComponent.foodEntryData !== "undefined") && (foodEntryDescriptionComponent.foodEntryData.size != Math.round(immediateValue))) {
                // set label based on slider value
                var intImmediateValue = Math.round(immediateValue);

                // update values and write back the data
                // note that a temp entry is needed because the children of the page variant are read only
                var tempEntry = new FoodEntryType.FoodEntry();
                tempEntry = foodEntryDescriptionComponent.foodEntryData;
                tempEntry.size = intImmediateValue;
                foodEntryDescriptionComponent.foodEntryData = tempEntry;
            }
        }
    }

    // health rating slider
    CustomSlider {
        id: foodHealthRating

        // slider range definition
        fromValue: 0
        toValue: 2
        value: 2

        // initial health rating and description
        label: "Healthy"

        // add logic to change rating on slider movement
        onValueChanged: {
            var intImmediateValue = Math.round(immediateValue);

            // if the slider value has changed, show the according text
            if ((typeof foodEntryDescriptionComponent.foodEntryData !== "undefined") && (foodEntryDescriptionComponent.foodEntryData.rating != intImmediateValue)) {
                // set label based on slider value
                var intImmediateValue = Math.round(immediateValue);

                // update values and write back the data
                // note that a temp entry is needed because the children of the page variant are read only
                var tempEntry = new FoodEntryType.FoodEntry();
                tempEntry = foodEntryDescriptionComponent.foodEntryData;
                tempEntry.rating = intImmediateValue;
                foodEntryDescriptionComponent.foodEntryData = tempEntry;
            }
        }
    }

    onFoodEntryDataChanged: {
        // set new calory value based on portion size
        var caloryModulation = parseInt(foodEntryData.calories) + Math.round(((foodEntryData.size - 1) / 2) * parseInt(foodEntryData.calories));
        // console.log("# calories: " + foodEntryData.calories + " size: " + foodEntryData.size + " modulation: " + caloryModulation);
        
        // fill in data values
        var foodPortionAndCalories = foodEntryData.portion + " with " + caloryModulation + " calories";
        foodItemPortion.text = foodPortionAndCalories;
        foodItem.text = foodEntryData.description;
        foodPortionSize.label = Copytext.portionSizeValues[foodEntryData.size];
        foodHealthRating.label = Copytext.healthRatingValues[foodEntryData.rating];
        
        // signal that entry data has been changed
        foodEntryDescriptionComponent.foodDescriptionChanged(foodEntryData);
    }
}