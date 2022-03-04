/*Wykorzystując słownik/i, oraz dotychczasową wiedzę stwórz własną, spójną, logiczną grę paragrafową (przykłady profesjonalnych).

uwagi:
- proszę o minimum 15 paragrafów, rozgałęzienia, zapętlenia w akcji i zakończenie/a,
- tworząc rysuj/zapisuj drzewo zależności - ułatwi ewentualną ocenę,
- decydujemy o akcji poprzez "a"/"b"/"c"/itd. - nie wpisujemy wprost numeru paragrafu do którego się udajemy,
- zadbaj o grafiki (mogą być "z sieci"). Konwerter na ASCII arty (+opcja invert)*/

import Foundation;

enum Colours: String 
{
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case blue = "\u{001B}[0;34m"
    case cyan = "\u{001B}[0;36m"
    case magenta = "\u{001B}[0;35m"
    case yellow = "\u{001B}[0;33m"
    case black = "\u{001B}[0;30m"
    case white = "\u{001B}[0;37m"
    case defaultColour = "\u{001B}[0;0m"
}

func getColouredString( _ colour: Colours, _ string: String ) -> String
{
    return colour.rawValue + string + Colours.defaultColour.rawValue;
}


class Paragraph
{
    var title: String;
    var text: String;
    var image: String?;
    var options: [String: Option] = [:];
    var newOptionKey: String = "A";
    var isThisTheEnd: Bool = false;

    init( title: String, text: String = "Lorem ipsum dolor sit amet", options: [Option]? = nil, ASCIIArt: String? = nil, ending: Bool = false )
    {
        self.title = title;
        self.text = text;
        self.isThisTheEnd = ending
        self.image = ASCIIArt;

        if options != nil
        {
            addOptions( options! );
        }
    };

    func addOption( _ option: Option ) -> Void
    {
        self.options[ self.newOptionKey ] = option;
        self.setNewOptionKey();
    }

    // consumes item?
    func addOption( text: String, goesTo: Paragraph ) -> Void
    {
        let tmp: Option = Option( text: text, target: goesTo );
        self.options[ self.newOptionKey ] = tmp;
        self.setNewOptionKey();
    }

    func addOptions( _ options: [Option] ) -> Void
    {
        for option in options
        {
            self.addOption( option );
        }
    }

    func setNewOptionKey() -> Void
    {
        let val: Character = Array( self.newOptionKey )[0] as Character;
        self.newOptionKey = String( UnicodeScalar( val.asciiValue! + 1 ) );
    }

    func show( showText: Bool = true ) -> Void
    {
        if( showText )
        {
            print( getColouredString( Colours.yellow, "\n"+self.title.uppercased() ), terminator: "\n\n" );
            if( self.image != nil )
            {
                linePrinter( self.image! );
                // print( self.image!, terminator: "\n\n" );
            }
            // print( self.text, terminator: "\n\n" );
            charPrinter( self.text );
            print( "\n" );
        
            for key in self.options.keys.sorted()
            {
                let string: String = key + ") " + self.options[ key ]!.text;
                print( string );
            }
        }
        // print( self.options );
        if( !self.isThisTheEnd )
        {
            let input: String = readLine()!.uppercased();
            if( !self.options.keys.contains( input ) )
            {
                print( getColouredString( Colours.red, "[[ Nieprawidłowa opcja ]]" ) );
                self.show( showText: false );
                return;
            }
            else
            {
                options[ input ]!.show();
            }
        }
    }
}


struct Option {
    var text: String;
    var target: Paragraph;

    func show() {
        self.target.show();
    }
}


