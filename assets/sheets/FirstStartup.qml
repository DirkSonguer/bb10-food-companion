// *************************************************** //
// First Startup Sheet
//
// This sheet shows information on first startup and
// handles the import of new database items with
// respective progress indicator while the database
// is imported.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// import blackberry components
import bb.cascades 1.2

// set import directory for components
import "../components"

// shared js files
import "../global/globals.js" as Globals
import "../global/copytext.js" as Copytext
import "../classes/configurationhandler.js" as Configuration
import "../classes/itemdatabase.js" as ItemDatabase

// import timer type
import QtTimer 1.0

Page {
    id: firstStartupPage

    // data if database needs to be imported
    property variant foodData

    Container {
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

            // accessibility
            accessibility.name: ""

            // image scaling and opacity
            scalingMethod: ScalingMethod.AspectFill

            // image file
            imageSource: "asset:///images/page_background.png"
        }

        // container for importing the database and handling the
        // according progress bar
        // this step is triggered by the onFoodDataChanged() signal
        Container {
            id: step0ImportDatabase
            
            // layout orientation
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            // layout definition
            verticalAlignment: VerticalAlignment.Center
            leftPadding: 10
            rightPadding: 10

            // info message that import needs to be done
            InfoMessage {
                id: importMessage
                
                // message content
                titleText: Copytext.importDBHeadline
                messageText: Copytext.importDBText
                textColor: Color.White

                // layout definition
                leftPadding: 10
                rightPadding: 10
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

                // accessibility
                accessibility.name: "Importing data, please wait"

                // state has been changed
                // the importer method sets the state to ProgressIndicatorState.Pause
                // if one batch is finished but there are more waiting for import
                // and to ProgressIndicatorState.Complete if all data has been imported
                onStateChanged: {
                    // import done
                    if (state == ProgressIndicatorState.Complete) {
                        // timer should not be running, but stop it anyway
                        importTimer.stop();
                        
                        // close the sheet
                        // TODO: next info step
                        firstStartupSheet.close();
                    }

                    // load next batch
                    // note that we let a timer do this to give
                    // the UI time to update
                    if (state == ProgressIndicatorState.Pause) {
                        // reset the state to progressing
                        state = ProgressIndicatorState.Progress;
                        
                        // start the timer for importing the next batch
                        importTimer.start();
                    }
                }
            }
        }
    }

    // new data to import has been given
    onFoodDataChanged: {
        ItemDatabase.itemdb.importDatabase(firstStartupPage.foodData, importProgress);
    }

    // attach components
    attachedObjects: [
        // timer component
        Timer {
            id: importTimer

            // set the interval to a short delay
            // the UI will update itself even with 1ms delay
            interval: 1
            
            // only import one batch at a time
            singleShot: true

            // when triggered, import next batch
            onTimeout: {
                ItemDatabase.itemdb.importDatabase(firstStartupPage.foodData, importProgress);
            }
        }
    ]
}
