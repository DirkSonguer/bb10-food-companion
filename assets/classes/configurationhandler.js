// *************************************************** //
// Configuration handler Script
//
// This script handles the configuration management for
// the application.
// The general configuration data will be stored in the
// local app database (table: configurationdata).
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// singleton instance of class
var conf = new ConfigurationHandler();

// class function that gets the prototype methods
function ConfigurationHandler() {
}

// This reads out the current configuration
// It can either be the configuration array if successful
// or it can contain an error with respective message
ConfigurationHandler.prototype.getConfiguration = function(configurationKey) {
	// console.log("# Getting configuration");

	// found configuration
	var configurationData = new Array();

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize database table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS configurationdata(key TEXT, value TEXT)');
	});

	// get configuration
	var dataStr = "SELECT * FROM configurationdata WHERE key = ?";
	var data = [ configurationKey ];
	db.transaction(function(tx) {
		var rs = tx.executeSql(dataStr, data);
		if (rs.rows.length > 0) {
			configurationData = rs.rows.item(0);
		}
	});

	return configurationData;
};

// This stores the given configuration
// It can either be the configuration array if successful
// or it can contain an error with respective message
ConfigurationHandler.prototype.setConfiguration = function(configurationKey, configurationValue) {
	// console.log("# Storing configuration);

	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// initialize database table
	db.transaction(function(tx) {
		tx.executeSql('CREATE TABLE IF NOT EXISTS configurationdata(key TEXT, value TEXT)');
	});

	// store configuration
	var dataStr = "INSERT INTO configurationdata VALUES(?, ?)";
	var data = [ configurationKey, configurationValue ];
	db.transaction(function(tx) {
		tx.executeSql(dataStr, data);
	});

	return true;
};

// Resets the current configuration to empty values
ConfigurationHandler.prototype.resetConfiguration = function() {
	// initialize db connection
	var db = openDatabaseSync("FoodCompanion", "1.0", "Food Companion persistent data storage", 1);

	// drop the database table
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE configurationdata');
	});

	return true;
};
