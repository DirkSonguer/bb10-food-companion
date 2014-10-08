// *************************************************** //
// Food Entry Detail Page
//
// This page shows the details of a food entry.
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
import "../structures/foodentry.js" as FoodEntryType
import "../classes/entrydatabase.js" as EntryDatabase

Page {
    id: foodEntryDetailPage

    // the object containing the data of the food entry
    // this is of type FoodEntry()
    property variant foodEntryData

    Container {
        id: backgroundContainer

        // layout orientation
        layout: DockLayout {
        }

        // background image slot
        // this just shows the wooden background
        ImageView {
            id: backgroundImage

            // layout definition
            verticalAlignment: VerticalAlignment.Top
            preferredWidth: DisplayInfo.width
            preferredHeight: DisplayInfo.height

            // accessibility
            accessibility.name: ""

            // image scaling and opacity
            scalingMethod: ScalingMethod.AspectFill
        }

        // food item description
        Container {
            id: foodEntryBackground

            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            topPadding: 10
            leftPadding: 20
            rightPadding: 10
            bottomPadding: 20
            verticalAlignment: VerticalAlignment.Top
            preferredWidth: DisplayInfo.width
            background: Color.create(Globals.defaultBackgroundColorActive)
            opacity: 0.9

            // food item description
            Container {
                Label {
                    id: foodEntryDescription

                    // layout definition
                    topMargin: 0

                    // accessibility
                    accessibility.name: ""

                    // text style definition
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontWeight: FontWeight.W400
                    textStyle.textAlign: TextAlign.Left
                    textStyle.lineHeight: 0.85
                    textStyle.color: Color.White
                    multiline: true
                    autoSize {
                        maxLineCount: 3
                    }                    
                }
            }

            // food item portion
            Container {
                // portion information
                // this contains the portion, size and calory information of the item
                Label {
                    id: foodEntryPortion

                    // layout definition
                    topMargin: 10

                    // accessibility
                    accessibility.name: ""

                    // text style definition
                    textStyle.fontSize: FontSize.PointValue
                    textStyle.fontSizeValue: 7
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    textStyle.fontStyle: FontStyle.Italic
                    textStyle.color: Color.White
                    textStyle.lineHeight: 0.85
                    multiline: true
                    autoSize {
                        maxLineCount: 2
                    }
                }
            }
        }

        // info message
        InfoMessage {
            id: infoMessage

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            leftPadding: 10
            rightPadding: 10
        }
    }

    // food description has been changed
    // this is entered by the FoodGallery page
    onFoodEntryDataChanged: {
        // console.log("# Updating food item data: " + foodEntryData.description);

        // check if there is an image file available
        // if not, then show only the background color
        if (foodEntryData.imageFile != "") {
            backgroundImage.imageSource = "file:///" + foodEntryData.imageFile;
        } else {
            backgroundImage.visible = false;
            foodEntryBackground.verticalAlignment = VerticalAlignment.Center;
        }

        // set food description
        foodEntryDescription.text = foodEntryData.description;

        // set food portion and calories
        var foodPortionAndCalories = Copytext.portionSizeValues[foodEntryData.size] + ", ";
        foodPortionAndCalories += foodEntryData.portion + " with " + foodEntryData.calories + " calories";
        foodPortionAndCalories += ", rating: " + Copytext.healthRatingValues[foodEntryData.rating].toLowerCase();
        foodEntryPortion.text = foodPortionAndCalories;

        // set backgrounds
        foodEntryBackground.background = Color.create(Globals.healthRatingColors[foodEntryData.rating]);
        backgroundContainer.background = Color.create(Globals.healthRatingColors[foodEntryData.rating]);
    }

    // attach components
    attachedObjects: [
        // page to select food for an item
        // will be called if user clicks on add description
        ComponentDefinition {
            id: selectFoodItemPageComponent
            source: "SelectFoodItem.qml"
        }
    ]
}
