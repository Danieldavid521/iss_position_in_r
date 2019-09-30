library(curl)
library(jsonlite)
library(maps)

iss_position <-as.data.frame(fromJSON("http://api.open-notify.org/iss-now.json"))

print(iss_position)

map("world", fill=TRUE, col="purple", bg="orange", ylim=c(-60, 90), mar=c(0,0,0,0))

points(as.numeric(as.character(iss_position$iss_position.latitude)),as.numeric(as.character(iss_position$iss_position.longitude)), col="black")