// prints string one character at a time
func charPrinter( _ str: String, interval: Double = 0.05 )
{
    var realInterval: Double = interval;
    // let workItem = DispatchWorkItem{
    //     var _ = readLine();
    //     realInterval = 0;
    // }
    // DispatchQueue.global().asyncAfter( deadline: .now(), execute: workItem );

    for char in str
    {
        // print( workItem.isCancelled );
        print( char, terminator: "" );
        if char == "."
        {
            Thread.sleep( forTimeInterval: realInterval * 6 );
        }
        else
        {
            Thread.sleep( forTimeInterval: realInterval );
        }
        
    }
    // workItem.cancel();
    print("\n");
}
func linePrinter( _ str: String, interval: Double = 0.02 )
{
    let lines = str.split( separator: "\n" );
    for line in lines
    {
        print( line );
        Thread.sleep( forTimeInterval: interval );
    }
    Thread.sleep( forTimeInterval: interval );
    print("\n\n");
}

// var start: Paragraph = Paragraph( title: "Pole startowe", text: "To jest pole startowe piszę to dla jaj" );
// var boisko: Paragraph = Paragraph( title: "Boisko do piłki nożnej" );
// start.addOption( text: "Idź na boisko", goesTo: boisko );
// start.addOption( text: "Idź na boisko", goesTo: boisko );
// start.addOption( text: "Idź na boisko", goesTo: boisko );





