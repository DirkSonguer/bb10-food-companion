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
    layout: DockLayout {
    }

    // layout definition
    leftPadding: 5
    rightPadding: 5

    // standard width is minimum display width
    // however this should be overwritten by calling page
    // with DisplayInfo.width by the calling page
    preferredWidth: 720

    // general background image
    // this will be changed from green to wood once there is content to show
    Container {
        id: foodItemBackground

        // layout definition
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.create(Globals.defaultBackgroundColorActive)

        visible: false
    }

    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        // layout definition
        topPadding: 20
        bottomPadding: 20
        leftPadding: 20
        rightPadding: 10

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

                    // text style definition
                    textStyle.base: SystemDefaults.TextStyles.BodyText
                    textStyle.fontWeight: FontWeight.W400
                    textStyle.textAlign: TextAlign.Left
                    textStyle.lineHeight: 0.85
                    multiline: true

                    // component width minus the icon width and the paddings
                    preferredWidth: (foodItemComponent.preferredWidth - 110)
                }

                // image caption label
                Label {
                    id: foodItemPortion

                    // layout definition
                    textStyle.base: SystemDefaults.TextStyles.SmallText
                    textStyle.fontWeight: FontWeight.W100
                    textStyle.textAlign: TextAlign.Left
                    multiline: true

                    // component width minus the icon width and the paddings
                    preferredWidth: (foodItemComponent.preferredWidth - 110)
                }
            }

            // handle tap on food icon
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        // console.log("# Food icon clicked");
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

            // handle tap on bookmark icon
            gestureHandlers: [
                TapHandler {
                    onTapped: {
                        // console.log("# Icon bookmark clicked");
                        foodItemComponent.bookmarkClicked();
                    }
                }
            ]
        }
    }

    // handle ui touch elements
    onTouch: {
        // user pressed description
        if (event.touchType == TouchType.Down) {
            foodItemBackground.visible = true;
        }

        // user release description or is moving
        if ((event.touchType == TouchType.Up) || (event.touchType == TouchType.Cancel)) {
            foodItemBackground.visible = false;
        }
    }

    // change background and mask color according to confirmed state
    onFoodItemDataChanged: {
        foodItemDescription.text = foodItemData.description.toUpperCase();
        foodItemPortion.text = foodItemData.calories + " calories per " + foodItemData.portion;

        // set bookmark icon according to state
        if (foodItemData.bookmark == 1) {
            foodItemBookmarked.imageSource = "asset:///images/icons/icon_bookmarked.png";
        } else {
            foodItemBookmarked.imageSource = "asset:///images/icons/icon_notbookmarked.png";
        }
    }
}