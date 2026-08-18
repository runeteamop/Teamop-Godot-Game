extends Node3D

# On-ready variables for controlling leg movement
@onready var step_items_wrapper = $LegMarkerWrapper
@onready var player = $".."

@onready var legs: Dictionary = {
	is_moving_index = 0,
	# 0 -> No leg moving
	# 1 -> SW leg moving
	# 2 -> NW leg moving
	# 3 -> SE leg moving
	# 4 -> NE leg moving
	
	SW = {
		marker_current_target = $LegMarkerWrapper/LegSWTarget,
		marker_new_target = $LegMarkerWrapper/LegSWNewTarget,
		#is_moving = false
	},
	
	NW = {
		marker_current_target = $LegMarkerWrapper/LegNWTarget,
		marker_new_target = $LegMarkerWrapper/LegNWNewTarget,
		#is_moving = false
	},
	
	SE = {
		marker_current_target = $LegMarkerWrapper/LegSETarget,
		marker_new_target = $LegMarkerWrapper/LegSENewTarget,
		#is_moving = false
	},
	
	NE = {
		marker_current_target = $LegMarkerWrapper/LegNETarget,
		marker_new_target = $LegMarkerWrapper/LegNENewTarget,
		#is_moving = false
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Normal behavior for the legs when the spider is not dashing
	if !player.is_dashing:
		if player.velocity.length() > 0:
			step_items_wrapper.position = lerp(step_items_wrapper.position, player.velocity * .5, .2)
		else:
			step_items_wrapper.position = Vector3(0,0,0)
		
		#TODO:
		"""
		function to choose leg to move
		function for moving the leg
		should i make an object(/class?) to keep all the leg data inside it? - yes
		data for each leg:
			moving: bool
			3 variables to markers for target, pole, and newtarget
			(varible to connect to leg root node probably not needed)
		object should be in a seperate script to keep this script clean
		(or as clean as can be lol)
		"""
	"""
	if !dashing:
		move leg furthest from intended position
		can move leg if adjacent legs are not moving
		timer to wait to move leg again
	"""



# Functions for controlling leg movement
func choose_leg(legs: Dictionary) -> int:
	return 0

func find_lowest_distances(legs: Dictionary) -> Array:
	return []

# Okay, there needs to be an array that contains all the legs to loop through
# Maybe it's better to switch to gitea before I do this? IDK
# There's a lot of unknowns in this project right now...