let starWarsASCII: String = 
"""
                ....................::.  .:.....:.     .:..........             
             .!YPGGGGGGGGGGGGGGGGGGGGB5 ^GGGGGGGB5.   .PGGGGGGGGGGGPJ^          
             J##BBBBB######BBBBB######P.P#BBB#BBB#?   .GBBBBBBGGBBBB#B!         
             5#BBBBBY!~!!~7BBBBBJ!!!!!~?BBBBBYBBBBB^  .PBBBBB7~~!GBBB#Y         
             .YBBBBBB5:   :BBBBB~     :BBBBBY.YBBBBP. .PBBBBBBBBBBBBB5:         
   .!77777777!7YBBBBB#G.  :BBBB#~     5BBBBBGPGBBBBB? .PBBBBB#BBBBBBY7!7!!77:   
   ^#######BB##BBBBBB#P.  :BBBB#~    !#BBBBBBBBBBBBBB^.PBBBBB75BBBBBB#######^   
   ^BBBBBBBBBBBBBBBBGJ:   :BBBBB~   .PBBB#Y:::::5BBBB5.PBBBBB: ~5GBBBBBBBBBG^   
   :?JJJJ?~^?JJJJJ?::!!!!!~^^?JJ7!!!7?^^^^.:!!!!7JJJJJ!7~^^^^.  :!?JJJJJJJJJ:   
    Y#BBB#?^BBBBBBB:7##BB#! ~BBBB#BBBB~    ?#BBBBB#BBBBBGY:   ~5BBBBBBBBBBBB^   
    :GBBBBGPBBBBBBBPGBBB#Y .P#BBBBBBBBP.   ?#BBBBGYYYPBBB#G. :BBBBBBBGGGGGGG^   
     !#BBBBBBBBBBBBBBBBBG: ?#BBBB7PBBB#?   ?#BBBBP!!7YBBB#G. .5#BBBBBJ^.::::.   
      Y#BBBBBBBBBBBBBBB#! ^BBBBB5:J#BBBB~  ?#BBBBBB#BBBBGY^   .?GBBBBBP^        
      :GBBBBBBGJBBBBBB#Y .5BBBBBBBBBBBBBP. ?#BBBBGB#BBBBGYY555YYPBBBBB#5        
       7#BBBB#? 5#BBBBB: 7#BBBBPP555BBBB#? ?#BBB#J~5B#BBB#######BBBBB#B!        
       .JPPPPY. ^PPPPP7 :5PPPP?     7PPPP5:7PPPPP7 .~J5PPPPPPPPPPPPP5?^.^.
	   
					 'JAK ROZPĘTAŁEM II WOJNĘ GALAKTYCZNĄ'
""";
let bed: String = 
"""
((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
((((((@@@@@@@@@((((((((#@@%@@@@@@((((@(((#@@&(((((((((((((((((((((((((((((((((((
((((((@@((((((((((@(((((@@((((&(@(((&@(((((((@((((((((((((((((((((((((((((((((((
((((((@@(((@@@((((((((((@@(((((@@(((@@(@##(((@((((((((((((((((((((((((((((((((((
((((((@@(((@((((((((@((#@@(((((@@(((@@(((((%%((((((((#(@@@@@@@((((((((((((((((((
((((((@@(((@@@((((((&((#@@(((@@@@(((@@((@@((((((((@@@.,..&&&&&@@((((((((((((((((
((((((@@(((((((((@#((((#@@(((((@@(((@(((((#((#((@@#####/###&&&&,@(((((((((((((((
((((((@@(((@@@(((((@((((@@(((%@#(((((&@@@@@@@@@@,,(#######/##&&&/.,.@@@@@@@(((((
((((((@@(((@((@((((@((((@@@(((((@@@@@@@.@@&&&&@.(,.###########.%@@@&,&@,,@@(((((
((((((@@((((((((((@((((((##@@@@@.((((((((((,%@&&&&&@&,#####(*@@@.@@@@@@.@(((((((
((((((@@((((#@@((((((@@@@@@.(((((((((((((((((((*&&&&&&&,,,@@@&%@@@@@@*&,,@#(((((
((((((@#(((((#(@@@@@@./((((((((((((((((((((((((((((,%&&&@,&@@@@@@@%*&@.@@,@(((((
(((((((((@@@@@@@*/(((((((((((((((((((((((((((((((((((((((,%&&,&%&&@@@@@@@.@@((((
(#(@@@@@@@,.((((((((((((((((((((((((((((((((((((((((((((((((*&,@@@@@@@@@@,@@((((
@@@,.(((((((((((((((((((((((((((((((((((((((((((((((((((((((((%@@@@@@@@@@(@@((((
((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((.,@@@@@@@@@.@@((((
(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((%(@@@@@@@@,@@((((
((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((*@@@@@@@@.,@@@((((
"""
let imperialOfficer: String =
"""
                                                                                
                                   ^?YYJ7?7^                                    
                                  Y##GPJ7JJY?.                                  
                                 .###BP5YYYYY:                                  
                                  J##BP5YJJJ7                                   
                                  J5GBPJYPJ?~                                   
                                :!BJ57J7^!^:                                    
                               .B&@GJ?57^^:                                     
                                !B&&GPY7!^.                                     
                                .~Y#&B5!~!Y                                     
                           :!7JY5GGGGP5J?Y57^:                                  
                        .!5GP555P555555YJJJ?77~^:.                              
                      .7PP5PGY?YGG5Y55YYYJ???JJ7!?.                             
                    :75555PPBBGGGG5Y55Y5YJJJ?YJ7~Y!                             
                  !5PP55PYJ77#&&BGP5YYY5YYYJJJ?JYYJ                             
                ~PGP5P5?:    ~G##BP55555YYYYYJJJ5YY.                            
               Y#GP55!.       !P##GP555555YY5YJJYYY^                            
               7##GPJ          5B#GPP5YYY5555PY55YY:                            
                :P#G5J^        ^##BP5PP5YY5YYPY55YY^                            
                  7GGPP!.       P&&#BGP5Y?^!5P5555Y?                            
                   .JBGPY!.    .G@@&&B5Y~^ .#&G?P5YY.                           
                     ~GGB#&##&&BBB#BBGP5Y7^~5P5~P5YY7                           
                      .^75G#&&&#GGBGPPP55YYYJJJ7!PYYY:                          
                            .G#GGGBBGPP55YYJJYYJ^!5YY?                          
                            .GBBGGGGGPPP5YYYYYYJJ.75YY^                         
                            Y##BGPPPGGPP5YYYYYYJY! J5YJ.                        
                            G#BBBGPPPGP5YYYYYYJJJY. 5P5?                        
                           !B##BBGGGPP55555555YYYY? .#&#:                       
                          ^&##BPGB5PGGBB##BBGGPYJJY! !&&5                       
                         .B&#BBP5#YY55PB&BGGPPP5JJY5!.#&B                       
                        .B&&##B5PBYYYY5#&#GPPPP5YJJY5!G&?                       
                        !###BBP5PPYYY5J?&&#GPPP5YYJJY?:.                        
                        7BGGGPPPPYYYY5~ B&#BPP55YYJJJY:                         
                        .GBBGGGP5YYYYY. ~&##G5PP5YJJJJ.                         
                         .5BGBGG5YYYY?   5###G5Y5PYJJ^                          
                           YGGGG5YYYY:   .GB#BG5Y5P5^                           
                            YBGPYYYY?     ^GBBGP5Y5?                            
                            :BBG5YYY!      ?GPGGPYJ!                            
                            .GGPP5YY.       !PPPP55~                            
                            .#&#PGB~         Y&###&7                            
                             B&&G#&!         !&#B&&G                            
                             G&&B#&J         ^&&B#&#.                           
                             J&&B#&J         .#&##&&:                           
                             ~&&GB&J          5&##&&~                           
                             ^&&B#&?          ^&&#&&?                           
                             .#&BB&?           B&##&Y                           
                              B&##&!           7&&#&G                           
                              G&GB&!           .#&&&#                           
                              J#GB&!           .B&&&#~                          
                             .YPGG#J           ^BB##&P                          
                             !YG5PB^           .PGGB##5.                        
                            .Y5P5B5             !5GB#B#G.                       
                            ^BBG#B:               :P##&#P.                      
                             :^::                    ...                         
"""
let rebelAlliance: String = 
"""
                                       ::                                       
                                     :^^^^:                                     
                                   .^^^^^^^^.                                   
                                 .^^^^^^^^^^^^.                                 
               .:.               .^^^^^^^^^^^^.               .:.               
             :^:                  .^^^^^^^^^^.                  :^:             
           :^^.            .^^^.   :^^^^^^^^:   .^^^.            .^^:           
         :^^^.           .^^^^^^^:  ^^^^^^^^  :^^^^^^^.           .^^^:         
       .^^^^.            ..:^^^^^^^:^^^^^^^^:^^^^^^^:..            .^^^^.       
      :^^^^:                 :^^^^^^^^^^^^^^^^^^^^:                 :^^^^:      
     ^^^^^^                    :^^^^^^^^^^^^^^^^:                    ^^^^^^     
    ^^^^^^:                     :^^^^^^^^^^^^^^:                     :^^^^^^    
   ^^^^^^^.                      :^^^^^^^^^^^^:                      .^^^^^^^   
  ^^^^^^^^.                       ^^^^^^^^^^^^                       .^^^^^^^^  
 .^^^^^^^^:                       .^^^^^^^^^^.                       :^^^^^^^^. 
 ^^^^^^^^^^                        ^^^^^^^^^^                        ^^^^^^^^^^ 
.^^^^^^^^^^.                       ^^^^^^^^^^                       .^^^^^^^^^^.
:^^^^^^^^^^^.                      ^^^^^^^^^^                      .^^^^^^^^^^^:
^^^^^^^^^^^^^.                    :^^^^^^^^^^:                    .^^^^^^^^^^^^^
^^^^^^^^^^^^^^:                  .^^^^^^^^^^^^.                  :^^^^^^^^^^^^^^
^^^^^^^^^^^^^^^^.               .^^^^^^^^^^^^^^.               .^^^^^^^^^^^^^^^^
:^^^^^^^^^^^^^^^^^:.          .:^^^^^^^^^^^^^^^^:.          .:^^^^^^^^^^^^^^^^^:
.^^^^^^^^^^^^^^^^^^^^^::..::^^^^^^^^^^^^^^^^^^^^^^^^::..::^^^^^^^^^^^^^^^^^^^^^.
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
 .^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^. 
  :^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:  
   :^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:   
    :^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:    
     :^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:     
      .^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^.      
        :^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:        
         .^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^.         
           .:^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:.           
              :^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:              
                .:^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:.                
                    .:^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^:.                    
                        .::^^^^^^^^^^^^^^^^^^^^^^^^^^::.                        
                             ...::^^^^^^^^^^^^::...                              
"""


