# @popochiu-docs-ignore-class
extends NineVerbCommands


# Override this to register additional commands.
# Note: any override must call `super()` to preserve base registration.
#func _init() -> void:
	#super()


# Override this to change the identifying name for this command set.
#static func get_script_name() -> String:
	#return "NineVerbCommands"


# Called when a registered command has no Callable defined.
# By default this calls `walk_to()`. Override to implement a different fallback behavior.
func fallback() -> void:
	super()


# Called when `E.current_command == Commands.WALK_TO` and `E.command_fallback()` is triggered.
func walk_to() -> void:
	super()


# Called when `E.current_command == Commands.OPEN` and `E.command_fallback()` is triggered.
func open() -> void:
	var lines := ["I don't think that opens. I've been wrong before, but not this time.", "It refuses to open. Relatable."]
	await C.player.say(lines.pick_random())


# Called when `E.current_command == Commands.PICK_UP` and `E.command_fallback()` is triggered.
func pick_up() -> void:
	var lines := ["My back says no.", "That's not mine. Also, it's heavy. Mostly the heavy part."]
	await C.player.say(lines.pick_random())


# Called when `E.current_command == Commands.PUSH` and `E.command_fallback()` is triggered.
func push() -> void:
	var lines := ["I pushed it. Spiritually.", "Nothing happened. Story of my life."]
	await C.player.say(lines.pick_random())


# Called when `E.current_command == Commands.CLOSE` and `E.command_fallback()` is triggered.
func close() -> void:
	var lines := ["It's about as closed as it's going to get.", "Closed. Like my chances of promotion."]
	await C.player.say(lines.pick_random())


# Called when `E.current_command == Commands.LOOK_AT` and `E.command_fallback()` is triggered.
func look_at() -> void:
	var lines := ["Yep. That's definitely a thing.", "I stared at it. It stared back. Nobody won."]
	await C.player.say(lines.pick_random())


# Called when `E.current_command == Commands.PULL` and `E.command_fallback()` is triggered.
func pull() -> void:
	var lines := ["I pull, it stays. We're at an impasse.", "I'm not pulling that. I have standards. Low ones, but still."]
	await C.player.say(lines.pick_random())


# Called when `E.current_command == Commands.GIVE` and `E.command_fallback()` is triggered.
func give() -> void:
	super()


# Called when `E.current_command == Commands.TALK_TO` and `E.command_fallback()` is triggered.
func talk_to() -> void:
	var lines := ["I'm not that lonely. Yet.", "It doesn't want to talk. Nobody on this ship does."]
	await C.player.say(lines.pick_random())


# Called when `E.current_command == Commands.USE` and `E.command_fallback()` is triggered.
func use() -> void:
	super()


# Called when the player uses an item on something that has no special reaction to it.
func use_item_on(_item: PopochiuInventoryItem, _target: Node) -> void:
	I.active = null
	await C.player.say(["That doesn't go there.", "Even I know that won't work."].pick_random())
