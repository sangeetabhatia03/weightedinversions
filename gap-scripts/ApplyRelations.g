Replace := function(word, from, to, with)
 local before, after;
 before := word{[1..(from - 1)]};
 after := word{[(to + 1)..Length(word)]};
 return Concatenation(before, with, after);
end;
################################################
# if elem not in list then add elem to list 
AddUnique := function(list, elem)
 if not elem in list then
  Add(list, elem);
 fi;
end;
################################################
ApplyInvolution := function(r,i)
 return Replace(r, i, i+1, []);
end;
##################################################
# Return a new expression with the commutative relation applied at pos i.
##################################################
ApplyCommutative := function(r, i)
  local rprime;
 
  rprime := ShallowCopy(r);
  rprime[i] := r[i+1];
  rprime[i+1] := r[i];
  return rprime;
end;
##################################################
#Apply the braid relation if applicable to r[i] , r[i+1] , r[i+2].
##################################################
ApplyBraid := function(r, i)
  local rprime;
   
  rprime := ShallowCopy(r);
  rprime[i] := r[i+1];
  rprime[i+1] := r[i];
  rprime[i+2] := r[i+1];
  return rprime;

end;
#################################################################
# We need to index all inversions, not just the coxeter generators.
# In such a way that it defaults to the standard indexing on the cox gens.
#################################################################
index := function(i, j, n)
 local J;
 J := j-i; 
 if i=1 then 
  return (1+((2*n -J)*(J-1)/2));           
 else
  return index(i-1, j-1, n)+1;
 fi;
end;
##################################################
# r is an list of lists where each item is [i, j] indicating t_{ij}. n is the number of regions
# Assume that j > i
# r is mapped to a list of integers according to the indexing scheme defined above.
##################################################
MapGenToIndex := function(r, n)
 local mapped, inv;

 mapped := List(r, inv-> index(inv[1], inv[2], n));
 return mapped;
end;
##################################################
MapIndexToGen := function(index, n)
  local diags,i, t1j, diff, perm, k;
  diags := List([1..(n-1)],i-> n-i); #Number of diagonal elements
  t1j := [1];
  for i in [1..(n-1)] do
    t1j[i+1] := t1j[i] + diags[i]; 
    if index < t1j[i+1] then
     diff := index - t1j[i];
     perm := (diff + 1, diff + 1 +i);
     k := 1;
     while k < i/2 do
      perm := perm * (diff + 1 +k, diff + 1 +i-k);
      k := k + 1;
     od;
     return perm;
    fi; 
   od;
   return fail;  
 end;
##################################################
CanBraid := function(word)
 local i;
 for i in [1..(Length(word)-2)]
 do
  if (word[i] = word[i+2]) and (word[i+1] = word[i] -1) then
   return i;
  fi;
 od;
 return fail;
end;
##################################################
CanCommute := function(word)
 local i;
 for i in [1..(Length(word)-1)]
 do
  if (word[i] - word[i+1] > 1) then
   return i;
  fi;
 od;
 return fail;
end;
##################################################
HasInversePair := function(word)
 local i;
 for i in [1..(Length(word)-1)] do
  if word[i] = word[i+1] then
   return i;
  fi;
 od;
 return fail;
end;
##################################################
# Apply commutative and braid relations to r
# word is a list of indices of 2-inversions. Assume that all os good, so no error checking. 
##################################################

CannonicalForm := function(word)
 local i, braidpos, commutepos, inverse;
 Print("\n",word," = ",Product(List(word,i->(i,i+1))));
 braidpos := CanBraid(word);
 commutepos := CanCommute(word);
 inverse := HasInversePair(word);
 if (braidpos = fail) and (commutepos = fail) and (inverse = fail) then
   return word;
 else
   if inverse <> fail then
     word := ApplyInvolution(word, inverse);
     return CannonicalForm(word);
   fi;
   if braidpos <> fail then
      word := ApplyBraid(word, braidpos);
      return CannonicalForm(word);
   fi;
   if commutepos <> fail then
      word := ApplyCommutative(word, commutepos);
      return CannonicalForm(word);
   fi;
 fi;
end;