extends Control

export var bus_name_index="Music"
var bus_index : int =0
onready var h_slider = get_node("Panel_creditos/HSlider")
onready var value_label = get_node("Panel_creditos/vol_value")
onready var name_label = get_node("Panel_creditos/vol_value")

func _ready():
	h_slider.connect("value_changed",self,"on_value_change")
	set_name_label_txt()
	get_bus_name_by_index()
	set_slider_value()

func set_name_label_txt():
	name_label.text = bus_name_index + " volumen"

func get_bus_name_by_index():
	bus_index= AudioServer.get_bus_index(bus_name_index)

func set_audio_num_label_txt():
	
	value_label.text=str( int(h_slider.value * 100)) +"%"

func set_slider_value():
	h_slider.value = db2linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_num_label_txt()

func on_value_change(value):
	AudioServer.set_bus_volume_db(bus_index,linear2db(value))
	set_audio_num_label_txt()
