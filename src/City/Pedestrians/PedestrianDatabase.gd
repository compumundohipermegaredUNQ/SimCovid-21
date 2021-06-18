extends Node

var ticks_per_phrase = 10
var user_name

const PEDESTRIANS = {
	"low": {
		"cultural_bar": "neanderthal",
		"economia_bar": "homeless",
		"salud_bar": "zombie",
		"social_bar": "fan"
	},
	"high": {
		"cultural_bar": "scientific",
		"economia_bar": "smoking",
		"salud_bar": "mask",
		"social_bar": "worker"
	}
}

const PHRASES = [
	
#Cultural
	"{user_name}, abrime las escuelas!",
	"Quiero ver rápidos y furiosos 9 en el cine!",
	"{user_name} dijo que los de Brasil salieron de la selva",

#Economico
	"{user_name} me aumentó el monotributo, RETROACTIVO",
	"Menos mal que tenemos menos pobres que Alemania",
	"Que lujo es nuestra economía. Dijo nunca nadie",
	"{user_name} dijo que, si deposité dólares, voy a recibir dólares",
	
#Salud
	"Hay demasiada gente en la calle. ¡Vuelvan a sus casas!",
	"Esperemos que no se relaje el sistema sanitario",
	"Ese señor no tiene barbijo!",
	"Si me doy la rusa seguro termino hecho un robot",
	"No me la contacto estrecho",

#Social
	"{user_name} me quiere encerrar de nuevo",
	"{user_name}, habilitame los bares!",
	"No aguanto más a mis hijos en casa",
]

func set_user_name(name):
	user_name = "Albertacri" if name == '' || name == null else name

func get_user_name():
	return user_name

func get_current_ticks():
	ticks_per_phrase = clamp(ticks_per_phrase - 1, 0, 10)
	return ticks_per_phrase

func restart_ticks():
	ticks_per_phrase = 10
