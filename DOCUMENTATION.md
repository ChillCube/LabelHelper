# LabelHelper API Reference
Generated: 2026-08-01

Functions that are useful for dealing with text and labels

## Class: LabelHelper
**Inherits:** [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html)


### 🛠️ Methods
| Method | Arguments | Returns | Description |
| :--- | :--- | :--- | :--- |
| **static func get_text_size()** | `label: Label` | `Vector2` |  Get the actual pixel size of text in a label |
| **static func get_text_width()** | `label: Label` | `float` |  Get text width in pixels |
| **static func get_text_height()** | `label: Label` | `float` |  Get text height in pixels |
| **static func calculate_optimal_font_size()** | `label: Label`<br>`max_width: float`<br>`max_height: float`<br>`min_size: int = 8`<br>`max_size: int = 72` | `int` |  Calculate optimal font size to fit within max_width and max_height |
| **static func auto_fit_text()** | `label: Label`<br>`margin: float = 10.0` | `void` |  Auto-adjust font size to fit label bounds |
| **static func fit_to_text()** | `label: Label` | `void` |  Scale label to fit text exactly (removes extra padding) |
| **static func set_size_with_padding()** | `label: Label`<br>`padding: Vector2 = Vector2` | `void` |  Set label size to match text with padding |
| **static func center_in_parent()** | `label: Label` | `void` |  Center label relative to its parent Control |
| **static func position_at_sprite_center()** | `label: Label`<br>`sprite: Sprite2D`<br>`offset: Vector2 = Vector2.ZERO` | `void` |  Position label at center of a sprite (label must be child of sprite) |
| **static func position_above_sprite()** | `label: Label`<br>`sprite: Sprite2D`<br>`offset_y: float = 10.0` | `void` |  Position label above a sprite (for health bars, names, etc.) |
| **static func position_below_sprite()** | `label: Label`<br>`sprite: Sprite2D`<br>`offset_y: float = 10.0` | `void` |  Position label below a sprite |
| **static func position_relative_to()** | `label: Label`<br>`target: Label`<br>`offset: Vector2 = Vector2` | `void` |  Position label relative to another label |
| **static func align_to_screen_corner()** | `label: Label`<br>`corner: ScreenCorner`<br>`margin: Vector2 = Vector2` | `void` |  Align label to screen corner |
| **static func center_on_screen()** | `label: Label` | `void` |  Center label on screen |
| **static func add_background()** | `label: Label`<br>`color: Color`<br>`corner_radius: int = 3`<br>`padding: Vector2 = Vector2` | `void` |  Create a colored background for the label |
| **static func add_border()** | `label: Label`<br>`color: Color`<br>`width: int = 2`<br>`corner_radius: int = 3` | `void` |  Add border to label background |
| **static func add_text_outline()** | `label: Label`<br>`color: Color`<br>`size: int = 1` | `void` |  Add outline to text |
| **static func set_text_color()** | `label: Label`<br>`color: Color` | `void` |  Set text color |
| **static func set_font_size()** | `label: Label`<br>`size: int` | `void` |  Set font size |
| **static func set_font()** | `label: Label`<br>`font: Font` | `void` |  Set custom font |
| **static func make_health_style()** | `label: Label`<br>`border_color: Color = Color.WHITE`<br>`bg_color: Color = Color` | `void` |  Create a health bar style label with border and background |
| **static func make_damage_style()** | `label: Label`<br>`size: int = 24` | `void` |  Create a damage number style (red with outline) |
| **static func make_gold_style()** | `label: Label`<br>`size: int = 20` | `void` |  Create a gold/coin style |
| **static func format_number()** | `value: int` | `String` |  Format numbers with K/M/B suffixes (e.g., 1.5K, 2.3M) |
| **static func format_leading_zeros()** | `value: int`<br>`digits: int` | `String` |  Format with leading zeros (e.g., 005) |
| **static func format_percentage()** | `value: float`<br>`decimal_places: int = 0` | `String` |  Format as percentage |
| **static func format_time()** | `seconds: int` | `String` |  Format time as MM:SS |
| **static func format_time_long()** | `seconds: int` | `String` |  Format time as HH:MM:SS |
| **static func copy_style()** | `from_label: Label`<br>`to_label: Label` | `void` |  Copy all style properties from one label to another |
| **static func duplicate_label()** | `label: Label`<br>`new_text: String = ""` | `Label` |  Create a duplicate label with same properties |
| **static func wrap_text_to_width()** | `label: Label`<br>`max_width: float` | `void` |  Wrap text to specific width |
| **static func clear_overrides()** | `label: Label` | `void` |  Clear all theme overrides (reset to default) |
| **static func fade_in()** | `label: Label`<br>`duration: float = 0.5` | `void` |  Create a fade-in effect |
| **static func fade_out()** | `label: Label`<br>`duration: float = 0.5`<br>`free_on_complete: bool = false` | `void` |  Create a fade-out effect |
| **static func pop_in()** | `label: Label`<br>`duration: float = 0.3` | `void` |  Create a pop-in effect (scale up) |
| **static func floating_damage_number()** | `label: Label`<br>`start_pos: Vector2`<br>`end_offset: Vector2 = Vector2` | `void` |  Create a floating damage number effect |
| **static func pulse()** | `label: Label`<br>`scale_amount: float = 1.2`<br>`duration: float = 0.5` | `void` |  Pulse animation (for important notifications) |
| **static func shake()** | `label: Label`<br>`intensity: float = 5.0`<br>`duration: float = 0.3` | `void` |  Shake animation |
| **static func typewriter()** | `label: Label`<br>`duration: float = 1.0`<br>`on_complete: Callable = Callable` | `void` |  Typewriter effect (reveals text one character at a time) |
| **static func quick_setup()** | `label: Label`<br>`text: String`<br>`font_size: int = 16`<br>`color: Color = Color.WHITE`<br>`centered: bool = true` | `void` |  Quick setup for a basic label |
| **static func create_label()** | `parent: Node`<br>`text: String`<br>`position: Vector2`<br>`font_size: int = 16`<br>`color: Color = Color.WHITE` | `Label` |  Create a complete label node with text and styling |
| **static func update_text()** | `label: Label`<br>`new_text: String`<br>`auto_resize: bool = true` | `void` |  Update label text and auto-resize |
| **static func toggle_visibility()** | `label: Label` | `void` |  Toggle label visibility |

---

