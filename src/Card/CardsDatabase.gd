extends Node

onready var card_scene = preload("res://src/Card/CardBase.tscn")
onready var user_name = PedestrianDatabase.get_user_name()
#Multipliers order Cultural, Economico, Salud, Social
#[0.0, 0.0, 0.0, 0.0]
#: [".", "\n\n .", [0.005, 0.005, 0.005, 0.005]],

var INTRO_DECK = {
	"Introduccion": [ "Bienvenidx a tu peor pesadilla.", "\n\n No solo estas viviendo en una pandemia mundial, sino que ahora vas a jugar que estas en otra, si leíste la ayuda o esta info ya la conoces podés saltearla con la X, sino presta atención porque no la voy a volver a repetir", [0.00, 0.00, 0.00, 0.00]],
	"RoundResume": ["Resumen", "", [0.005, 0.005, 0.005, 0.005]]
}

const TUTORIAL_DECK = {
	"Introduccion": {
		"I0": ["Vivimos en una sociedad.", "\n\n Tus ciudadanos son básicos, así que se categorizan a la sociedad en: Cultural, Económico, Salud y Social. Encontra el balance para ver que los hace felices.", [0.005, 0.005, 0.005, 0.005]],
		"I1": ["Ahora VOS estas a cargo.", "\n\n Empezas con 1 carta por cada categoría. Las decisiones no son lineales así que todo afecta a todo solo que en distinta medida.", [0.005, 0.005, 0.005, 0.005]],
		"I2": ["Pensá bien que elegís.", "\n\n Cada decisión va a tener efecto durante una FASE (15 días). Las primeras 4 son en las ÚNICAS donde aceptar es positivo y rechazar negativo.", [0.005, 0.005, 0.005, 0.005]],
		"I3": ["Vas a tener que madrugar.", "\n\n Todos los días a las 8AM tendrás que tomar alguna decisión. Pero... la cosa no va a ser tan clara, solo vas a saber en dónde es su efecto principal.", [0.005, 0.005, 0.005, 0.005]],
		"I4": ["Que paso ahora, LPM.", "\n\n La idea es que sobrevivas 5 FASES. Si aguantaste, ya te aseguras estar preparado para las vacunas, inmunidad natural o la extinción de la raza humana.", [0.005, 0.005, 0.005, 0.005]],
		"I5": ["Bueno, vamo a juga.", "\n\n No pierdas la paciencia ya te dejamos empezar a hacer cagadas. Pero te repito por última vez, leé bien y analiza cada decisión, usa tu experiencia porque las cosas no son tan fáciles y directas como parecen. Buena suerte, la vas a necesitar.", [0.005, 0.005, 0.005, 0.005]]
	},
	"BadEvent": {
		"BE1": ["Felicitaciones, sos un desastre.", "\n\n Que no panda el cunico. Después de todo esto es un intento de apocalipsis, pero más aburrido que en las películas.", [0.005, 0.005, 0.005, 0.005]],
		"BE2": ["En caso de emergencia, romper...", "\n\n Tenes la chance de camuflar el desastre, aceptar estas cartas va a aumentar el valor de la categoría, pero no como se siente la gente. Tenés que mejorar las decisiones para que las cosas dejen de empeorar", [0.005, 0.005, 0.005, 0.005]],
		"BE3": ["Bases y condiciones.", "\n\n Si no las lees te jodes porque la sociedad se la va a bancar, pero todo tiene un límite. En estos casos, por fase solo vas a poder salvar a cada barra una vez. Y en el total de las fases solo 3 veces cada una, después de eso a rezar", [0.005, 0.005, 0.005, 0.005]]
	},
	"GoodEvent": {
		"GE1": ["Todo está bien, demasiado bien.", "\n\n Nada bueno dura mucho tiempo, están tan felices que la cosa se empieza a descontrolar. Lo peor de todo, es que no podés hacer nada al respecto ", [0.005, 0.005, 0.005, 0.005]],
		"GE2": ["Keep calm and drink mate.", "\n\n Estate tranquilo, solo va a afectar el valor de esta categoría, pero no como se siente la gente. Y si, te damos las opciones solo de placebo", [0.005, 0.005, 0.005, 0.005]]
	},
	"RoundResume": {
		"RR1": ["Duraste más de lo pensado.", "\n\n La verdad que no te teníamos fe, pero ahora tu sociedad está más cerca de poder ver otra temporada de 'Almorzando con Mirtha'.", [0.005, 0.005, 0.005, 0.005]],
		"RR2": ["Ah shit, here we go again.", "\n\n Vas a empezar una nueva fase, pero como podrás ver las barras se van a mantener en su posición y vas a traer también una pequeña secuela. Tené en cuenta que mientras más avances, peor va a ser esta, la paciencia se acaba...", [0.005, 0.005, 0.005, 0.005]]
	}
}

