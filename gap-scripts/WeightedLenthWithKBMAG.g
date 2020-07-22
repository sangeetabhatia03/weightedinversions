###################
# For some weird reason, calling RelationsAsId as a function returns me an incomplete list!!
# while executing it line by line on the prompt gives the right set.
# no idea what is going on here, I'm going to dismantle this beautful modular logic and copy-paste 
###################
RelationsAsId := function(n)
  local numgens, relations, rules, i, keys, key;

  relations := AllRelations(n, 1);  
  rules := [];

  keys := Keys(relations);
  for key in keys do
    Add(rules, Concatenation(relations[key], key));
  od;
  numgens := n * (n-1)/ 2;
  Perform([1..numgens], function(i) Add(rules, [i,i]); end);
  return rules;
end;

###################

MakeRewritingSystem := function(G, weights)
  local R;

  R := KBMAGRewritingSystem(G);
  SetOrderingOfKBMAGRewritingSystem(R, "wtlex", weights);
  KnuthBendix(R);
  return R;
end;

###################
AllInversionsAsQuotientGroup := function(n)
  local numgens, F, tmp, G, rules, relations, keys, key, i;

  numgens := n * (n-1)/ 2; 
  F       := FreeGroup(numgens);
  # See comments above RelationsAsId
  relations := AllRelations(n, 1);  
  rules := [];

  keys := Keys(relations);
  for key in keys do
    Add(rules, Concatenation(relations[key], key));
  od;
  Perform([1..numgens], function(i) Add(rules, [i,i]); end);

  tmp     := [];
  Perform(rules, function(rule) Add(tmp, AssocWordByLetterRep(FamilyObj(F.1), rule)); end);
  G := F/tmp;
  return G;
end;
###################
LeastWeightRep := function(R, elem)
  local redw, assocword;

  redw := ReducedWord(R, UnderlyingElement(elem));
  assocword := LetterRepAssocWord(redw);
  return assocword;

end;

###################
WeightedLengthElem := function(assocword, weights)
  local i;
  
  return Sum(List(assocword, i -> weights[i]));

end;

###################
# For testing purposes.
###################
WeightedLengthAll := function(n, weights)
  local numgens, F, rels, G, R, wlen, elem, perm, wl, assocword;

  G := AllInversionsAsQuotientGroup(n);  
  R := MakeRewritingSystem(G, weights);
  wlen := [];
  for elem in Elements(G) do
    assocword := LeastWeightRep(R, elem);
    perm := Product(List(assocword, i -> MapIndexToGen(i, n)));
    wl := WeightedLengthElem(assocword, weights);
    Add(wlen, [perm, wl]);
  od;
  return wlen;
end;

###################
PrintWeightedLengthAll := function(n, weights)
  local weighted_distance, tmpfile, wlen, word, txt;

  weighted_distance :=  Concatenation("from-gap-s", String(n), ".csv");
  tmpfile := OutputTextFile(weighted_distance, false);
  SetPrintFormattingStatus(tmpfile, false);
  wlen := WeightedLengthAll(n, weights);
  for word in wlen do
    txt := Concatenation("\n",ShrinkToPrint(ListPerm(word[1], n)), ",",String(word[2]));
    PrintTo(tmpfile, txt);
    Print("\n",txt);
  od;
  CloseStream(tmpfile);
end;



