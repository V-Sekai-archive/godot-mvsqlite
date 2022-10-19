extends Node

# SQLite module
# Variables
var item_list = [];

func _ready() -> void:
	# Create new gdsqlite instance
	var db = SQLite.new();

	# Open item database
	if (!open_database(db, "res://items.db")):
		print("Failed opening database.");
		return;

	# Get item list from db
	var pots = db.fetch_array("SELECT * FROM potion ORDER BY id ASC");
	if (pots == null or pots.is_empty()):
		return;

	for pot in pots:
		# Create new item from database
		var item = {
			'id': pot['id'],
			'name': pot['name'],
			'price': pot['price'],
			'heals': pot['heals']
		};

		# Add to item list
		item_list.append(item);

	# Print all item
	for i in item_list:
		print("Item ", i.id, " (", i.name, ") $", i.price, " +", i.heals, "hp");

func open_database(db : SQLite, path : String) -> bool:
	if (path.begins_with("res://")):
		# Open packed database
		var file = FileAccess.open(path, FileAccess.READ);
		if file == null:
			return false;
		var size = file.get_length();
		var buffers = file.get_buffer(size);
		return db.open_buffered(path, buffers, size);

	# Open database normally
	return db.open(path);
