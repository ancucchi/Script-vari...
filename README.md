# Script vari...

Spesso mi capita di dover fare moltitudini di operazioni identiche tra loro e quindi perchè non scrivere un bello script, che a volte può essere composto anche di una sola riga...<br>

## Estrapolazione del contenuto di file p7m
Tutti i software gratuiti che conosco che trattano i file p7m, firmando digitalmente file vari o verificando o file p7m, permettono di elaborare un file alla volta. E se bisogna estrapolare il contenuto di un migliaio o più di file p7m, come si fa?<br>
Fortunatamente linux ci viene in aiuto (anche a chi usa windows tramite il tool WSL - Windows Subsystem Linux) per mezzo del comando da terminale <b>p7m</b>.

Prima versione: `ls -Q *.p7m | xargs -n 1 p7m -x` <br>
Difetti? Se l'estensione non era tutta minuscola (Linux distingue le maiuscole dalle maiuscole nei nomi dei file e nei comandi di terminale) saltava qualche file...<br>

Seconda versione: `find . -maxdepth 1 -iname "*.p7m" -print0 | xargs -0 -n 1 p7m -x`
Difetti? il comando p7m è tremendamente lento per vari motivi tra cui la verifica del certificato quindi vedere elaborare i file lentamente lasciando la CPU alla minima capacità computazionale mi uscire pazzo :cursing_face: !!!<br>
Quindi cosa c'è di meglio nel parallelizzare l'istruzione <b>p7m</b> ?<br>
Versione con esecuzione di otto istruzioni parallele:<br>
- `find . -maxdepth 1 -iname "*.p7m" -print0 | xargs -0 -n 1 -P 8 p7m -x`<br>
Versione con esecuzione di trentadue istruzioni parallele:<br>
- `find . -maxdepth 1 -iname "*.p7m" -print0 | xargs -0 -n 1 -P 32 p7m -x`<br>
Ognuno può customizzare lo script in base alla potenza elaborativa del proprio computer cambiando il numero dopo l'opzione -<b>P</b>... <br>

PS Attenzione a maiuscole e spazi quando si scrive nel terminale di Linux...
