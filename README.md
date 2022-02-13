Det endte med at være en del overkill og var heller ikke planen til at starte med, men jeg fik lavet en NeuralNetwork klasse,
som er generaliseret, så man selv kan vælge, hvor mange lag den skal have, og hvor mange noder hvert lag skal have.

Jeg har også brugt min GeneticAlgorithm klasse, som jeg startede med at lave til sidste projekt, men fik videre bygget siden da.


Jeg valgte også at lave nogle ændringer såsom at give bilerne mulighed for at styre deres hastighed ved at hæve mængden af outputs i det neurale netværk.


Jeg valgte også at hæve populations-størrelsen til 10.000. Tilgengæld viser jeg kun 100 af dem, og det er de hundrede bedste biler ud fra mine score-kriterier.

Det score-kriterier, som jeg valgte var først og fremmest af bilerne ikke måtte køre uden for banen, og så måtte de ikke køre baglens, og så sidst vurderede jeg dem ud fra, hvor hurtigt de har kørt en runde.
Det betyder tilgengæld at det ikke nødvendigvis er alle, der når en score, men eftersom jeg kører med en population på 10.000, så vil der realistisk set altid mindst én bil, som når i mål.
Men hvis der skulle ske det, at ingen biler når at komme i mål, så vil den bare vælge en bil, som kører den rigtige vej, og som ikke er kørt ud af banen.