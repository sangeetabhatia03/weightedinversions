# Determining the lexicograhically smallest reduced expression.
# At each step find the first adjacent pair that is out of order. The reflection that fixes it 
# goes in the reduced expression.

LeastReducedWord := function(perm)
 local wred,l,i;
 wred := [];
 l := ListPerm(perm);
 i := 1; 
 while not IsSortedList(l) do
  while i < Length(l) do
   if l[i] < l[i+1] then
     i := i + 1;
   else
     Add(wred,i);
     perm := (i, i+1)*perm;
     l := ListPerm(perm);
     i := 1;
   fi;
  od;
 od;
 return wred;
end;