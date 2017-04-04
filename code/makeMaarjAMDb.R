#Archaeosporomycetes  778
#Glomeromycetes       23631
#Paraglomeromycetes   433

#1. Correct biogeodata files #Currently, there are 46 empty fields after export
#2. Export in CSV format, tab delimited
#3. cat *.csv > maarjAM.biogeodata.csv #Merge CSV files
#4. Open in Excell
#5. Delete biogeodata header rows
#6. Sort ascending by GenBank Accession Number, save
#7. awk script#1
#awk -F"\t" '{if ($8 !~ /^ *$/) {print $2"\tFungi;Glomeromycota;"$3";"$4";"$5";"$6"_"$7"_"$8} else {print
#$2"\tFungi;Glomeromycota;"$3";"$4";"$5";"$6"_"$7}}' maarjAM.biogeodata.csv > maarjAM.id_to_taxonomy.txt

#Generate ID-2-TX file with 6 levels descriptors
#8. Open in text Editor and delete YYY00000 entries (and duplicates)

#LOAD THE FILE 
library("gdata")
paraglom <- read.xls("data/raw/export_biogeo_Paraglomeromycetes.xls", sheet = 1)
archaeo <- read.xls("data/raw/export_biogeo_Archaeosporomycetes.xls", sheet = 1)
#glomerom <- read.xls("data/raw/", sheet = 1)

all <- rbind(paraglom,archaeo)
all.ordered <- all[order(all$GenBank.accession.number),]


#paraglom.sorted <- paraglom[order(paraglom$GenBank.accession.number),]

library(Biostrings)
paraglom.seq <- readBStringSet("data/raw/sequence_export_Paraglomeromycetes.txt","fasta")
archaeo.seq <- readBStringSet("data/raw/sequence_export_Archaeosporomycetes.txt", "fasta")
glomerom.seq <- readBStringSet("data/raw/sequence_export_Glomeromycetes.txt", "fasta")

paraglom.s
