ApplyRules := function(word, rules)
 local choices, rule, pos, newword, wcopy;

  
  choices := []; 
  for rule in rules do #For each applicable rewriting rule 
    pos := PositionSublist(word, rule[1]); #Check if there is a rule applicable to this word.
    while pos <> fail do #For each rule, multiple checks may be required.
      wcopy := ShallowCopy(word);
      newword := Replace(wcopy, pos, pos + Length(rule[1])-1, rule[2]);
      if not newword in choices then 
        Add(choices, newword);
      fi; 
      pos := PositionSublist(word, rule[1], pos); 
    od;
  od;
  return DuplicateFreeList(choices);

end;
######################################################
CheckLibrary := function(word, library)
  local choices, uilist, rows, row, ulist, pos, newword, ui, applicable;
  #Print("\n Input ",word);
  
  applicable := [];
  rows := Length(library);
  ulist := library{[1..rows]}[1];
  for row in [1..rows] do #For each rewriting rule in the library
    ui := ulist[row];
    pos := PositionSublist(word, ui); #Check if there is a rule applicable to this word.
    if (pos <> fail) then 
      Add(applicable, row);
    fi;
  od;
  #Print("\n Apply rules ",applicable);
  return applicable;
end;
######################################################
# queue is a list of words to be explored.
# visited is a list of words that have already been explored.
# rules is the set of rules for getting new words.
######################################################
BFWalk := function(queue, visited, rules)
  local u, uprime, applicable, rule, word, w, newwords; 
    
  while not IsEmpty(queue) do
    u := Remove(queue, 1);
    #Print("\n Dequeued ",u);
    applicable := Unique(CheckLibrary(u, rules));
    if not IsEmpty(applicable) then
      applicable := rules{applicable};
    fi;
    uprime := ApplyRules(u, applicable);
    Apply(uprime, w -> MakeSquareFree(w));
    newwords := Filtered(uprime, w -> not w in visited);
    #Print("\n Applying rules ",applicable," to ",u);
    #Print("\n The new words I get are ",newwords);
    Append(visited, newwords);
    newwords := Filtered(newwords, w -> not w in queue);
    Append(queue, newwords);
    #Print("\n Enqueued ",newwords);
  od;
end;
######################################################
SelectCandidates := function(wordlist, weights, select)
  local tmp, costs, t, i, selected, pos;
  tmp := ShallowCopy(wordlist);
  costs := List(tmp, t -> Sum(List(t, i -> weights[i])));
  if Length(tmp) < select then return tmp; fi;
  selected := []; 
  while Length(selected) < select do
    pos := Position(costs, Minimum(costs));
    Add(selected, Remove(tmp, pos));
    Remove(costs, pos);
  od;
  return selected;
end;
######################################################
MinimalWeightExp := function(word, lib_lessthan, lib_equal, weights)
 local toexplore, seen, newwords, sub, seen_copy, tmp, s, select, best, i;
 toexplore := [word];
 seen := [word];
 newwords := [word];
 select := 5;
 repeat
   seen_copy := ShallowCopy(seen);
   tmp := List(seen_copy, s -> Sum(s, i -> weights[i]));
   best := seen_copy{Positions(tmp, Minimum(tmp))};
   #Print("\n Best candidates at this stage ",best);
   BFWalk(toexplore, seen, lib_lessthan);
   newwords := Filtered(List(seen), s-> not s in seen_copy);
   if not IsEmpty(newwords) then
     continue;
   fi;
   #Print("\n Best = ", best);
   seen := ShallowCopy(best);
   seen_copy := ShallowCopy(best);
   BFWalk(best, seen, lib_equal);
   newwords := Filtered(List(seen), s-> not s in seen_copy);
   #Print("\n New words of same weight ",newwords);
   toexplore := newwords;
 until IsEmpty(newwords);
 return seen_copy;
end;