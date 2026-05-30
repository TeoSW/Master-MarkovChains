# 1. Încărcarea librăriilor (instalează-le mai întâi dacă nu le ai)
# install.packages("tidyverse")
# install.packages("zoo")
install.packages("tidyverse")
install.packages("zoo")
library(tidyverse)
library(zoo)

# 2. Importarea fișierului

install.packages("readxl")
library(readxl)

cale_fisier <- "c:/facultate master/semestrul 2 anul 1/procese si modele stochastice/proiect/weatherAUS.xlsx"

df <- read_excel(cale_fisier)

# 3. Pregătirea datelor (Alegem Sydney pentru consistență)
df_proiect <- df %>%
  filter(Location == "Sydney") %>%
  mutate(Date = as.Date(Date)) %>% # Ne asigurăm că R vede coloana ca dată calendaristică
  arrange(Date)                   # Ordonăm cronologic

# 4. Definirea Stărilor (Discretizarea Rainfall)
# Creăm 3 stări: 1 (Uscat), 2 (Ploaie Slabă), 3 (Ploaie Abundentă)
df_proiect <- df_proiect %>%
  mutate(Stare = case_when(
    Rainfall == 0 ~ "Uscat",
    Rainfall > 0 & Rainfall <= 2 ~ "Ploaie_Slaba",
    Rainfall > 2 ~ "Ploaie_Abundenta",
    TRUE ~ NA_character_ 
  ))

# 5. IMPUTAREA (Rezolvarea valorilor NA)
# Pasul A: Folosim Last Observation Carried Forward (LOCF)
# Dacă avem o zi cu NA, R va pune valoarea din ziua precedentă
df_proiect$Stare_Imputata <- na.locf(df_proiect$Stare, na.rm = FALSE)

# Pasul B: Dacă prima zi din setul de date era NA, na.locf nu are de unde să ia valoare.
# Completăm restul de NA cu "Moda" (cea mai des întâlnită stare, probabil "Uscat")
moda_vreme <- names(sort(table(df_proiect$Stare), decreasing = TRUE))[1]
df_proiect$Stare_Imputata[is.na(df_proiect$Stare_Imputata)] <- moda_vreme

# 6. Verificare rezultat
print(paste("Număr de NA rămase:", sum(is.na(df_proiect$Stare_Imputata))))
table(df_proiect$Stare_Imputata)

# 1. Instalează și încarcă pachetul necesar

install.packages("markovchain")
library(markovchain)

# 2. Estimarea matricei de tranziție (P)
# Folosim coloana 'Stare_Imputata' creată anterior
fit_markov <- markovchainFit(data = df_proiect$Stare_Imputata, method = "mle")

# Extragem matricea propriu-zisă
P <- fit_markov$estimate
print("Matricea de tranzitie P:")
print(P)

# 3. Vizualizarea Grafului Orientat (Cerința: reprezentarea sub formă de graf)
# Pachetul are o funcție de plot nativă
plot(P, edge.arrow.size = 0.5, main = "Graful tranzitiilor starii vremii")

# 4. Verificarea proprietăților structurale (Cerința: clase de comunicare, periodicitate)

# Verificăm dacă lanțul este ireductibil 
print(paste("Este lantul ireductibil?:", is.irreducible(P)))

# Afișarea claselor de comunicare 
# Aceasta va arăta dacă toate stările comunică între ele
print("Clasele de comunicare:")
print(communicatingClasses(P))

# Calcularea perioadei 
# Dacă dă un singur număr, e perioada întregului lanț
p <- period(P)
print(paste("Perioada lanțului este:", p))

# Stabilim dacă lanțul este aperiodic 
# Un lanț este aperiodic dacă perioada este 1
este_aperiodic <- (p == 1)
print(paste("Este lanțul aperiodic?:", este_aperiodic))

# Stabilim dacă lanțul este ergodic (Ireductibil + Aperiodic) 
print(paste("Este lanțul ergodic?:", is.irreducible(P) && este_aperiodic))

# Clasificarea stărilor 
print("Stări recurente:")
print(recurrentStates(P))

print("Stări tranziente:")
print(transientStates(P))

# 5. Comportamentul pe termen lung (Cerința: distribuția staționară și limită)

# A. Distribuția staționară (Vectorul pi)
# Aceasta se calculează după ce am stabilit că lanțul este ireductibil
pi_stat <- steadyStates(P)
print("Distribuția staționară (Probabilitățile de echilibru pe termen lung):")
print(pi_stat)

# B. Distribuția limită (Calculul lim P^n)
# Ridicăm matricea la o putere mare pentru a verifica convergența
P_limita <- P^100
print("Matricea limită (P^100):")
print(P_limita)

# C. Durata medie de reîntoarcere (Cerință specifică pentru lanțuri ireductibile)
# Calculează numărul mediu de zile până la revenirea în aceeași stare
print("Durata medie de reîntoarcere (exprimată în zile):")
meanRecurrenceTime(P)

# 7. Simulări și Replicări (Cerința: Simularea unei traiectorii și replicarea de 10.000 de ori)

# Fixăm o stare inițială sau o distribuție inițială
# Exemplu: Plecăm de la o zi "Uscat"
stare_initiala <- "Uscat"

# A. Simularea unei singure traiectorii (ex: pentru un an - 365 de zile)
stare_initiala <- "Uscat"

set.seed(123) # Pentru ca rezultatele să fie reproductibile
traiectorie_simulata <- rmarkovchain(n = 365, object = P, t0 = stare_initiala)

print("Primele 10 zile din traiectoria simulată:")
print(head(traiectorie_simulata, 10))

# B. REPLICAREA de 10.000 de ori (Cerință specifică)
# Vrem să vedem în ce stare se află procesul după 100 de pași, repetând experimentul de 10.000 de ori
replicari_10000 <- replicate(10000, {
  # Simulăm 100 de pași și extragem doar ultima stare
  sim <- rmarkovchain(n = 100, object = P, t0 = stare_initiala)
  tail(sim, 1)
})

# C. Calculul frecvențelor relative din cele 10.000 de simulări
distributie_simulata <- table(replicari_10000) / 10000

print("Distribuția starilor după 10.000 de replicări (la momentul n=100):")
print(distributie_simulata)

# D. Comparația finală (Verificarea modelului)
print("Comparație cu Distribuția Staționară teoretică (pi):")
print(pi_stat)
