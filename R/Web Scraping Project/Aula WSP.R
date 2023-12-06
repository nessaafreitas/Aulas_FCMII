library(RSelenium)
library(wdman)
library(netstat)
library(tidyverse)
library(rvest)

wpage <- "https://emec.mec.gov.br"
maxpages <- 13
selenium()

selenium(retcommand = TRUE, check = TRUE)

remote_driver <- rsDriver(
  browser = "firefox",
  port = free_port(),
  verbose = FALSE,
  chromever = NULL # necessário
)

remDr <- remote_driver$client

remDr$navigate(wpage)
Sys.sleep(15)