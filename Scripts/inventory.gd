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
	var inventory: Array[InventorySlot] = []
	_inventories[body] = inventory

static func get_inventory(body: Node) -> Array:
	return _inventories[body]

# -----------------------------------------------------------------

static func add_item(body: Node, key: String, count:= 1) -> void:
	assert(_inventories.has(body), "Inventory does not exist for %s" % body)
	assert(count > 0, "%d is an invalid number!" % count)
	key = key.to_lower()
	assert(ITEMS.contents.has(key), "Item %s does not exist!" % body)
	
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

static func consume_item(body: Node, key: String, count:= 1) -> void:
	assert(_inventories.has(body), "Inventory does not exist for %s" % body)
	assert(count > 0, "%d is an invalid number!" % count)
	key = key.to_lower()
	assert(ITEMS.contents.has(key), "Item %s does not exist!" % body)
	
	# DECREMENT AND REMOVE ITEMS IF NEEDED
	var inventory :Array[InventorySlot] = _inventories[body]
	for i in range(inventory.size()-1, -1, -1):
		if inventory[i].key == key:
			if inventory[i].count <= count:
				count -= inventory[i].count
				inventory.remove_at(i)
				if count <= 0:
					return
				continue
			else:
				inventory[i].count -= count
				return
	
	if count > 0:
		printerr("Items removed. Couldn't remove %d more items." % key)
		return
	printerr("Inventory does not contain item %s." % key)

static func has_item(body: Node, key: String) -> int:
	assert(_inventories.has(body), "Inventory does not exist for %s" % body)
	key = key.to_lower()
	assert(ITEMS.contents.has(key), "Item %s does not exist!" % body)
	
	var inventory :Array[InventorySlot] = _inventories[body]
	for i in range(inventory.size()):
		if inventory[i].key == key:
			return true
	
	return false

static func has_item_amount(body: Node, key: String, count:= 1) -> bool:
	assert(_inventories.has(body), "Inventory does not exist for %s" % body)
	assert(count > 0, "%d is an invalid number!" % count)
	key = key.to_lower()
	assert(ITEMS.contents.has(key), "Item %s does not exist!" % body)
	
	var inv_count := 0
	var inventory :Array[InventorySlot] = _inventories[body]
	for i in range(inventory.size()):
		if inventory[i].key == key:
			inv_count += inventory[i].count
			if inv_count >= count:
				return true
	
	return false

static func get_item(body: Node, index: int) -> InventorySlot:
	return _inventories[body][index]

static func get_item_amount(body: Node, key: String) -> int:
	assert(_inventories.has(body), "Inventory does not exist for %s" % body)
	key = key.to_lower()
	assert(ITEMS.contents.has(key), "Item %s does not exist!" % body)
	
	var inv_count := 0
	var inventory :Array[InventorySlot] = _inventories[body]
	for i in range(inventory.size()):
		if inventory[i].key == key:
			inv_count += inventory[i].count
	
	return inv_count
