// *************************************************** //
// Info Message Component
//
// This component shows an information message with
// message content and header
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
    id: infoMessageComponent

    // show the component with a given message and title
    signal showMessage(string message, string title)

    // hide the title and message
    signal hideMessage()

    // signal to indicate a tap on the error message
    // this can be used by the using page
    signal messageClicked()

    property alias titleText: infoTitle.text
    property alias messageText: infoMessage.text
    property variant textColor

    // layout orientation
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    // layout definition
    leftPadding: 10
    rightPadding: 10

    // the actual title text
    Label {
        id: infoTitle

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.BigText
        textStyle.fontWeight: FontWeight.W500
        textStyle.textAlign: TextAlign.Left
        multiline: true

        // accessibility
        accessibility.name: "Info"

        // hide title components initially
        // will be set true if content is added
        visible: false

        // content added, show component
        onTextChanged: {
            visible = true;
        }
    }

    // the actual message text
    Label {
        id: infoMessage

        // text style definition
        textStyle.base: SystemDefaults.TextStyles.BodyText
        textStyle.fontWeight: FontWeight.W100
        textStyle.textAlign: TextAlign.Left
        multiline: true

        // accessibility
        accessibility.name: "Info"

        // hide message components initially
        // will be set true if content is added
        visible: false

        // content added, show component
        onTextChanged: {
            visible = true;
        }
    }

    // handle tap on message container
    gestureHandlers: [
        TapHandler {
            onTapped: {
                infoMessageComponent.messageClicked();
            }
        }
    ]
    
    onTextColorChanged: {
        infoTitle.textStyle.color = infoMessageComponent.textColor;
        infoMessage.textStyle.color = infoMessageComponent.textColor;
    }

    // show the loader with the given message
    onShowMessage: {
        // only show message component if a message was given
        if (message) {
            infoMessage.text = message;
            // infoMessage.visible = true;
        }

        // only show title component if a title was given
        if (title) {
            infoTitle.text = title;
            // infoTitle.visible = true;
        }
    }

    // hide title and message
    onHideMessage: {
        infoMessage.visible = false;
        infoTitle.visible = false;
    }
}