extends CanvasLayer

@onready var settings_menu_box: Sprite2D = $SettingsButton/SettingsMenuBox
@onready var settings_v_container: VBoxContainer = $SettingsButton/SettingsVContainer
@onready var main_scene = preload("res://Scenes/Farmland.tscn")
@onready var master_volume_slider: HSlider = $SettingsButton/SettingsVContainer/MasterVolumeSlider
@onready var sfx_volume_slider: HSlider = $SettingsButton/SettingsVContainer/SFXSlider
@onready var fps_limit_slider: HSlider = $SettingsButton/SettingsVContainer/FPSLimitSlider
var data

func _ready() -> void:
	#data dictionary
	data = {
		"master_volume": master_volume_slider.value,
		"sfx_volume": sfx_volume_slider.value,
	}
	
	#accesses the setting file so that it can turn it into settings
	var r = FileAccess.open("user://settings.dat", FileAccess.READ)
	
	if r == null:
		var f = FileAccess.open("user://settings.dat", FileAccess.WRITE)
		var json_string = JSON.stringify(data)
		f.store_string(JSON.stringify(data))
		f.close()
		r = FileAccess.open("user://settings.dat", FileAccess.READ)
		
	if r.get_as_text().length() > 0:
		_turn_text_into_settings(r.get_as_text())

	settings_menu_box.visible = false
	settings_v_container.visible = false

func _on_main_menu_button_pressed() -> void:
	pass


func _on_settings_button_pressed() -> void:
	settings_menu_box.visible = true
	settings_v_container.visible = true


func _on_option_button_item_selected(index: int) -> void:
	#fullscreen, windowed and bordeless depending on which button is pressed
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)

func _on_close_button_pressed() -> void:
	settings_menu_box.visible = false
	settings_v_container.visible = false
	
	#updates dictionary to values that were just changed, so that when we save we have them
	data = {
		"master_volume": master_volume_slider.value,
		"sfx_volume": sfx_volume_slider.value,
	}
	
	#overwrites previous settings with recently changed settings
	var f = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	var json_string = JSON.stringify(data)
	f.store_string(JSON.stringify(data))
	f.close()

func _turn_text_into_settings(inputText: String) -> void:
	var json = JSON.new()
	var error = json.parse(inputText)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			print(data_received) # Prints the array.
			for key in data.keys():
				data[key] = data_received.get(key)
			_update_data()
		else:
			print(data_received)
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", inputText, " at line ", json.get_error_line())

func _update_data() -> void:
	master_volume_slider.value = data["master_volume"]
	sfx_volume_slider.value = data["sfx_volume"]