const INITIAL_DECK = {
	"Cultural": ["Cultura", "Wikipedia dice que cultura tiene 164 significados, pero para nosotros va a ser solo 1: Que tanto querés que sepa tu sociedad?", [0.05, 0.01, -0.05, 0.03]],
	"Economico": ["Económico", "Acá vas a decidir que tanto querés que le cueste a tu sociedad llegar a fin de mes", [0.02, 0.05, -0.2, 0.01]],
	"Salud": ["Salud", "Bueno, estamos en una pandemia, si tu prioridad no es la salud una de dos: querés perder o estas tan bien que te podés dar el lujo de que deje de ser un ministerio", [0.02, -0.06, 0.04, 0.03]],
	"Social": ["Social", "Para que te guíes, si hay que pensar en los extremos de esto solo pensá que un extremo es dictadura y otro comunismo. Dejo a tu criterio cual es el peor y cual el mejor", [0.03, 0.02, -0.05, 0.05]]
}

# Remaining attempts -> Frase
const BAD_EVENTS_FRASES = {
	1: ["Último intento: \n", "\n \n Más no te puedo ayudar. \n\n"],
	2: ["Segundo intento: \n", "\n \n La gente te va a bancar solo una vez más eh. \n\n"],
	3: ["Primer intento: \n", "\n \n Hay que levantar esa barra.\n Un error lo tiene cualquiera, no? \n\n"]
}

const GAME_OVER_PHRASES = {
	"Cultural": "Lograste tu cometido. Según las últimas encuestas a la gente, 2+2 = 5 y la capital de Argentina es Avellaneda.",
	"Economico": "Y sí, perdiste. Destruiste la economía (igual ya estamos acostumbrados). En un momento así, solo se puede reír.",
	"Salud": "Creiste que con un té caliente se solucionaba todo y decidiste vacunar a tu perro. Se te desbordaron los hospitales.",
	"Social": "La gente no te banca más. Te censuraron tu Twitter, Instagram, Facebook, MySpace y Fotolog. Solo te quedan las cadenas nacionales."
}

const GAME_OVER_RESTART_PHRASE = "\n\nQuerés seguir jugando? Vas a tener que recargar, porque todavía no tenemos botón de restart."

