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
import "../structures/fooditem.js" as FoodItemType

Container {
    id: customSliderComponent

    signal valueChanged(real immediateValue)

    property int currentSliderIndex: 1
    
    property alias label: customSliderLabel.text
    property alias description: customSliderDescription.text

    property alias fromValue: customSlider.fromValue
    property alias toValue: customSlider.toValue
    property alias value: customSlider.value

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // small headline describing the slider feature
    Container {
        // layout definition
        leftPadding: 25

        Label {
            id: customSliderDescription
            
            // layout definition
            horizontalAlignment: HorizontalAlignment.Left

            // description text
            text: "Portion size:"

            // text style definition
            textStyle.base: SystemDefaults.TextStyles.SmallText
            textStyle.fontWeight: FontWeight.W100
            textStyle.textAlign: TextAlign.Left
        }
    }

    // health rating description
    Label {
        id: customSliderLabel

        // layout definition
        horizontalAlignment: HorizontalAlignment.Center

        // text style definition
        textStyle.fontSize: FontSize.PointValue
        textStyle.fontSizeValue: 12
        textStyle.fontWeight: FontWeight.W100
        textStyle.textAlign: TextAlign.Right
        textStyle.color: Color.White
    }

    // health rating slider
    Slider {
        id: customSlider

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