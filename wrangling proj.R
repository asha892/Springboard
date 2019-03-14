
#step 1 
refine_original$company <- tolower(refine_original$company)
refine_original$company <- sub(pattern = ".*ps$", replacement = "Philips", x = refine_original$company) 
refine_original$company <- sub(pattern = "ak.*", replacement = "Akzo", x = refine_original$company)
refine_original$company <- sub(pattern = "v.*n", replacement = "Van Houten", x = refine_original$company) 
refine_original$company <- sub(pattern = "u.*r", replacement = "Unilever", x = refine_original$company) 


#step 2 
refine_original$product_code <- sapply(refine_original$Product.code...number, function(val) strsplit(as.character(val),"-")[[1]][1])
refine_original$product_number <- sapply(refine_original$Product.code...number, function(val) strsplit(as.character(val),"-")[[1]][2])

#step 3
#refine_original$product_category[refine_original$product_code == "x"] <- "Laptop"
#refine_original$product_category[refine_original$product_code == "p"] <- "Smart Phone"
#refine_original$product_category[refine_original$product_code == "v"] <- "TV"
#refine_original$product_category[refine_original$product_code == "q"] <- "Tablet"

refine_original <- refine_original %>%
  mutate(product_category = case_when(product_code == "x" ~ "Laptop",
                                      product_code == "p" ~ "Smart Phone",
                                      product_code == "v" ~ "TV",
                                      product_code == "q" ~ "Tablet"))
#step 4 
refine_original <- refine_original %>%
  mutate(full_address=paste(address,city,country,sep=","))

#step 5
refine_original <- refine_original %>%
mutate(company_philips=case_when(company=="Philips"~"1",company!="Philips"~"0"))
 refine_original <- refine_original %>%
mutate(company_akzo =case_when(company=="Akzo"~"1",company!="Akzo"~"0"))
 refine_original <- refine_original %>%
 mutate(company_van_houten=case_when(company=="Van Houten"~"1",company!="Van Houten"~"0"))
refine_original <- refine_original %>%
mutate(company_unilever=case_when(company=="Unilever"~"1",company!="Unilever"~"0"))  

refine_original <- refine_original %>%
mutate(product_smartphone=case_when(product_category=="SmartPhone"~"1",company!="SmartPhone"~"0"))
refine_original <- refine_original %>%
  mutate(product_tv=case_when(product_category=="TV"~"1",company!="TV"~"0"))
refine_original <- refine_original %>%
  mutate(product_laptop=case_when(product_category=="Laptop"~"1",company!="Laptop"~"0"))
refine_original <- refine_original %>%
  mutate(product_tablet=case_when(product_category=="Tablet"~"1",company!="Tablet"~"0"))








