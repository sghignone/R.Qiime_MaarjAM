
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

#COMBINE THE DATASETS
#all <- rbind(paraglom,archaeo) #For testing
all <- rbind(paraglom,archaeo,glomerom.sanger) #For production

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
names(paraglom.seq) <- gsub("gb\\|", "", names(paraglom.seq))
archaeo.seq <- readBStringSet("data/raw/sequence_export_Archaeosporomycetes.txt", "fasta") #778
names(archaeo.seq) <- gsub("gb\\|", "", names(archaeo.seq))
glomerom.seq <- readBStringSet("data/raw/sequence_export_Glomeromycetes_sanger.txt", "fasta") #23631 (454: 16985 / Sanger: 6646)
names(glomerom.seq) <- gsub("gb\\|", "", names(glomerom.seq))
#append
#append(x, values, after=length(x)), x and values are XStringSet objects
#all.seq <- append(paraglom.seq,archaeo.seq,after=length(paraglom.seq)) #For testing
all.seq <- append(paraglom.seq, c(archaeo.seq,glomerom.seq), after=length(paraglom.seq)) #For production
#filter out  YYY00000 - 788 values)
all.seq <- all.seq[names(all.seq) != "YYY00000"]
#order
all.ordered.seq <- all.seq[order(as.character((names(all.seq))))]
#save (da aggiungere skip su YYY00000 - 788 values)
writeXStringSet(all.ordered.good.seq, "results/maarjAM.2017.fasta", format="fasta")



#####################
names(all.ordered.seq)[which(!(names(all.ordered.seq) %in% all.ordered_taxo[,1]))]
all.ordered_taxo[,1][which(!(all.ordered_taxo[,1] %in% names(all.ordered.seq)))]

# Load limma library
library(limma)

# Create protein universe
universe <- unique(c(as.character(names(all.ordered.seq)),
					 as.character(all.ordered_taxo[,1]))) 

# Create data.frame for venn diagram
tmp <- data.frame(seq = rep(0, length(universe)), taxo = rep(0, length(universe)))
rownames(tmp) <- universe
for (i in 1:length(universe)){
	if (universe[i] %in% names(all.ordered.seq)) {
		tmp[i, 1] <- 1
	}
	if (universe[i] %in% as.character(all.ordered_taxo[, 1])){
		tmp[i, 2] <- 1
	}
}

# Venn Diagram
vennDiagram(tmp)

# Double check the absense of the 10 sequences
tmp2 <- rownames(tmp[which(tmp$seq ==1 & tmp$taxo != 1), ])
all.ordered_taxo[which(all.ordered_taxo$V1 %in% tmp2), ]

##############################
# Remove duplicates
paraglom <- unique(as.character(paraglom[,2]))
paraglom <- paraglom[paraglom != "YYY00000"]
paraglom.seq <- paraglom.seq[names(paraglom.seq) != "YYY00000"]

# Do they have the same lenght?
length(paraglom) == length(names(paraglom.seq)) # TRUE



names(paraglom.seq)[which(!(names(paraglom.seq) %in% paraglom))]
paraglom[which(!(paraglom %in% names(paraglom.seq)))]

# Load limma library
library(limma)

# Create protein universe
universe <- unique(c(names(paraglom.seq), paraglom)) 

# Create data.frame for venn diagram
tmp <- data.frame(seq = rep(0, length(universe)), taxo = rep(0, length(universe)))
rownames(tmp) <- universe
for (i in 1:length(universe)){
	if (universe[i] %in% names(paraglom.seq)) {
		tmp[i, 1] <- 1
	}
	if (universe[i] %in% paraglom){
		tmp[i, 2] <- 1
	}
}

# Venn Diagram
vennDiagram(tmp)

