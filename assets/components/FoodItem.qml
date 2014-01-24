// *************************************************** //
// Food Item Component
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
    id: foodItemComponent

    // signal that the description has been clicked
    signal itemClicked()

    // signal that the bookmark button has been clicked
    signal bookmarkClicked()

    // data for the food item that should be shown
    // this is of type FoodItem()
    property variant foodItemData

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
    background: Color.create(Globals.defaultBackgroundColor)

    // standard width is minimum display width
    // however this should be overwritten by calling page
    // with DisplayInfo.width by the calling page
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
                preferredWidth: foodItemComponent.preferredWidth - 81
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
                preferredWidth: foodItemComponent.preferredWidth - 81
            }
        }

        // handle tap on custom button
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# Container clicked");
                    foodItemComponent.itemClicked();
                }
            }
        ]
    }

    // Bookmark container
    Container {
        // layout orientation
        layout: DockLayout {
        }

        verticalAlignment: VerticalAlignment.Fill
        leftPadding: 10

        // mask the profile image to make it round
        ImageView {
            id: foodItemBookmarked

            // position and layout properties
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Left

            // set image size to maximum profile picture size
            preferredHeight: 81
            preferredWidth: 81
            minHeight: 81
            minWidth: 81

            // set as not bookmarked by default
            imageSource: "asset:///images/icons/icon_notbookmarked.png"
        }

        // handle tap on profile picture
        gestureHandlers: [
            TapHandler {
                onTapped: {
                    // console.log("# User profile clicked");
                    foodItemComponent.bookmarkClicked();
                }
            }
        ]
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            foodItemComponent.background = Color.create(Globals.buttonBackgroundColor);
        }

        // user release description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            foodItemComponent.background = Color.create(Globals.defaultBackgroundColor);
        }
    }

    // change background and mask color according to confirmed state
    onFoodItemDataChanged: {
        foodItemDescription.text = foodItemData.description;
        foodItemPortion.text = foodItemData.calories + " calories per " + foodItemData.portion;

        // set bookmark icon according to state
        if (foodItemData.bookmark == 1) {
            foodItemBookmarked.imageSource = "asset:///images/icons/icon_bookmarked.png";
        } else {
            foodItemBookmarked.imageSource = "asset:///images/icons/icon_notbookmarked.png";
        }
    }
}