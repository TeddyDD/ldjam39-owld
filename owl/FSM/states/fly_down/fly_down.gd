extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################

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
	logicRoot.velocity = Vector2()
	logicRoot.get_node("anim").play("fly")

#when updating state, paramx can be used only if updating fsm manually
func update(delta, param0=null, param1=null, param2=null, param3=null, param4=null):
	logicRoot.hp -= logicRoot.hp_passive * delta
	logicRoot.sideways_movement(delta)
	var motion = logicRoot.velocity * delta
	logicRoot.move(motion)
	
	# random wind
	if randi() % 5 > 1:
		logicRoot.velocity += Vector2(50,50) * delta
	
	
	if (logicRoot.is_colliding()):
		var n = logicRoot.get_collision_normal()
		logicRoot.last_collision = n
#		get_node("debug").set_text("%s" % rad2deg(n.floor().angle()))
		motion = n.slide(motion)
		logicRoot.velocity = n.slide(logicRoot.velocity)
		logicRoot.move(motion)
	else:
		logicRoot.last_collision = null

#when exiting state
func exit(toState=null):
	pass

##################################################################################
#########                       Connected Signals                        #########
##################################################################################

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
