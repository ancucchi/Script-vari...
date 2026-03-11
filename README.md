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

## Conversione Massiva di file XLS, XLSX o ODS
Mi capita spesso di ricevere centinaia di file XLS, XLSX o ODS contenenti dati in forma tabulare, coerenti tra loro, e volerli unire in un unico grandissimo file da aprire con Excel, fino a 50.000 righe, o Access, in caso di righe superiori, al fine di poter fare delle ricerche univoche o effettuare dei filtri sul totale senza aprire individualmente centinaia di fogli di calcolo.<br>
Dopo aver fatto vari tentativi, la soluzione più semplice è stata quella di creare il seguente script linux:<br>
01. `for i in *.[xX][lL][sS]; do`<br>
02. `    echo ${i}`<br>
03. `   python3 -W ignore /usr/bin/unoconv -f csv "$i" #"${i%.*}.csv"`<br>
04. `done`<br>
05. `for i in *.[xX][lL][sS][xX]; do`<br>
06. `    echo ${i}`<br>
07. `   python3 -W ignore /usr/bin/unoconv -f csv "$i" #"${i%.*}.csv"`<br>
08. `done`<br>
09. `for i in *.[oO][dD][sS]; do`<br>
10. `    echo ${i}`<br>
11. `    python3 -W ignore /usr/bin/unoconv -f csv "$i" #"${i%.*}.csv"`<br>
12. `done`<br>


copy *.csv totale.txt
cat *.csv > totale.txt



<h2> PS Attenzione a maiuscole e spazi quando si scrive nel terminale di Linux...</h2>
