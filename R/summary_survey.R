require(tidyverse)
require(openxlsx)


# directory -----------------------------------------------------
dir_input = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/input"
dir_output = "/Users/Yuki/Dropbox/業務/若鷹丸調査結果まとめ_東北底魚研究/2020年度/output"



# data ----------------------------------------------------------
pointsdata = read.xlsx(paste0(dir_input, "/in_操業記録データ.xlsx"), sheet = 1, startRow = 1)
pointsdata = pointsdata[, c(1, 16:20)]
colnames(pointsdata) = c("station", "lat1", "lat2", "lon1", "lon2", "memo")
pointsdata = pointsdata %>% mutate(lat = lat1+lat2/60, lon = lon1+lon2/60, date = str_sub(memo, -5, -2), station2 = ifelse(is.na(as.numeric(str_sub(memo, 2, 3))), str_sub(memo, 1, 2), str_sub(memo, 1, 1))) %>% filter(str_length(station2) == 1) %>% select(station, lon, lat, memo, date)



# check data ------------------------------------------------------

# # of survey points
nrow(pointsdata)

# survey date
unique(pointsdata$date)
