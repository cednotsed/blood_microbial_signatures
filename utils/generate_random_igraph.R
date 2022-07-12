require(igraph)


g1 <- erdos.renyi.game(
  40,
  0.3,
  type = c("gnp", "gnm"),
  directed = FALSE,
  loops = FALSE
)

plot(g1, 
     vertex.color = "skyblue4", 
     vertex.frame.color = "skyblue4", 
     vertex.size = 8,
     vertex.label = NA)
