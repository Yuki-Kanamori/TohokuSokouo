require(tidyverse)
require(openxlsx)


# directory -----------------------------------------------------
dir_input = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/input"
dir_output = "/Users/Yuki/FRA/TohokuSokouo"



# data ----------------------------------------------------------
old = NULL
for(i in 1:(2018-1995+1)){
  temp = read.xlsx(paste0(dir_input, "/1_1995～2018資源尾数、重量グラフ.xlsx"), sheet = i, startRow = 1)
  
  if(i < 12){
    temp = temp[, c(1:5, 7:9)]
    temp = temp %>% na.omit() %>% filter(南北 != "南北計")
  }else{
    temp = temp[, 1:8]
    temp = temp %>% na.omit() %>% filter(南北 != "南北計")
  }
  
  old = rbind(old, temp)
}

y19 = read.xlsx(paste0(dir_input, "/q_資源量合計クエリ2019.xlsx"), sheet = 1, startRow = 1) %>% na.omit() %>% filter(南北 != "南北計")
y20 = read.xlsx(paste0(dir_input, "/q_資源量合計クエリ2020.xlsx"), sheet = 1, startRow = 1) %>% na.omit() %>% filter(南北 != "南北計")

all = rbind(old, y19, y20)
all = all %>% mutate(year = as.numeric(str_sub(調査種類名称, 1, 4)), NS = str_sub(南北, 1, 1)) %>% dplyr::rename(data = "尾数・重量", sp = "和名", sum = "資源量計") %>% select(year, NS, data, sp, sum)
ns = data.frame(NS = c("N", "S"), 南北 = c("北部", "南部"))
all = left_join(all, ns, by = "NS") %>% select(-NS) %>% dplyr::rename(NS = 南北)
all$NS = factor(all$NS, levels = c("北部", "南部"))
all = all %>% mutate(data = ifelse(all$data == "資源重量", "重量", "尾数"))
unique(all$sp)


# function ------------------------------------------------------
plot_trend_abst = function(data){
  get_sp = c(
    "スケトウダラ０＋",
    "スケトウダラ１＋",
    "マダラ０＋",
    "マダラ１＋",
    "マダラ２＋",
    "イトヒキダラ",
    "キチジ",
    "ズワイガニ雌",
    "ズワイガニ雄",
    "アカガレイ",
    "サメガレイ",
    "ババガレイ")
  
  # 
  # filterでも[]でもwarningが出る&抽出がうまくいかないので，抽出方法をforループに変更する
  # data2 = data %>% filter(data == "重量", sp == get_sp) # with a warning
  # data2 = data %>% filter(data == "重量")
  # data2 = data[data$sp == get_sp, ]
  # 
  data2 = NULL
  for(i in 1:length(get_sp)){
    temp = data %>% filter(sp == get_sp[i])
    data2 = rbind(data2, temp)
  }
  data2$sp = factor(data2$sp, levels = c("スケトウダラ０＋",
                                         "スケトウダラ１＋",
                                         "マダラ０＋",
                                         "マダラ１＋",
                                         "マダラ２＋",
                                         "イトヒキダラ",
                                         "キチジ",
                                         "ズワイガニ雌",
                                         "ズワイガニ雄",
                                         "アカガレイ",
                                         "サメガレイ",
                                         "ババガレイ"))
  # levels(data2$sp)
  
  g = ggplot(data2 %>% filter(data == "重量"), aes(x = year, y = sum/1000, fill = NS))
  b = geom_bar(stat = "identity", width = 1, colour = "black")
  f = facet_wrap(~ sp, ncol = 4, scales = "free")
  c = scale_fill_manual(values = c("grey40", "lightcoral")) #orangered
  lab = labs(x = "年", y = "", colour = "")
  
  
  th = theme(panel.grid.major = element_blank(),
             panel.grid.minor = element_blank(),
             axis.text.x = element_text(size = rel(1.5), angle = 90, colour = "black"),
             axis.text.y = element_text(size = rel(1.5), colour = "black"),
             axis.title.x = element_text(size = rel(1.5)),
             axis.title.y = element_text(size = rel(1.5)),
             legend.title = element_blank(),
             legend.text = element_text(size = rel(1.5)),
             strip.text.x = element_text(size = rel(1.5)),
             #legend.position = c(0.75, 0.05),
             legend.background = element_rect(fill = "white", size = 0.4, linetype = "solid", colour = "black"))
  
  fig = g+b+f+c+lab+theme_bw(base_family = "HiraKakuPro-W3")+th+scale_x_continuous(expand = c(0, 0), breaks = seq(as.numeric(min(data$year)), as.numeric(max(data$year)), by = 5))
  
  ggsave(file = paste0(dir_output, "/trendabst.png"), plot = fig, units = "in", width = 11.69, height = 8.27)
}


# run ---------------------------------------------------------------------
plot_trend_abst(data = all)
