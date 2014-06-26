// *************************************************** //
// Image with border Component
//
// This component shows a given image with a border.
// Image and border color are defined as properties.
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
    id: imageWithBorderComponent

    // image source
    property alias imageSource: componentImage.imageSource

    // border color
    property alias borderColor: imageWithBorderComponent.background

    // size of the border in pixels
    property int borderSize

    layout: DockLayout {
    }

    // default background color
    // this is basically the image border color
    background: Color.Black

    Container {
        // padding is used as border size
        topPadding: imageWithBorderComponent.borderSize
        bottomPadding: imageWithBorderComponent.borderSize
        leftPadding: imageWithBorderComponent.borderSize
        rightPadding: imageWithBorderComponent.borderSize

        // image
        ImageView {
            id: componentImage

            // align image in the center of the parent container
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center

            // image scaling
            scalingMethod: ScalingMethod.AspectFill
            
            // accessibility
            accessibility.name: ""
        }
    }
}
