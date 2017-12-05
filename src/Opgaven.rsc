// uitwerking oefenopgaven Rascal
// naam: C. Zijlstra
// studenten nummer: 851948642
// uitvoeren dmv
// import Opgaven;
// opgave_4();
// opgave_5();
// opgave_6();
// opgave_7();
// test regel


module Opgaven

 import IO;
 import List;
 import Map;
 import Relation;
 import Set;
 import analysis::graphs::Graph;
 import util::Resources;
 import lang::java::jdt::m3::Core;
 import util::Resources;
 

 
 public void opgave_4() {
 list[str] eu=["Belgie","Bulgarije","Cyprus","Denemarken","Duitsland","Estland",
"Finland","Frankrijk","Griekenland","Hongarije","Ierland","Italie","Letland",
"Litouwen","Luxemburg","Malta","Nederland","Oostenrijk","Polen","Portugal",
"Roemenie","Slovenie","Slowakije","Spanje","Tsjechie","Verenigd Koninkrijk","Zweden"];

 println("4a");
 // /i is case insensitive /s is de te zoeken letter.
 println([a | a <- eu, /s/i := a]);

 println("4b");
 // zoek naar een e en zoek dan naar nog een e
 println([a | a <- eu,  /e.*e/i := a ]);
 
 println("4c");
 // zoek vanaf het begin van de string (^), een 0 of meer aantal letters die geen e zijn. Daarna een e,
 // daarna weer 0 of meer letters die geen e zijn, weer gevolgd door een e. 
 // daarna weer 0 of meer letters die geen e zijn, tot aan het eind van de string ($).  
 println([a | a <- eu,  /^([^e]*e){2}[^e]*$/i := a ]);
 
 println("4d");
 //zoek vanaf het begin van de sting (^) naar letters die niet e of n zijn ([^en]) tot aan het eind van de string ($)
 println([a | a <- eu,  /^[^en]*$/i := a ]);
 
 println("4e");
 // laat x een letter zijn (<x:[a-z]>) zoek of die minimaal nog eens voorkomt (.*<x>)
 println([a | a <- eu,  /<x:[a-z]>.*<x>/i := a]);
 
 println("4f");
 // laat begin alle letters vanaf het begin van de string zijn (^) die geen a zijn ([^a]). Daarna komt een a.
 // laat daarna eind alle overige letters .* tot aan het eind van de string ($) zijn.
 println([begin+"o"+eind | a <- eu, /^<begin:[^a]*>a<eind:.*>$/i :=a]);
 
 }
 
 public rel[int,int] delers(int maxnum) {
 // geef alle a, b terug waarvoor geldt:
 // a loopt van 1 tot maxnum +1 (+1 zodat maxnum ook wordt meegenomen)
 // b loopt van 1 tot a (+1 zodat ook het getal zelf steeds wordt meegenomen)
 // de modulus van a/b is gelijk aan 0
 return {<a,b> | a <- [1..maxnum+1], b <- [1..a+1], a%b ==0};
 }
 
 
 public void opgave_5() {
 
 // aantal is het maximale getal wat moet worden meegenomen
 
 int aantal = 100;
 println("5a");
 // d krijgt alle getal combinaties
 rel[int,int] d = delers(aantal);
 println(d);
 
 println("5b");
 //maak een map aan met m als key en a als het aantal keer dat een getal een deler heeft.
 // a krijgt daarvoor eerst alle waarden uit het domein van d.
 // daarna wordt per a het aantal keer dat deze in d voorkomt bepaald.
 // vervolgens wordt van de range van m het maximum bepaald
 // daarna krijgt a het domein van m en wordt voor iedere a bepaald of de waarde het maximaal aantal delers is.
 
 map[int, int] m = (a:size(d[a]) | a <- domain(d));
 int maxdiv = max(range(m));
 println({a | a <- domain(m), m[a] == maxdiv});
 
 println("5c");
 // voor iedere a moet gelden;
 // a komt voor in m
 // het aantal delers van m moet 2 zijn (1 en het getal zelf)
 println(sort([a| a <- domain(m), m[a] == 2]));
 
 }
 
 
 
 
