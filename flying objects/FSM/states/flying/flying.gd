extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################
var rot_speed
var sprite
var n
var caught = false

##################################################################################
#########                       Getters and Setters                      #########
##################################################################################
#you will want to use those
func getFSM(): return fsm; #defined in parent class
func getLogicRoot(): return logicRoot; #defined in parent class 

##################################################################################
#########                 Implement those below ancestor                 #########
##################################################################################
#you can transmit parameters if fsm is initialized manually
func stateInit(inParam1=null,inParam2=null,inParam3=null,inParam4=null, inParam5=null): 
	pass

#when entering state, usually you will want to reset internal state here somehow
func enter(fromStateID=null, fromTransitionID=null, inArg0=null,inArg1=null, inArg2=null):
	rot_speed = rand_range(-8,8)
	sprite = getFSM().getState().get_node("n/Sprite")
	n = getFSM().getState().get_node("n")

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	sprite.set_rot(sprite.get_rot() + rot_speed * deltaTime)
	logicRoot.velocity += global.gravity * deltaTime
	var motion = logicRoot.velocity * deltaTime
	n.set_pos(n.get_pos() + motion)
	logicRoot.vis_pos = n.get_pos()

#when exiting state
func exit(toState=null):
	pass

##################################################################################
#########                       Connected Signals                        #########
##################################################################################
func _on_Area2D_area_enter( area ):
	if area.is_in_group("player"):
		# i shuldn't do this...
		if area.get_parent().carry_items == 0: # more than 1?
			area.get_parent().carry_items += 1
			caught = true
	
##################################################################################
#########     Methods fired because of events (usually via Groups interface)  ####
##################################################################################

##################################################################################
#########                         Public Methods                         #########
##################################################################################

##################################################################################
#########                         Inner Methods                          #########
##################################################################################

##################################################################################
#########                         Inner Classes                          #########
##################################################################################



