
# crypto historical pricing
library(httr)
library(tidyverse)


base_url <- "https://www.cryptocompare.com/"

# all coins ---------------------------------------------------------------
coin_list <- "api/data/coinlist"
get_coin_list <- GET(paste0(base_url,coin_list))
return_of_the_coin_list <- content(get_coin_list)
res <- bind_rows(return_of_the_coin_list$Data)
res %>% filter(grepl("IOTA",CoinName))



res <- GET("https://min-api.cryptocompare.com/data/pricemulti?fsyms=ETH,DASH&tsyms=BTC,USD,EUR")
content(res)

price_multi <- function(fsyms = c("ETH","DASH"), tsyms = c("BTC","USD","EUR")){
  base_url <- "https://min-api.cryptocompare.com/"
  api_endpoint <- "data/pricemulti?"
  fsyms_param <- paste0("fsyms=",paste0(fsyms, collapse = ","))
  tsyms_param <- paste0("&tsyms=",paste0(tsyms, collapse = ","))
  full_querry <- paste0(base_url, api_endpoint, fsyms_param, tsyms_param)
  res <- GET(full_querry)
  dat <- content(res)
  name_col <- data_frame("Sym"=names(dat))
  out <- bind_cols(name_col,bind_rows(dat))
  out$`Time Stamp` = Sys.time()
  return(out)
}


price_multi(fsyms = c("IOT","BTC")
            , tsyms = c("USD","ETH", "BTC")
            )


# historical prices --------------------------------------------------------



# COINBASE offers:
# 1 hour (minutes)
# 1 day (minutes)
# 1 week (hourly)
# 1 year (daily)
# all (daily)



# historical by minute ----------------------------------------------------
# can go back 24 hours
res <- content(GET("https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USD&limit=10000&aggregate=1&e=CCCAGG"))

res %>% 
  .$Data %>% 
  bind_rows() %>% 
  mutate(time = as.POSIXct(time, origin="1970-01-01")) %>% 
  select(time) %>% summary

# historical by hour ------------------------------------------------------
# can get entire history
res <- content(GET("https://min-api.cryptocompare.com/data/histohour?fsym=IOT&tsym=USD&limit=10000&aggregate=1&e=CCCAGG"))
res %>% 
  .$Data %>% 
  bind_rows() %>% 
  mutate(time = as.POSIXct(time, origin="1970-01-01")) %>% 
  select(time) %>% summary

# historical by day -------------------------------------------------------
res <- content(GET("https://min-api.cryptocompare.com/data/histoday?fsym=BTC&tsym=USD&limit=10000&aggregate=1&e=CCCAGG"))
res %>% 
  .$Data %>% 
  bind_rows() %>% 
  mutate(time = as.POSIXct(time, origin="1970-01-01")) %>% 
  select(time) %>% summary


# gives daily price at any timestamp:
"https://min-api.cryptocompare.com/data/pricehistorical?fsym=ETH&tsyms=BTC,USD,EUR&ts=1452680400"





