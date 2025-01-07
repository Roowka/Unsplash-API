# Unsplash

## Exercice 1

### Expliquez ce qu’est LazyVGrid et pourquoi on l’utilise.

LazyVGrid est un composant SwiftUI permettant d’afficher des éléments dans une grille verticale. C'est un composant paresseux (lazy) car il ne charge les éléments que lorsqu’ils sont affichés à l’écran (pour des raisons de performances)

On l'utilise car il permet d’afficher plusieurs images dans un format structuré. En terme de performances il ne charge uniquement que les images visibles à l’écran, ce qui est bien quand il y a beaucoup d'éléments. De plus, il est moins gourmand que des composants chargés statiquement (comme VStack ou HStack).

### Expliquez les différents types de colonnes et pourquoi on utilise flexible ici.

Les différents types de colonnes dans LazyVGrid sont les suivants :

LazyVGrid utilise un tableau de colonnes, qui définit comment les éléments doivent être répartis dans la grille.
- .fixed : 
    - Une taille fixe est imposée à chaque colonne.
    - Exemple : .fixed(100) -> donne une colonne de 100 points de large.
- .flexible :
     - La colonne s’étend pour remplir l’espace disponible.
    - Possibilité de définir une taille minimale et maximale : .flexible(minimum: 150, maximum: 300).
- .adaptive :
    - Crée automatiquement plusieurs colonnes en fonction de l’espace disponible.
    - Exemple : .adaptive(minimum: 150) -> remplit l’espace avec autant de colonnes que possible, chaque colonne ayant au moins 150px de largeur.

Dans ce projet, on utilise .flexible(minimum: 150) car avec les colonnes s’adaptent automatiquement à l’espace disponible. Ensuite ça assure que les images aient au moins 150px de largeur. Et enfin ça crée une grille cohérente de 2 colonnes, même sur des tailles d’écran différentes.

Les images prennent toute la largeur de l'écran car il faut préciser un .padding(.horizontal) sur la ScrollView.

