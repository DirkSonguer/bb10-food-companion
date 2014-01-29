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

    // signal that input has been cleared
    // or interaction is not relevant
    signal cleared()

    // signal that input field should be focussed
    signal focus()

    // make input field properties accessible by external components
    property alias text: foodInputField.text
    property alias hintText: foodInputField.hintText

    // layout definition
    topPadding: 10
    bottomPadding: 10
    leftPadding: 10
    rightPadding: 10

    // green background
    background: Color.create(Globals.greenBackgroundColor)

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    // set initial visibility to false
    visible: true

    // comment submit button
    ImageButton {
        defaultImageSource: "asset:///images/icons/icon_search_dimmed.png"
        pressedImageSource: "asset:///images/icons/icon_search.png"
        onClicked: {
            // signal that input has been triggered
            foodInputField.input.submitted(foodInputField);
        }
    }

    // comment input field
    TextField {
        id: foodInputField

        // configure text field
        hintText: "Enter food name"
        clearButtonVisible: true
        focusHighlightEnabled: false
        inputMode: TextFieldInputMode.Text

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
                if (foodInputField.text.length > 2) {
                    // signal that input has been changed
                    foodInputComponent.changed(foodInputField.text);
                } else {
                    // signal that input field is empty or too short
                    foodInputComponent.cleared();
                }
            }
        }
    }

    onFocus: {
        console.log("# Requesting focus via onFocus");
        foodInputField.requestFocus();
    }
}