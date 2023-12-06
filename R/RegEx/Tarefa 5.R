# Titanic --------------------------------------------------------------------

titanic <- read.csv("titanic.csv") %>% 
  bind_rows(read.csv("titanicII.csv"))

titanic %>% 
  filter(grepl("Cumings", Name))
# Pronomes
pronomes <- str_extract(titanic$Name, "[A-Za-z]+(?=\\.)")

# sum(is.na(pronomes))

# Lastname

lastname <- str_extract(titanic$Name, "[A-Za-z]+(?=\\,)")

# Nome
titanic$Name[517]

name <- str_extract(titanic$Name, "(?<=\\. ).*(?=\\()|(?<=\\. ).*$")
name <- trimws(name, "both")
 
df <- data.frame(name, lastname, pronomes, original = titanic$Name)
View(df)

str_extract(df$original, "(?<=\\().*(?=\\))")

df %>%
rowwise() %>% mutate(
  maidenname = case_when(
    grepl("Mrs|mrs|MRS|[cC]ountess|[lL]ady|Mlle", pronomes) ~ str_extract(original, "(?<=\\().*(?=\\))"),
    TRUE ~ NA_character_
    )
) %>% 
  filter(grepl("Mr(s)?", pronomes))%>% View

  
glimpse(titanic)
names(titanic)


# DATASUS ----------------------------------------------------------------

# https://datasus.saude.gov.br/transferencia-de-arquivos/#

library(read.dbc)
library(tidyverse)

# Tarefa 5 --------------------------------------------------------------------

tab <- read.table("RACA_COR.CNV", skip = 1, sep = ";", encoding = "latin1")

tab$V1

str_split(tab$V1, "  ")

str_extract(tab$V1, "[\\dA-Za-z,]+$")

tab$V1[10]

cod_prob <- str_extract(tab$V1[10], "1M.*") %>%
  str_split_1(",") %>% trimws("both")

desc_prob <- rep("RAÇA/COR (OUTROS INDEVIDOS)", length(cod_prob))

tab$V1

cod_bom <- tab$V1 %>%
  gsub(",", "", .) %>% 
  str_extract( "\\d+\\s*$") %>% 
  trimws("right")
cod_bom = cod_bom[1:9]

desc_bom <- tab$V1[1:9] %>%
  gsub(",", "", .) %>%
  trimws("both") %>%
  str_extract("(?<=\\d{1,2}).*(?=\\d{2})") %>%
  gsub("^\\d", "", .) %>%
  trimws("both")

  
df <- data.frame(descrição = c(desc_prob, desc_bom), código = c(cod_prob, cod_bom))

openxlsx::write.xlsx(df, "resultado.xlsx")
