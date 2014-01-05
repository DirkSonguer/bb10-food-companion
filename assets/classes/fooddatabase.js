// *************************************************** //
// Food Database Script
//
// This script handles the calls to the food database.
// Note that it's a class that needs to be defined first:
// fooddb = new FoodDatabase();
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "structures/fooditem.js");

// singleton instance of class
var fooddb = new FoodDatabase();

// class function that gets the prototype methods
function FoodDatabase() {
}

// search the database
// parameter is the search query used
// return value is an array of type FoodItem()
FoodDatabase.prototype.searchDatabase = function(searchQuery) {
	console.log("# Searching database for " + searchQuery);

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(food_id INT, food_description TEXT, food_portion TEXT, food_calories INT, food_favorite INT, food_usergen INT)');
	});

	// get number of items in SQL database
	// based on the search term
	var dataStr = "SELECT * FROM fooditems WHERE food_description LIKE ? ORDER BY food_favorite DESC";
	var data = [ "%" + searchQuery + "%" ];
	var foundItems = new Array();
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr, data);
		foundItems = rs.rows;
	});

	console.log("Found " + foundItems.length + " items for term " + searchQuery);

	// initialize return array
	var foodItemArray = new Array();
	
	// iterate through all found food items
	for ( var index = 0; index < foundItems.length; index++) {
		console.log("# Found " + foundItems.item(index).food_description + ", " + foundItems.item(index).food_portion);

		// initialize new food item
		var foodItem = new FoodItem();

		// fill item data
		foodItem.description = foundItems.item(index).food_description;
		foodItem.portionSize = foundItems.item(index).food_portion;
		foodItem.calories = foundItems.item(index).food_calories;
		foodItem.favorite = foundItems.item(index).food_favorite;

		// store food item in return array
		foodItemArray[index] = foodItem;
	}

	// return found items
	return foodItemArray;
};

// initialize the database
// this takes an array of food items, loaded from the database json file.
// it makes sure that the items have been imported to the SQL database.
// parameter is an array based on a DataSource import
FoodDatabase.prototype.initDatabase = function(foodData) {
	console.log("# Initializing database");

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(food_id INT, food_description TEXT, food_portion TEXT, food_calories INT, food_favorite INT, food_usergen INT)');
	});

	// get number of items in JSON database
	var numItemsInJSONDB = foodData.food.length;

	// get number of items in SQL database
	var numItemsInSQLDB = 0;
	var dataStr = "SELECT COUNT(food_id) as foods FROM fooditems WHERE food_usergen = 0";
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr);
		numItemsInSQLDB = rs.rows.item(0).foods;
	});

	console.log("# Found " + numItemsInJSONDB + " items in JSON db and " + numItemsInSQLDB + " items in SQL db");
	if ((numItemsInSQLDB == 0) || (numItemsInSQLDB != numItemsInJSONDB)) {
		// either no import has been done yet or the imported data
		// is not up to date (maybe due to an update)
		// iterate through all food items and import them
		for ( var index in foodData.food) {
			var dataStr = "INSERT INTO fooditems(food_id, food_description, food_portion, food_calories, food_favorite, food_usergen) VALUES (?, ?, ?, ?, 0, 0)";
			var data = [ index, foodData.food[index].description, foodData.food[index].portion, foodData.food[index].kcal ];

			db.transaction(function(tx) {
				var rs = tx.executeSql(dataStr, data);
			});
		}

		// get updated number of items in SQL database again
		var numItemsInSQLDB = 0;
		var dataStr = "SELECT COUNT(food_id) as foods FROM fooditems WHERE food_usergen = 0";
		db.transaction(function(tx) {
			var rs = tx.executeSql(dataStr);
			numItemsInSQLDB = rs.rows.item(0).foods;
		});
		console.log("# Updated " + numItemsInJSONDB + " items in JSON db and " + numItemsInSQLDB + " items in SQL db");
	}

	return true;
};

// reset the database
// this resets the contents of the database by removing all items
FoodDatabase.prototype.resetDatabase = function() {
	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE fooditems');
	});

	return true;
};
