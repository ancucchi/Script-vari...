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
Mi capita spesso di ricevere centinaia di file XLS, XLSX o ODS contenenti dati in forma tabulare, coerenti tra loro, e volerli unire in un unico grandissimo file da aprire con Excel/LibreCalc/OpenCalc, fino a 50.000 righe, o Access, in caso di righe superiori, al fine di poter fare delle ricerche univoche o effettuare dei filtri sul totale senza aprire individualmente centinaia di fogli di calcolo.<br>
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

<b>Spiegazione</b>
Le righe 01, 05 e 09 cercano nella directory tutti i file con estensione xls, xlsx e ods in qualunque variante di maiuscole e minuscole.<br>
Le righe 02, 06 e 10 viasulaizzano il nome del file trovato che staper essere convertito. Quando i file sono molti un feedback ci aiuta a capire se va tutto bene e quanto manca al termine.<br>
Le righe 03, 07 e 11 usano il comando linux <b>unoconv</b> per convertire il file trovato in formato <b>csv</b>. La parte `python3 -W ignore` impedisce la visualizzazione dell'allert che ci informa che il comando unoconv sia [deprecato](https://github.com/unoconv/unoconv).<br>
Le righe 04, 08 e 12 chiudo i cicli for iniziati nelle righe 01, 05 e 09.<br>

<b>E ora?</b><br>
Adesso che tutti i nostri fogli di calcolo sono in formato <b>csv</b> e quindi in formato testuale, una semplice comando da terminale ci permette di riunirli in un unico grande file da dare in pasto ad Excel/LibreCalc/OpenCalc o Access.<br>

Terminale Windows `copy *.csv totale.txt`<br>
Terminale Linux `cat *.csv > totale.txt`<br>

<b>Excel/LibreCalc/OpenCalc o Access? E perchè?</b><br>
Le vecchie versioni di Excel permettevano ai file <b>xls</b> una dimensione massima dei fogli di calcolo con 65.536 colonne e altrettante righe.<br>
Le versioni più recenti di Excel permettono ai file <b>xlsx</b> una dimensione massima dei fogli di calcolo di oltre 65.536 colonne e altrettante righe ma nella maggior parte dei pc poi la gestione e manipolazione di questi file diventa lunga e tediosa.<br>
Quindi se superate le 50.000 righe di un file <b>csv</b> importarlo in Access è la via più semplice.<br>
Se poi volete proprio esagerare, un passaggio intermedio in Notepad++#64 (fino a 20.000.000 di righe l'ho testato - bisogna avere tanta RAM) permetterà di controllare i dati e di scremarli...<br>
Alternativamente le funzioni cat, head, tail, grep, sort e simii del terminale linux vis permettono di controllare i dati e di scremarli senza avere bisogno di tanta RAM solo di un po' di basi di Linux...<br>
<h2> PS Attenzione a maiuscole e spazi quando si scrive nel terminale di Linux...</h2>