// starting the intro
charPrinter( getColouredString( Colours.cyan, "                   Dawno dawno temu, w odległej galaktyce...                    " ) );
linePrinter( getColouredString( Colours.yellow, starWarsASCII ), interval: 0.6 );

let story: [ String : Paragraph ] = [
    "start": Paragraph( title: "",
                        text: "'No i masz. Znowu w tej dziurze.' - słyszysz swoje myśli podnosząc się z łóżka. Od kiedy zostawili cię na pastwę losu nie marzysz o niczym innym jak odlecieć gdzieś daleko w stronę migoczących gwiazd. Na razie to tylko wymysł twojej wyobraźni, ale może dzisiaj wreszczie nadszedł dzień wybawienia...?",
                        ASCIIArt: bed
                    ),
    "street": Paragraph( title: "Ulica niedaleko mieszkania", 
                            text: "Jesteś na zewnątrz otoczony hukiem miasta i tłumu ulicznego.\nCo chcesz teraz zrobić?"
                    ),
    "junction": Paragraph( title: "Rozwidlenie",
                            text: "Chwilę idziesz ulicą przyglądając się otaczającym cię budynkom, ludziom i kosmitom. Docierasz do rozwidlenia."
                    ),


    "alleyway": Paragraph( title: "Uliczka",
                            text: "Jesteś w mniejszej uliczce, gdzie tłok nie jest tak dotkliwy. Ze znudzeniem przyglądasz się ścianom licząc, że coś się wydarzy. Z monotonii szarych ścian wyróżnia się jedynie jakiś plakat świecący czerwienią."
                    ),
    "poster": Paragraph( title: "Plakat werbunkowy",
                            text: "Z zaciekawieniem podchodzisz do plakatu. Widnieje na nim wielki napis \(getColouredString(Colours.red, "DOŁĄCZ DO IMPERIUM")) razem z rysunkami kilku pilotów w czarnych mundurach stojącymi przed jedynymi w swoim rodzaju w kategorii wyglądu myśliwcami TIE.\nImperialni. Udało ci się już o nich zapomnieć. Okupanci ze łbami zakutymi w białe wiadra. Czy ich nienawidzisz? W zasadzie to nie - po prostu trochę za bardzo się panoszą na nie swojej planecie.\nWtedy do głowy wpada ci pomysł - 'A gdyby tak...'. Nagle jak spod ziemi pojawia się obok ciebie oficer w szarym mundurze i skórzanych rękawiczkach w towarzystwie dwóch Szturmowców w charakterystycznych białych pancerzach." ),
    "posterConversation1": Paragraph( title: "Rozmowa z oficerem imperialnym",
                            text: "'Witajcie obywatelu! Jesteście zainteresowani służbą dla Imperium, utrzymywaniem pokoju i porządku w galaktyce, a może szukacie kariery wojskowej?'",
                            ASCIIArt: imperialOfficer
                    ),
    "posterConversation2": Paragraph( title: "Rozmowa z oficerem imperialnym",
                            text: "'Nieukrywam, że przesz-' - 'Wspaniale! Takich ludzi potrzebujemy w marynarce!' - przerywa ci wojskowy - 'Zaraz możemy ci załatwić miejsce w Akademi.' - mówi z uśmiechem.\nJaka jest twoja ostateczna odpowiedź?"
                    ),
    "posterConversationDenial": Paragraph( title: "Rozmowa z oficerem imperialnym",
                            text: "'Jednak nie? Jaka szkoda... No nic, miłego dnia i pamiętajcie, że zawsze możecie do nas dołączyć!' - mówi oficer i żegnając się odchodzi."
                    ),
    "posterConversationAccept": Paragraph( title: "Zaciągniecie do marynarki",
                            text: "Oficer prowadzi cię do biura gdzie wypełniacie potrzebne dokumenty. Zanim w pełni dotarło do ciebie co się dzieje już wsadzili cię na prom do Caridy. Tak spełniasz marzenie ucieczki z Corelli rozpoczynając przygody we flocie Imperium Galaktycznego.\n\(getColouredString(Colours.green, "                     [[ ZAKOŃCZENIE ZWIĄZANIEM Z IMPERIUM ]]                    "))",
                            ending: true
                    ),
    "posterConversationInsult": Paragraph( title: "Zatrzymanie",
                            text: "'O ty! Nie będziesz tak traktować oficera! Zabierzcie go, chłopcy!' - mówi z oburzeniem wojskowy zwracając się jednocześnie do towarzyszących mu żołnierzy. Szturmowcy obezwładniają cię i zakładają kajdanki. Potem prowadzą cię przez kolejne ulice i korytarze w nieznane miejsce..."
                    ),

    "arrestEscapeOption": Paragraph( title: "Transport do aresztu",
                            text: "'Hej, wiadrogłowi!' - słyszysz krzyk gdzieś z boku. Sturmowcy odwracają się zdezorientowani - to twoja szansa na ucieczkę. Jaka jest twoja decyzja?"
                    ),
    "arrestComply": Paragraph( title: "Transport do aresztu",
                            text: "'Lepiej nie pogarszać sprawy' - myślisz stojąc w bezruchu. Żołnierze nie mogąc znaleźć sprawcy incydentu silnym pchnięciem dają ci znać, żeby iść dalej."
                    ),
    "arrestFinal": Paragraph( title: "Areszt",
                            text: "Po pewnym czasie docieracie do budynku, który zapewne jest aresztem. Wrzucony do celi z jakimś Rodianinem żałujesz niewykorzystanej szansy ucieczki. Nie wiadomo, czy twoje życie kiedykolwiek wróci do normalności...\n\(getColouredString(Colours.red, "                        [[ ZAKOŃCZENIE ARESZTOWANIEM ]]                         "))",
                            ending: true
                    ),

    "arrestEscape": Paragraph( title: "Ucieczka!",
                            text: "'Teraz albo nigdy!' - mówisz pod nosem zrywając się z miejsca. Biegniesz do najbliższej uliczki. Byle jak najdalej i jak najszybciej."
                    ),
    "resistanceIntroduction": Paragraph( title: "? ? ?",
                            text: "Nagle ktoś łapie cię za ramie i wciąga w jeden z licznych zaułków. 'Strach! Rany boskie! Trzeba było odsiedzieć swoje i mieć święty spokój...' - przebiega przez twoją głowę męczoną już najgorszymi przeczuciami. Jednak przed sobą widzisz nie żołdaka w białej zbroi, nie rasowego przedstawiciela tutejszego przestępczego półświatka, a całkiem zwyczajnie wyglądającą Twi'lekankę.\n'Czemu cię wzieli?' - pyta kobieta nie rozluźniając swojego uścisku. 'Trochę nawymyślałem jakiemuś oficerowi.' - odpowiadasz z zaskoczeniem. 'Dobra, sprawdzimy cię później. Chodź ze mną jeśli chcesz przeżyć!' - mówi podając ci rękę. Na jej przedramieniu widać tatuaż. Po sekundzie przypominasz sobie skąd go znasz - wygląda dokładnie jak symbol Rebelii. Czyli wszystko jasne. Teraz tylko, czy chcesz plątać się w to wszystko?",
                            ASCIIArt: rebelAlliance
                    ),
    "resistanceDenial": Paragraph( title: "Ucieczka...?",
                            text: "'Zwariowałaś?! Nawet cię nie znam! Poradzę sobie bez ciebie.' - mówisz z pewnością w głosie. 'Echh, no dobra, jak tam chcesz. Tylko nie mów, że nie ostrzegałam!' - mówi kobieta i po chwili znika ci z oczu.\nW tym momencie wszystkie drogi dalszej ucieczki zasłaniają ci Szturmowcy, którym dopiero co udało ci się zwiać. 'Jest okej.' - myślisz czując silne uderzenie blasterem w brzuch - 'Wszystko jest wporzo'. Wojskowi ponownie prowadzą cię w tylko im znanym kierunku jednak tym razem nie spuszczając z ciebie oczu nawet na sekundę."
                    ),
    "resistanceAccept": Paragraph( title: "Lance do boju, blaster w dłoń,\nimperialnych goń, goń, goń!",
                            text: "'Raz się żyje...' - chwytasz dłoń kobiety, a ona wciąga cię przez imponująco wtapiające się w otoczenie drzwi do pomieszczenia pełnego ludzi i muzyki. Wygląda na bar czy kantynę. Przeciskacie się przez tłum i po chwili wchodzicie do dużo cichszej części budynku. Wszyscy tutaj mają w pewnym miejscu na ciele ten sam tatuaż co twoja wybawicielka. I broń. Wszyscy są uzbrojeni.\n'Witamy w Rebelii!' - mówi Twi'lekanka z uśmiechem. Wygląda na to, że nie ma już odwrotu. No cóż, może pora przysłużyć się galaktyce...?\n\(getColouredString(Colours.cyan, "                     [[ ZAKOŃCZENIE ZWIĄZANIEM Z REBELIĄ ]]                     "))",
                            ending: true
                    ),
];

