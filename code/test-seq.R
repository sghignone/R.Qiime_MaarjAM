library("testthat")



# context("All sequences report")
# test_that("Marches", {
#     names(all.ordered.seq)[which(!(names(all.ordered.seq) %in% all.ordered_taxo[,1]))]
#     all.ordered_taxo[,1][which(!(all.ordered_taxo[,1] %in% names(all.ordered.seq)))]

	


context("Sequence matches")
test_that("Control sequences matches", {
	## TEST UNIT
	n <- 100
	x1 <- as.character(sample(paraglom[paraglom$GenBank.accession.number != "YYY00000", 2], n))
	x2 <- as.character(sample(archaeo[archaeo$GenBank.accession.number != "YYY00000", 2], n))
	x3 <- as.character(sample(glomerom.sanger[glomerom.sanger$GenBank.accession.number != "YYY00000", 2], n))
	# PARAGLOM
	expect_identical(all.ordered.seq[names(all.ordered.seq) %in% x1,], paraglom.seq[names(paraglom.seq) %in% x1,])
	# ARCHAEO
	expect_identical(all.ordered.seq[names(all.ordered.seq) %in% x2,], archaeo.seq[names(archaeo.seq) %in% x2,])
	# GLOMEROM
	expect_identical(all.ordered.seq[names(all.ordered.seq) %in% x3,], glomerom.seq[names(glomerom.seq) %in% x3,])
})

