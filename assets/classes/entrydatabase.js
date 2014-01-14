// *************************************************** //
// Entry Database Script
//
// This script handles the calls to the entries database.
// Note that it's a class that needs to be defined first:
// fooddb = new FoodDatabase();
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "structures/fooditem.js");

// singleton instance of class
var entrydb = new EntryDatabase();

// class function that gets the prototype methods
function EntryDatabase() {
}

// This reads out all entries
// It can either be the item array if successful
// or it can contain an error with respective message
EntryDatabase.prototype.getEntries = function() {
	// console.log("# Getting entries");

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS foodentries(entry_filename TEXT, entry_rating INT, entry_foodid INT, entry_portion INT, entry_timestamp INT)');
	});

	var dataStr = "SELECT * FROM foodentries LEFT JOIN fooditems ON foodentries.entry_foodid = fooditems.food_id";
	var foundItems = new Array();
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr);
		foundItems = rs.rows;
	});

	console.log("Found " + foundItems.length);

	// initialize return array
	var foodItemArray = new Array();

	// iterate through all found food items
	for ( var index = 0; index < foundItems.length; index++) {
		console.log("# Found image " + foundItems.item(index).entry_filename + " with food id " + foundItems.item(index).entry_foodid + " and description " + foundItems.item(index).food_description);

		// initialize new food item
		var foodItem = new FoodItem();

		// fill item data
		foodItem.imageFile = foundItems.item(index).entry_filename;
		foodItem.description = foundItems.item(index).entry_description;
		foodItem.portionSize = foundItems.item(index).entry_portion;
		foodItem.calories = foundItems.item(index).entry_calories;
		foodItem.timestamp = foundItems.item(index).entry_timestamp;
		foodItem.portionSize = foundItems.item(index).entry_portion;

		// store food item in return array
		foodItemArray[index] = foodItem;
	}

	// return found items
	return foodItemArray;
};

// adds the given entry data into the SQL database
// the entry data needs to be of type FoodItem()
// returns a boolean if the import has been done
EntryDatabase.prototype.addEntry = function(entryData) {
	console.log("# Adding item into the SQL db: " + entryData.description);

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS foodentries(entry_filename TEXT, entry_rating INT, entry_foodid INT, entry_portion INT, entry_timestamp INT)');
	});

	// either no import has been done yet or the imported data
	// is not up to date (maybe due to an update)
	var dataStr = "INSERT INTO foodentries(entry_filename, entry_rating, entry_foodid, entry_portion, entry_timestamp) VALUES (?, ?, ?, ?, ?)";

	// calculate current timestamp (unix epoch in seconds)
	var currentTimestamp = Math.round(new Date().getTime() / 1000);

	// fill data array
	var data = new Array();
	data = [ entryData.imageFile, entryData.healthRating, entryData.id, entryData.portionSize, currentTimestamp ];

	// note start we start the transaction first
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
};

// reset the database
// this resets the contents of the database by removing all items
EntryDatabase.prototype.resetDatabase = function() {
	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE foodentries');
	});

	return true;
};
