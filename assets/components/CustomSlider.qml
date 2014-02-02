// *************************************************** //
// Custom Slider Component
//
// This component provides the portion size selector.
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
    id: customSliderComponent

    signal valueChanged(real immediateValue)

    property alias label: customSliderLabel.text
    property int currentSliderIndex: 1
    property alias fromValue: customSlider.fromValue
    property alias toValue: customSlider.toValue
    property alias value: customSlider.value

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // slider description
    Label {
        id: customSliderLabel

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        bottomMargin: 0

        // text style definition
        textStyle.fontSize: FontSize.PointValue
        textStyle.fontSizeValue: 10
        textStyle.fontWeight: FontWeight.W100
        textStyle.textAlign: TextAlign.Right
        textStyle.color: Color.White
    }

    // actual slider component
    Slider {
        id: customSlider

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center
        topMargin: 0

        // initial slider range definition
        fromValue: 0
        toValue: 100
        value: 100

        // slider value changed
        onImmediateValueChanged: {
            customSliderComponent.valueChanged(immediateValue);
        }
    }
}