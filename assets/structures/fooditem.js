// *************************************************** //
// Food Item Data Structure
//
// This structure holds data for a food item.
// Note that only photo and health rating are
// mandatory user created data. The timestamp is
// handled by the system.
//
// Author: Dirk Songuer
// License: All rights reserved
// *************************************************** //

// data structure for Instagram media
function FoodItem() {
	// food database id
	// note that this is always the id of the food item
	// no the id in the user entry table
	this.id = 0;
	
	// image path and filename
	this.imageFile = "asset:///images/header_background.png";

	// description for the food item
	this.description = "";

	// portion for the food item
	this.portion = "";

	// calories this food has
	this.calories = 0;
	
	// portion size
	// this is a factor from 0 to 2 whereby 1 represents
	// the normal portion size
	this.portionSize = 1;

	// this is the health rating as integer
	// it maps against Copytext.foodcompanionHealthValues
	this.healthRating = 2;
	
	// flag if user has favorited the item
	this.favorite = 0;

	// creation timestamp
	this.timestamp = "";
}
