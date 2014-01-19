// *************************************************** //
// Food Item Data Structure
//
// This structure holds data for a food item.
// Note that this struccture represents a food item
// stored in fooditem database.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Instagram media
function FoodItem() {
	// food database id
	// note that this is the primary field for the fooditem table
	this.id = 0;

	// description for the food item
	this.description = "";

	// portion information for the food item
	this.portion = "";

	// calories this food has per portion
	this.calories = 0;

	// flag if user has favorited the item
	this.favorite = 0;

	// flag if item is user generated
	this.usergen = 0;
}
