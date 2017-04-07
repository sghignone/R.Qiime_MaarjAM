
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
glomerom.sanger <- read.xls("data/raw/export_biogeo_Gomeromycetes_sanger.xls", sheet = 1, fileEncoding="latin1")
dim(glomerom.sanger)
#COMBINE THE DATASETS
#all <- rbind(paraglom,archaeo) #For testing
all <- rbind(paraglom,archaeo,glomerom.sanger) #For production

dim(all)
#Check for duplicated entries and remove them
all[duplicated(all$GenBank.accession.number), ]
all <- all[unique(all$GenBank.accession.number), ]
dim(all)
# Skip  YYY00000 entries
#count
length(which(paraglom$GenBank.accession.number == "YYY00000"))
length(which(archaeo$GenBank.accession.number == "YYY00000"))
length(which(glomerom.sanger$GenBank.accession.number == "YYY00000"))
#skip
all <- all[all$GenBank.accession.number != "YYY00000", ]
dim(all)

#SORT DATASET BY GenBank.accession.number
all.ordered <- all[order(as.character(all[,"GenBank.accession.number"])),]
dim(all.ordered)
head(all.ordered)


#Take GenBank.accession.number, extract taxonomy, format  
all.ordered_taxo <- data.frame()
for (i in 1:nrow(all.ordered)){
  if (all.ordered$VTX[i] != ""){
    all.ordered_taxo[i, 1] <- all.ordered[i, "GenBank.accession.number"] 
    all.ordered_taxo[i, 2] <- paste0("Fungi;Glomeromycota;",
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
    all.ordered_taxo[i, 1] <- all.ordered[i, "GenBank.accession.number"] 
    all.ordered_taxo[i, 2] <- paste0("Fungi;Glomeromycota;",
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
# Save table to file
write.table(all.ordered_taxo, "results/all_ordered_taxo.txt", sep = "\t",
			row.names = FALSE, col.names = FALSE, quote = FALSE)


##PART TWO##
#PREPARATION OD THE FASTA FILE
paraglom.seq <- readBStringSet("data/raw/sequence_export_Paraglomeromycetes.txt","fasta") #433
names(paraglom.seq)<-gsub("gb\\|", "", names(paraglom.seq))
archaeo.seq <- readBStringSet("data/raw/sequence_export_Archaeosporomycetes.txt", "fasta") #778
names(archaeo.seq)<-gsub("gb\\|", "", names(archaeo.seq))
glomerom.seq <- readBStringSet("data/raw/sequence_export_Glomeromycetes_sanger.txt", "fasta") #23631 (454: 16985 / Sanger: 6646)
names(glomerom.seq)<-gsub("gb\\|", "", names(glomerom.seq))
#append
#append(x, values, after=length(x)), x and values are XStringSet objects
#all.seq <- append(paraglom.seq,archaeo.seq,after=length(paraglom.seq)) #For testing
all.seq <- append(paraglom.seq, c(archaeo.seq,glomerom.seq), after=length(paraglom.seq)) #For production
#order
all.ordered.seq <- all.seq[order(as.character((names(all.seq))))]
#filter out  YYY00000 - Archaeo=0; Paraglom=1;GlomTot=787;GlomSanger=391)
all.ordered.good.seq <- all.ordered.seq[names(all.ordered.seq) != "YYY00000"]
#save
writeXStringSet(all.ordered.good.seq, "results/maarjAM.2017.fasta", format="fasta")
