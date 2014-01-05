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

// singleton instance of class
var fooddb = new FoodDatabase();

// class function that gets the prototype methods
function FoodDatabase() {
}

// initialize the database
// this takes an array of food items, loaded from the database json file.
// it makes sure that the items have been imported to the SQL database.
// Parameter is an array based on a DataSource import
FoodDatabase.prototype.initDatabase = function(foodData) {
	console.log("# Initializing database");

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(food_id INT, food_description TEXT, food_portion TEXT, food_calories INT, food_fav INT, food_usergen INT)');
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
			var dataStr = "INSERT INTO fooditems(food_id, food_description, food_portion, food_calories, food_fav, food_usergen) VALUES (?, ?, ?, ?, 0, 0)";
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
