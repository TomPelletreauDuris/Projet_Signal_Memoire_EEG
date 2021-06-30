# Projet_Signal_Memoire_EEG
Traitement de signal biomédical pour la caractérisation de l'encodage mémoriel

# Presentation 
Ici, nous nous intéressons plus particulièrement au traitement du signal concernant les
processus cognitifs de “charge mentale”. On parle aussi de charge cognitive. Le concept de charge
mentale est souvent utilisé en sciences cognitives pour aborder la gestion des ressources
cognitives par un individu vis à vis d’une situation de stress. En effet, au cours de l'exécution d’une
tâche, l’état dans lequel se trouve l’opérateur varie selon son niveau d’aptitude à comprendre et
résoudre le problème engendré par la tâche. Cette aptitude varie selon les émotions ressenties
par l’opérateur comme l’énervement, la joie, la fatigue, la confiance (Martin, C., Hourlier, S. &
Cegarra, J.) et c’est en cela qu’il en découle certaines modifications physiologiques traduisant un
certain niveau de stress cognitif. Par là, nous pouvons comprendre que les mesures de ces
modifications physiologiques peuvent représenter des marqueurs de l’état cognitif du sujet
observé.

Nous nous proposons d’expliciter la méthodologie de l’ingénieur cogniticien face à cette
problématique avec l’outil de traitement de données Matlab® et son langage de programmation
propre. Tout d’abord nous montrerons comment un signal peut être acquis puis analysé dans le
domaine temporel et fréquentiel, notamment en liant ces deux repères par l’analyse tempsfréquence.
En deuxième lieu nous présenterons la méthode associée à l’analyse de la régularité
d’un signal grâce aux méthodes DFA (detendred fluctuations analysis) et DMA (detendred
moving average). Dans ces premières parties, nous testerons les méthodes sur des signaux
connus (bruits blancs) afin de s’assurer de la fonctionnalité des outils développés. Enfin, nous
montrerons comment ces méthodes peuvent s'appliquer à l’analyse d'un signal EEG afin de
caractériser la profondeur d’encodage mémoriel d’un utilisateur, c’est à dire, sa capacité à
transformer des informations traitées par sa mémoire de travail en informations mémorielles de
long terme.
