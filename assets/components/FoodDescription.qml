// *************************************************** //
// Food Description Component
//
// This component shows the food information like
// name, description and favorited status
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
    id: foodDescriptionComponent

    // signal that the description has been clicked
    signal descriptionClicked()

    // signal that the fav button has been clicked
    signal favoriteClicked()
    
    // property for the food description
    property alias description: foodDescription.text

    // flag if food is favorited
    property bool favorite

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.RightToLeft
    }

    // layout definition
    topPadding: 5
    bottomPadding: 10
    leftPadding: 10
    rightPadding: 5

    // set background color
    background: Color.create(Globals.foodcompanionDefaultBackgroundColor)

    // standard width is full display width
     preferredWidth: Qt.DisplayInfo.width

    // Fav container
    Container {
        // layout orientation
        layout: DockLayout {
        }

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
                    foodDescriptionComponent.favoriteClicked();
                }
            }
        ]
    }

    // name and description container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        
        // position and layout properties
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Left

        // image caption label
        Label {
            id: foodDescription

            // layout definition
            textStyle.base: SystemDefaults.TextStyles.BodyText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
            multiline: true
            
            // standard width is full display width
            preferredWidth: (Qt.DisplayInfo.width - 81)
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Container clicked");
                    foodDescriptionComponent.descriptionClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            foodDescriptionComponent.background = Color.create(Globals.foodcompanionHighlightBackgroundColor);
        }

        // user release description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
                foodDescriptionComponent.background = Color.create(Globals.foodcompanionDefaultBackgroundColor);
        }
    }

    // change background and mask color according to confirmed state
    onFavoriteChanged: {
        if (foodDescriptionComponent.favorite) {
            foodFavorite.imageSource = "asset:///images/icons/icon_faved.png";
        } else {
            foodFavorite.imageSource = "asset:///images/icons/icon_notfaved.png";
        }
    }
}