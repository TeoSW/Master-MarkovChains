# 🌧️ Modelarea Probabilistică a Precipitațiilor din Sydney folosind Lanțuri Markov

> Proiect academic realizat în cadrul cursului **Statistică Aplicată și Data Science**  
> Facultatea de Cibernetică, Statistică și Informatică Economică — ASE București  
> Autori: **Danielov Matei**, **Nițu Vlad-Cristian**, **Miron Andreea-Paraschiva**, **Constantin Teodor-Vasile**

---

## 📌 Descriere

Acest proiect construiește și analizează un **lanț Markov discret** pentru modelarea evoluției zilnice a precipitațiilor în Sydney, pe baza datasetului *Rain in Australia* (Kaggle, 10 ani de date). Sunt acoperite toate etapele unui studiu de procese stochastice: definirea spațiului stărilor, estimarea matricei de tranziție, analiza proprietăților structurale, calculul distribuțiilor staționară și limită, și validarea prin simulare Monte Carlo.

📦 **Sursă date:** [Rain in Australia – Kaggle](https://www.kaggle.com/datasets/jsphyg/weather-dataset-rattle-package)

---

## 🎯 Obiective

- Discretizarea variabilei continue *Rainfall (mm)* în 3 stări meteorologice
- Estimarea matricei de tranziție prin metoda MLE (Maximum Likelihood Estimation)
- Analiza proprietăților lanțului: ireductibilitate, recurență, aperiodicitate, ergodicitate
- Calculul distribuției staționare și al distribuției limită (P¹⁰⁰)
- Calculul duratei medii de reîntoarcere pentru fiecare stare
- Simularea unei traiectorii de 365 de zile și replicarea de 10.000 de ori

---

## 🗂️ Structura Proiectului

```
📁 markov-precipitatii-sydney/
├── 📄 proiect_lanturi_markov.docx   # Documentul complet al proiectului
├── 📊 ppt_lanturi_markov.pptx       # Prezentarea rezultatelor
├── 📜 script_proiect.R              # Codul R complet
├── 📊 weatherAUS.xlsx               # Dataset (descărcat de pe Kaggle)
└── 📄 README.md
```

---

## 🧮 Metodologie

### Spațiul stărilor

Variabila `Rainfall` (mm/zi) a fost discretizată în 3 stări:

| Stare | Condiție | Simbol |
|---|---|---|
| **Uscat** | Rainfall = 0 mm | 🌤 |
| **Ploaie slabă** | 0 < Rainfall ≤ 2 mm | 🌦 |
| **Ploaie abundentă** | Rainfall > 2 mm | 🌧 |

### Matricea de tranziție estimată

```
              Ploaie_Abundenta  Ploaie_Slaba  Uscat
Ploaie_Ab.         0.75          0.14         0.11
Ploaie_Sl.         0.48          0.30         0.22
Uscat              0.27          0.36         0.37
```

### Proprietăți structurale

| Proprietate | Rezultat |
|---|---|
| Ireductibil | ✅ Da — toate stările comunică |
| Recurent | ✅ Da — nicio stare tranzientă |
| Aperiodic | ✅ Da — perioada = 1 pentru toate stările |
| **Ergodic** | ✅ Da — admite distribuție staționară unică |

### Distribuția staționară

```
π = (Ploaie_Abundentă: 0.1788,  Ploaie_Slabă: 0.2150,  Uscat: 0.6062)
```

Pe termen lung, Sydney este **uscat ~60.6%** din timp, cu ploaie slabă ~21.5% și ploaie abundentă ~17.9%.

### Durata medie de reîntoarcere

| Stare | Durata medie |
|---|---|
| 🌤 Uscat | ~1.65 zile |
| 🌦 Ploaie slabă | ~4.65 zile |
| 🌧 Ploaie abundentă | ~5.59 zile |

### Simulări

- **Traiectorie unică:** 365 de zile, pornind din starea „Uscat" — frecvențele relative converg către distribuția staționară
- **Replicare Monte Carlo:** 10.000 de simulări × 100 pași — distribuția stărilor finale validează modelul teoretic

---

## ⚙️ Instalare & Rulare

### Pachete necesare

```r
install.packages(c("tidyverse", "zoo", "readxl", "markovchain"))
```

### Rulare

1. Descarcă datasetul de pe [Kaggle](https://www.kaggle.com/datasets/jsphyg/weather-dataset-rattle-package) și salvează-l ca `weatherAUS.xlsx`
2. Actualizează calea fișierului în script:
```r
cale_fisier <- "calea/ta/catre/weatherAUS.xlsx"
```
3. Rulează `script_proiect.R` în RStudio sau din linie de comandă:
```bash
Rscript script_proiect.R
```

---

## 🛠️ Tehnologii utilizate

![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r)
![RStudio](https://img.shields.io/badge/RStudio-IDE-75AADB?logo=rstudio)

| Pachet | Utilizare |
|---|---|
| `markovchain` | Estimare MLE, proprietăți structurale, simulare |
| `tidyverse` | Filtrare, mutate, pipe-uri |
| `zoo` | Imputare LOCF pentru valori lipsă |
| `readxl` | Citire fișier Excel |

---

## 📊 Rezultate cheie

- Lanțul Markov estimat este **ergodic**, confirmând existența unei distribuții staționare unice
- Distribuția limită (P¹⁰⁰) **converge** la distribuția staționară, independent de starea inițială
- Simulările Monte Carlo (10.000 replicări) **validează** modelul teoretic cu erori neglijabile
- Variabilele comportamentale dominante: **frecvența zilelor uscate** (~60%) și **raritatea ploii abundente** (~18%)

---

*Proiect academic | ASE București*
