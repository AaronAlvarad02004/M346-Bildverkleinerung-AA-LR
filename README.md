# M346-Bildverkleinerung-AA-LR
Project with AWS
## Anleitung
1. Den Projektordner von Github herunterladen.
2. Die VMWare mit LP22.04 öffnen.
3. Skript in die VMWare übertragen, falls dies nicht bereits geschehen ist.
4. Script über Rechtsklick -> "Run as a Program" ausführen. Optional kann man das Skript auch über das Terminal öffnen.
5. Es verlangt etwas Geduld, da das Laden der Zip-Datei und deren Funktion eine gewisse Zeit in Anspruch nehmen kann. Je nach Internetverbindung geht es schneller oder weniger.
6. Es werden verschiedene Aufrufe an den User gestellt, welche möglichst den Anforderungen getreu umgesetzt werden sollen. Falsche Eingaben führen zur wiederholten Eingabe.
   
## Code Erklärung


## Tests
![21.12.2023 Aaron Alvarado](Test1.jpg "Test 1")


In diesem Test wird überprüft, ob der Bucket bereits existiert und wenn er bereits existiert eine Fehlermeldung ausgegeben wird. Hier mussten wir einige Male herumprobieren, bis wir realisiert hatten, dass der oberste Aufruf des Bash-Interpreters noch nicht eingefügt war und der Standard-Interpreter den Code nicht öffnen konnte.

![21.12.2023 Aaron Alvarado](Test2.jpg "Test 2")

In diesem Schritt wurde geprüft, ob die Prozentzahl des Users eingegeben werden kann. Dabei hat es zuerst einen Fehler ausgespuckt, weil die Erstellung des Destinantion-Buckets nicht in der Schleife eingebaut war. Im Nachhinein hat es funktioniert. 

![21.12.2023 Aaron Alvarado](Test3.jpg "Test 3")

Test ob die Prozentzahl für die Bildverkleinerung übergeben werden konnte. Zuerst haben wurde ein Error zurückgegeben, weil die Erstellung des Destinationbuckets nicht in der Schleife mitgegeben wurde. Im Nachhinein hat es dann aber funktioniert.

![21.12.2023 Aaron Alvarado](Test4.jpg "Test 4")

Es wurde geprüft, ob die Lambdafunktion richtig erstellt wird und ob die Berechtigungen für den Bucket gesetzt werden. Hier wurde zuerst eine falsche Variable bei der Berechtigung angegeben, weshalb es einige Probleme gab.

![21.12.2023 Aaron Alvarado](Test5.jpg "Test 5")

Test um die Existenz von AWS CLI, war erfolgreich.

![21.12.2023 Aaron Alvarado](Test6.jpg "Test 6")

Prüfung, ob Konfiguration im Falle der Nicht-Existenz erstellbar ist. Hier ist aufgrund der nicht möglichen Übergabe des Session Tokens fehlgeschlagen. Jedoch mit einem expliziten Aufruf, dass man einen Input haben möchte, welche den Session Key übergeben, hat es schlussendlich funktioniert.

![21.12.2023 Aaron Alvarado](Test7.jpg "Test 7")

Es wurde getestet, ob das Bild in den ersten Bucket hochgeladen wurde. Dies hat keine Probleme bereitet. Beim Download wiederum gab es Probleme weild die Funktion noch nicht ganz ausgeführt wurde und das Bild noch nicht im Bucket zwei abgelegt war. Dies wurde durch ein Sleep 10 behoben.

## Reflexion
### Aaron
### Larissa

Im allgemeinen hat die Aufgabenstellung mich etwas überfordert, da wir in den vorherigen Lektionen das Thema etwas zu schnell für meinen Geschmack durchgegangen sind. Dementsprechend war ich sehr froh über die Gruppenzusammenarbeit, da sie mich entlastet hat und ich Aufgaben die ich noch nicht ganz Verknüpfen konnte mit meinem kompetenten Partner abgleichen konnte. Im allgemeinen habe ich mich mit der Lambda-Funktion befasst. Einen Teil konnte ich aus den Aufgabenblätter entnehmen der restliche Grossteil hat mir das Internet geliefert und fürs Verständnis Chat GPT und meine Oberstiften. Zurückblickend finde ich es nicht so gut, dass man den Funktionsinhalt nicht vorab gestellt bekommt, denn im Endeffekt bleibt einem gar nichts anderes übrig als die Informationen, welche man eventuell auch nicht immer gerade versteht, aus dem Internet zu beziehen und es ist im Ende nicht das Ziel, wer besser Research betreibt, sondern die vorherigen Aufgaben anwenden zu können.
Ein weiterer negativer Aspekt aus meiner Seite war unser Zeitmanagement. Im allgemeinen hätte es der Qualität des Projektes geholfen, hätten wir nicht zeitgleich zwei weitere Projekte abschliessen müssen und nicht noch reguläre Prüfungen zu schreiben gehabt. Dementsprechend hat unsere Gruppe klare Prioritäten gesetzt, bei denen die Lektionen im Unterricht nirgendswohin gereicht haben. 
Dennoch fand ich das Projekt lehrreich und hatte einigermassen Spass, dies umzusetzten.

## Quellen



