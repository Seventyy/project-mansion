# Tesseract Team Docs

## Struktura folderów

_"In general, large projects work best with data locality. Having all images in one folder, all scenes in another, and all scripts in another becomes hell once projects start to grow. Just put in a same folder all scripts, scenes, images, assets, etc. that are related."_

~reduz

## Nazewnictwo

### Język

Angielski górą, choć polskiego można używać w komentarzach w kodzie.

### System plików

|                 |            |
|-----------------|------------|
| Foldery         | PascalCase |
| Sceny           | PascalCase |
| Skrypty         | snake_case |
| Pliki graficzne | snake_case |
| Pliki dźwiękowe | snake_case |
| Zasoby          | snake_case |

### Kod

|                  |             |
|------------------|-------------|
| Klasy            | PascalCase  |
| Funkcje          | snake_case  |
| Zmienne          | snake_case  |
| Stałe            | UPPER_CASE  |
| Sygnały          | snake_case  |
| Enumy            | PascalCase  |
| Wartości enum'ów | UPPER_CASE  |

### Sugestie

Jeżeli w kodzie chcemy podkreślić, że określona funkcja lub zmienna jest "prywatna", do nazwy należy dodać prefiks podłogi '_'.

Zalecane jest unikanie używania oczywistych określeń w nazwach np. lepszą nazwą dla pliku "s_boom_sound.wav" byłoby po prostu "boom.wav"(wiadomo, że to dźwięk ze względu na format ".wav").

## Zalecenia dla programistów

### Kolejność elementów skryptu

