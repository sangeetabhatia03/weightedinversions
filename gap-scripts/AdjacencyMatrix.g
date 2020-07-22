AdjacencyMatrix := function(gens, weights)
 local mat, e, elems, row, pos, i, gen;
 elems := Elements(Group(gens));
 mat := [];
 for e in elems do              
   row := List([1..Size(elems)], i -> 0);
   for i in [1..Length(gens)] do
    gen := gens[i];
    pos:= Position(elems, e * gen);
    row[pos] := weights[i];
   od;
   Add(mat,row);
 od;
 return [mat, elems];
end;
############################################################################
EdgeList := function(gens, weights)
 local edgelist,u, uprime, queue, visited, gen; 
  edgelist := [];
  queue := [()];
  visited := [()];
  while not IsEmpty(queue) do
    #Print("\n queue = ",queue);
    #Print("\n visited = ", visited);
    u := Remove(queue, 1);
    for gen in gens do
      uprime := u * gen;
      if not uprime in visited then
        if not uprime in queue then Add(queue, uprime); fi;
        Add(visited, uprime);
        Add(edgelist, [u, uprime, gen, weights[Position(gens, gen)]]);
      fi;
    od;
  od;
 return edgelist; 
end;
############################################################################
ShrinkToPrint := function(word)
 local row;
 row := String(word);
 RemoveCharacters(row,"[], ");
 return row;
end;
############################################################################
PrintMatrix := function(rownames,distmat)
 local i,j,str,row;
   
 str:="";
 for i in [1..Length(distmat)] do
	str:=Concatenation(str, rownames[i], ",");
	row:=String(distmat[i]);
	RemoveCharacters(row,"[]");
	str:=Concatenation(str,row,"\n");
 od;
 return str;
end;
#################################################################################

