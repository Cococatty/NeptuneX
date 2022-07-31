install.packages("BioCircos")
library(BioCircos)

links_chromosomes_1 = c('X', '2', '9') # Chromosomes on which the links should start
links_chromosomes_2 = c('3', '18', '9') # Chromosomes on which the links should end

links_pos_1 = c(155270560, 154978472, 42512974)
links_pos_2 = c(102621477, 140253678, 20484611)
links_labels = c("Link 1", "Link 2", "Link 3")

tracklist = BioCircosBackgroundTrack("myBackgroundTrack", minRadius = 0, maxRadius = 0.55,
                                     borderSize = 0, fillColors = "#EEFFEE")  

tracklist = tracklist + BioCircosLinkTrack('myLinkTrack', links_chromosomes_1, links_pos_1,
                                           links_pos_1 + 50000000, links_chromosomes_2, links_pos_2, links_pos_2 + 750000,
                                           maxRadius = 0.55, labels = links_labels)

BioCircos(tracklist, genomeFillColor = "PuOr",
          chrPad = 0.02, displayGenomeBorder = FALSE, yChr =  FALSE,
          genomeTicksDisplay = FALSE,  genomeLabelTextSize = "8pt", genomeLabelDy = 0)