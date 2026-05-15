# label_helper.gd
extends RefCounted
class_name LabelHelper

# ============================================
# LABEL HELPER - Utility functions for Godot Labels
# ============================================

# Prevent instantiation
func _init(): ## Called when class is instantiated - prevents creating instances
	if not Engine.is_editor_hint():
		push_warning("LabelHelper is a static class - use LabelHelper.function_name() directly")

# ============================================
# TEXT SIZING & MEASUREMENT
# ============================================

static func get_text_size(label: Label) -> Vector2: ## Get the actual pixel size of text in a label
	if not label or label.text.is_empty():
		return Vector2.ZERO
	
	var font = label.get_theme_font("font")
	var font_size = label.get_theme_font_size("font_size")
	return font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

static func get_text_width(label: Label) -> float: ## Get text width in pixels
	return get_text_size(label).x

static func get_text_height(label: Label) -> float: ## Get text height in pixels
	return get_text_size(label).y

static func calculate_optimal_font_size(label: Label, max_width: float, max_height: float, min_size: int = 8, max_size: int = 72) -> int: ## Calculate optimal font size to fit within max_width and max_height
	var text = label.text
	var font = label.get_theme_font("font")
	
	if text.is_empty():
		return min_size
	
	var low = min_size
	var high = max_size
	var best_size = min_size
	
	while low <= high:
		var mid = (low + high) / 2
		var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, mid)
		
		if text_size.x <= max_width and text_size.y <= max_height:
			best_size = mid
			low = mid + 1
		else:
			high = mid - 1
	
	return best_size

static func auto_fit_text(label: Label, margin: float = 10.0) -> void: ## Auto-adjust font size to fit label bounds
	if label.size == Vector2.ZERO:
		return
	
	var max_width = label.size.x - margin
	var max_height = label.size.y - margin
	var new_size = calculate_optimal_font_size(label, max_width, max_height)
	label.add_theme_font_size_override("font_size", new_size)

static func fit_to_text(label: Label) -> void: ## Scale label to fit text exactly (removes extra padding)
	var text_size = get_text_size(label)
	label.size = text_size
	label.custom_minimum_size = text_size

static func set_size_with_padding(label: Label, padding: Vector2 = Vector2(10, 5)) -> void: ## Set label size to match text with padding
	var text_size = get_text_size(label)
	label.size = text_size + padding * 2
	label.custom_minimum_size = label.size

# ============================================
# POSITIONING & ALIGNMENT
# ============================================

static func center_in_parent(label: Label) -> void: ## Center label relative to its parent Control
	var parent = label.get_parent()
	if not parent:
		return
	
	if parent is Control:
		label.position = (parent.size - label.size) / 2
	elif parent is Node2D:
		push_warning("Center in parent works best with Control nodes. Use position_at_center() for Node2D")

static func position_at_sprite_center(label: Label, sprite: Sprite2D, offset: Vector2 = Vector2.ZERO) -> void: ## Position label at center of a sprite (label must be child of sprite)
	if not sprite:
		return
	
	var sprite_center = sprite.get_rect().size / 2
	label.position = sprite_center - (label.size / 2) + offset

static func position_above_sprite(label: Label, sprite: Sprite2D, offset_y: float = 10.0) -> void: ## Position label above a sprite (for health bars, names, etc.)
	if not sprite:
		return
	
	var sprite_top = -sprite.get_rect().size.y / 2
	label.position = Vector2(0, sprite_top - offset_y)
	label.position.x = -label.size.x / 2

static func position_below_sprite(label: Label, sprite: Sprite2D, offset_y: float = 10.0) -> void: ## Position label below a sprite
	if not sprite:
		return
	
	var sprite_bottom = sprite.get_rect().size.y / 2
	label.position = Vector2(0, sprite_bottom + offset_y)
	label.position.x = -label.size.x / 2