Inspirowane [tym](https://docs.godotengine.org/pl/stable/getting_started/scripting/gdscript/gdscript_styleguide.html#code-order) ułożeniem z dokumentacji Godota, choć z kilkoma modyfikacjami.

1. tool
1. class_name
1. extends
1. docstring
1. signals
1. enums
1. constants
1. exported NodePaths and references
1. onready variables
1. exported general variables
1. exported PackedScenes
1. public variables
1. private variables
1. _init
1. _ready
1. other built-in virtual methods
1. public methods
1. private methods
1. signal handlers

Przykładowy kod ukazujący to ułożenie:
```nim
# tool, class_name and extends
tool class_name Foo extends Node
# docstring
# This is an example script to show proper code order for GDScript.

# signals
signal something_happened()

# enums
enum States {
    IDLE,
    ACTIVE
}

# constants
const ANSWER_TO_EVERYTHING := 42

# exported NodePaths and references
export var timer_path := @""; onready var timer := get_node(timer_path) as Timer
export var hitbox_path := @""; onready var hitbox := get_node(hitbox_path) as Hitbox

# onready variables
onready var owner2d := owner as Node2D

# not exported references
var origin: Node2D

# exported general variables
export var example_int := 0
export var example_string := "Hello World!"

# exported PackedScenes
export var bullet_packed: PackedScene

# public variables
var foo := 4.2
var bar := .0

# private variables
var _x := "This is private!"
var _y := true

# _init
func _init() -> void:
    print("Init!")

# _ready
func _ready() -> void:
    # signal connections
    hitbox.connect("area_entered", self, "_on_area_entered")
    # other stuff
    print("Ready!")

# other built-in virtual methods
func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    pass

# public methods
func spam() -> void:
    pass

# private methods
func _eggs() -> void:
    pass

# signal handlers
func _on_area_entered(area: Area2D) -> void:
    print(area, " -> ", "entered!")
```

### Static typing

Zobacz [tutaj.](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/static_typing.html#doc-gdscript-static-typing)

_"Typed GDScript and dynamic GDScript can coexist in the same project. But I recommended to stick to either style for consistency in your codebase, and for your peers. It's easier for everyone to work together if you follow the same guidelines, and faster to read and understand other people's code."_

~Godot docs

```nim
# przypisywanie typu zmiennej
var x: int
# skrót
var x := 42
# przypisywanie typu stałej
const x := 42

# przypisywanie zwracanego typu funkcji
func foo() -> int:
    return 0
func foo() -> void:
    return
# przypisywanie typu argumentom funkcji
func foo(arg: int) -> void:
    return
# argument domyślny
func foo(arg := 42) -> void:
    return

# eksportowanie zmiennych z typem
export var name: String
# skrót
export var name := "Bob"
# przykład
export var timer_path: NodePath
onready var timer := get_node(timer_path) as Timer
```

Zaleca się zawsze przypisywać domyślną wartość zmiennej typowanej zamist pisać osobno typu i wartości np.:
```nim
# brzydko
export var timer_path: NodePath = @""

# brzydko
export(NodePath) var timer_path: NodePath

# ładnie, krótko i schludnie
export var timer_path := @""
```

Istnieje wiele miejsc, w których static typing jeszcze nie został zaimplementowany, np. nie da się zdefiniować typu argumentów sygnału oraz typu elementów tablicy. To zmieni się wraz z Godotem 4.

### Eksportowanie referencji do inspektora

#### Standardowe (a zarazem lepsze) podejście
Eksportowanie zmiennych do edytora jest przydatne. Można to osiągnąć przy użyciu dwóch zmiennych:
```nim
export var node_path = @""; onready var node := get_node(node_path) as Node
```
Jedna z nich to NodePath, który zostaje przekazany do funckji get_node, która zwraca referencję, która zostaje przypisana do zmiennej.

#### Jak tego **NIE** robić
Ciekawym trikiem jest poniższa linijka:
```nim
export(NodePath) onready var timer = get_node(timer) as Timer
```
Umożliwia ona uzyskanie referencji do węzła przy użyciu jednej zmiennej. Niestety w jej wypadku static typing również **nie** działa. Ten trik niesie za sobą kilka nieprzyjemnych konsekwencji (chociażby nie można go używać z tool script'ami oraz uniemożliwia duplikowanie węzłów).

### Schludność kodu

Zobacz [tutaj.](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_styleguide.html)

### Komentarze

Programista pisząc komentarz powinien po znaku '#' postawic spację. Odróżnia to zwykłe komentarze od "wykomentowanego" przy użyciu CTRL + K (tylko we wbudowanym w Godota edytorze) kodu.

Dodawanie kilkulinijkowego komentarza wygląda tak:
```nim
"""
To
jest
wielolinijkowy
komentarz.
"""
```

### Wektory jako przedziały

Do określenia przedziału liczbowego (min-max) najlepiej użyć dwuwymiarowego wektora zamiast dwóch osobnych zmiennych liczbowych. Do takowej zmiennej powinno się dodać prefiks **range_** lub postfiks **_range**.
```nim
export var range_speed := Vector2(0.0, 100.0)
# lub
export var speed_range := Vector2(0.0, 100.0)
```

### Domyślna rotacja obiektów 2D

Przodem obietku w dwóch wymiarach jest prawo. Wektor (1, 0) ma kąt 0 stopni. Dlatego sprite'y należy domyślnie obracać właśnie tak, aby grafika była zwrócona w prawą stronę.

## Modułowy design

Zobacz [tutaj.](https://www.gdquest.com/tutorial/godot/design-patterns/entity-component-system/)

### Podział funkcjonalności na osobne pliki

Zamiast implementować całą funkcjonalność do pojedynczego skryptu należącego zwykle do głównego węzła określonej sceny (tak jak jest to pokazywane w większości poradników), lepiej rozdzielić różne feature'y na różne węzły sceny, które mogą się odwoływać do siebie za pomocą **NodePath** lub **Utils.get_component** oraz do głównego węzła sceny za pomocą **owner**.\ Przykładowo gracz, który ma zaimplementowane poruszanie się za pomocą WASD oraz strzelanie za pomocą spacji może mieć podzieloną scenę tak:

- Player (Node2D, brak skryptu)
  - InputHandler (Node, odpowiada za przyjmowanie wejścia od gracza i przekazywanie go do odpowiedniego węzła lub emitowanie określonego sygnału)
  - Movement (Node, porusza graczem (**owner**), reaguje na input)
  - Shooting (Node, instancjonuje scenę pocisku przy kliknięciu spacji)
    - RateOfFire (Timer, brak skryptu)
  - Sprite (Sprite, brak skryptu)

Takich węzłów (nazywam je zwykle komponentami, gdyż mają podobne zastosowanie co w Unity) może być bardzo wiele, a nie jeden z nich może być użytecznych w wielu scenach na raz (np. system punktów życia może się przydać zarówno w graczu, jak i w przeciwnikach czy nawet innych neutralnych obiektach - przy założeniu, że każdy z nich ma punkty życia i po ich wyczerpaniu zostaje zniszczony) co ogranicza niepotrzebne i nieschludne kopiuj-wklej kodu.

### Static typing w kontekście modułowości

Przy okazji modułowego designu należy wspomnieć o takich tematach jak:

#### class_name

Programiści mogą definiować własne nazwy klas globalnie dostępne w projekcie:
```nim
class_name OneShotAudioStreamPlayer2D extends Node

# [...]
```

Później można tego używać tak jak każdego innego typu:
```nim
# [...]

func _on_hit() -> void:
    var oof_sound := OneShotAudioStreamPlayer2D.new()
    oof_sound.global_position = owner.global_position
    oof_sound.stream = oof_stream
    Signals.emit_signal("spawn_audio_stream_player", oof_sound)

# [...]
```

#### const

Używanie stałych do przypisywania typów jest przestarzałe i zostało zastąpione przez class_name. Niemniej wspominam o tym, gdyż okazjonalnie bywa to jeszcze przydatne.
```nim
# [...]

const Health := load("res://Components/health.gd")
# teraz ta stała na przypisany typ, który jest określony przez skrypt health.gd

# [...]
```

#### Statyczne funkcje

Statyczne funkcje są przypisane do klasy, a nie do obiektu.
```nim
class_name Example extends Reference

static func foo() -> void:
    print("Hello World!")
```

Z tego powodu można ich używać przy pomocy samej nazwy klasy, bez instancjonowania jej:
```nim
# [...]

Example.foo() # taki zapis jest prawidłowy, gdyż funkcja jest statyczna

# [...]
```

#### Typy jako wartości zmiennych

W Unity istnieją bardzo przydatne metody do odnajdywania komponentów po typach (GetComponent oraz GetComponents). Używają one mechanizmu generic'ów z C#, które są podobne do template'ów z C++. GDScript nie posiada czegoś takiego, lecz może przypisać typ jako wartość zmiennej.
```nim
# [...]

var t
t = Area2D # natywna klasa
t = MyClass # klasa zdefiniowana przez użycie class_name

# [...]
```
Niestety static typing działa tutaj różnie, bo o ile zdefiniowane przez programistę typy mają swoją własną klasę (Script), to te natywne już nie. Z tego powodu zalecam omijanie static typing'u w tym przypadku. Typy jako wartości można wykorzystać trochę jak wcześniej wspomniane generic'y z C#. Umożliwia to proste zaimplementowanie funkcji get_component czy get_components.

#### Tworzenie zbiorów globalnie dostępnych funkcji
```nim
class_name Utils extends Reference

static func get_component(base: Node, type) -> Node:
    # zwraca pierwszy w kolejności węzeł potomny o podanych typie
    # [...]

static func get_components(base: Node, type) -> Array:
    # zwraca wszystkie węzły potomne o podanym typie w formie tablicy
    # [...]

# [...]
```

Później takowych funkcji możemy użyć w innym pliku pisząc np.:

```nim
# [...]

onready var areas := Utils.get_components(owner, Area2D)
onready var health := Utils.get_component(owner, Health) as Health

# [...]
```

---