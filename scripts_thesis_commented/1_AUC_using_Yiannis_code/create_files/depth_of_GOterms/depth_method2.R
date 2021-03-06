#Script to compute depth of a GO term using .R code. This method gives very smilar results than method1. Deliverable is a file with a dataframe with two columns. The first column is the GO term id and the second column is the depth.

    #MSc thesis bioinfomratics WUR. Protein function prediction for poorly annotated species.
    #Author: Fernando Bueno Gutierrez
    #email1: fernando.buenogutierrez@wur.nl
    #email2: fernando.bueno.gutie@gmail.com


library(GO.db)

   getAllBPChildren <- function(goids)
   {
     ans <- unique(unlist(mget(goids, GOBPCHILDREN), use.names=FALSE))
     ans <- ans[!is.na(ans)]
   }

   level1_BP_terms <- getAllBPChildren("GO:0008150")     # 23 terms
   level2_BP_terms <- getAllBPChildren(level1_BP_terms)  # 256 terms
   level3_BP_terms <- getAllBPChildren(level2_BP_terms)  # 3059 terms
   level4_BP_terms <- getAllBPChildren(level3_BP_terms)  # 9135 terms
   level5_BP_terms <- getAllBPChildren(level4_BP_terms)  # 15023 terms
   level6_BP_terms <- getAllBPChildren(level5_BP_terms)  # 15023 terms
   level7_BP_terms <- getAllBPChildren(level6_BP_terms)  # 15023 terms
   level8_BP_terms <- getAllBPChildren(level7_BP_terms)  # 15023 terms
   level9_BP_terms <- getAllBPChildren(level8_BP_terms)  # 15023 terms
   level10_BP_terms <- getAllBPChildren(level9_BP_terms)  # 15023 terms
   level11_BP_terms <- getAllBPChildren(level10_BP_terms)  # 15023 terms
   level12_BP_terms <- getAllBPChildren(level11_BP_terms)  # 15023 terms
   level13_BP_terms <- getAllBPChildren(level12_BP_terms)  # 15023 terms
   level14_BP_terms <- getAllBPChildren(level13_BP_terms)  # 15023 terms
   level15_BP_terms <- getAllBPChildren(level14_BP_terms)  # 15023 terms
   level16_BP_terms <- getAllBPChildren(level15_BP_terms)  # 15023 terms
   level17_BP_terms <- getAllBPChildren(level16_BP_terms)  # 15023 terms
   level18_BP_terms <- getAllBPChildren(level17_BP_terms)  # 15023 terms
   level19_BP_terms <- getAllBPChildren(level18_BP_terms)  # 15023 terms
   level20_BP_terms <- getAllBPChildren(level19_BP_terms)  # 15023 terms




print(length(level1_BP_terms))
print(length(level2_BP_terms))
print(length(level3_BP_terms))
print(length(level4_BP_terms))
print(length(level5_BP_terms))
print(length(level6_BP_terms))
print(length(level7_BP_terms))
print(length(level8_BP_terms))
print(length(level9_BP_terms))
print(length(level10_BP_terms))
print(length(level11_BP_terms))
print(length(level12_BP_terms))
print(length(level13_BP_terms))
print(length(level14_BP_terms))
print(length(level15_BP_terms))
print(length(level16_BP_terms))
print(length(level17_BP_terms))
print(length(level18_BP_terms))
print(length(level19_BP_terms))
print(length(level20_BP_terms))



level0<-rep(0,1)
names(level0)<-"GO:0008150"

level1<-rep(1,length(level1_BP_terms))
names(level1)<-level1_BP_terms

level2<-rep(2,length(level2_BP_terms))
names(level2)<-level2_BP_terms

level3<-rep(3,length(level3_BP_terms))
names(level3)<-level3_BP_terms

level4<-rep(4,length(level4_BP_terms))
names(level4)<-level4_BP_terms

level5<-rep(5,length(level5_BP_terms))
names(level5)<-level5_BP_terms

level6<-rep(6,length(level6_BP_terms))
names(level6)<-level6_BP_terms

level7<-rep(7,length(level7_BP_terms))
names(level7)<-level7_BP_terms

level8<-rep(8,length(level8_BP_terms))
names(level8)<-level8_BP_terms

level9<-rep(9,length(level9_BP_terms))
names(level9)<-level9_BP_terms

level10<-rep(10,length(level10_BP_terms))
names(level10)<-level10_BP_terms

level11<-rep(11,length(level11_BP_terms))
names(level11)<-level11_BP_terms

level12<-rep(12,length(level12_BP_terms))
names(level12)<-level12_BP_terms

level13<-rep(13,length(level13_BP_terms))
names(level13)<-level13_BP_terms

level14<-rep(14,length(level14_BP_terms))
names(level14)<-level14_BP_terms

level15<-rep(15,length(level15_BP_terms))
names(level15)<-level15_BP_terms

level16<-rep(16,length(level16_BP_terms))
names(level16)<-level16_BP_terms

level17<-rep(17,length(level17_BP_terms))
names(level17)<-level17_BP_terms

level18<-rep(18,length(level18_BP_terms))
names(level18)<-level18_BP_terms

level19<-rep(19,length(level19_BP_terms))
names(level19)<-level19_BP_terms

level20<-rep(20,length(level20_BP_terms))
names(level20)<-level20_BP_terms

levels<-append(level1,c(level2,level3,level4,level5,level6,level7,level8,level9,level10,level11,level12,level13,level14,level15,level16,level17,level18,level19,level20,level0))

allgoes<-unique(names(levels))


vector<-c()
for(i in 1:length(allgoes)){
    in_these<-levels[names(levels)==allgoes[i]] 
    this_is_the_max<-in_these[in_these==max(in_these)]
    vector<-append(vector,this_is_the_max)}

V<-as.data.frame(vector)
V$name<-rownames(V)

write.table(V, file="depth_all_species_newMethod", col.names = F, row.names = F, quote = F, sep="\t")






