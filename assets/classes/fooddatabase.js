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

// check the database state
// this takes an array of food items, loaded from the database json file,
// and checks it against the current contents of the SQL database to make sure
// that the items have been imported correctly.
// parameter is an array based on a DataSource import
// returns a boolean if the import is correct
FoodDatabase.prototype.checkDatabaseState = function(foodData) {
	// console.log("# Checking database state");

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

	// check if the number of items in the SQL database is equal to the JSON
	// data. if so, the import is correct
	if ((numItemsInSQLDB > 0) || (numItemsInSQLDB == numItemsInJSONDB)) {
		return true;
	}

	// default return is false
	// if in doubt, reimport
	return false;
};

// imports the given JSON database into the SQL database
// this takes an array of food items, loaded from the database json file,
// and imports it into the SQL database.
// first parameter is an array based on a DataSource import
// returns a boolean if the import has been done
FoodDatabase.prototype.importDatabase = function(foodData, importProgress) {
	// console.log("# Importing items into the SQL db");

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(food_id INT, food_description TEXT, food_portion TEXT, food_calories INT, food_favorite INT, food_usergen INT)');
	});

	// set import progress state to active
	importProgress.state = 0;

	// set to and from values for the next batch
	// this makes sure that only 500 items max are imported
	// per batch
	importProgress.toValue = foodData.food.length;
	var currentFromValue = importProgress.currentIndex;
	var currentToValue = importProgress.currentIndex + 500;
	if (currentToValue > foodData.food.length) {
		currentToValue = foodData.food.length;
	}

	// either no import has been done yet or the imported data
	// is not up to date (maybe due to an update)
	// iterate through all food items and import them
	for ( var index = currentFromValue; index < currentToValue; index++) {
		var dataStr = "INSERT INTO fooditems(food_id, food_description, food_portion, food_calories, food_favorite, food_usergen) VALUES (?, ?, ?, ?, 0, 0)";
		var data = [ index, foodData.food[index].description, foodData.food[index].portion, foodData.food[index].kcal ];

		db.transaction(function(tx) {
			var rs = tx.executeSql(dataStr, data);
		});
	}

	importProgress.value = currentToValue;
	console.log("#Value: " + importProgress.value);

	// get updated number of items in SQL database again
	var numItemsInSQLDB = 0;
	var dataStr = "SELECT COUNT(food_id) as foods FROM fooditems WHERE food_usergen = 0";
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr);
		numItemsInSQLDB = rs.rows.item(0).foods;
	});

	// console.log("# Imported " + numItemsInSQLDB + " items in SQL db (" +
	// foodData.food.length + " items in JSON)");

	// set current index in progress bar component
	// this will be used as index how many items / batches have been imported
	importProgress.currentIndex = currentToValue;

	// if the import is finished, set the state of the component
	// to complete (ProgressIndicatorState.Complete = 2), otherwise
	// set it to pause (ProgressIndicatorState.Pause = 4)
	if (currentToValue != foodData.food.length) {
		importProgress.state = 2;
	} else {
		importProgress.state = 4;

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
