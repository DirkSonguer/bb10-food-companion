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

    // flag if the item is currently enlarged
    property bool enlarged: false

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // standard width is minimum display width
    // however this should be overwritten by calling page
    // with DisplayInfo.width
    preferredWidth: 720

    // default height
    // this will be changed on user interaction
    preferredHeight: 450

    // name and description container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // image of the food entry
        // size will be adapted according to the current height
        ImageView {
            id: foodEntryImage

            // layout definition
            scalingMethod: ScalingMethod.AspectFill
        }

        // wrapper container for the entry description
        Container {
            id: foodEntryDescriptionContainer

            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            preferredWidth: foodGalleryItemComponent.preferredWidth
            verticalAlignment: VerticalAlignment.Bottom
            opacity: 0.85
            leftPadding: 10
            rightPadding: 10
            bottomPadding: 10

            // default background
            // this will be set according to the item rating
            background: Color.create(Globals.greenBackgroundColor)

            // food entry description
            // this contains the name of the food item
            Label {
                id: foodEntryDescription

                // layout definition
                bottomMargin: 0
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 10
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left
                textStyle.lineHeight: 0.85
                multiline: true
            }

            // portion information
            // this contains the portion, size and calory information of the item
            Label {
                id: foodEntryPortion

                // layout definition
                topMargin: 0
                textStyle.base: SystemDefaults.TextStyles.BodyText
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left
                multiline: true
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
        foodEntryDescription.text = foodEntryData.description;

        // set title of the action menu to the current food item name
        foodEntryDescriptionActionSet.subtitle = foodEntryData.description;

        // show food entry image
        foodEntryImage.imageSource = "file:///" + foodEntryData.imageFile;

        // set background color according to food rating
        foodEntryDescriptionContainer.background = Color.create(Globals.healthRatingColors[foodEntryData.rating]);
        // foodItemTimestamp.text = foodEntryData.timestamp;
    }

    // handle ui touch elements
    // note that this is only the generic touch, setting the touch feedbacks
    // tap actions are defined in the gestureHandlers
    onTouch: {
        // user pressed component
        if (event.touchType == TouchType.Down) {
            foodEntryImage.opacity = 0.85;
        }

        // user release component or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            foodEntryImage.opacity = 1.0;
        }
    }

    // handle tap on component
    gestureHandlers: [
        TapHandler {
            // the image should be enlarged on tap
            onTapped: {
                // check current state and enlarge image if state is negative
                if (! foodGalleryItemComponent.enlarged) {
                    foodEntryDescriptionContainer.opacity = 0.5;
                    // foodGalleryItemComponent.preferredHeight = foodGalleryItemComponent.preferredWidth / 1836 * 3264;
                    foodGalleryItemComponent.preferredHeight = foodGalleryItemComponent.preferredWidth;
                    foodGalleryItemComponent.enlarged = true;
                } else {
                    foodEntryDescriptionContainer.opacity = 0.85;
                    foodGalleryItemComponent.preferredHeight = 450;
                    foodGalleryItemComponent.enlarged = false;
                }

                // send signal to calling page
                foodGalleryItemComponent.clicked();
            }
        }
    ]
}