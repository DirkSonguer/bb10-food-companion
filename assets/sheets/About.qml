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

        // background image slot
        // this just shows the green food companion background
        ImageView {
            id: backgroundImage

            // layout definition
            verticalAlignment: VerticalAlignment.Top
            preferredWidth: DisplayInfo.width
            preferredHeight: DisplayInfo.height

            // image scaling and opacity
            scalingMethod: ScalingMethod.AspectFill
            opacity: 0.75

            // image file
            imageSource: "asset:///images/page_background.png"
        }

        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definiton
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            leftPadding: 10
            rightPadding: 10

            InfoMessage {
                id: infoMessage

                titleText: "Food Companion"
                messageText: "A foto diary for your daily food as well as a calory and nutrition logger for BlackBerry 10."

                leftPadding: 0
                rightPadding: 0
            }

            InfoMessage {
                id: iconMessage

                messageText: "<html><body>Food Companion uses the <a href=\"http://subway.pixle.pl/\">Subway</a> set by Pixle for application icons as well as emoticons by <a href=\"http://icons8.com/\">Icon 8</a>.</body></html>"

                topMargin: 10
                leftPadding: 0
                rightPadding: 0
            }

            // contact invocation trigger
            CustomButton {
                narrowText: "Contact developer"

                // layout definition
                topMargin: 40
                alignText: HorizontalAlignment.Center
                backgroundColor: Color.create(Globals.defaultBackgroundColor)
                preferredWidth: DisplayInfo.width
                opacity: 0.85

                // trigger email invocation
                onClicked: {
                    emailInvocation.trigger(emailInvocation.query.invokeActionId);
                }
            }
        }
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
