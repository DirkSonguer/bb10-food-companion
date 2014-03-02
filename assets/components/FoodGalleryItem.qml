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

    // data for the food entry
    property variant foodEntryData

    // layout orientation
    layout: DockLayout {
    }

    // standard width is minimum display width
    // however this should be overwritten by calling page
    // with DisplayInfo.width
    preferredWidth: 720

    // default height
    preferredHeight: 280

    Container {
        layout: DockLayout {

        }

        horizontalAlignment: HorizontalAlignment.Center
        preferredWidth: (foodGalleryItemComponent.preferredWidth - 10)

        ImageView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            imageSource: "asset:///images/card_background.png"
        }

        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            topPadding: 40
            leftPadding: 30

            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }

            ImageWithBorder {
                id: foodEntryImage
                
                minHeight: 200
                maxHeight: 200
                minWidth: 200
                maxWidth: 200
            }

            Container {
                leftPadding: 10
                rightPadding: 20

                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }

                Container {
                    // portion information
                    // this contains the portion, size and calory information of the item
                    Label {
                        id: foodEntryDescription

                        // layout definition
                        topMargin: 0
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 8
                        textStyle.fontWeight: FontWeight.W400
                        textStyle.textAlign: TextAlign.Left
                        textStyle.lineHeight: 0.85
                        multiline: true
                        autoSize {
                            maxLineCount: 3
                        }
                    }
                }
                
                Container {
                    Label {
                        id: foodEntryPortion
                        
                        // layout definition
                        topMargin: 10
                        textStyle.fontSize: FontSize.PointValue
                        textStyle.fontSizeValue: 7
                        textStyle.fontWeight: FontWeight.W100
                        textStyle.textAlign: TextAlign.Left
                        textStyle.fontStyle: FontStyle.Italic
                        textStyle.color: Color.create(Globals.greenBackgroundColor)
                        textStyle.lineHeight: 0.85
                        multiline: true
                        autoSize {
                            maxLineCount: 2
                        }
                    }                    
                }
            }

        }
    }

    // food entry data has been given
    onFoodEntryDataChanged: {
        // fill portion data (portion, size, calories)
        var foodPortionAndCalories = Copytext.portionSizeValues[foodEntryData.size] + ", ";
        foodPortionAndCalories += foodEntryData.portion + " with " + foodEntryData.calories + " calories";
        foodEntryPortion.text = foodPortionAndCalories;
                
        // fill food item name
        foodEntryDescription.text = foodEntryData.description.toUpperCase();
        
        foodEntryImage.imageSource = "file:///" + foodEntryData.imageFile;
        foodEntryImage.borderColor = Color.create(Globals.healthRatingColors[foodEntryData.rating]);
        foodEntryImage.borderSize = 5;
        
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