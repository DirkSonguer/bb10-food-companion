// *************************************************** //
// Item Database Script
//
// This script handles the calls to the food ite database.
// Note that the class uses the FoodItem() structure.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

//include other scripts used here
Qt.include(dirPaths.assetPath + "structures/fooditem.js");

// singleton instance of class
var itemdb = new ItemDatabase();

// class function that gets the prototype methods
function ItemDatabase() {
}

// search the database
// parameter is the search query used
// return value is an array of type FoodItem()
ItemDatabase.prototype.searchDatabase = function(searchQuery) {
	// console.log("# Searching database for " + searchQuery);

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(item_foodid INT, item_description TEXT, item_portion TEXT, item_calories INT, item_bookmark INT, item_usergen INT)');
	});

	// get number of items in SQL database based on the search term
	// split search terms based on space
	var searchArray = new Array();
	searchArray = searchQuery.split(" ");

	// define query and data arrays
	var sqlQuery = "SELECT * FROM fooditems WHERE ";
	var sqlData = new Array();

	// iterate through all search terms
	for ( var index = 0; index < searchArray.length; index++) {
		if (searchArray[index].length > 0) {
			sqlQuery += "(item_description LIKE ?) AND ";
			sqlData.push("%" + searchArray[index] + "%");
		}
	}

	// remove trailing "AND"
	sqlQuery = sqlQuery.substring(0, (sqlQuery.length - 4));

	// sort so that the faved items are on top and then alphabetical
	sqlQuery += "ORDER BY item_bookmark ASC, item_description DESC";

	// execute statement and store found items
	var foundItems = new Array();
	db.transaction(function(tx) {
		var rs = tx.executeSql(sqlQuery, sqlData);
		foundItems = rs.rows;
	});

	// initialize return array
	var foodItemArray = new Array();

	// iterate through all found food items
	for ( var index = 0; index < foundItems.length; index++) {
		// console.log("# Found " + foundItems.item(index).item_description + ",
		// " + foundItems.item(index).item_portion);

		// initialize new food item
		var foodItem = new FoodItem();

		// fill item data
		foodItem.foodid = foundItems.item(index).item_foodid;
		foodItem.description = foundItems.item(index).item_description;
		foodItem.portion = foundItems.item(index).item_portion;
		foodItem.calories = foundItems.item(index).item_calories;
		foodItem.bookmark = foundItems.item(index).item_bookmark;

		// store food item in return array
		foodItemArray[index] = foodItem;
	}

	// return found items
	return foodItemArray;
};

// update the bookmark state of the given item
// this resets the contents of the database by removing all items
// first parameter is an array based on a DataSource import
// returns a boolean if the import has been done
ItemDatabase.prototype.updateBookmarkState = function(foodData) {
	console.log("# Updating bookmark state of food item " + foodData.foodid + " to value " + foodData.bookmark);

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(item_foodid INT, item_description TEXT, item_portion TEXT, item_calories INT, item_bookmark INT, item_usergen INT)');
	});

	// update respective food item
	var sqlQuery = "UPDATE fooditems SET item_bookmark = ? WHERE item_foodid = ?";
	var sqlData = [ foodData.bookmark, foodData.foodid ];
	db.transaction(function(tx) {
		tx.executeSql(sqlQuery, sqlData);
	});

	return true;
};

// add a given item to the database
// first parameter is an array of type FoodItem()
// returns a boolean if the import has been done
ItemDatabase.prototype.addItem = function(foodData) {
	console.log("# Adding food item " + foodData.description + " with portion " + foodData.portion + " and " + foodData.calories + " calories");

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(item_foodid INT, item_description TEXT, item_portion TEXT, item_calories INT, item_bookmark INT, item_usergen INT)');
	});

	// update respective food item
	var sqlQuery = "INSERT INTO fooditems(item_foodid, item_description, item_portion, item_calories, item_bookmark, item_usergen) VALUES (?, ?, ?, ?, ?, ?)";
	var sqlData = [ foodData.foodid, foodData.description, foodData.portion, foodData.calories, foodData.bookmark, foodData.usergen ];
	db.transaction(function(tx) {
		tx.executeSql(sqlQuery, sqlData);
	});

	return true;
};

// check the database state
// this takes an array of food items, loaded from the database json file,
// and checks it against the current contents of the SQL database to make sure
// that the items have been imported correctly.
// parameter is an array based on a DataSource import
// returns a boolean if the import is correct
ItemDatabase.prototype.checkDatabaseState = function(jsonData) {
	// console.log("# Checking database state");

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(item_foodid INT, item_description TEXT, item_portion TEXT, item_calories INT, item_bookmark INT, item_usergen INT)');
	});

	// get number of items in JSON database
	var numItemsInJSONDB = jsonData.food.length;

	// get number of items in SQL database
	var numItemsInSQLDB = 0;
	var sqlQuery = "SELECT COUNT(item_foodid) as foods FROM fooditems WHERE item_usergen = 0";
	db.transaction(function(tx) {
		var rs = tx.executeSql(sqlQuery);
		numItemsInSQLDB = rs.rows.item(0).foods;
	});

	// check if the number of items in the SQL database is equal to the JSON
	// data. if so, the import is correct
	if ((numItemsInSQLDB > 0) || (numItemsInSQLDB == numItemsInJSONDB)) {
		return true;
	}

	// default return is false, if in doubt, reimport
	return false;
};

// imports the given JSON database into the SQL database
// this takes an array of food items, loaded from the database json file,
// and imports it into the SQL database.
// first parameter is an array based on a DataSource import
// returns a boolean if the import has been done
ItemDatabase.prototype.importDatabase = function(jsonData, importProgress) {
	// console.log("# Importing items into the SQL db");

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize food db table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS fooditems(item_foodid INT, item_description TEXT, item_portion TEXT, item_calories INT, item_bookmark INT, item_usergen INT)');
	});

	// set import progress state to active
	importProgress.state = 0;

	// set to and from values for the next batch
	// this makes sure that only 500 items max are imported
	// per batch
	importProgress.toValue = jsonData.food.length;
	var currentFromValue = importProgress.currentIndex;
	var currentToValue = importProgress.currentIndex + 500;
	if (currentToValue > jsonData.food.length) {
		currentToValue = jsonData.food.length;
	}

	// either no import has been done yet or the imported data
	// is not up to date (maybe due to an update)
	var sqlQuery = "INSERT INTO fooditems(item_foodid, item_description, item_portion, item_calories, item_bookmark, item_usergen) VALUES (?, ?, ?, ?, 0, 0)";
	var sqlData = new Array();

	// note start we start the transaction first
	db.transaction(function(tx) {
		// iterate through all food items and add the data to the transaction
		for ( var index = currentFromValue; index < currentToValue; index++) {
			sqlData = [ index, jsonData.food[index].description, jsonData.food[index].portion, jsonData.food[index].kcal ];
			tx.executeSql(sqlQuery, sqlData);
		}
	});

	// store current index value in calling component
	importProgress.value = currentToValue;

	// set current index in progress bar component
	// this will be used as index how many items / batches have been imported
	importProgress.currentIndex = currentToValue;

	// if the import is finished, set the state of the component
	// to complete (ProgressIndicatorState.Complete = 2), otherwise
	// set it to pause (ProgressIndicatorState.Pause = 4)
	if (currentToValue != jsonData.food.length) {
		importProgress.state = 2;
	} else {
		importProgress.state = 4;

	}

	return true;
};

// reset the database
// this resets the contents of the database by removing all items
ItemDatabase.prototype.resetDatabase = function() {
	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// drop the database table
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE fooditems');
	});

	return true;
};
