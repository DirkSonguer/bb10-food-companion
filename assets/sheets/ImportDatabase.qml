// *************************************************** //
// Import Database Sheet
//
// This sheet acts as a notification sheet when the
// database needs to be initialized.
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
    id: importDatabasePage
    
    property variant importData
    property bool running: false

Container {
    layout: DockLayout {
        
    }
    
    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
        verticalAlignment: VerticalAlignment.Center
        
        leftPadding: 10
        rightPadding: 10

        InfoMessage {
            id: infoMessage

            leftPadding: 0
            rightPadding: 0
            bottomPadding: 20
        }
        
        ProgressIndicator {
            id: foodcompanionProgressToast
            
            property int currentIndex: 0
            
            fromValue: 0
            toValue: 100
            
            horizontalAlignment: HorizontalAlignment.Center
            
            onStateChanged: {
                if (state == ProgressIndicatorState.Complete) {
                    importDatabaseSheet.close();
                    mediaCommentsTimer.stop();
                }
                
                if (state == ProgressIndicatorState.Pause) {
                    // console.log("# Loading paused");
                    state = ProgressIndicatorState.Progress;
                    mediaCommentsTimer.start();
                } 
            }
        }        
    }
}
    
    onImportDataChanged: {
        infoMessage.showMessage("Please wait, the database needs to be imported before use. This might take up to a minute, but needs to be done only once.", "Import needed")
        FoodDatabase.fooddb.importDatabase(importDatabasePage.importData, foodcompanionProgressToast);
    }
    
    
    // attach components
    attachedObjects: [
        // timer component
        // used to delay reload after commenting
        Timer {
            id: mediaCommentsTimer
            interval: 500
            singleShot: true
            
            // when triggered, reload the comment data
            onTimeout: {
                FoodDatabase.fooddb.importDatabase(importData, foodcompanionProgressToast);
            }
        }
    ]    
}
