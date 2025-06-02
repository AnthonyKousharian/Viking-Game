extends Control

@onready var day_label: Label = %DayLabel

@onready var time_label: Label = %TimeLabel

var isNight: bool =  false
var timeIsAm: bool = false   

func set_daytime(day: int, hour: int, minute: int) -> void:
	day_label.text = "Day " + str(day + 1)
	time_label.text = _amfm_hour(hour) + ":" + _minute(minute) + " " + _am_pm(hour)
	
	timeIsAm = hour < 12
	
	update_is_night(hour, timeIsAm)
	
	

func _amfm_hour(hour:int) -> String:
	if hour == 0:
		return str(12)
	if hour > 12:
		return str(hour - 12)
	return str(hour)
	
func update_is_night(hour: int, timeIsAm: bool) -> void:
	if hour >= 19 or hour < 7:
		isNight = true
	else:
		isNight = false
	
func _minute(minute:int) -> String:
	if minute < 10:
		return "0" + str(minute)
	return str(minute)

func _am_pm(hour:int) -> String:
	if hour < 12:
		return "am"
	else:
		return "pm"

func _remap_rangef(input:float, minInput:float, maxInput:float, minOutput:float, maxOutput:float):
	return float(input - minInput) / float(maxInput - minInput) * float(maxOutput - minOutput) + minOutput
