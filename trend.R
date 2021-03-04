require(tidyverse)
require(openxlsx)


# directory -----------------------------------------------------
dir_input = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/input"
dir_output = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/output"



# data ----------------------------------------------------------
old = NULL
for(i in 1:(2018-1995+1)){
  temp = read.xlsx(paste0(dir_input, "/1_1995～2018資源尾数、重量グラフ.xlsx"), sheet = i, startRow = 1)
  temp = temp[, 1:8]
  temp = temp %>% na.omit() %>% filter(南北 != "南北計")
  
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
plot_trend = function(data){
  sp = unique(data$sp)

  
  for(i in 1:length(sp)){
    # data2 = data %>% filter(sp == sp[i]) #なぜかうまく引っ掛からない
    data2 = data[data$sp == sp[i], ]
    
    g = ggplot(data2, aes(x = year, y = sum/1000, fill = NS))
    b = geom_bar(stat = "identity", width = 1, colour = "black")
    f = facet_wrap(~ data, ncol = 2, scales = "free")
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
    
    ggsave(file = paste0(dir_output, "/", sp[i], "trend.png"), plot = fig, units = "in", width = 11.69, height = 8.27)
    
    
    }
  
  
}



# run ---------------------------------------------------------------------
plot_trend(data = all)




# check values in each species ----------------------------------
suke0 = all %>% filter(sp == "スケトウダラ０＋") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))
suke1 = all %>% filter(sp == "スケトウダラ１＋") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))

mada0 = all %>% filter(sp == "マダラ０＋") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))
mada1 = all %>% filter(sp == "マダラ１＋") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))
mada2 = all %>% filter(sp == "マダラ２＋") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))

ito = all %>% filter(sp == "イトヒキダラ") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))

kiti = all %>% filter(sp == "キチジ") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))

zuwaf = all %>% filter(sp == "ズワイガニ雌") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))
zuwam = all %>% filter(sp == "ズワイガニ雄") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))

aka = all %>% filter(sp == "アカガレイ") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))

same = all %>% filter(sp == "サメガレイ") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))

baba = all %>% filter(sp == "ババガレイ") %>% group_by(year, data, sp) %>% summarize(sum = sum(sum))