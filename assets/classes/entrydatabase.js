// *************************************************** //
// Entry Database Script
//
// This script handles the calls to the entries database.
// The general configuration data will be stored in the
// local app database (table: foodentries).
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

	// initialize database table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS foodentries(entry_filename TEXT, entry_foodid INT, entry_size INT, entry_rating INT, entry_timestamp INT)');
	});

	// initialize database table
	db.transaction(function(tx) {
		// TODO: Change to item_ prefix (eg. item_foodid, ..)
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(item_foodid INT, item_description TEXT, item_portion TEXT, item_calories INT, item_bookmark INT, item_usergen INT)');
	});

	// get food items
	var sqlQuery = "SELECT * FROM foodentries LEFT JOIN fooditems ON foodentries.entry_foodid = fooditems.item_foodid ORDER BY foodentries.entry_timestamp ASC";
	var foundItems = new Array();
	db.transaction(function(tx) {
		var rs = tx.executeSql(sqlQuery);
		foundItems = rs.rows;
	});

	// initialize return array
	var foodItemArray = new Array();

	// iterate through all found food items
	for ( var index = 0; index < foundItems.length; index++) {
		console.log("# Found image " + foundItems.item(index).entry_filename + " with food id " + foundItems.item(index).entry_foodid + ", description " + foundItems.item(index).item_description + " and timestamp " + foundItems.item(index).entry_timestamp);

		// initialize new food item
		var foodItem = new FoodItem();

		// fill item data
		foodItem.imageFile = foundItems.item(index).entry_filename;
		foodItem.rating = foundItems.item(index).entry_rating;
		foodItem.size = foundItems.item(index).entry_size;
		foodItem.timestamp = foundItems.item(index).entry_timestamp;
		foodItem.description = foundItems.item(index).item_description;
		foodItem.calories = foundItems.item(index).item_calories;
		foodItem.portion = foundItems.item(index).item_portion;

		// convert timestamp to reguar date
		var date = new Date(foodItem.timestamp * 1000);
		// foodItem.date = new Date(foodItem.timestamp * 1000);
		foodItem.date = date.getFullYear() + "/" + (date.getMonth()+1) + "/" + date.getDate();

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
	console.log("# Adding item into the SQL db: " + entryData.imageFile + ", " + entryData.rating + ", " + entryData.foodid + ", " + entryData.size);

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS foodentries(entry_filename TEXT, entry_foodid INT, entry_size INT, entry_rating INT, entry_timestamp INT)');
	});

	// either no import has been done yet or the imported data
	// is not up to date (maybe due to an update)
	var sqlQuery = "INSERT INTO foodentries(entry_filename, entry_foodid, entry_size, entry_rating, entry_timestamp) VALUES (?, ?, ?, ?, ?)";

	// calculate current timestamp (unix epoch in seconds)
	var currentTimestamp = Math.round(new Date().getTime() / 1000);

	// fill data array
	var data = new Array();
	data = [ entryData.imageFile, entryData.foodid, entryData.size, entryData.rating, currentTimestamp ];

	// note start we start the transaction first
	db.transaction(function(tx) {
		tx.executeSql(sqlQuery, data);
	});

	return true;
};

// delete an entry from the database
// note that the entry database does not have an id
// instead the timestamp is used as primary key
EntryDatabase.prototype.deleteEntry = function(entryTimestamp) {
	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS foodentries(entry_filename TEXT, entry_foodid INT, entry_size INT, entry_rating INT, entry_timestamp INT)');
	});

	var sqlQuery = "DELETE FROM foodentries WHERE entry_timestamp = ?";

	// fill data array
	var data = new Array();
	data = [ entryTimestamp ];

	// note start we start the transaction first
	db.transaction(function(tx) {
		tx.executeSql(sqlQuery, data);
	});

	return true;
};

// reset the database
// this resets the contents of the database by removing all items
EntryDatabase.prototype.resetDatabase = function() {
	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// drop the database table
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE foodentries');
	});

	return true;
};
