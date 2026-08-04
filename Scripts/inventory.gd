class_name INVENTORY
extends RefCounted

class InventorySlot:
	extends  RefCounted
	var key: String
	var count: int

	func _init(k: String, c: int):
		key = k
		count = c

static var _inventories :Dictionary = {}

static func create_inventory(body: Node) -> void:
	_inventories[body] = []

static func get_inventory(body: Node) -> Array:
	return _inventories[body]

# -----------------------------------------------------------------

static func add_item(body: Node, key: String, count:= 1) -> void:
	if !_inventories.has(body):
		printerr("Inventory does not exist for ", body)
		return
	if count <= 0:
		printerr("Cannot add %d amount of item to inventory!" % count)
		return
	key = key.to_lower()
	if !ITEMS.contents.has(key):
		printerr("Item %s does not exist!" % key)
		return
	
	# INCREMENT EXISTING ITEM
	var inventory :Array[InventorySlot] = _inventories[body]
	var item :Dictionary = ITEMS.contents[key]
	for i in range(inventory.size()):
		if inventory[i].key == key:
			var space :int = item["max"] - inventory[i].count
			var added :int = min(space, count)
			
			inventory[i].count += added
			count -= added
			
			if count == 0:
				return
	
	while count > 0:
		var count_min :int = min(count, ITEMS.contents[key]["max"])
		inventory.append(InventorySlot.new(key, count_min))
		count -= count_min

static func get_inventory_item(body: Node, index: int) -> InventorySlot:
	return _inventories[body][index]
