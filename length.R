require(tidyverse)
require(openxlsx)


# directory -----------------------------------------------------
dir_input = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/input"
dir_output = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/output"



# data ----------------------------------------------------------
old = NULL
for(i in 5:19){
  temp = read.xlsx(paste0(dir_input, "/魚種別体長別資源量.xlsx"), sheet = i, startRow = 1)
  temp2 = temp %>% gather(key = size_cate, value = B, 4:ncol(temp))
  old = rbind(old, temp2)
}

latest = read.xlsx(paste0(dir_input, "/q_魚種別体長別資源量2020.xlsx"), sheet = 1, startRow = 1) %>% filter(集計単位名称 == "南北別計")
latest$和名;
sp = unique(old$和名)

new = NULL
for(i in 1:length(sp)){
  temp = latest[str_detect(latest$和名, sp[i]), ]
  l = old %>% filter(和名 == sp[i]) %>% select(size_cate) %>% mutate(nsize = as.numeric(size_cate)) 
  l = max(l$nsize)
  
  temp2 = data.frame(年 = as.numeric(str_sub(temp$調査種類名称, 1, 4)), 和名 = paste0(sp[i]), 南北 = c("北部", "南部"), l = temp[, 16:(16+l)])
  temp2 = temp2 %>% gather(key = size_cate, value = B, 4:(ncol(temp2))) %>% mutate(size_cate = str_sub(size_cate, 5, 6), B = B/1000)
  new = rbind(new, temp2)
}
summary(new)

colnames(old); colnames(new)
all = rbind(old, new) %>% dplyr::rename(year = 年, sp = 和名, NS = 南北)
# ns = data.frame(NS = c("N", "S"), 南北 = c("北部", "南部"))
# all = left_join(all, ns, by = "南北") %>% select(-南北)
all$NS = factor(all$NS, levels = c("北部", "南部"))
levels(all$NS)
summary(all)

# function ------------------------------------------------------
plot_length = function(data){
  sp = unique(data$sp)
  
  for(i in 1:length(sp)){
    # data2 = data %>% dplyr::filter(sp == sp[i]) #なぜかうまく引っ掛からない
    i = 5
    data2 = data[str_detect(data$sp, sp[i]), ]
    check = data2 %>% group_by(year) %>% summarize(sum = sum(B)) %>% filter(sum == 0)
    remove = check$year
    
    # check2 = data2 %>% group_by(size_cate) %>% summarize(sum = sum(B)) %>% filter(sum == 0)
    # remove2 = as.numeric(check2$size_cate)
    # remove2 = remove2[-1]
    
    summary(data2)
    
    # if(nrow(check) > 0){
    #   if(nrow(check2) > 1){
    #     data3 = data2 %>% mutate(nsize = as.numeric(size_cate)) %>% filter(year != remove, size_cate < min(remove2))
    #   }else{
    #     data3 = data2 %>% mutate(nsize = as.numeric(size_cate)) %>% filter(year != remove) 
    #   }
    # }else{
    #   if(nrow(check2) > 1){
    #     data3 = data2 %>% mutate(nsize = as.numeric(size_cate)) %>% filter(nsize < min(remove2))
    #   }else{
    #     data3 = data2
    #   }
    # }
    
    if(nrow(check) > 0){
      data3 = data2 %>% mutate(nsize = as.numeric(size_cate)) %>% filter(year != remove)
    }else{
      data3 = data2
    }
    
    
    g = ggplot(data3, aes(x = as.numeric(size_cate), y = B/1000, fill = NS))
    b = geom_bar(position="dodge", stat = "identity", width = 0.8, colour = "black")
    f = facet_wrap(~ year, ncol = 6)
    c = scale_fill_manual(values = c("black", "red"))
    lab = labs(x = "体長（cm）", y = "尾数 (百万尾)", colour = "エリア")
    
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
    
    fig = g+b+f+c+lab+theme_bw(base_family = "HiraKakuPro-W3")+th+scale_x_continuous(expand = c(0, 0), breaks = seq(0, as.numeric(max(data3$size_cate)), by = 10))
    
    ggsave(file = paste0(dir_output, "/", sp[i], "length.png"), plot = fig, units = "in", width = 11.69, height = 8.27)
    
    
  }
  
  
}



# run -----------------------------------------------------------
plot_length(data = all)

