require(tidyverse)
require(openxlsx)
library(maps)
library(mapdata)
require(plyr)

# directory -----------------------------------------------------
dir_input = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/input"
dir_output = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/output"



# data ----------------------------------------------------------
old = NULL
for(i in 1995:2018){
  temp = read.xlsx(paste0(dir_input, "/4_分布密度データ01-18.xlsx"), sheet = i-1994)
  old = rbind(old, temp)
}
summary(old)
colnames(old) = c("year", "syurui", "NS", "station", "group", "depth", "swept_area", "n_sp", "weight", "number")

y19 = read.xlsx(paste0(dir_input, "/q_魚種別各層別集計クエリ2019.xlsx"))
y20 = read.xlsx(paste0(dir_input, "/q_魚種別各層別集計クエリ2020.xlsx"))
y19$year = 2019
y20$year = 2020
new = rbind(y19, y20)
colnames(new)
colnames(new) = c("syurui", "NS", "station", "group", "depth", "swept_area", "n_sp", "weight", "number", "year")

data = all = rbind(old, new)
summary(all)


# function ----------------------------------------------------------------
get_dens = function(data){
  # ここのwarningでデータが抜け落ちる
  # df2 = data %>% filter(station == c("A", "B", "C", "D", "E", "F", "G", "H"))
  # unique(df2$station)
  
  df2 = data %>% mutate(d = number/swept_area)
  densN = df2 %>% dplyr::group_by(year, NS, station, depth, n_sp) %>% dplyr::summarize(D = mean(d)/1000)
  densN = densN %>% filter(n_sp < 16)
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
  
  n_st = data.frame(station = c("A", "B", "C", "D", "E", "F", "G", "H"), n_station = rep(1:8), lat = c(41, 40.3, 39.7, 39, 38.4, 37.7, 37.1, 36.5))
  n_st$station = as.character(as.factor(n_st$station))
  mode(n_st$station)
  mode(densN$station)
  densN = left_join(densN, n_st, by = "station") %>% filter(year > 2000)
  
  n_dep = data.frame(depth = unique(densN$depth)) %>% arrange(depth) %>% mutate(lon = c(142.5, 143, 143.5, 144, 144.5, 145, 145.5, 146))
  densN = left_join(densN, n_dep, by = "depth")
  
  densN = densN %>% na.omit()
  unique(densN$station)
  densN$station = factor(densN$station, levels = c("A", "B", "C", "D", "E", "F", "G", "H"))
}




map_dens = function(data){
  # g = ggplot(data = densN %>% filter(year > 2000, n_sp == 2), aes(x = depth, y = n_station, fill = D))
  # t = geom_tile()
  # c = scale_fill_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
  # f = facet_wrap(~ year, ncol = 7)
  # labs = labs(title = "", x = "", y = "", color = "密度（千尾/km^2）")
  # th = theme(panel.grid.major = element_blank(),
  #            panel.grid.minor = element_blank(),
  #            axis.text.x = element_text(size = rel(1.8), colour = "black"),
  #            axis.text.y = element_text(size = rel(1.8), colour = "black"),
  #            axis.title.x = element_text(size = rel(2)),
  #            axis.title.y = element_text(size = rel(2)),
  #            strip.text.x = element_text(size = rel(1.8)),
  #            plot.title = element_text(size = rel(1.8)),
  #            legend.title = element_text(size = rel(1.8)),
  #            legend.text = element_text(size = rel(1.8)),
  #            legend.position = 'none')
  # g+t+c+f+labs
  
  data = densN
  sp = unique(data$species)
  
  for(i in 1:length(sp)){
    # map
    japan = map_data("japan") %>% mutate(long = long - 0.01, lat = lat - 0.01)
    
    g = ggplot() + 
      geom_polygon(data = japan, aes(x = long, y = lat, group = group), colour = "gray 50", fill = "gray 50") + 
      coord_map(xlim = c(140, 148), ylim = c(36, 42))
    p = geom_point(data = densN %>% filter(year > 2000, species == sp[i]), aes(x = lon, y = lat, fill = D), shape = 22, size = 3)
    c = scale_fill_gradientn(colours = c("white", "blue", "cyan", "green", "yellow", "orange", "red"))
    # c = scale_fill_gradientn(colours = c("white", "blue", "red"))
    f = facet_wrap(~ year, ncol = 6)
    labs = labs(title = "", x = "", y = "", fill = "密度")
    th = theme(panel.grid.major = element_blank(),
               panel.grid.minor = element_blank(),
               # axis.text.x = element_text(size = rel(1.8), colour = "black"),
               # axis.text.y = element_text(size = rel(1.8), colour = "black"),
               # axis.text.x = element_text(size = rel(1.5), angle = 90, colour = "black"),
               # axis.text.y = element_text(size = rel(1.5), colour = "black"),
               axis.text.x = element_blank(),
               axis.text.y = element_blank(),
               axis.title.x = element_blank(),
               axis.title.y = element_blank(),
               strip.text.x = element_text(size = rel(1.3)),
               plot.title = element_text(size = rel(1.3)),
               legend.title = element_text(size = rel(1.3)),
               legend.text = element_text(size = rel(1.3)),
               legend.position = c(0.38, 0.12))
    
    # th = theme(panel.grid.major = element_blank(),
    #            panel.grid.minor = element_blank(),
    #            axis.text.x = element_text(size = rel(1.5), angle = 90, colour = "black"),
    #            axis.text.y = element_text(size = rel(1.5), colour = "black"),
    #            axis.title.x = element_text(size = rel(1.5)),
    #            axis.title.y = element_text(size = rel(1.5)),
    #            legend.title = element_blank(),
    #            legend.text = element_text(size = rel(1.5)),
    #            strip.text.x = element_text(size = rel(1.5)),
    #            #legend.position = c(0.75, 0.05),
    #            legend.background = element_rect(fill = "white", size = 0.4, linetype = "solid", colour = "black"))
    
    
    
    fig_densN = g+p+c+f+theme_bw(base_family = "HiraKakuPro-W3")+labs+th+
      # guides(fill = guide_legend(title = "密度"))+
      annotate("text",x=147,y=41,label="A",size = 3.5,fontface="italic") +
      annotate("text",x=147,y=40.3,label="B",size = 3.5,fontface="italic") +
      annotate("text",x=147,y=39.7,label="C",size = 3.5,fontface="italic") +
      annotate("text",x=147,y=39,label="D",size = 3.5,fontface="italic") +
      annotate("text",x=147,y=38.4,label="E",size = 3.5,fontface="italic") +
      annotate("text",x=147,y=37.7,label="F",size = 3.5,fontface="italic") +
      annotate("text",x=147,y=37.1,label="G",size = 3.5,fontface="italic") +
      annotate("text",x=147,y=36.5,label="H",size = 3.5,fontface="italic") +
      annotate("text",x=142.9,y=41.5,label="-250m",fontface="italic",size = 2.5) +
      annotate("text",x=144.5,y=41.5,label="-550m",fontface="italic",size = 2.5) +
      annotate("text",x=146,y=41.5,label="-900m",fontface="italic",size = 2.5) 
    
    ggsave(file = paste0(dir_output, "/", sp[i], "dens.png"), plot = fig_densN, units = "in", width = 11.69, height = 8.27)  
    
    
  }

}





# run ---------------------------------------------------------------------
get_dens(data = all)

map_dens(data = densN)
