extends Node

onready var card_scene = preload("res://src/Card/CardBase.tscn")
onready var user_name = PedestrianDatabase.get_user_name()
#Multipliers order Cultural, Economico, Salud, Social
#[0.0, 0.0, 0.0, 0.0]
#: [".", "\n\n .", [0.005, 0.005, 0.005, 0.005]],

var INTRO_DECK = {
	"Introduccion": [ "Bienvenidx a tu peor pesadilla." , "\n\n No solo estas viviendo en un pandemia mundial sino que ahora vas a jugar que estas en otra, si leiste la ayuda o esta info ya la conoces podes saltearla con la X, sino presta atencion por que no la voy a volver a repetir", [0.00, 0.00, 0.00, 0.00]],
	"RoundResume": ["Resumen", "", [0.005, 0.005, 0.005, 0.005]]
}

const TUTORIAL_DECK = {
	"Introduccion": {
		"I0": ["Vivimos en una sociedad.", "\n\n Tus ciudadanos son basicos, asi que categorizan todo en 4 aspectos: Cultural, Economico, Salud y Social. Dependiendo de estos tu sociedad se vera afectada asi que tenes que encontrar el balance para ver que los hace felices.", [0.005, 0.005, 0.005, 0.005]],
		"I1": ["Ahora VOS estas a cargo.", "\n\n La cosa es facil, vas a empezar con 1 carta, por cada una de las 4 categorias, para definir que priorizas. Tene en cuenta que, como en la vida real, las decisiones no son lineales asi que todo afecta a todo solo que en distinta medida.", [0.005, 0.005, 0.005, 0.005]],
		"I2": ["Pensa bien que elegis.", "\n\n Cada decision que tomes va a tener efecto durante la duracion de una FASE (15 dias), donde ahi recien vas a poder cambiar. Las primeras 4 son en las UNICAS que aceptar es algo positivo y rechazar algo negativo.", [0.005, 0.005, 0.005, 0.005]],
		"I3": ["Vas a tener que madrugar.", "\n\n Una vez hechas tus elecciones iniciales la cosa se pone movida, todos los dias a las 8AM tendras que tomar alguna decision. Pero... la cosa no va a ser tan clara, por que solo vas a saber en donde es su efecto principal.", [0.005, 0.005, 0.005, 0.005]],
		"I4": ["Que paso ahora, LPM.", "\n\n Sin desesperar todavia. La idea es que a pesar de todo esto logres sobrevivir 5 FASES. Si pudiste aguantar a tus ciudadanos todo ese tiempo, ya te aseguras estar preparado para el futuro. Este sea vacunas, inmunidad natural o la extincion de la raza humana.", [0.005, 0.005, 0.005, 0.005]],
		"I5": ["Bueno, vamo a juga.", "\n\n No pierdas la paciencia ya te dejamos empezar a hacer cagadas. Pero te repito por ultima vez, lee bien y analiza cada decision, usa tu experiencia por que las cosas no son tan faciles y directas como parecen. Buena suerte, la vas a necesitar.", [0.005, 0.005, 0.005, 0.005]]
	},
	"BadEvent": {
		"BE1": ["Felicitaciones, sos un desastre.", "\n\n Que no panda el cunico, se sabia que esto podia pasar. Despues de todo esto es un intento de apocalipsis pero mas aburrido que en las peliculas. Ahora te muestro como revertir esto pero sabé que no va a ser gratis.", [0.005, 0.005, 0.005, 0.005]],
		"BE2": ["En caso de emergencia, romper...", "\n\n Tenes la chance de camuflar el desastre, aceptar estas cartas va a aumentar el valor de la categoria pero no como se siente la gente. Asi que te estamos dando tiempo pero tenes que mejorar las decisiones para que las cosas dejen de empeorar", [0.005, 0.005, 0.005, 0.005]],
		"BE3": ["Bases y condiciones.", "\n\n Si no las lees te jodes porque la sociedad se la va a bancar pero todo tiene un limite. En estos casos, por fase solo vas a poder salvar a cada barra una vez por fase. Y en el total de las fases solo 3 veces cada una, despues de eso a rezar", [0.005, 0.005, 0.005, 0.005]]
	},
	"GoodEvent":{
		"GE1": ["Todo esta bien, demasiado bien.", "\n\n Nada bueno dura mucho tiempo, estan tan felices que la cosa se empieza a descontrolar. Lo peor de todo, es que no podes hacer nada al respecto, la gente esta manija y solos se van a calmar", [0.005, 0.005, 0.005, 0.005]],
		"GE2": ["Keep calm and drink mate.", "\n\n Como te dije esto va a pasar y no hay nada que puedas hacer al respecto. Igual estate tranquilo, solo va a afectar el valor de esta categoria pero no como se siente la gente. Y si, te damos las opciones solo de placebo", [0.005, 0.005, 0.005, 0.005]]
	},
	"RoundResume":{
		"RR1": ["Duraste mas de lo pensado.", "\n\n La verdad que no te teniamos fe, pero ahora tu sociedad esta mas cerca de poder ver otra temporada de 'Almorzando con Mirtha'. Ahora te mostramos como te fue en esta fase, pero primero unos ultimos detalles", [0.005, 0.005, 0.005, 0.005]],
		"RR2": ["Ah shit, here we go again.", "\n\n Vas a empezar una nueva fase, pero como podras ver las barras se van a mantener en su posicion y vas a traer tambien una pequeña secuela. Tene en cuenta que mientras mas avances pero va a ser esta, la paciencia se acaba...", [0.005, 0.005, 0.005, 0.005]]
	}
}

