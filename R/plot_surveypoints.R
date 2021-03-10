require(tidyverse)
require(maps)
require(mapdata)
require(openxlsx)


# directory -----------------------------------------------------
dir_input = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/input"
dir_output = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/output"



# data ----------------------------------------------------------
mapdata = data.frame(read.csv(paste0(dir_input, "/marmap_coord.csv")))

pointsdata = read.xlsx(paste0(dir_input, "/in_操業記録データ.xlsx"), sheet = 1, startRow = 1)
pointsdata = pointsdata[, c(1, 16:20)]
colnames(pointsdata) = c("station", "lat1", "lat2", "lon1", "lon2", "memo")
pointsdata = pointsdata %>% mutate(lat = lat1+lat2/60, lon = lon1+lon2/60, station2 = ifelse(is.na(as.numeric(str_sub(memo, 2, 3))), str_sub(memo, 1, 2), str_sub(memo, 1, 1))) %>% select(station, lon, lat, station2)
pointsdata = pointsdata %>% filter(str_length(station2) == 1)
unique(pointsdata$station)



# function ------------------------------------------------------
plot_surveypoints = function(dir_input, dir_output, mapdata, pointsdata){
  # map data
  colnames(mapdata) = c("long","lat","depth")
  
  # points data
  pointsdata$station = factor(pointsdata$station, levels = c("A", "B", "C", "D", "E", "F", "G", "H"))
  ns = data.frame(station = c("A", "B", "C", "D", "E", "F", "G", "H"), NS = c("N", "N", "N", "N", "S", "S", "S", "S"))
  pointsdata = left_join(pointsdata, ns, by = "station")
  pointsdata$NS = factor(pointsdata$NS, levels = c("N", "S"))
  
  japan = map_data("japan") %>% mutate(long = long - 0.01, lat = lat - 0.01)
  
  g = ggplot(mapdata %>% filter(depth < 0, depth >= -1300), aes(x = long, y = lat))
  # col = c("black", "white")
  # c = scale_colour_manual(values = col)
  s = scale_shape_manual(values = c(21, 21))
  f = scale_fill_manual(values = c("grey40", "lightcoral"))
  th = theme(panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             axis.text.x = element_text(size = rel(1.8), colour = "black"),
             axis.text.y = element_text(size = rel(1.8), colour = "black"),
             axis.title.x = element_text(size = rel(2)),
             axis.title.y = element_text(size = rel(2)),
             strip.text.x = element_text(size = rel(1.8)),
             plot.title = element_text(size = rel(1.8)),
             legend.title = element_text(size = rel(1.8)),
             legend.text = element_text(size = rel(1.8)),
             legend.position = 'none')
  fig1 = g + geom_polygon(data = japan, group = japan$group, fill= "gray50", colour= "gray50") + coord_map(xlim = c(140, 143), ylim = c(36, 42)) + scale_x_continuous(breaks=seq(140, 143, by = 1)) + scale_y_continuous(breaks=seq(36, 42, by = 1)) + stat_contour(aes(z = depth), binwidth = 200, colour = "black") + theme_bw(base_family = "HiraKakuPro-W3") + th + geom_point(data = pointsdata, aes(x = lon, y = lat, shape = NS, fill = NS), size = 4) + s + f + labs(title = "", x = "", y = "", color = "") + 
    annotate("text",x=142.9,y=41,label="A",size=10,fontface="italic") +
    annotate("text",x=142.9,y=40.3,label="B",size=10,fontface="italic") +
    annotate("text",x=142.9,y=39.7,label="C",size=10,fontface="italic") +
    annotate("text",x=142.9,y=39,label="D",size=10,fontface="italic") +
    annotate("text",x=142.9,y=38.4,label="E",size=10,fontface="italic") +
    annotate("text",x=142.9,y=37.7,label="F",size=10,fontface="italic") +
    annotate("text",x=142.9,y=36.9,label="G",size=10,fontface="italic") +
    annotate("text",x=142.9,y=36.5,label="H",size=10,fontface="italic") 
  ggsave(file = paste0(dir_output, "/fig1.png"), plot = fig1, units = "in", width = 8.27, height = 11.69)
}



# plot ----------------------------------------------------------
plot_surveypoints(dir_input = dir_input,
                  dir_output = dir_output,
                  mapdata = mapdata,
                  pointsdata = pointsdata)
