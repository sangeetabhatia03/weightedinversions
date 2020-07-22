######################################
# Misc utility functions
######################################

ShrinkToPrint := function(word)
 local row;
 row := String(word);
 RemoveCharacters(row,"[], ");
 return row;
end;

######################################
PrintWeightedAdjMat := function(n, weights)
  local mat, elems, rownames, identity, str, sn, adj_mat, numgens, gens;
 
  identity := "";
  Perform([1..n], function(i) Append(identity, String(i)); end);
  adj_mat := Concatenation("s", String(n),".mat");
  
  numgens := n * (n-1)/ 2;
  gens := List([1..numgens], i -> MapIndexToGen(i,n));
  
  mat := AdjacencyMatrix(gens, weights);; 
  elems := mat[2];
  rownames := List(elems, e -> ShrinkToPrint(ListPerm(e, n)));
  rownames[1] := identity;
  str := PrintMatrix(rownames, mat[1]);;
  sn := OutputTextFile(adj_mat, false);
  SetPrintFormattingStatus(sn, false);
  PrintTo(sn, str);
  CloseStream(sn);
end;
######################################

