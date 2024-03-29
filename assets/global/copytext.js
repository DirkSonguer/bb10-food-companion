// *************************************************** //
// Copytext
//
// This file contains globally relevant text content.
// Note that the var content is stable (making them
// constants - if there was such a thing in JS).
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

var working = "Working..";

var aboutHeadline = "Food Companion";
var aboutText = "<html>Food Companion is a photo diary for your daily food as well as a calorie and nutrition logger for BlackBerry 10.<br /><br />You can snap pictures and log calorie and nutritional informationto get a comprehensive overview of your daily eating routine.<br /><br />Note that the food database is stored locally on your device. No internet access is needed for this application. You diary data is not shared in any way and does not leave your device.<br /><br />Code &amp; UI: Dirk Songuer (dirk@songuer.de).</html>";

var portionSizeValues = new Array("Small portion", "Normal portion", "Large portion");
var healthRatingValues = new Array("Unhealthy", "Ok", "Healthy");
var summaryRatingEmoticons = new Array("02_crying.png", "03_sad.png", "04_surprised.png", "05_happy.png", "06_wink.png", "07_lol.png");

var importDBHeadline = "Import needed";
var importDBText = "Please wait, the database needs to be imported and processed before first use. This might take up to a minute, but needs to be done only once.";

var noFoodEntriesFoundHeadline = "No entries found";
var noFoodEntriesFoundText = "It seems you don't have any food entries in your diary yet. Why not tap here and start logging your food?";

var noFoodImageTaken = "Please take a picture of your food first";
var noFoodDescription = "Please add a description for your food first";

var enterFoodItemHeadline = "Enter food name";
var enterFoodItemText = "Start typing in the name of your food to get a list of known items.";

var noFoodItemsFoundHeadline = "No search results";
var noFoodItemsFoundText = "Could not find a food item for this search. Please refine your search or add the item to the database.";

var foodEntrySaved = "Food entry has been saved in your diary";
var foodEntryDeleted = "The diary entry has been deleted (";

var foodItemSaved = "Food item has been saved in the database";

var statBaseText = "Your diary has %1 entries with an average of %2 calories. All in all you eat %3. %4%5";
var statAvgRatingComment =  new Array("pretty unhealthy", "pretty healthy", "very healthy");
var statLogActivityComment = new Array("Keep going", "Well done", "Awesome");
var statLogRatingComment =  new Array(", but try to eat more healthy!", ", you are doing ok.", " and keep it healthy!");
