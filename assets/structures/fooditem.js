// *************************************************** //
// Food Item Data Structure
//
// This structure holds data for a food item.
// Note that this struccture represents a food item
// stored in fooditem database.
//
// Author: Dirk Songuer
// License: GPL v2
// See: http://choosealicense.com/licenses/gpl-v2/
// *************************************************** //

// data structure for Instagram media
function FoodItem() {
	// food database id
	// note that this is the primary field for the fooditem table
	this.foodid = 0;

	// description for the food item
	this.description = "";

	// portion information for the food item
	this.portion = "";

	// calories this food has per portion
	this.calories = 0;

	// flag if user has bookmarked the item
	this.bookmark = 0;

	// flag if item is user generated
	this.usergen = 0;
}
