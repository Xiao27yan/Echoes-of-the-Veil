extends CanvasLayer


var hearts :Array[Control] = []


func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			#刚开始加载的时候先不显示 要根据人物hp具体显示
			child.visible = false
	pass
#更新所有心
func update_hp(_hp:int,_max_hp:int)->void:
#	先新一下显示多少颗心
		update_max_hp(_max_hp)
		for i in _max_hp:
			#然后再对每颗心看血量
			update_heart(i,_hp)
			pass
		pass
#更新单个心
func update_heart(_index:int,_hp :int)->void:
	var _value: int = clampi(_hp - _index*2,0,2)
	hearts[_index].value = _value
	pass
		
#	决定显示多少心
func update_max_hp(_max_hp:int)->void:
	var _heart_count:int = roundi(_max_hp*0.5)
	for i in hearts.size():
		if i< _heart_count:
			hearts[i].visible =true
		else:
			hearts[i].visible  =false
	pass
