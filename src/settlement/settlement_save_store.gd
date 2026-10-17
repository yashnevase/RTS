extends RefCounted

## Small versioned JSON persistence adapter for the M3 settlement prototype.

const DEFAULT_PATH := "user://saves/m3_settlement.json"


static func save_simulation(simulation: RefCounted, path: String = DEFAULT_PATH) -> Dictionary:
	var directory_path := ProjectSettings.globalize_path(path.get_base_dir())
	var directory_error := DirAccess.make_dir_recursive_absolute(directory_path)
	if directory_error != OK:
		return {"ok": false, "message": "Could not create save folder (%s)." % error_string(directory_error)}
	var temporary_path := path + ".tmp"
	var temporary_global := ProjectSettings.globalize_path(temporary_path)
	var destination_global := ProjectSettings.globalize_path(path)
	var backup_global := destination_global + ".bak"
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		return {"ok": false, "message": "Could not open save file (%s)." % error_string(FileAccess.get_open_error())}
	file.store_string(JSON.stringify(simulation.to_save_data(), "\t"))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		DirAccess.remove_absolute(temporary_global)
		return {"ok": false, "message": "Could not write save file (%s)." % error_string(write_error)}
	if FileAccess.file_exists(path):
		if FileAccess.file_exists(backup_global):
			DirAccess.remove_absolute(backup_global)
		var backup_error := DirAccess.rename_absolute(destination_global, backup_global)
		if backup_error != OK:
			DirAccess.remove_absolute(temporary_global)
			return {"ok": false, "message": "Could not protect the previous save (%s)." % error_string(backup_error)}
		var replace_error := DirAccess.rename_absolute(temporary_global, destination_global)
		if replace_error != OK:
			DirAccess.rename_absolute(backup_global, destination_global)
			DirAccess.remove_absolute(temporary_global)
			return {"ok": false, "message": "Could not replace the previous save (%s)." % error_string(replace_error)}
		DirAccess.remove_absolute(backup_global)
	else:
		var rename_error := DirAccess.rename_absolute(temporary_global, destination_global)
		if rename_error != OK:
			DirAccess.remove_absolute(temporary_global)
			return {"ok": false, "message": "Could not finalize the save (%s)." % error_string(rename_error)}
	return {"ok": true, "message": "Settlement saved."}


static func load_simulation(simulation: RefCounted, path: String = DEFAULT_PATH) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"ok": false, "message": "No saved settlement was found."}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"ok": false, "message": "Could not read save file (%s)." % error_string(FileAccess.get_open_error())}
	var content := file.get_as_text()
	file.close()
	var parsed := JSON.new()
	var parse_error := parsed.parse(content)
	if parse_error != OK:
		return {"ok": false, "message": "Save file is not valid JSON at line %d." % parsed.get_error_line()}
	if not simulation.load_save_data(parsed.data):
		return {"ok": false, "message": simulation.last_error}
	return {"ok": true, "message": "Settlement loaded."}
