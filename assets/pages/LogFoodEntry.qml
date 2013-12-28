// *************************************************** //
// Log Food Entry Page
//
// This page is the main page to log new food entries.
// The process will be handled by the page itself
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
    id: logFoodEntryPage

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
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            leftPadding: 10
            rightPadding: 10

            InfoMessage {
                id: infoMessage

                leftPadding: 0
                rightPadding: 0
            }
        }

        onCreationCompleted: {
//            infoMessage.showMessage(Copytext.instagoLoginBody, Copytext.instagoLoginHeadline);
        }
    }
}