// *************************************************** //
// Food Input Component
//
// This component provides an input field for the
// food selection functionality.
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
    id: foodInputComponent

    // signal that input has been submitted
    signal submitted(string text)

    // signal that input has been changed
    signal changed(string text)

    // make input field properties accessible by external components
    property alias text: foodInput.text
    property alias hintText: foodInput.hintText

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // set initial visibility to false
    visible: true

    // comment input field
    TextField {
        id: foodInput

        // configure text field
        hintText: "Enter food name"
        clearButtonVisible: true
        inputMode: TextFieldInputMode.Chat

        // input behaviour and handling
        input {
            submitKey: SubmitKey.Submit
            onSubmitted: {
                if (submitter.text.length > 0) {
                    // signal that input has been triggered
                    foodInputComponent.submitted(submitter.text);
                }
            }
        }

        // input validation
        validator: Validator {
            mode: ValidationMode.Immediate
            onValidate: {
                if (foodInput.text.length > 2) {
                    // signal that input has been changed
                    foodInputComponent.changed(foodInput.text);
                }
            }
        }
    }

    // comment submit button
    ImageButton {
        defaultImageSource: "asset:///images/icons/icon_search_dimmed.png"
        pressedImageSource: "asset:///images/icons/icon_search.png"
        onClicked: {
            // signal that input has been triggered
            foodInput.input.submitted(foodInput);
        }
    }
}