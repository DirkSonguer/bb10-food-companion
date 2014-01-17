// *************************************************** //
// Food Entry Database Page
//
// This page shows the gallery of logged food items.
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
import "../classes/entrydatabase.js" as EntryDatabase

Page {
    
    Container {
        // layout orientation
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
        // page header
        PageHeader {
            headline: "Your food gallery"
            imageSource: "asset:///images/header_background.png"
        }
        
    }
    
    onCreationCompleted: {
        EntryDatabase.entrydb.getEntries();
    }
}
