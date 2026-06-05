extends Control

@onready var _en_button: Button = $HBox/English
@onready var _es_button: Button = $HBox/Spanish

func _ready() -> void:
    $Label.text = tr("Language")
    _en_button.text = tr("English")
    _es_button.text = tr("Español")
    _en_button.pressed.connect(_on_locale_pressed.bind("en"))
    _es_button.pressed.connect(_on_locale_pressed.bind("es"))
    refresh()

func refresh() -> void:
    var locale := TranslationServer.get_locale()
    _en_button.disabled = locale == "en"
    _es_button.disabled = locale == "es"

func _on_locale_pressed(locale: String) -> void:
    var main = get_tree().root.get_node("Main")
    main.apply_locale(locale)
    refresh()
