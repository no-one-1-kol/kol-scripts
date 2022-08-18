import <clan-stash.ash>;
boolean skip_items = true; //skip having all stash items to run garbo?
int vOA = 6000; // base value of adventure
boolean pantagram = false; //use pantagram?

int handle_zatara() {
    if (get_property("_clanFortuneConsultUses") < 3) {
        int retries = 12;
        string clan = "bonus adventures from hell"; // clan to consult in
        string name = "cheesefax"; //person you want to consult
        cli_execute("/whitelist " + clan);
        while ( retries > 0 ) {
            string page = visit_url( "clan_viplounge.php?preaction=lovetester", false );
            page = visit_url( "choice.php?pwd=&whichchoice=1278&option=1&which=1&whichid=" +name+ "&q1=pizza&q2=batman&q3=thick" );
            if ( page.contains_text( "You can't consult Madame Zatara about your relationship with anyone else today." ) ) {
                retries = 0;
                print("No more consults for today", "red");
            }
            if ( page.contains_text( "You enter your answers and wait for " + name + " to answer, so you can get your results!" ) ||
             page.contains_text( "You're already waiting on your results with " + name + "." ) ) {
                print( "Waiting for " + name + " to respond...", "green");
            }
            else if ( page.contains_text( "You can only consult Madame Zatara about someone in your clan.") ) {
                print( name + " is not in the clan. Waiting...", "blue" );
            } else {
                print( "Waiting for " + name + " to respond..."," green");
            }
            retries -= 1;
            waitq( 10 );
        }
    }
    return 0;
}

