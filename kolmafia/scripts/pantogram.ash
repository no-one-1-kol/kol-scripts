// Pantogram.ash 1.2
// by Zarqon
script "Pantogram.ash";
notify Zarqon;
import <zlib.ash>

record onesac {
   item tosac;
   int needed;
   string keywords;
};
onesac[string, string] sacs;  // form category, form value => record
file_to_map("pantodata.txt",sacs);

string[string] pf;          // pants form choices
boolean[string] configgerd; // choices already made
boolean silent, force;      // globals to be set by keywords
// set defaults
switch (my_primestat()) {
   case $stat[muscle]: pf["m"] = "1"; break;
   case $stat[mysticality]: pf["m"] = "2"; break;
   default: pf["m"] = "3";
}
pf["e"] = "5";  // stench
pf["s1"] = my_maxmp() < 50 ? "-2,0" : "-1,0";  // +max mp/hp
pf["s2"] = my_primestat() == $stat[mysticality] ? "-2,0" : "-1,0";  // spell/wpn dmg
pf["s3"] = "-1,0"; // -combat

boolean pantsme() {
   string choiceinf(onesac s) {
      buffer res;
      if (s.tosac != $item[none]) {
         res.append(rnum(s.needed)+" ");
         res.append(s.needed > 1 ? s.tosac.plural : s.tosac.to_string());
         res.append(" for ");
      }
      res.append(split_string(s.keywords,"\\|")[0]);
      return res.to_string();
   }
   if (!silent) {
      buffer conf;
      conf.append("You are about to summon pants with ");
      boolean popped;
      foreach cat,form in pf {
         if (popped) conf.append(", "); else popped = true;
         if (cat == "s3") conf.append("and ");
         conf.append(choiceinf(sacs[cat,form]));
      }
      conf.append(".  Proceed?");
      if (!user_confirm(conf.to_string())) return false;
   }
   buffer purl;
   purl.append("choice.php?whichchoice=1270&pwd&option=1");
   foreach k in $strings[m, e, s1, s2, s3] {
      purl.append("&"+k+"="+pf[k]);
      if (!retrieve_item(sacs[k,pf[k]].needed, sacs[k,pf[k]].tosac))
         return vprint("Unable to ready "+sacs[k,pf[k]].needed+" "+sacs[k,pf[k]].tosac,-3);
   }
   visit_url("inv_use.php?pwd&whichitem=9573");
   visit_url(purl.to_string());
   return have_item($item[pantogram pants]) > 0;
}

boolean pants_choice(string cat, string form) {
   if (configgerd[cat]) vprint("Multiple choices specified for the '"+cat+"' slot.  "+
      (force ? "Overwriting prior choice..." : "Use the 'force' keyword if you want to overwrite choices and continue."), -force.to_int());
   item i = sacs[cat,form].tosac;
   int willeat = sacs[cat,form].needed;
   if (have_item(i) + creatable_amount(i) < willeat)
      return vprint("You lack the specified "+rnum(willeat)+" "+(willeat > 1 ? i.plural : i.to_string())+" for slot '"+cat+"'."+
         (force ? "  Falling back to prior selection." : ""), -force.to_int());
   configgerd[cat] = true;
   pf[cat] = form;
   return true;
}

boolean findsac(string w) {
   foreach cat,form,rec in sacs 
      if (list_contains(rec.keywords,w,"|")) return pants_choice(cat,form);  // first, check keywords
   if (w.to_item() != $item[none]) foreach cat,form,rec in sacs 
      if (rec.tosac == w.to_item()) return pants_choice(cat,form);  // next, maybe it's an item
   return vprint("Unknown pantogram keyword '"+w+"'.  Type 'pantogram help' for a list of keywords.",0);
}

void printhelp() {
   buffer h;
   h.append("Add any of the below keywords/phrases in a pipe-delimited list to customize your pants.  Keywords can also be items.  Not all slots must be specified; omissions will use the bolded default below.  Example command: pantogram muscle|cold|silent");
   string nowslot;
   foreach cat,form,rec in sacs {
      if (cat != nowslot) {
         h.append("<h3>Slot "+cat+"</h3>");
         nowslot = cat;
      }
      if (pf[cat] == form) h.append("<b>");
      h.append(rec.keywords.replace_string("|"," | "));
      if (pf[cat] == form) h.append("</b>");
      if (rec.tosac != $item[none]) {
         h.append(" - requires ");
         if (rec.needed > 1) h.append(rnum(rec.needed)+" "+rec.tosac.plural);
          else h.append(rec.tosac.to_string());
         h.append(" (<span style='color:green'>"+rnum(mall_val(rec.tosac,3)*rec.needed)+"&mu;</span>, you have "+rnum(item_amount(rec.tosac))+")");
      }
      h.append("<br>");
   }
   h.append("<h3>No slot</h3>");
   h.append("silent - suppress the confirmation message<br>default - simply use all the default selections (same as empty string but facilitates automation)<br>");
   h.append("force - when missing the specified item, fall back to pre-existing choice rather than abort. Also, override rather than abort in the case of multiple selections for a single slot (allows prioritized lists).");
   print_html(h.to_string());
}

void main(string params) {  // specify pipe-delimited stat|element|items|modifiers to override defaults
   foreach i,s in split_string(params,"\\|") switch (s) {
      case "silent": silent = true; break;
      case "force": force = true; break;
      case "help": printhelp();  // you can set choices prior to initiating help!
      case "default": break;
      default: findsac(s);
   }
   if (params == "help") return;
   if (item_amount($item[portable pantogram]) == 0) vprint("No portable pantogram found.",0);
   if (have_item($item[pantogram pants]) > 0) vprint("You've already summoned pants today.",0);
   if (pantsme()) vprint("Pantalones summonated.",3);  // there is no "you acquire an item" message in the CLI!
    else vprint("Unable to summon pants.  Type 'pantogram help' for more info.",-3);
}