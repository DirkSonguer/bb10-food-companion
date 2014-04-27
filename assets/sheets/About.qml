// *************************************************** //
// About Sheet
//
// The about sheet shows a description text for the app
// defined in the copytext file.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext

Page {
    Container {
        // layout orientation
        layout: DockLayout {
        }

        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definiton
            // layout definition
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            leftPadding: 10
            rightPadding: 10

            InfoMessage {
                id: infoMessage

                leftPadding: 0
                rightPadding: 0
            }

            // contact invocation trigger
            CustomButton {
                narrowText: "Contact developer"

                // layout definition
                preferredWidth: DisplayInfo.width
                topMargin: 30

                // trigger email invocation
                onClicked: {
                    emailInvocation.trigger(emailInvocation.query.invokeActionId);
                }
            }
        }
    }
    
    onCreationCompleted: {
        infoMessage.showMessage(Copytext.aboutText, Copytext.aboutHeadline);
    }    

    // close action for the sheet
    actions: [
        ActionItem {
            title: "Close"
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/icons/icon_close.png"

            // close sheet when pressed
            // note that the sheet is defined in the main.qml
            onTriggered: {
                aboutSheet.close();
            }
        }
    ]

    // invocation for opening browser
    attachedObjects: [
        // contact invocation
        Invocation {
            id: emailInvocation

            // query data
            query {
                mimeType: "text/plain"
                invokeTargetId: "sys.pim.uib.email.hybridcomposer"
                invokeActionId: "bb.action.SENDEMAIL"
                uri: "mailto:appworld@songuer.de?subject=Food Companion Feedback"
            }
        }
    ]
}
