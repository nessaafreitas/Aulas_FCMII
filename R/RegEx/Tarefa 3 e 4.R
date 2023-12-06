# Lendo o PDF -----------------------------------------------------------------

pdf <- pdf_text("cadastro.pdf")
pdf <- str_split_1(pdf, "\\n")

# Encontrar as diferentes tabelas ---------------------------------------------

# Nome

pdf[grepl("[nN]ome:", pdf)]

x <- pdf[grepl("[nN]ome:", pdf)]
x <- gsub("[nN]ome:", "", x)
x <- gsub("\\(.*\\)", "", x)
x <- trimws(x, "both")

# Alias

pdf[grepl("[nN]ome:", pdf)]

y <- pdf[grepl("[nN]ome:", pdf)]
y <- str_extract(y, "\\(.*\\)")
y <- gsub("\\(.\\w+ |\\)", "", y)

# CEP (Tarefa 3)

pdf[grepl("CEP:", pdf)]

z <- pdf[grepl("CEP:", pdf)]
z <- gsub("\\w+: |\\w+ |\\w+, ", "", z)
z <- gsub("\\.|\\-", "", z)

z1 <- str_extract(z, "^\\d{5}")
z2 <- str_extract(z, "\\d{3}$")

z <- paste(z1, z2, sep = "-")

# CPF

pdf[grepl("[cC][pP][fF]:", pdf)]

cpf <-pdf[grepl("[cC][pP][fF]:", pdf)]
cpf <-gsub("[cC][pP][fF]:", "", cpf)
cpf <-gsub("\\D", "", cpf)

# Telefone

pdf
tel <-pdf[grepl("Tel", pdf)]
tel <-gsub("\\D", "", tel)

tel1 <-str_extract(tel, "^\\d{2}")
tel2 <-str_extract(tel, "(?<=\\d{2})\\d{5}(?=\\d{4})")
tel3 <-str_extract(tel, "(?<=\\d{7})\\d{4}")

tel <- paste0("(", tel1,") ", tel2, "-", tel3)

# Data de Nascimento

pdf
DN <- pdf[grepl("Da?ta? (de )?[Nn]asc", pdf)]
DN <- gsub(".*:", "", DN)
obs_DN <- str_extract(DN, "[A-Za-z]+\\.[A-Za-z]+\\.?$")

DN <-trimws(DN, "both")

DN <- str_extract(DN, "\\d+[-/]\\d+[-/]\\d+(\\.\\d+)?|\\d+[-/]\\w+[-/]\\d+")
DN <- gsub("\\.", "", DN)

DN <- gsub("([-/])(\\d{3})$", "\\10\\2", DN)
# 
# dt_teste <- c("12-12-281", "12/12/281")
# gsub("[-/](\\d{3})$", "-0\\1",dt_teste)
# 
# gsub("([-/])(\\d{3})$", "\\10\\2",dt_teste)

# Endereço (Tarefa 4)

pdf
end <- pdf[grepl("Endereço", pdf)]
end <- gsub("CEP.*", "", end)
end <- gsub("Endereço: *", "", end)

# número

numero <- str_extract(end, "\\d+")
# ifelse(is.na(numero), "SN", numero)

# Logradouro 

logradouro <- str_extract(end, "[A-Za-z]+\\s([A-Za-z]+\\s)?[A-Za-z]+\\,")
logradouro <- gsub("\\,", "", logradouro)

# Bairro

bairro <- gsub(".*,", "", end)
bairro <- gsub("[\\. ]", "", bairro)

# data frame

data.frame(Nome = x, Alias = y, CEP = z, CPF = cpf, Telefone = tel, 'Data de Nascimento' = DN, Número = numero, logradouro, bairro)

df <- data.frame(Nome = x, Alias = y, CEP = z, CPF = cpf, Telefone = tel, 'Data de Nascimento' = DN, Número = numero, logradouro, bairro)

openxlsx::write.xlsx(df, "resultado.xlsx")