const INITIAL_DECK = {
	"Cultural": ["Cultura", "Wikipedia dice que cultura tiene 164 significados, pero para nosotros va a ser solo 1: Que tanto querés que sepa tu sociedad?", [0.05, 0.01, -0.05, 0.03]],
	"Economico": ["Economico", "Acá vas a decidir que tanto querés que le cueste a tu sociedad llegar a fin de mes", [0.02, 0.05, -0.2, 0.01]],
	"Salud": ["Salud", "Bueno, estamos en una pandemia, si tu prioridad no es la salud una de dos: querés perder o estas tan bien que te podés dar el lujo de que deje de ser un ministerio", [0.02, -0.06, 0.04, 0.03]],
	"Social": ["Social", "Para que te guíes, si hay que pensar en los extremos de esto solo pensa que un extremo es dictadura y otro comunismo. Dejo a tu criterio cual es el peor y cual el mejor", [0.03, 0.02, -0.05, 0.05]]
}

# Remaining attempts -> Frase
const BAD_EVENTS_FRASES = {
	1: ["Último intento: \n", "\n \n Más no te puedo ayudar. \n\n"],
	2: ["Segundo intento: \n", "\n \n La gente te va a bancar solo una vez más eh. \n\n"],
	3: ["Primer intento: \n", "\n \n Hay que levantar esa barra.\n Un error lo tiene cualquiera, no? \n\n"]
}

const GAME_OVER_CARDS = {
	"Cultural": ["Cultural", "\n\n Lograste tu cometido. Según las últimas encuestas\n a la gente, 2+2 = 5", [0.0, 0.0, 0.0, 0.0]],
	"Economico": ["Economico", "\n\n Y sí, perdiste. Destruiste la economía (chocolate por la noticia) \n En un momento así, solo se puede reír.", [0.0, 0.0, 0.0, 0.0]],
	"Salud": ["Salud", "\n \n Decidiste vacunar a tu perro así que se te desbordaron los hospitales", [0.0, 0.0, 0.0, 0.0]],
	"Social": ["Social", "\n \n Te censuraron tu Twitter, Instagram, Facebook, MySpace y Fotolog", [0.0, 0.0, 0.0, 0.0]]
}

var RANDOM_DECK = {

	"Cultural": [
		["Cerrar Escuelas", "\n Los docentes a las aulas... virtuales", [-0.19, 0.0, 0.07, -0.04]],
		["Prohibir Deportes", "\n Excepto las canchitas de fulbo 5", [-0.15, 0.0, 0.06, -0.06]],
		["Prohibir Actividades al Aire Libre", "\n Adiós runners", [-0.17, 0.0, 0.05, -0.08]],
		["La gente está triste", "¿Les dejamos ver a Tinelli?", [-0.03, 0.02, 0.4, -0.01]]
	],

	"Economico": [
		["Planes Sociales", "Al país se lo saca laburando?", [0.0, -0.17, 0.02, 0.06]],
		["Reducir Impuestos", "Vas a dar una mano al pueblo, estás seguro?", [-0.03, -0.19, -0.04, 0.07]],
		["Libre Comercio", "Aduana quién te conoce", [0.04, -0.14, 0.1, -0.03]],
	],

	"Salud": [
		["Ayuda a Esenciales", "Y no, los políticos no entramos acá", [0.0, -0.07, 0.15, 0.04]],
		["Aumento de Investigación", "Es esto o tener fe de no salir hablando ruso", [0.03, -0.06, 0.17, 0.0]],
		["Inversión en Suplementos", "A traer más barbijos, y enseñar como usarlos", [0.02, -0.08, 0.19, 0.03]],
	],

	"Social": [
		["Limitar Comercios", "A usar MercadoLibre y Rappi", [0.0, -0.08, 0.05, -0.04]],
		["Limitar Circulación", "No más salidas, sólo clandestinas", [-0.02, -0.05, 0.06, -0.14]],
		["Prohibir Eventos", "Bienvenidos los Zoomples", [-0.04, 0.0, 0.05, -0.018]],
	]
}

var USED_RANDOM_DECK = {
	"Cultural": [],
	"Economico": [],
	"Salud": [],
	"Social": []
}

