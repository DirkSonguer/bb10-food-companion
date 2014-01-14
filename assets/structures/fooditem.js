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
	this.id = 0;
	
	// image path and filename
	this.imageFile = "";

	// description for the food item
	this.description = "";

	// calories this food has
	this.calories = 0;
	
	// portion size
	// this is a factor whereby 1 represents
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
