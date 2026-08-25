extends ProgressBar


@onready var actor: Actor = $"../../.."





func _ready():
	max_value = actor.max_hp
	value = actor.hp
	visible = false
	actor.enemy_damaged.connect(UpdateHp)
	

func UpdateHp(hurt_box:HurtBox):
	self.value = actor.hp
	visible = true
