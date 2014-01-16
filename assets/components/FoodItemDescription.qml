// *************************************************** //
// Food Item Description Component
//
// This component shows the food information like
// name, description and favorited status.
// It is used in the FoodItemList.
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
    id: foodItemDescriptionComponent

    // signal that the description has been clicked
    signal descriptionClicked()

    // signal that the fav button has been clicked
    signal favoriteClicked()

    // property for the food description
    property alias description: foodItemDescription.text
    
    // property for the food portion
    property alias portion: foodItemPortion.text

    // flag if food is favorited
    property bool favorite

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // layout definition
    topPadding: 5
    bottomPadding: 10
    leftPadding: 10
    rightPadding: 5

    // set background color
    background: Color.create(Globals.foodcompanionDefaultBackgroundColor)

    // standard width is minimum display width
    // however this should be overwritten by calling page
    // with DisplayInfo.width
    preferredWidth: 720

    // name and description container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        // position and layout properties
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Left

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // image caption label
            Label {
                id: foodItemDescription

                // layout definition
                textStyle.base: SystemDefaults.TextStyles.BodyText
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left
                multiline: true

                // component width minus the icon width
                preferredWidth: foodItemDescriptionComponent.preferredWidth - 81
            }

            // image caption label
            Label {
                id: foodItemPortion
                
                // layout definition
                textStyle.base: SystemDefaults.TextStyles.SmallText
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left
                multiline: true
                
                // component width minus the icon width
                preferredWidth: foodItemDescriptionComponent.preferredWidth - 81
            }
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Container clicked");
                    foodItemDescriptionComponent.descriptionClicked();
                }
            }
        ]
    }

    // Fav container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        verticalAlignment: VerticalAlignment.Fill
        leftPadding: 10

        // mask the profile image to make it round
        ImageView {
            id: foodFavorite

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: 81
            preferredWidth: 81
            minHeight: 81
            minWidth: 81

            imageSource: "asset:///images/icons/icon_notfaved.png"
        }

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# User profile clicked");
                    foodItemDescriptionComponent.favoriteClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            foodItemDescriptionComponent.background = Color.create(Globals.foodcompanionHighlightBackgroundColor);
        }

        // user release description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            foodItemDescriptionComponent.background = Color.create(Globals.foodcompanionDefaultBackgroundColor);
        }
    }

    // change background and mask color according to confirmed state
    onFavoriteChanged: {
        if (foodItemDescriptionComponent.favorite) {
            foodFavorite.imageSource = "asset:///images/icons/icon_faved.png";
        } else {
            foodFavorite.imageSource = "asset:///images/icons/icon_notfaved.png";
        }
    }
    
    onFavoriteClicked: {
        foodItemDescriptionComponent.favorite = (foodItemDescriptionComponent.favorite*(-1)) + 1;
    }
}