void ro(){
    while (have_effect($effect[ode to booze]) < 10){
        if (have_skill($skill[The Ode to Booze])) use_skill($skill[The Ode to Booze]);
        else cli_execute("/whisper buffy ode to booze");
    }
    if (have_familiar($familiar[stooper]) && my_inebriety() <= inebriety_limit()) use_familiar($familiar[stooper]);
    if (my_inebriety() < (inebriety_limit()-1)){
        abort("Something went wrong probably");
    }
    if (my_inebriety() < inebriety_limit()){ //stooper drink
        if (item_amount($item[tiny stillsuit]) > 0){
            equip($item[tiny stillsuit]);
            visit_url("inventory.php?action=distill&pwd='+pwdhash+'");
            visit_url("choice.php");
            run_choice(1);
        }
        else if (item_amount($item[Cold One]) > 0){
            drink($item[Cold One]);
        }
        else{
            drink($item[Elemental caipiroska]);
        }
    }
    if (my_inebriety() < inebriety_limit()){
        abort("Something went wrong probably");
    }
    else if(my_level() >= 6 && my_inebriety() == inebriety_limit()){
        cli_execute("/whitelist redemption city");
        if (item_amount($item[emergency margarita]) > 0) overdrink($item[emergency margarita]); //normal nightcap
        else if (stash_amount($item[938]) > 0){ 
            take_stash($item[938], 1); //tiny plastic sword
            if (item_amount($item[grogtini]) > 0){
                overdrink($item[grogtini]);
            }
            else if (item_amount($item[938]) /*tiny plastic sword*/ > 0 && item_amount($item[333]) /*lime*/ > 1 && item_amount($item[787]) /*bottle of rum*/ > 0){ //make a grogtini
                cli_execute("mix grogtini");
                overdrink($item[grogtini]);
            }
        }
    else if (my_level() >= 11 && my_inebriety() == inebriety_limit()){ //backup nightcap
        cli_execute("acquire Psychotic Train wine");
        overdrink($item[Psychotic Train wine]);
    }
    put_stash($item[938], 1); //tiny plastic sword
    }
    if (have_familiar($familiar[Trick-or-Treating Tot]) && item_amount($item[Li'l unicorn costume]) > 0) use_familiar($familiar[Trick-or-Treating Tot]);
    if (have_familiar($familiar[left-hand man])) use_familiar($familiar[left-hand man]);
    if (item_amount($item[burning cape]) == 0 && item_amount($item[vampyric cloake]) == 0 || get_property("valueOfAdventure") > mall_price($item[burning newspaper])){
        cli_execute("acquire burning cape");
    }
    if (my_primestat()==$stat[muscle]) cli_execute("maximize adv, 2 bonus ratskin pajama pants, 1 bonus spacegate scientist, 0.1 bonus green lava lamp, 0.1 bonus blue lava lamp, 0.2 bonus red lava lamp");
    if (my_primestat()==$stat[mysticality]) cli_execute("maximize adv, 2 bonus ratskin pajama pants, 1 bonus spacegate scientist, 0.1 bonus green lava lamp, 0.2 bonus blue lava lamp, 0.1 bonus red lava lamp");
    if (my_primestat()==$stat[moxie]) cli_execute("maximize adv, 2 bonus ratskin pajama pants, 1 bonus spacegate scientist, 0.2 bonus green lava lamp, 0.1 bonus blue lava lamp, 0.1 bonus red lava lamp");
    else cli_execute("maximize adv, 2 bonus ratskin pajama pants, 1 bonus spacegate scientist, 0.1 bonus green lava lamp, 0.1 bonus blue lava lamp, 0.1 bonus red lava lamp");
    use($item[fishy pipe]);
    use($item[universal seasoning]);
}

void main(string arg){
    if( holiday().to_lower_case() == "halloween"){
        print("Warning: Today is halloween, will continue to run script in 15 seconds.", "red");
        wait(15);
    }
    handle_zatara();
    cli_execute("/whitelist redemption city");
    if (get_property("_chronerCrossUsed") == false){ // Do daily events in clan that may not be covered
        cli_execute("shower ice");
        take_stash($item[picky tweezers], 1);
        use($item[picky tweezers], 1);
        put_stash($item[picky tweezers], 1);
        take_stash($item[chroner trigger], 1);
        use($item[chroner trigger], 1);
        put_stash($item[chroner trigger], 1);
        take_stash($item[chroner cross], 1);
        use($item[chroner cross], 1);
        put_stash($item[chroner cross], 1);
    }
    if (get_property("_discoKnife") == false){ // Summon Knife
        use_skill($skill[That's Not a Knife]);
        put_closet($item[soap knife], item_amount($item[soap knife]));
    }
    if (stills_available() > 0){ // Nash Crosby Still
        create(stills_available(),$item[kiwi]);
    }
    if (get_property("_tonicDjinn")==false){ // tonic djinn meat
        cli_execute("acquire tonic djinn");
        visit_url("inv_use.php?pwd=0a2614e9f1c980fdd2c7ca5de8aa6f1f&which=3&whichitem=6421");
        run_choice(1);
    }
    if (get_property("_pantogramModifier") == "" && pantagram){ // Pantagramming
        if(item_amount($item[lead necklace]) < 11){
            buy($item[lead necklace], 11, 3000);
        }
        cli_execute("acquire porquoise");
        cli_execute("pantogram mox|stench|max mp|clover|high meat|force|familiar|silent");
    }
    if (my_class() == $class[seal clubber]){
        vOA = vOA + 300;
    }
    set_property("garbo_vipClan", "redemption city"); // Set prefs for garbo
    set_property("garbo_stashClan", "redemption city");
    set_property("garbo_fightGlitch", true);
    set_property("garbo_buyPass", true); // change to false if you have charter
    if (have_effect($effect[Human-Fish Hybrid]) > 5000){
        set_property("valueOfAdventure", vOA + 125);
    }
    use($item[universal seasoning]);
    use($item[universal seasoning]);
    if ((have_effect($effect[Feeling Lost]) < 0)){
        cli_execute("uneffect feel lost");
    }
    if (item_amount($item[ChibiBuddy&trade; (off)]) == 1){ // turn chibibuddy on
        visit_url("inv_use.php?pwd='+pwdhash+'&which=f2&whichitem=5925");
        visit_url("choice.php");
        run_choice(1);
    } 
    if (item_amount($item[ChibiBuddy&trade; (on)]) > 0) cli_execute("ChibiParent"); // call decent chibi management script
    if (get_property("dinseyRapidPassEnabled") == true){ // disable fast pass if it is enabled
        visit_url("place.php?whichplace=airport_stench&action=airport3_tunnels");
        run_choice(1);
        run_choice(2);
        run_choice(6);
    }
    if(arg.to_int() != 0){
        if (clan_stash("check") || skip_items){
            print("running garbo"+arg);
            cli_execute("garbo "+arg);
        }
        else print("stash items missing","red");
    }
    else if(arg == "nobarf" || arg == "nb"){
        if (clan_stash("check") || skip_items){
            print("running garbo nobarf", "blue");
            cli_execute("garbo nobarf");
        }
        else print("stash items missing","red");
    }
    else if(arg == "ascend" || arg == "a"){
        if (clan_stash("check") || skip_items){
            print("running garbo ascend", "blue");
            cli_execute("garbo ascend");
        }
        else print("stash items missing","red");
    }
    else if(arg == "nogarbo" || arg == "ng") print("skipping garbo completely", "blue");
    else if(arg == "rollover" || arg == "ro" || arg == "r"){
        print("doing rollover stuff");
        ro();
    }
    else if(arg == "yachtzeechain" || arg == "y"){
        if (clan_stash("check") || skip_items){
            print("running garbo yachtzeechain", "blue");
            use($item[one-day ticket to Spring Break Beach]);
            cli_execute("garbo yachtzeechain");
            ro();
        }
        else print("stash items missing","red");
    }
    else if(arg == "help" || arg == "h"){
        print("lazy_garbo help:", "blue");
        print("Arguments: ");
        print("help / h: displays this message");
        print("0 / blank / random stuff: runs start of day stuff then garbo normally then rollover instructions");
        print("any integer (negatives included): runs start of day stuff then garbo with that number of turns (negative means to leave the number of turns at the end");
        print("ascend / a: runs start of day stuff then garbo ascend");
        print("nobarf / nb: runs start of day stuff then garbo nobarf");
        print("nogarbo / ng: runs start of day stuff only");
        print("yachtzeechain / y: runs start of day stuff then garbo yachtzeechain then rollover instructions");
        print("rollover / ro / r: runs start of day stuff then rollover instructions");
    }
    else{
        if (clan_stash("check") || skip_items){
            print("running garbo", "blue");
            cli_execute("garbo");
            ro();
        }
        else print("stash items missing","red");
    }
    cli_execute("/whitelist redemption city");
    print("Script has finished running","blue");
}


