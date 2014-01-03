// *************************************************** //
// Page Header Component
//
// This component is a custom header with a background
// color and image as well as a custom header text
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: pageHeaderComponent

    // signal that button has been clicked
    signal clicked()

    // external properties
    property alias backgroundColor: pageHeaderComponent.background
    property alias imageSource: pageHeaderBackgroundImage.imageSource
    property alias headline: pageHeaderHeadline.text

    // layout definition
    preferredWidth: DisplayInfo.width
    preferredHeight: 100

    // set initial background color
    // can be changed via the componentBackground property
    background: Color.create(Globals.foodcompanionDefaultBackgroundColor)

    Container {
        id: pageHeaderContainer

        // layout orientation
        layout: DockLayout {
        }

        // gallery image
        // this is a web image view provided by WebViewImage
        ImageView {
            id: pageHeaderBackgroundImage

            // align the image in the center
            scalingMethod: ScalingMethod.AspectFill
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            preferredWidth: DisplayInfo.width
            maxHeight: 100
        }

        Container {
            // layout definition
            leftPadding: 10
            rightPadding: 10

            // text label for headline
            Label {
                id: pageHeaderHeadline

                // layout definition
                leftMargin: 5
                textStyle.base: SystemDefaults.TextStyles.BigText
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left

                // layout definition
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center

                // set initial visibility to false
                // make label visible if text is added
                visible: false
                onTextChanged: {
                    visible = true;
                }
            }
        }
    }

    // handle tap on custom button
    gestureHandlers: [
        TapHandler {
            onTapped: {
                pageHeaderComponent.clicked();
            }
        }
    ]
}