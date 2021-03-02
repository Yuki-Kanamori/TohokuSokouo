require(tidyverse)
require(openxlsx)
library(maps)
library(mapdata)
require(plyr)

# directory -----------------------------------------------------
dir_input = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/input"
dir_output = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/output"



# data ----------------------------------------------------------
df = NULL
for(i in 1995:2018){
  old = read.xlsx(paste0(dir_input, "/4_分布密度データ01-18.xlsx"), sheet = i-1994)
  df = rbind(df, old)
}
summary(df)
colnames(df) = c("year", "syurui", "NS", "station", "group", "depth", "swept_area", "n_sp", "weight", "number")

data = df


get_dens = function(data){
  # ここのwarningでデータが抜け落ちる
  # df2 = data %>% filter(station == c("A", "B", "C", "D", "E", "F", "G", "H"))
  # unique(df2$station)
  
  df2$d = data$number/data$swept_area
  densN = df2 %>% group_by(year, NS, station, depth, n_sp) %>% summarize(D = mean(d)/1000) %>% filter(n_sp < 16)
  j_sp = c(
    "スケトウダラ０＋",
    "スケトウダラ１＋",
    "マダラ０＋",
    "マダラ１＋",
    "マダラ２＋",
    "イトヒキダラ",
    "キチジ",
    "ズワイガニ雌",
    "ズワイガニ雄",
    "スルメイカ",
    "ベニズワイ雌",
    "ベニズワイ雄",
    "アカガレイ",
    "サメガレイ",
    "ババガレイ")
  splist = data.frame(n_sp = 1:15, species = j_sp)
  densN = left_join(densN, splist, by = "n_sp")
  
  n_st = data.frame(station = c("A", "B", "C", "D", "E", "F", "G", "H"), n_station = rep(1:8), lat = c(41, 40.3, 39.7, 39, 38.4, 37.7, 36.9, 36.5))
  densN = left_join(densN, n_st, by = "station")
  densN = densN %>% mutate(lon = 142+0.5*depth)
  densN = densN %>% na.omit()
  unique(densN$station)
  densN$station = factor(densN$station, levels = c("A", "B", "C", "D", "E", "F", "G", "H"))
}




map_dens = function(data){
  n_st = data.frame(station = c("A", "B", "C", "D", "E", "F", "G", "H"), n_station = rep(1:length(unique(df2$station))), lat = c(41, 40.3, 39.7, 39, 38.4, 37.7, 36.9, 36.5))
  densN = left_join(densN, n_st, by = "station")
  densN = densN %>% mutate(lon = 142+0.5*depth)
  densN$station = factor(densN$station, levels = c("A", "B", "C", "D", "E", "F", "G", "H"))
  
  
  g = ggplot(data = densN %>% filter(year > 2000, n_sp == 2), aes(x = depth, y = n_station, fill = D))
  t = geom_tile()
  c = scale_fill_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
  f = facet_wrap(~ year, ncol = 7)
  labs = labs(title = "", x = "", y = "", color = "密度（千尾/km^2）")
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
  g+t+c+f+labs
  
  
  
  # map
  g = ggplot() + 
    geom_polygon(data = japan, aes(x = long, y = lat, group = group), colour = "gray 50", fill = "gray 50") + 
    coord_map(xlim = c(140, 143), ylim = c(36, 42))
  p = geom_point(data = densN %>% filter(year > 2000, n_sp == 2), aes(x = lon, y = lat, colour = D), shape = 22, size = 4)
  c = scale_colour_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
  f = facet_wrap(~ year, ncol = 7)
  labs = labs(title = "", x = "", y = "", color = "")
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
  
  fig_densN = g+p+c+f+labs+th+theme_bw(base_family = "HiraKakuPro-W3") +
    scale_x_continuous(breaks=seq(140, 143, by = 1)) + scale_y_continuous(breaks=seq(36, 42, by = 1)) + 
    annotate("text",x=142.9,y=41,label="A",size=10,fontface="italic") +
    annotate("text",x=142.9,y=40.3,label="B",size=10,fontface="italic") +
    annotate("text",x=142.9,y=39.7,label="C",size=10,fontface="italic") +
    annotate("text",x=142.9,y=39,label="D",size=10,fontface="italic") +
    annotate("text",x=142.9,y=38.4,label="E",size=10,fontface="italic") +
    annotate("text",x=142.9,y=37.7,label="F",size=10,fontface="italic") +
    annotate("text",x=142.9,y=36.9,label="G",size=10,fontface="italic") +
    annotate("text",x=142.9,y=36.5,label="H",size=10,fontface="italic") +
    annotate("text",x=142.9,y=41.5,label="-250m",fontface="italic",size=4) +
    annotate("text",x=144.3,y=41.5,label="-550m",fontface="italic",size=4) +
    annotate("text",x=145.6,y=41.5,label="-900m",fontface="italic",size=4) 
    
      
  
  
}







check = densN %>% filter(year > 2000, n_sp == 2)
check2 = check %>% filter(year == 2001)
