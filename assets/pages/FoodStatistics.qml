// *************************************************** //
// Food Statistics Page
//
// This page shows the aggregated statistics of all the
// logged food entries.
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
    id: foodStatisticsPage

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
            // layout definition
            verticalAlignment: VerticalAlignment.Center
            leftPadding: 10
            rightPadding: 10

            // info message
            Label {
                id: foodStatistics

                // font definition
                textStyle.fontSize: FontSize.PointValue
                textStyle.fontSizeValue: 13
                textStyle.fontWeight: FontWeight.W100
                textStyle.textAlign: TextAlign.Left
                textStyle.lineHeight: 0.9
                multiline: true
            }

            // info message
            InfoMessage {
                id: infoMessage

                onMessageClicked: {
                    // jump to the food entry tab
                    tabbedPane.activeTab = newFoodEntryTab;
                }
            }
        }
    }

    onCreationCompleted: {
        var foundFoodItems = EntryDatabase.entrydb.getStatistics();

        // check if they are entries in the database
        // if so, show the logged entries
        if (foundFoodItems.numberOfEntries > 0) {
            var statistics = Copytext.statBaseText;
            statistics = statistics.replace(/%1/g, foundFoodItems.numberOfEntries);

            statistics = statistics.replace(/%2/g, Math.round(foundFoodItems.averageCalories));

            statistics = statistics.replace(/%3/g, Copytext.statAvgRatingComment[Math.round(foundFoodItems.averageRating)]);

            var activityComment = "";
            if (foundFoodItems.numberOfEntries < 10) activityComment = Copytext.statLogActivityComment[0];
            if ((foundFoodItems.numberOfEntries >= 10) && (foundFoodItems.length < 20)) activityComment = Copytext.statLogActivityComment[1];
            if (foundFoodItems.numberOfEntries >= 20) activityComment = Copytext.statLogActivityComment[2];
            statistics = statistics.replace(/%4/g, activityComment);

            statistics = statistics.replace(/%5/g, Copytext.statLogRatingComment[Math.round(foundFoodItems.averageRating)]);

            foodStatistics.text = statistics;
        } else {
            // if no food items have been logged yet, show note
            infoMessage.showMessage(Copytext.noFoodEntriesFoundText, Copytext.noFoodEntriesFoundHeadline);
        }
    }
}
