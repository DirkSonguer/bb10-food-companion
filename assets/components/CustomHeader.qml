// *************************************************** //
// Custom Header Component
//
// This component is a custom header with a background
// color and image as well as a custom header text
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2
import bb.system 1.2

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Container {
    id: customHeaderComponent

    // signal that button has been clicked
    signal clicked()

    // external properties
    property alias backgroundColor: customHeaderComponent.background
    property alias imageSource: customHeaderBackgroundImage.imageSource
    property alias headline: customHeaderHeadline.text

    // layout definition
    preferredWidth: DisplayInfo.width
    preferredHeight: 100

    Container {
        id: customHeaderContainer

        // layout orientation
        layout: DockLayout {
        }

        // gallery image
        // this is a web image view provided by WebViewImage
        ImageView {
            id: customHeaderBackgroundImage

            // align the image in the center
            scalingMethod: ScalingMethod.AspectFill
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            preferredWidth: DisplayInfo.width
            maxHeight: 100
            
            // accessibility
            accessibility.name: ""
        }

        Container {
            // layout definition
            topPadding: 10
            leftPadding: 10
            rightPadding: 10

            // layout definition
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Bottom
            
            // text label for headline
            Label {
                id: customHeaderHeadline

                // layout definition
                leftMargin: 5
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 12
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left

                // accessibility
                accessibility.name: ""

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
                customHeaderComponent.clicked();
            }
        }
    ]
}