
library("gdata")
library("Biostrings")

#Archaeosporomycetes  778
#Glomeromycetes       23631
#Paraglomeromycetes   433

##PART ONE##
#PREPARATION OD THE ID to TAXONOMY FILE
#LOAD THE FILES 
paraglom <- read.xls("data/raw/export_biogeo_Paraglomeromycetes.xls", sheet = 1, fileEncoding="latin1")
archaeo <- read.xls("data/raw/export_biogeo_Archaeosporomycetes.xls", sheet = 1, fileEncoding="latin1")
#glomerom.sanger <- read.xls("data/raw/export_biogeo_Gomeromycetes_sanger.xls", sheet = 1, fileEncoding="latin1")

#COMBINE THE DATASETS
#all <- rbind(paraglom,archaeo,glomerom.sanger)
all <- rbind(paraglom,archaeo)
dim(all)
#Check for duplicated entries and remove them
all[duplicated(all$GenBank.accession.number), ]
all <- all[unique(all$GenBank.accession.number), ]
dim(all)
# Skip  YYY00000 entries
all <- all[all$GenBank.accession.number != "YYY00000", ]
dim(all)

#SORT DATASET BY GenBank.accession.number
all.ordered <- all[order(as.character(all[,"GenBank.accession.number"])),]
dim(all.ordered)
head(all.ordered)


#[TODO] take GenBank.accession.number, extract taxonomy, format according to 
all.ordered_taxo <- NULL
for (i in 1:nrow(all.ordered)){
	if (all.ordered$VTX[i] != ""){
		all.ordered_taxo[i] <- paste0(all.ordered[i, "GenBank.accession.number"],
									  "    ",
									  "Fungi;Glomeromycota;",
									  all.ordered[i, "Fungal.class"],
									  ";",
									  all.ordered[i, "Fungal.order"],
									  ";",
									  all.ordered[i, "Fungal.family"],
									  ";",
									  all.ordered[i, "Fungal.genus"],
									  "_",
									  all.ordered[i, "Fungal.species"],
									  "_",
									  all.ordered[i, "VTX"]
									  )
	} else {
		all.ordered_taxo[i] <- paste0(all.ordered[i, "GenBank.accession.number"],
									  "    ",
									  "Fungi;Glomeromycota;",
									  all.ordered[i, "Fungal.class"],
									  ";",
									  all.ordered[i, "Fungal.order"],
									  ";",
									  all.ordered[i, "Fungal.family"],
									  ";",
									  all.ordered[i, "Fungal.genus"],
									  "_",
									  all.ordered[i, "Fungal.species"]
									  )
	}
}

head(all.ordered_taxo)
# awk -F"\t" '{if ($8 !~ /^ *$/) {print $2"\tFungi;Glomeromycota;"$3";"$4";"$5";"$6"_"$7"_"$8} else {print $2"\tFungi;Glomeromycota;"$3";"$4";"$5";"$6"_"$7}}' maarjAM.biogeodata.csv > maarjAM.id_to_taxonomy.txt



##PART TWO##
#PREPARATION OD THE FASTA FILE
paraglom.seq <- readBStringSet("data/raw/sequence_export_Paraglomeromycetes.txt","fasta") #433
names(paraglom.seq)<-gsub("gb\\|", "", names(paraglom.seq))
archaeo.seq <- readBStringSet("data/raw/sequence_export_Archaeosporomycetes.txt", "fasta") #778
names(archaeo.seq)<-gsub("gb\\|", "", names(archaeo.seq))
#glomerom.seq <- readBStringSet("data/raw/sequence_export_Glomeromycetes.txt", "fasta") #23631 (454: 16985 / Sanger: 6646)
#names(glomerom.seq)<-gsub("gb\\|", "", names(glomerom.seq))
#append
#append(x, values, after=length(x)), x and values are XStringSet objects
#all.seq <- append(paraglom.seq, c(archaeo.seq,glomerom.seq), after=length(paraglom.seq))
all.seq <- append(paraglom.seq,archaeo.seq,after=length(paraglom.seq))
#order
all.ordered.seq <- all.seq[order(as.character((names(all.seq))))]
#filter out  YYY00000 - 788 values)
all.ordered.good.seq <- all.ordered.seq[names(all.ordered.seq) != "YYY00000"]
#save (da aggiungere skip su YYY00000 - 788 values)
writeXStringSet(all.ordered.good.seq, "results/maarjAM.2017.fasta", format="fasta")