var RANDOM_DECK = {

	"Cultural": [
		["Cerrar Escuelas", "\n Los docentes a las aulas... virtuales.\n ¿Cerramos las escuelas?", [-0.19, 0.0, 0.07, -0.04]],
		["Prohibir Deportes", "\n ¿Prohibimos los deportes?\n Excepto las canchitas de fulbo 5, obvio.", [-0.15, 0.0, 0.06, -0.06]],
		["Prohibir Actividades al Aire Libre", "\n Chau chau runners.\n ¿Dejamos a la gente hacer deporte al aire libre?", [-0.17, 0.0, 0.05, -0.08]],
		["La gente está triste", "¿Les dejamos ver a Tinelli?", [-0.03, 0.02, 0.4, -0.01]]
	],

	"Economico": [
		["Planes Sociales", "Al país se lo saca laburando.\n ¿Seguimos dando planes sociales?", [0.0, -0.17, 0.02, 0.06]],
		["Reducir Impuestos", "Vas a dar una mano al pueblo. ¿Estás seguro?\n ¿Les reducimos el IVA?", [-0.03, -0.19, -0.04, 0.07]],
		["Libre Comercio", "Aduana quién te conoce.\n ¿Abrimos las exportaciones?", [0.04, -0.14, 0.1, -0.03]],
	],

	"Salud": [
		["Ayuda a Esenciales", "¿Les tiramos unos pesos a los esenciales?\n Mira que los políticos no ligamos nada eh.", [0.0, -0.07, 0.15, 0.04]],
		["Aumento de Investigación", "Es esto o tener fé de no salir hablando ruso.\n ¿Incrementamos el presupuesto en investigación?", [0.03, -0.06, 0.17, 0.0]],
		["Inversión en Suplementos", "¿Traemos barbijos?\n Mira que vamos a tener que enseñar como usarlos.", [0.02, -0.08, 0.19, 0.03]],
	],

	"Social": [
		["Limitar Comercios", "A usar MercadoLibre y Rappi.\n ¿Dejamos abrir solo a los negocios esenciales?", [0.0, -0.08, 0.05, -0.04]],
		["Limitar Circulación", "No más salidas, sólo clandestinas.\n ¿Vamos a dejar que la gente salga de noche?", [-0.02, -0.05, 0.06, -0.14]],
		["Prohibir Eventos", "Bienvenidos los Zoomples.\n ¿Prohibimos los eventos de más de 5 personas?", [-0.04, 0.0, 0.05, -0.018]],
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
		["Restaurando", "\n \n ¿Viste todos esos colegios que inauguramos? Se inundaron todos. Volvemos a la virtualidad.", [-30]],
	],

	"Economico": [
		["Al parecer tenían frio", "\n \n Veníamos tan bien que un magnate asustado quiso aumentar su riqueza.\n Ahora tenés varios bosques con árboles luminosos", [-20]],
		["Tik Tok ahora paga?", "\n \n Te sacaron una nueva moneda electrónica y miles de influencers empezaron a facturar.\n Menos recaudación para nosotros.", [-25]],
		["Twitter maldito", "\n \n A Elon Musk le pintó twittear que el peso argentino es malo. \n Nuestra bella moneda se devalúa un 30%. ", [-30]],
	],

	"Salud": [
		["Juntada de famosos", "\n \n Se juntaron unos cuantos ”famosos” a cantar por los esenciales. Terminaron todos contagiados.", [-20]],
		["La ley de la selva", "\n \n Mantuviste bien a la gente, pero por eso la naturaleza gano poder. Ahora tenés una invasión de animales en la ciudad.", [-25]],
		["Arriba las palmas", "\n \n Felices por el esfuerzo de todos, la gente empieza a aplaudir todos los días. Caos entre los vecinos que se acuestan temprano.", [-35]],
		["Fiesta en el balcón", "\n \n Fiestas, conciertos, clases de spinning. \n Los edificios se pueblan de todo tipo de actividades.", [-15]]
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
		["De vuelta juntos", "Se junta un cast de una serie para hacer una reunión, hablar boludeces y distraer a la gente", [20, -0.05]],
		["Tortas a donde mires", "Nuevo trend de memes para hacer que todos duden de su realidad, ¿Acaso yo soy una torta?", [25, -0.1]],
		["La pelota no se contagia", "Das rienda suelta a la liga profesional de futbol, por lo menos se distraen un poco", [35, -0.15]],
	],

	"Economico": [
		["Nos vamos a la Internet", "Impulsas la moneda virtual a pesar de que nadie tiene idea como funciona", [20, -0.05]],
		["No te dejes influenciar", "Impuestos a los creadores de contenido, porque ante la duda que paguen", [25, -0.1]],
		["Si hay que llorar, llora", "Vamos a tener que pedirle más tiempo al FMI porque si no hay que vender alguna provincia", [35, -0.15]],
		["Impuesto al viento", "¿No sabías? Ahora le cobramos a la gente por repirar.", [35, -0.15]],
	],

	"Salud": [
		["Vamos el verde", "Por fin sacas adelante la ley del aborto", [20, -0.05]],
		["Churros everywhere", "Por pedido del pueblo te resignas y habilitas el consumo.\n Por lo menos la gente está más feliz", [25, -0.1]],
		["¿Se vienen las vacunas?", "En realidad no sabes, pero casi seguro que están más cerca así que digamos eso", [35, -0.2]],
		["Aceptamos caridad", "Llegan donaciones de dudosa procedencia, pero como estamos en las últimas, las aceptamos y después vemos que onda", [30, -0.15]]
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