var GOOD_EVENT_DECK = {

	"Cultural": [
		["Llegaron los ovnis", "\n \n Mentira no llegaron, o si… \n La cuestión es que por unas imágenes medio raras se armó una conspiración y se descontrolo un poco todo", [-20]],
		["Tenias un obelisco?", "\n \n Te apareció un monumento en el medio de la nada. \n Nadie sabe porque está ahí ni como llego, mas paranoia en el medio de la pandemia", [-25]],
		["Restaurando", "\n \n Mandaste a arreglar escultura famosa y no salió muy bien que digamos", [-30]],
	],

	"Economico": [
		["Al parecer tenían frio", "\n \n Veníamos tan bien que un magnate asustado quiso aumentar su riqueza.\n Ahora tenés varios bosques con árboles luminosos", [-20]],
		["Tik Tok ahora paga?", "\n \n Te sacaron una nueva moneda electrónica y miles de influencers empezaron a facturar.\n Los boomers se están enojando", [-25]],
		["Hijo o robot", "\n \n Empresario mundialmente conocido nombra a su ¿hijo? \n Las acciones mundiales se enloquecen ", [-30]],
	],

	"Salud": [
		["SUPON QUE…", "\n \n ”Famosos” se juntan para cantar por los esenciales pero la verdad es que suben las consultas al otorrino", [-20]],
		["La ley de la selva", "\n \n Mantuviste bien a la gente, pero por eso la naturaleza gano poder, ahora tenés una invasión de animales en la ciudad", [-25]],
		["A las palmas", "\n \n Felices por el esfuerzo de todos, la gente empieza a aplaudir todos los días, esto solo genera caos entre vecinos", [-35]],
		["Balconeando", "\n \n Fiestas, conciertos, clases de spinning. \n Los edificios se pueblan de todo tipo de actividades", [-15]]
	],

	"Social": [
		["Que buena onda la NASA", "\n \n Cuantos apocalipsis juntos podés soportar? \n Porque dicen que se puede venir un asteroide", [-20]],
		["Hablemos sin saber", "\n \n Un supuesto periodista bardeo a un streamer famoso y ahora hicieron huelga. Miles de pibes embolados no saben qué hacer", [-25]],
		["A los memes", "\n \n Salen a la luz algunas declaraciones, los memes las viralizan y se va al carajo la reputación", [-15]],
		["Que en paz…", "\n \n Muere deportista ídolo mundial, y su despedida parece haber curado la pandemia, o no…", [-30]],
	]
}

var USED_GOOD_EVENT_DECK = {
	"Cultural": [],
	"Economico": [],
	"Salud": [],
	"Social": []
}

var BAD_EVENT_DECK = {

	"Cultural": [
		["De vuelta juntos", "Junta a cast de serie para hacer una reunión, hablar boludeces y distraer a la gente", [20, -0.05]],
		["Tortas a donde mires", "Nuevo trend de memes para hacer que todos duden de su realidad, ¿acaso yo soy una torta?", [25, -0.1]],
		["La pelota no se contagia", "Das rienda suelta a la liga profesional de futbol, por lo menos se distraen un poco", [35, -0.15]],
	],

	"Economico": [
		["Nos vamos a la Internet", "Impulsas la moneda virtual a pesar de que nadie tiene idea como funciona", [20, -0.05]],
		["No te dejes influenciar", "Impuestos a los creadores de contenido, porque ante la duda que paguen", [25, -0.1]],
		["Si hay que llorar, llora", "Vamos a tener que pedirle más tiempo al FMI porque si no hay que vender alguna provincia", [35, -0.15]],
	],

	"Salud": [
		["Vamos el verde", "No estamos hablando de “María”. Por fin sacas adelante la ley del aborto", [20, -0.05]],
		["Ahora si es ESE verde", "Por pedido del pueblo te resignas y habilitas el consumo.\n Por lo menos la gente está más feliz", [25, -0.1]],
		["Se vienen las vacunas?", "En realidad no sabes, pero casi seguro que están más cerca así que digamos eso", [35, -0.2]],
		["Aceptamos caridad", "Llegan donaciones de dudosa precedencia, pero como estamos en las últimas, las aceptamos y después vemos que onda", [30, -0.15]]
	],

	"Social": [
		["Un aDIOS", "La pandemia no importa si hablamos de un símbolo, así que juntemos millones de personas para despedir a un ídolo", [20, -0.05]],
		["No era el hotel", "Reservas a propósito una florería para tu próximo discurso.\n Que se concentren en los memes", [25, -0.1]],
		["De acá a Japón", "Sacas a la venta boletos para un futuro viaje a la estratosfera", [35, -0.15]],
	]
}

var USED_BAD_EVENT_DECK = {
	"Cultural": [],
	"Economico": [],
	"Salud": [],
	"Social": []
}
