// *************************************************** //
// Food Gallery Item Component
//
// This component shows the data for a food entry like
// image, name, description date and so on.
// It is used by the food gallery list component.
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
    id: foodGalleryItemComponent

    // signal that the item has been clicked
    signal clicked()

    // signal that the item should be deleted
    signal deleteFoodEntry()

    // data for the food entry
    property variant foodEntryData

    // layout orientation
    layout: DockLayout {
    }

    // layout definition
    leftPadding: 5
    rightPadding: 5

    // standard width is minimum display width
    // however this should be overwritten by calling page
    // with DisplayInfo.width
    preferredWidth: 720

    // default height
    //    preferredHeight: 240

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // layout definition
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        topPadding: 15
        bottomPadding: 5
        leftPadding: 10
        rightPadding: 10

        // food item image
        ImageWithBorder {
            id: foodEntryImage

            minHeight: 150
            maxHeight: 150
            minWidth: 150
            maxWidth: 150
        }

        // food item description
        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            topPadding: -10
            leftPadding: 20
            rightPadding: 10

            // food item description
            Container {
                Label {
                    id: foodEntryDescription

                    // layout definition
                    topMargin: 0

                    // text style definition
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontWeight: FontWeight.W400
                    textStyle.textAlign: TextAlign.Left
                    textStyle.lineHeight: 0.85
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

                    // text style definition
                    textStyle.fontSize: FontSize.PointValue
                    textStyle.fontSizeValue: 7
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    textStyle.fontStyle: FontStyle.Italic
//                    textStyle.color: Color.create(Globals.greenBackgroundColor)
                    textStyle.lineHeight: 0.85
                    multiline: true
                    autoSize {
                        maxLineCount: 2
                    }
                }
            }
        }

        // context menu for the item
        contextActions: [
            ActionSet {
                id: foodEntryDescriptionActionSet
                title: "Your food diary"

                // comment image action
                ActionItem {
                    id: deleteFoorEntryAction
                    imageSource: "asset:///images/icons/icon_delete.png"
                    title: "Delete food entry"

                    // click action
                    onTriggered: {
                        foodGalleryItemComponent.deleteFoodEntry();
                    }
                }
            }
        ]
    }

    // food entry data has been given
    onFoodEntryDataChanged: {
        // fill portion data (portion, size, calories)
        var foodPortionAndCalories = Copytext.portionSizeValues[foodEntryData.size] + ", ";
        foodPortionAndCalories += foodEntryData.portion + " with " + foodEntryData.calories + " calories";
        foodEntryPortion.text = foodPortionAndCalories;

        // fill food item name
        foodEntryDescription.text = foodEntryData.description.toUpperCase();

        // set food item image and border
        foodEntryImage.imageSource = "file:///" + foodEntryData.imageFile;
        foodEntryImage.borderColor = Color.create(Globals.healthRatingColors[foodEntryData.rating]);
        foodEntryImage.borderSize = 5;

        // set color rating
        foodEntryPortion.textStyle.color = Color.create(Globals.healthRatingColors[foodEntryData.rating]);
    }

    // handle tap on component
    gestureHandlers: [
        TapHandler {
            // the image should be enlarged on tap
            onTapped: {
                // send signal to calling page
                foodGalleryItemComponent.clicked();
            }
        }
    ]
}