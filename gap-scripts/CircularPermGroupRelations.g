###########################################
CircularPermMapIndexToGen := function(i, n)
 if i <> n then
   return [(i, i+1)]; 
 fi;  
 return [(1, n)];  

end;
###########################################
CircularPermMapGenToIndex := function(gen, n)
 local mp, larger, smaller;

 mp := MovedPoints(gen);
 if Length(mp) <> 2 then 
  Print("\n Not a valid generator in this context.");
  return fail;
 fi; 
 larger := Maximum(mp);
 smaller := Minimum(mp);
 if (larger - smaller)=1 then
   return smaller;
 elif (larger - smaller)=(n-1) then
   return n;
 else
   Print("\n Not a valid generator in this context.");
   return fail;     
 fi;  
 return fail;  
end;

###########################################
TopGeneratorDef := function(n)
 local cycleal;
 cycleal:= AssociativeList();
 Assign(cycleal, Concatenation([n], Reversed([1..(n-1)]), [2..(n-1)]), []);
 return cycleal;
end;
###########################################
CoxeterGensRelations := function(n)
 local cycleal, tuples, tuple, gens, t, order,  rel;
 
 cycleal:= AssociativeList();
 tuples := Combinations([1..n], 2);

 for tuple in tuples do
   gens := List(tuple, t -> CircularPermMapIndexToGen(t, n));
   order := Order(Product(gens));
   rel := Flat(List([1..order], t -> tuple));
   Assign(cycleal, rel, []);
 od;
 return cycleal;
end;
###########################################

###########################################
RelationsAsId := function(n)
  local coxrels, rules, i, keys, key, topgen, allrels;

  coxrels := CoxeterGensRelations(n);
  topgen := TopGeneratorDef(n);
  allrels := UnionAssociativeList([coxrels, topgen]);
  rules := [];
  Perform([1..n], function(i) Add(rules, [i,i]); end);
  Perform(Keys(allrels), function(key) Add(rules, key); end);
  
  return rules;
end;
###########################################
CircularInversionsAsQuotientGroup := function(n)
  local F, rels, G;
  
  F := FreeGroup(n);
  rels := [];
  Perform(RelationsAsId(n), function(rule) Add(rels, AssocWordByLetterRep(FamilyObj(F.1), rule)); end);
  G := F/rels;
  return G;
end;