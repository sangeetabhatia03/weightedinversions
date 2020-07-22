tij:=function(i,j)
 if j=i+1 or j=i+2 then
  return [(i,j)];
 else
  return [(i,j),tij(i+1,j-1)];
 fi;
end;

###################################################
#LibraryConstruction:=function(n)
# local cycleal,i,j,defn;
# cycleal:=AssociativeList();
# for i in [1..(n-1)] do
#  for j in [i+1..n] do
#   defn:=Flat(tij(i,j));
#   Assign(cycleal,(i,j),LeastReducedWord(Product(defn)));
#  od;
# od;
# return cycleal;
#end;
###################################################
OrderKRelations := function(n, k)
 local cycleal, i, j, order, gens, rel, numgens, tuples, tuple;
 cycleal:= AssociativeList();
 numgens := n * (n-1)/ 2;
 tuples := Combinations([1..numgens], k);
 for tuple in tuples do
   gens := List(tuple, t -> MapIndexToGen(t, n));
   order := Order(Product(gens));
   rel := Flat(List([1..(order - 1)], t -> tuple));
   Append(rel, tuple{[1..(k-1)]});
   Assign(cycleal, rel, [tuple[k]]);
 od;
 return cycleal;
end;
###################################################
# Indexing the associative list by index of a generator as returned by index in ApplyRelations.g
# So that a weights vector can be defined corresponding to the same 
DefinitionLibrary := function(n)
 local cycleal, i, j, defn;
 cycleal:=AssociativeList();
 for i in [1..(n-1)] do
   for j in [(i+2)..n] do
     defn := Flat(tij(i,j));
     Assign(cycleal, [index(i,j,n)], LeastReducedWord(Product(defn)));
   od;
 od;
 return cycleal;
end;
###################################################
# ExtractRelations := function(lhs, rhs, weights)
#  local rels, elem;
  
#  rels := [];
#  while Length(lhs) >= 1 do
#    Add(rels, [ShallowCopy(lhs), ShallowCopy(rhs)]);
#    Add(rels, [ShallowCopy(rhs), ShallowCopy(lhs)]);
#    elem := Remove(lhs);
#    Add(rhs, elem);
#  od;
#  return rels;
#end;
###################################################
ExtractRelations := function(lhs, rhs, weights)
  local wlhs, wrhs, rels_lessthan, elem, pair, rels_equal;
  rels_lessthan := [];
  rels_equal := [];
  while Length(lhs) >= 1 do
    wlhs := Sum(List(lhs), i -> weights[i]);
    wrhs := Sum(List(rhs), i -> weights[i]);
    if wlhs > wrhs then
      AddUnique(rels_lessthan, [ShallowCopy(lhs), ShallowCopy(rhs)]);
      AddUnique(rels_lessthan, [Reversed(ShallowCopy(lhs)), Reversed(ShallowCopy(rhs))]);
    elif wlhs < wrhs then
      AddUnique(rels_lessthan, [ShallowCopy(rhs), ShallowCopy(lhs)]);
      AddUnique(rels_lessthan, [Reversed(ShallowCopy(rhs)), Reversed(ShallowCopy(lhs))]);     
    else 
      AddUnique(rels_equal, [ShallowCopy(rhs), ShallowCopy(lhs)]);
      AddUnique(rels_equal, [Reversed(ShallowCopy(rhs)), Reversed(ShallowCopy(lhs))]);
      AddUnique(rels_equal, [ShallowCopy(lhs), ShallowCopy(rhs)]);
      AddUnique(rels_equal, [Reversed(ShallowCopy(lhs)), Reversed(ShallowCopy(rhs))]);
    fi;
    elem := Remove(lhs);
    Add(rhs, elem);

  od;
  return [rels_lessthan, rels_equal];
end;
###################################################
MakePairs := function(list)
 local sub, i;
 sub := [1,2];
 if IsEmpty(list) or Length(list) = 1 then
   return list;
 else
   list := List([1..Length(list)/2], i -> list{(i-1)*2 + sub});
 fi; 
 return list;
end;
###################################################
# Remove all occurances of (i,i)
MakeSquareFree := function(word)
  local i, stop;
  stop := Length(word);
  i := 1;
  while i < stop do
   if word[i]=word[i+1] then
     word := Replace(word, i, i+1, []);
     stop := Length(word);
     i := Maximum(1, i - 1); #Reset i
    else
     i := i+1; 
    fi;
  od;
  return word;
end;

###################################################
AllRelations := function(n, upto)
  local deflib, allrels, extra, i;

  deflib := DefinitionLibrary(n);
  extra := OrderKRelations(n, 2);
  for i in [3..upto] do
   extra := UnionAssociativeList([extra, OrderKRelations(n, i)]);
  od;
  allrels := UnionAssociativeList([deflib, extra]);
  return allrels;
end;

###################################################
# create two libraries lib_lessthan and lib_equal
###################################################
LibraryConstruction := function(relations, weights)
  local liblessthan, libequal, key, keys, rels;

  liblessthan:= [];
  libequal := [];
  keys := Keys(relations);
  for key in keys do
    rels := ExtractRelations(key, relations[key], weights);
    Append(liblessthan, rels[1]);
    Append(libequal, rels[2]);
  od;
  return [liblessthan, libequal];
end;