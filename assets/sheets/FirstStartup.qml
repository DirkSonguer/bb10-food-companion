// *************************************************** //
// First Startup Sheet
//
// This sheet shows information on first startup as well
// as the progress indicator while the database is
// imported.
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
import "../classes/configurationhandler.js" as Configuration
import "../classes/fooddatabase.js" as FoodDatabase

// import timer type
import QtTimer 1.0

Page {
    id: firstStartupPage

    // data if database needs to be imported
    property variant importData

    Container {
        layout: DockLayout {

        }

        // local image slot
        ImageView {
            id: backgroundImage

            // layout definition
            scalingMethod: ScalingMethod.AspectFill
            verticalAlignment: VerticalAlignment.Top
            preferredWidth: DisplayInfo.width
            preferredHeight: DisplayInfo.height
            opacity: 0.75

            imageSource: "asset:///images/page_background.png"
        }

        // container for importing the database
        // this step is triggered by the onImportDataChanged() signal
        Container {
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            leftPadding: 10
            rightPadding: 10

            // message
            InfoMessage {
                id: infoMessage

                // layout definition
                leftPadding: 0
                rightPadding: 0
                bottomPadding: 30
            }

            // progress indicator
            // note that the database is imported in batches
            // once importing is finished the state will be set to
            // ProgressIndicatorState.Complete
            ProgressIndicator {
                id: importProgress

                // the currentIndex property tracks the current index id
                // of the next item to import
                property int currentIndex: 0

                // set default from and to values
                // this will be overwritten by the import method
                fromValue: 0
                toValue: 100

                // layout definition
                horizontalAlignment: HorizontalAlignment.Center

                // state has been changed
                // the importer method sets the state to ProgressIndicatorState.Pause
                // if one batch is finished but there are more waiting and to
                // ProgressIndicatorState.Complete if all data has been imported
                onStateChanged: {
                    // import done
                    if (state == ProgressIndicatorState.Complete) {
                        firstStartupSheet.close();
                        importTimer.stop();
                    }

                    // load next batch
                    // note that we let a timer do this to give
                    // the UI time to update
                    if (state == ProgressIndicatorState.Pause) {
                        state = ProgressIndicatorState.Progress;
                        importTimer.start();
                    }
                }
            }
        }
    }

    // new data to import has been given
    onImportDataChanged: {
        infoMessage.showMessage(Copytext.foodcompanionImportDBText, Copytext.foodcompanionImportDBHeadline);
        FoodDatabase.fooddb.importDatabase(firstStartupPage.importData, importProgress);
    }

    // attach components
    attachedObjects: [
        // timer component
        Timer {
            id: importTimer

            // set the interval to a short delay
            // The UI will update itself even with 1ms
            interval: 1
            singleShot: true

            // when triggered, import next batch
            onTimeout: {
                FoodDatabase.fooddb.importDatabase(firstStartupPage.importData, importProgress);
            }
        }
    ]
}
