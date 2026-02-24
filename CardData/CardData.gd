extends Resource
class_name CardData

@export_group("Visuals")
@export var title: String = "Название"
@export_multiline var description: String = "Описание"
@export var icon: Texture2D

@export_group("Stats")
@export var cost: int = 1 # Сколько маны стоит
@export var damage: int = 0 # Урон по телке (XOXO Bar)
@export var heal: int = 0 # Хилл
@export var shield: int = 0 # Доп. ХП