static func position_relative_to(label: Label, target: Label, offset: Vector2 = Vector2(10, 0), relative_pos: String = "right") -> void: ## Position label relative to another label
	match relative_pos:
		"right":
			label.global_position = target.global_position + Vector2(target.size.x + offset.x, offset.y)
		"left":
			label.global_position = target.global_position + Vector2(-label.size.x - offset.x, offset.y)
		"above":
			label.global_position = target.global_position + Vector2(offset.x, -label.size.y - offset.y)
		"below":
			label.global_position = target.global_position + Vector2(offset.x, target.size.y + offset.y)

enum ScreenCorner { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT }

static func align_to_screen_corner(label: Label, corner: ScreenCorner, margin: Vector2 = Vector2(10, 10)) -> void: ## Align label to screen corner
	var viewport = label.get_viewport()
	if not viewport:
		return
	
	var screen_size = viewport.get_visible_rect().size
	
	match corner:
		ScreenCorner.TOP_LEFT:
			label.global_position = margin
		ScreenCorner.TOP_RIGHT:
			label.global_position = Vector2(screen_size.x - label.size.x - margin.x, margin.y)
		ScreenCorner.BOTTOM_LEFT:
			label.global_position = Vector2(margin.x, screen_size.y - label.size.y - margin.y)
		ScreenCorner.BOTTOM_RIGHT:
			label.global_position = screen_size - label.size - margin

static func center_on_screen(label: Label) -> void: ## Center label on screen
	var viewport = label.get_viewport()
	if not viewport:
		return
	
	var screen_size = viewport.get_visible_rect().size
	label.global_position = (screen_size - label.size) / 2

# ============================================
# VISUAL STYLING
# ============================================

static func add_background(label: Label, color: Color, corner_radius: int = 3, padding: Vector2 = Vector2(5, 3)) -> void: ## Create a colored background for the label
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	
	label.add_theme_stylebox_override("normal", style)
	
	if padding != Vector2.ZERO:
		label.custom_minimum_size = Vector2(label.custom_minimum_size.x + padding.x * 2, 
											 label.custom_minimum_size.y + padding.y * 2)

static func add_border(label: Label, color: Color, width: int = 2, corner_radius: int = 3) -> void: ## Add border to label background
	var style = label.get_theme_stylebox("normal")
	if not style:
		style = StyleBoxFlat.new()
	
	if style is StyleBoxFlat:
		style.border_width_left = width
		style.border_width_right = width
		style.border_width_top = width
		style.border_width_bottom = width
		style.border_color = color
		style.corner_radius_top_left = corner_radius
		style.corner_radius_top_right = corner_radius
		style.corner_radius_bottom_left = corner_radius
		style.corner_radius_bottom_right = corner_radius
		
		label.add_theme_stylebox_override("normal", style)

static func add_text_outline(label: Label, color: Color, size: int = 1) -> void: ## Add outline to text
	label.add_theme_color_override("font_outline_modulate", color)
	label.add_theme_constant_override("outline_size", size)

static func set_text_color(label: Label, color: Color) -> void: ## Set text color
	label.add_theme_color_override("font_color", color)

static func set_font_size(label: Label, size: int) -> void: ## Set font size
	label.add_theme_font_size_override("font_size", size)

static func set_font(label: Label, font: Font) -> void: ## Set custom font
	label.add_theme_font_override("font", font)

static func make_health_style(label: Label, border_color: Color = Color.WHITE, bg_color: Color = Color(0, 0, 0, 0.7), text_color: Color = Color.WHITE) -> void: ## Create a health bar style label with border and background
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = bg_color
	bg_style.border_width_left = 2
	bg_style.border_width_right = 2
	bg_style.border_width_top = 2
	bg_style.border_width_bottom = 2
	bg_style.border_color = border_color
	bg_style.corner_radius_top_left = 5
	bg_style.corner_radius_top_right = 5
	bg_style.corner_radius_bottom_left = 5
	bg_style.corner_radius_bottom_right = 5
	
	label.add_theme_stylebox_override("normal", bg_style)
	label.add_theme_constant_override("outline_size", 1)
	label.add_theme_color_override("font_outline_modulate", Color.BLACK)
	label.add_theme_color_override("font_color", text_color)

