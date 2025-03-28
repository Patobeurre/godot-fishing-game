extends Resource
class_name LoadingRes


func get_random_text() -> String:
	return subjects.pick_random() + " " + complements.pick_random()


@export var subjects :Array[String] = \
[
  "Amarrage",
  "Déferlement",
  "Affichage",
  "Arrosage",
  "Interfaçage",
  "Chargement",
  "Empaquetage",
  "Renversement",
  "Éloignement",
  "Mise en relation",
  "Collage",
  "Ralliement",
  "Démarrage",
  "Compression",
  "Emballage",
  "Déplacement",
  "Rotation",
  "Duplication",
  "Stimulation",
  "Hébergement",
  "Agitation",
  "Lissage",
  "Atténuation",
  "Nettoyage",
  "Nassage",
  "Translation",
  "Retournement",
  "Partage",
  "Passage",
  "Ramassage",
  "Décimation",
  "Connexion",
  "Confection",
  "Sauvetage",
  "Habillage",
  "Rapprochement",
  "Serrage",
  "Stockage",
  "Triage",
  "Vidage",
  "Lavage",
  "Lustrage",
  "Maillage",
  "Doublage",
  "Hachage",
  "Pressage",
  "Dégagement",
  "Déchargement",
  "Ponçage",
  "Cisaillage",
  "Pavage",
  "Moulage",
  "Fauchage",
  "Enlèvement",
  "Rétrécissement",
  "Agrandissement",
  "Échantillonnage",
  "Révision",
  "Guidage",
  "Traçage",
  "Calcul",
  "Interprétation",
  "Interpolation",
  "Ajustement",
  "Dédoublement",
  "Revigoration",
  "Éclatage"
]

@export var complements :Array[String] = \
[
  "des poissons",
  "du code",
  "des modèles",
  "du rendu",
  "des surfaces",
  "des rayons",
  "des particules",
  "de l’eau",
  "des nuages de points",
  "du terrain",
  "du processeur",
  "des textures",
  "des ombres",
  "des algorithmes",
  "des éléments du maillage",
  "des graphismes",
  "du calcul des ombres",
  "des outils du logiciel",
  "des environnements",
  "des matériaux",
  "des collisions",
  "des lumières",
  "du soleil",
  "de la caméra",
  "des roches",
  "des zones",
  "des images",
  "du fond",
  "des fleurs",
  "des dimensions",
  "du monde 3d",
  "des objets",
  "du volume des pixels",
  "du ciel",
  "des formes",
  "des ressources",
  "du contour des objets",
  "des paramètres",
  "du terrain des objets",
  "du paysage",
  "de l’atmosphère",
  "du ciel",
  "des points du réseau",
  "des pixels du rendu",
  "du maillage des espaces",
  "des contours des modèles",
  "du moteur",
  "des sphères de calcul",
  "du plan des surfaces",
  "des arbres",
  "du relief des montagnes",
  "des pentes du terrain",
  "de la simulation",
  "des mouvements du personnage",
  "du dégradé des couleurs",
  "des lumières du modèle",
  "du son",
  "du modèle des arbres",
  "des textures du sol",
  "du programme",
  "des pixels",
  "des effets",
  "des surfaces",
  "des scènes",
  "des reflets",
  "du sable",
  "des couleurs",
  "des distances"
]
