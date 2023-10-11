extends Area2D
signal hit #This defines a custom signal called "hit" that we will have our player emit (send out) when it collides with an enemy

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size

#function we can call to reset the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	#First, we need to check for input
	#Click on Project -> Project Settings -> Input Map: Type "move_right" in the top bar and click the "Add" button to add the move_right action
	#We need to assign a key to this action. Click the "+" icon on the right, to open the event manager window
	#You can detect whether a key is pressed using Input.is_action_pressed(), which returns true if it's pressed or false if it isn't
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() # $AnimatedSprite2D.play() is the same as get_node("AnimatedSprite2D").play()
	else:
		$AnimatedSprite2D.stop() # "$" returns the node at the relative path from the current node, or returns null if the node is not found
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