static func make_damage_style(label: Label, size: int = 24) -> void: ## Create a damage number style (red with outline)
	set_font_size(label, size)
	set_text_color(label, Color.RED)
	add_text_outline(label, Color.BLACK, 2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

static func make_gold_style(label: Label, size: int = 20) -> void: ## Create a gold/coin style
	set_font_size(label, size)
	set_text_color(label, Color(1, 0.8, 0.2))
	add_text_outline(label, Color(0.5, 0.3, 0), 1)

# ============================================
# TEXT FORMATTING
# ============================================

static func format_number(value: int) -> String: ## Format numbers with K/M/B suffixes (e.g., 1.5K, 2.3M)
	if value >= 1_000_000_000:
		return str(value / 1_000_000_000.0).pad_decimals(1) + "B"
	elif value >= 1_000_000:
		return str(value / 1_000_000.0).pad_decimals(1) + "M"
	elif value >= 1_000:
		return str(value / 1_000.0).pad_decimals(1) + "K"
	else:
		return str(value)

static func format_leading_zeros(value: int, digits: int) -> String: ## Format with leading zeros (e.g., 005)
	return str(value).lpad(digits, "0")

static func format_percentage(value: float, decimal_places: int = 0) -> String: ## Format as percentage
	return str(value * 100).pad_decimals(decimal_places) + "%"

static func format_time(seconds: int) -> String: ## Format time as MM:SS
	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	return "%02d:%02d" % [minutes, remaining_seconds]

static func format_time_long(seconds: int) -> String: ## Format time as HH:MM:SS
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var remaining_seconds = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, remaining_seconds]

# ============================================
# UTILITY
# ============================================

static func copy_style(from_label: Label, to_label: Label) -> void: ## Copy all style properties from one label to another
	to_label.horizontal_alignment = from_label.horizontal_alignment
	to_label.vertical_alignment = from_label.vertical_alignment
	
	if from_label.get_theme_font_size("font_size"):
		to_label.add_theme_font_size_override("font_size", from_label.get_theme_font_size("font_size"))
	
	if from_label.get_theme_color("font_color"):
		to_label.add_theme_color_override("font_color", from_label.get_theme_color("font_color"))
	
	if from_label.get_theme_color("font_outline_modulate"):
		to_label.add_theme_color_override("font_outline_modulate", from_label.get_theme_color("font_outline_modulate"))
	
	if from_label.get_theme_stylebox("normal"):
		to_label.add_theme_stylebox_override("normal", from_label.get_theme_stylebox("normal"))
	
	if from_label.get_theme_constant("outline_size"):
		to_label.add_theme_constant_override("outline_size", from_label.get_theme_constant("outline_size"))

static func duplicate_label(label: Label, new_text: String = "") -> Label: ## Create a duplicate label with same properties
	var new_label = Label.new()
	copy_style(label, new_label)
	new_label.text = new_text if not new_text.is_empty() else label.text
	return new_label

static func wrap_text_to_width(label: Label, max_width: float) -> void: ## Wrap text to specific width
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.size.x = max_width

static func clear_overrides(label: Label) -> void: ## Clear all theme overrides (reset to default)
	label.remove_theme_font_override("font")
	label.remove_theme_font_size_override("font_size")
	label.remove_theme_color_override("font_color")
	label.remove_theme_color_override("font_outline_modulate")
	label.remove_theme_stylebox_override("normal")
	label.remove_theme_constant_override("outline_size")

# ============================================
# ANIMATIONS (Requires the label to be in scene tree)
# ============================================

