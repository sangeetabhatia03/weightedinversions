# 17-01-2016
# Test case 1
# n := 3; weights := [1, 1, 2]; # 9
# n := 4; weights := [1, 1, 1, 2, 2, 3]; #44
# n := 5; weights := [1, 1, 1, 1, 2, 2, 2, 3, 3, 4];#204
# n := 6; weights := [1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5]; #1049
# n := 7; weights := [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6]; #6220
# Test case 2
# n := 4; weights := [1, 1, 1, 2, 2, 30];
# n := 5; weights := [1, 1, 1, 1, 2, 2, 2, 3, 3, 40];
# n := 6; weights := [1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 50];
# n := 7; weights := [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 60];
# Test case 3
# n := 4; weights := [10, 10, 10, 2, 2, 30];
# n := 5; weights := [10, 10, 10, 10, 2, 2, 2, 3, 3, 40];
# n := 6; weights := [10, 10, 10, 10, 10, 2, 2, 2, 2, 3, 3, 3, 4, 4, 50];
# n := 7; weights := [10, 10, 10, 10, 10, 10, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 60];
# Test case 4
# n := 8; weights := [1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7]; 
# time = 58785
# n := 9; weights := [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 8];
# MakeRewritingSystem time:4008
# IsConfluent : false
# n := 10; weights := [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9];
# MakeRewritingSystem time:6572
# IsConfluent : false
# n := 11; weights := [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 10];
# #####################################
# 30-01-2016
# Presentation changed to AllRelations(n,1)
# Test case 1
# n := 4; weights := [1, 1, 1, 2, 2, 3];
# n := 5; weights := [1, 1, 1, 1, 2, 2, 2, 3, 3, 4];
# n := 6; weights := [1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5];
# n := 7; weights := [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6];
# n 
G := AllInversionsAsQuotientGroup(n); R := MakeRewritingSystem(G, weights);

time;
elem := PseudoRandom(G:radius:=20);
assocword := LeastWeightRep(R, elem);
time;
wl := WeightedLengthElem(assocword, weights);

Wrapper := function(n, weights)
 PrintWeightedAdjMat(n, weights);
 PrintWeightedLengthAll(n, weights);
end;


###########################################
# 22-10-2016
# Circular Perms
weights := List([1..n], i->1);
G := CircularInversionsAsQuotientGroup(n);
R := MakeRewritingSystem(G, weights);
IsConfluent(R);
# Returns confluent rewriting system upto n=8
############################################

###########################################
# 08-10-2017
# Weights that look like the distribution in Darling's paper
# The paper (Figure 7) has the frequency on y-axis. Weights would be the inverse of that
# as we are set up to determine the minimal weight path.
# Also worked around issue in RelationsAsId
###########################################
# n := 9; weights := [3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9];
# IsConfluent(R) False
# n := 8; weights := [3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 7, 7, 8]; 
# IsConfluent(R) False
# n := 7; weights := [3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7]; 
# IsConfluent(R) True