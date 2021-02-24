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
pointsdata = pointsdata[, c(1, 16:19)]
colnames(pointsdata) = c("station", "lat1", "lat2", "lon1", "lon2")
pointsdata = pointsdata %>% mutate(lat = lat1+lat2/60, lon = lon1+lon2/60) %>% select(station, lon, lat)
unique(pointsdata$station)
pointsdata$station = factor(pointsdata$station, levels = c("A", "B", "C", "D", "E", "F", "G", "H"))



# function ------------------------------------------------------
plot_surveypoints = function(dir_input, dir_output, mapdata, pointsdata){
  # map data
  colnames(mapdata) = c("long","lat","depth")
  
  japan = map_data("japan") %>% mutate(long = long - 0.01, lat = lat - 0.01)
  
  g = ggplot(mapdata %>% filter(depth < 0, depth >= -1300), aes(x = long, y = lat))
  th = theme(panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             axis.text.x = element_text(size = rel(1.8), colour = "black"),
             axis.text.y = element_text(size = rel(1.8), colour = "black"),
             axis.title.x = element_text(size = rel(2)),
             axis.title.y = element_text(size = rel(2)),
             strip.text.x = element_text(size = rel(1.8)),
             plot.title = element_text(size = rel(1.8)),
             legend.title = element_text(size = rel(1.8)),
             legend.text = element_text(size = rel(1.8)),)
  fig1 = g + geom_polygon(data = japan, group = japan$group, fill= "gray50", colour= "gray50")  + coord_map(xlim = c(140, 143), ylim = c(36, 42)) +scale_x_continuous(breaks=seq(140, 143, by = 1)) + stat_contour(aes(z = depth), binwidth = 200, colour = "black") + theme_bw(base_family = "HiraKakuPro-W3") + th + geom_point(data = pointsdata, aes(x = lon, y = lat, shape = station), size = 3) + scale_shape_manual(values = c(15, 4, 17, 8, 18, 16, 1, 2)) + labs(title = "", x = "", y = "", shape = "調査ライン")
  ggsave(file = paste0(dir_output, "/fig1.png"), plot = fig1, units = "in", width = 8.27, height = 11.69)
}



# plot ----------------------------------------------------------
plot_surveypoints(dir_input = dir_input,
                  dir_output = dir_output,
                  mapdata = mapdata,
                  pointsdata = pointsdata)