static func fade_in(label: Label, duration: float = 0.5) -> void: ## Create a fade-in effect
	if not label.is_inside_tree():
		push_warning("Label not in scene tree, cannot animate")
		return
	
	var tween = label.create_tween()
	label.modulate.a = 0
	tween.tween_property(label, "modulate:a", 1.0, duration)

static func fade_out(label: Label, duration: float = 0.5, free_on_complete: bool = false) -> void: ## Create a fade-out effect
	if not label.is_inside_tree():
		push_warning("Label not in scene tree, cannot animate")
		return
	
	var tween = label.create_tween()
	tween.tween_property(label, "modulate:a", 0.0, duration)
	if free_on_complete:
		tween.tween_callback(label.queue_free)

static func pop_in(label: Label, duration: float = 0.3) -> void: ## Create a pop-in effect (scale up)
	if not label.is_inside_tree():
		push_warning("Label not in scene tree, cannot animate")
		return
	
	var tween = label.create_tween()
	label.scale = Vector2.ZERO
	tween.tween_property(label, "scale", Vector2.ONE, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

static func floating_damage_number(label: Label, start_pos: Vector2, end_offset: Vector2 = Vector2(0, -50), duration: float = 1.0) -> void: ## Create a floating damage number effect
	if not label.is_inside_tree():
		push_warning("Label not in scene tree, cannot animate")
		return
	
	label.global_position = start_pos
	var tween = label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "global_position", start_pos + end_offset, duration)
	tween.tween_property(label, "modulate:a", 0.0, duration)
	tween.tween_callback(label.queue_free)

static func pulse(label: Label, scale_amount: float = 1.2, duration: float = 0.5) -> void: ## Pulse animation (for important notifications)
	if not label.is_inside_tree():
		push_warning("Label not in scene tree, cannot animate")
		return
	
	var tween = label.create_tween()
	tween.set_loops()
	tween.tween_property(label, "scale", Vector2(scale_amount, scale_amount), duration / 2)
	tween.tween_property(label, "scale", Vector2.ONE, duration / 2)

static func shake(label: Label, intensity: float = 5.0, duration: float = 0.3) -> void: ## Shake animation
	if not label.is_inside_tree():
		push_warning("Label not in scene tree, cannot animate")
		return
	
	var original_pos = label.position
	var tween = label.create_tween()
	
	for i in range(5):
		var offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(label, "position", original_pos + offset, duration / 10)
	
	tween.tween_property(label, "position", original_pos, duration / 10)

static func typewriter(label: Label, duration: float = 1.0, on_complete: Callable = Callable()) -> void: ## Typewriter effect (reveals text one character at a time)
	if not label.is_inside_tree():
		push_warning("Label not in scene tree, cannot animate")
		return
	
	var full_text = label.text
	label.text = ""
	var character_duration = duration / full_text.length()
	
	for i in range(full_text.length()):
		await label.get_tree().create_timer(character_duration).timeout
		label.text = full_text.substr(0, i + 1)
	
	if on_complete.is_valid():
		on_complete.call()

# ============================================
# CONVENIENCE FUNCTIONS
# ============================================

static func quick_setup(label: Label, text: String, font_size: int = 16, color: Color = Color.WHITE, centered: bool = true) -> void: ## Quick setup for a basic label
	label.text = text
	set_font_size(label, font_size)
	set_text_color(label, color)
	
	if centered:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

static func create_label(parent: Node, text: String, position: Vector2, font_size: int = 16, color: Color = Color.WHITE) -> Label: ## Create a complete label node with text and styling
	var label = Label.new()
	label.text = text
	label.position = position
	set_font_size(label, font_size)
	set_text_color(label, color)
	
	parent.add_child(label)
	return label

static func update_text(label: Label, new_text: String, auto_resize: bool = true) -> void: ## Update label text and auto-resize
	label.text = new_text
	if auto_resize:
		fit_to_text(label)

static func toggle_visibility(label: Label) -> void: ## Toggle label visibility
	label.visible = not label.visible

