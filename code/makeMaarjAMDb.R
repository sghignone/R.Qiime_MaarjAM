
library("gdata")
library("Biostrings")

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

##PART ONE##
#PREPARATION OD THE ID to TAXONOMY FILE
#LOAD THE FILES 
paraglom <- read.xls("data/raw/export_biogeo_Paraglomeromycetes.xls", sheet = 1)
archaeo <- read.xls("data/raw/export_biogeo_Archaeosporomycetes.xls", sheet = 1)
#glomerom <- read.xls("data/raw/", sheet = 1)
#COMBINE THE DATASETS
all <- rbind(paraglom,archaeo)
#SORT DATASET BY GenBank.accession.number
all.ordered <- all[order(as.character(all[,2])),]
identical(all, all.ordered)

#[TO DO] take GenBank.accession.number, extract taxonomy, format according to 
# awk -F"\t" '{if ($8 !~ /^ *$/) {print $2"\tFungi;Glomeromycota;"$3";"$4";"$5";"$6"_"$7"_"$8} else {print $2"\tFungi;Glomeromycota;"$3";"$4";"$5";"$6"_"$7}}' maarjAM.biogeodata.csv > maarjAM.id_to_taxonomy.txt

##PART TWO##
#PREPARATION OD THE FASTA FILE
paraglom.seq <- readBStringSet("data/raw/sequence_export_Paraglomeromycetes.txt","fasta") #433
names(paraglom.seq)<-gsub("gb\\|", "", names(paraglom.seq))
archaeo.seq <- readBStringSet("data/raw/sequence_export_Archaeosporomycetes.txt", "fasta") #778
names(archaeo.seq)<-gsub("gb\\|", "", names(archaeo.seq))
glomerom.seq <- readBStringSet("data/raw/sequence_export_Glomeromycetes.txt", "fasta") #23631
names(glomerom.seq)<-gsub("gb\\|", "", names(glomerom.seq))

#append(x, values, after=length(x)), x and values are XStringSet objects
#append
all.seq <- append(paraglom.seq, c(archaeo.seq,glomerom.seq), after=length(paraglom.seq))
#order
all.seq <- all.seq[order(as.character((names(all.seq))))]
#save

