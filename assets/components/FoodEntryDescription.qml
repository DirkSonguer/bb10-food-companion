// *************************************************** //
// Food Entry Description Component
//
// This component shows the data for a food entry like
// image, name, description date and so on.
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
    id: foodEntryDescriptionComponent

    // signal that the item has been clicked
    signal clicked()
    
    signal deleteFoodEntry()

    // data for the food entry
    property variant foodEntryData
    
    property bool enlarged: false

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // standard width is minimum display width
    // however this should be overwritten by calling page
    // with DisplayInfo.width
    preferredWidth: 720

    preferredHeight: 500

    // name and description container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // camera image
        // this is filled by the camera control when the image has been taken
        ImageView {
            id: foodItemImage
            
            // layout definition
            scalingMethod: ScalingMethod.AspectFill
        }

        Container {
            id: foodEntryDescriptionContainer
            
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            
            preferredWidth: foodEntryDescriptionComponent.preferredWidth
            verticalAlignment: VerticalAlignment.Bottom
            background: Color.create(Globals.foodcompanionDefaultBackgroundColor)
            opacity: 0.75
            leftPadding: 10
            rightPadding: 10
            bottomPadding: 10

            // image caption label
            Label {
                id: foodItemDescription
                
                bottomMargin: 0

                // layout definition
                textStyle.base: SystemDefaults.TextStyles.BigText
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
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Container clicked");
                    foodEntryDescriptionComponent.clicked();
                }
            }
        ]
        
        
        
        // context menu for image
        // this will be deactivated based on login state on creation
        contextActions: [
            ActionSet {
                id: foodEntryDescriptionActionSet
                title: "Food entry"
                
                // comment image action
                ActionItem {
                    id: mediaDetailCommentImageAction
                    imageSource: "asset:///images/icons/icon_delete.png"
                    title: "Delete food entry"
                    
                    // click action
                    onTriggered: {
                        foodEntryDescriptionComponent.deleteFoodEntry();
                    }
                }
            }
        ]        
    }
    
    onFoodEntryDataChanged: {
        var foodPortionAndCalories = Copytext.foodcompanionPortionValues[foodEntryData.portionSize] + " portion, ";
        foodPortionAndCalories += foodEntryData.portion + " with " + foodEntryData.calories + " calories";
        foodItemPortion.text = foodPortionAndCalories;
        foodItemDescription.text = foodEntryData.description;
        foodEntryDescriptionActionSet.title = foodEntryData.description;
        foodItemImage.imageSource = "file:///" + foodEntryData.imageFile;  
        
        foodEntryDescriptionContainer.background = Color.create(Globals.foodcompanionEntryHealthColors[foodEntryData.healthRating]);
//        foodItemTimestamp.text = foodEntryData.timestamp;
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            foodItemImage.opacity = 0.75;
        }

        // user release description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            foodItemImage.opacity = 1.0;
        }
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                // console.log("# Container clicked");
                if (!foodEntryDescriptionComponent.enlarged) {
                    foodEntryDescriptionContainer.opacity = 0.5;
                    // foodEntryDescriptionComponent.preferredHeight = foodEntryDescriptionComponent.preferredWidth / 1836 * 3264;
                    foodEntryDescriptionComponent.preferredHeight = foodEntryDescriptionComponent.preferredWidth;
                    foodEntryDescriptionComponent.enlarged = true;
                } else {
                    foodEntryDescriptionContainer.opacity = 0.75;
                    foodEntryDescriptionComponent.preferredHeight = 500;
                    foodEntryDescriptionComponent.enlarged = false;
                }
            }
        }
    ]    
}