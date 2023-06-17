extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var drama_reader = DramaReader.new()
	
	drama_reader.load_gdrama("res://resources/example.gdrama")
	
	var line = drama_reader.next_line()
	while line["type"] != "END":
		if line["type"] == "CHOICE":
			drama_reader.make_choice(0)
		line = drama_reader.next_line()
	pass
	
	drama_reader.save_json("res://resources/transpiled.json")