// OPTIONS
story[ "start" ]!.addOption( Option( text: "DALEJ >>", target: story[ "street" ]! ) );

story[ "street" ]!.addOptions( [
    Option( text: "Spacer po miejskiej okolicy", target: story["junction"]! ),
    // Option( text: "Wizyta w barze 'Varnis'" )
] );
story[ "junction" ]!.addOptions( [
    Option( text: "Idź w lewo", target: story["alleyway"]! ),
] );



story[ "alleyway" ]!.addOptions( [ 
    Option( text: "Przyjrzyj się plakatowi z bliska", target: story[ "poster" ]! ),
    Option( text: "Zignoruj go i idź dalej", target: story[ "street" ]! )
 ] );

 story[ "poster" ]!.addOptions( [
     Option( text: "DALEJ >>", target: story[ "posterConversation1" ]! ),
 ] );

  story[ "posterConversation1" ]!.addOptions( [
     Option( text: "Tak", target: story[ "posterConversation2" ]! ),
     Option( text: "Nie", target: story[ "posterConversation2" ]! )
 ] );
 story[ "posterConversation2" ]!.addOptions( [
     Option( text: "'Zgoda'", target: story[ "posterConversationAccept" ]! ),
     Option( text: "'Odmawiam'", target: story["posterConversationDenial" ]! ),
     Option( text: "'Imperialny oficerze - spadaj pan' <-    ugrzecznione", target: story[ "posterConversationInsult" ]! )     // impe
 ] );
 story[ "posterConversationDenial" ]!.addOptions( [
     Option( text: "DALEJ >>", target: story[ "alleyway" ]! ),
 ] );

story[ "posterConversationInsult" ]!.addOptions( [
    Option( text: "DALEJ >>", target: story[ "arrestEscapeOption" ]!  )
] );
story[ "arrestEscapeOption" ]!.addOptions( [
    Option( text: "Spróbuj uciec", target: story[ "arrestEscape" ]!  ),
    Option( text: "Zostań tam, gdzie jesteś", target: story[ "arrestComply" ]!  )
] );
story[ "arrestComply" ]!.addOptions( [
    Option( text: "DALEJ >>", target: story[ "arrestFinal" ]!  )
] );

story[ "arrestEscape" ]!.addOptions( [
    Option( text: "DALEJ >>", target: story[ "resistanceIntroduction" ]!  )
] );
story[ "resistanceIntroduction" ]!.addOptions( [
    Option( text: "Weź rękę Twi'lekanki", target: story[ "resistanceAccept" ]!  ),
    Option( text: "Odmów", target: story[ "resistanceDenial" ]!  )
] );
story[ "resistanceDenial" ]!.addOptions( [
    Option( text: "DALEJ >>", target: story[ "arrestFinal" ]!  )
] );






story[ "start" ]!.show();

