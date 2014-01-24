// *************************************************** //
// Food Entry Data Structure
//
// This structure holds data for a food entry.
// Note that food entries refer to food items in the
// fooditem database.
// Also note that only photo and health rating are
// mandatory user created data. The timestamp is
// handled by the system.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Instagram media
function FoodEntry() {
	// creation timestamp
	// note that this is the primary field for the foodentry table
	this.timestamp = "";

	// image path and filename
	this.imageFile = "";

	// this is the health rating as integer
	// it maps against Copytext.healthValues
	this.rating = 2;

	// portion size
	// this is a factor from 0 to 2 whereby 1 represents the normal portion size
	this.size = 1;

	// id of the food item
	this.foodid = "";

	// description for the food item
	// note that this will be left joined from the fooditem table
	this.description = "";

	// portion information for the food item
	// note that this will be left joined from the fooditem table
	this.portion = "";

	// calories this food has according to the portion size
	// note that this will be left joined from the fooditem table
	this.calories = 0;
}