public void opgave_6() {

Graph[str] graaf = {<"A","B">,<"A","D">,<"B","D">,<"B","E">,<"C","B">,<"C","E">,<"C","F">,<"E","D">,<"E","F">};

//zet alle letters waaruit relaties lopen in componenten.
componenten = carrier(graaf);
println("6a");
// tel het aantal componenten.
println(size(componenten));

println("6b");
//tel het aantal relaties in graaf.
println(size(graaf));

println("6c");
// geef een overzicht van de hoogste beginpunten vran graaf.
println(top(graaf));

println("6d");
// graaf+ is de lijst van alle indirecte en directe relaties, zonder dat een relatie naar zichzelf wordt meegenomen.
// Uit graaf+ worden vervolgens alle letters getoond die vanuit A te bereiken zijn.
println((graaf+)["A"]);

println("6e");
// graaf* is de lijst van alle directe en indirecte relaties, inclusief een relatie naar zichzelf. 
// Van graaf* worden vervolgens alle letters genomen die C als begin punt hebben. 
// Het resultaat wordt uit de totale lijst van letters genomen, zodat alleen de niet gebruikte overblijven.
println(componenten - ((graaf*)["C"]));

println("6f");
// Met invert worden de relaties omgedraaid. Daarna wordt uit de hele lijst met letters, per letter het 
// aantal keer geteld dat deze voorkomt.
println(invert(graaf));
println(( a:size(invert(graaf)[a]) | a <- componenten ));

}

// hulp functie voor opgave 7. Invoer project. Uitvoer een set van alle bestanden met extentie java
public set[loc] javaBestanden(loc project) =
{ a | /file(a) <- getProject(project), a.extension == "java" };


// hulp functie voor opgave 7 voor aflopend sorteren
// ontvangt twee tuples. Indien het eerste tuple groter is dan het tweede geef dan true terug en anders false.
public bool aflopend(tuple[&a, num] x, tuple[&b, num] y) {
return x[1] > y[1];
}



public void opgave_7(){

// Haal alle bestanden uit Jabberpoint op en plaats die in bestanden.
set[loc] bestanden = javaBestanden(|project://Jabberpoint/|);

println("7a");
//bepaal de grootte van bestanden (dat is het aantal bestanden)
println(size(bestanden));

println("7b");
// maak een map aan met de bestandsnaam (loc) en het aantal regels. Plaats daarin het aantal regels
// regels is de size van readFileLines voor alle bestanden.
map[loc, int] regels = ( a:size(readFileLines(a)) | a <- bestanden );
// Voer een sort uit op lijst regels, zet daarvoor de map regels om naar een lijst van tuples. 
// geef de waarden uit deze lijst mee aan aflopend, die true terug geeft wanneer de eerste waarde groter is 
// dan de tweede. Durk daarna de file naam en het aantal regels af.
for (<a, b> <- sort(toList(regels), aflopend))
	println("<a>: <b> regels");

println("7c");
// plaats het project Jabberpoint in model
M3 model = createM3FromEclipseProject(|project://Jabberpoint/|);
println(model);
// Zet in methoden de methoden en constructors per class
methoden = { <x,y> | <x,y> <- model.containment,
	x.scheme=="java+class",
	y.scheme=="java+method" ||
	y.scheme=="java+constructor" };
// tel per klasse (het domain van methoden) het aantal keer dat deze voorkomt in methoden. 
// zet de naam en het aantal in telMethoden.
telMethoden = { <a, size(methoden[a])> | a <- domain(methoden) };
// sorteer telMethoden aflopend en print dan alle klassen met methoden af.
for (<a,n> <- sort(telMethoden, aflopend)) println("<a>: <n> methoden");




println("7d");
// neem de extends en plaats die in subklassen, maar draai daarbij de volgorde van subklasse en naam om.
subklassen = invert(model.extends);
// tel daarna voor iedere naam het aantal subklassen
telKinderen = { <a, size((subklassen+)[a])> | a <- domain(subklassen) };
// sorteer het resultaat aflopend en print de regels
for (<a, n> <- sort(telKinderen, aflopend))
	println("<a>: <n> subklassen");


}
