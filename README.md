# 🌧️ Probabilistic Modelling of Sydney Rainfall using Markov Chains

> Academic project for the course **Applied Statistics and Data Science**  
> Faculty of Cybernetics, Statistics and Economic Informatics — Bucharest University of Economic Studies (ASE)

---

## 📌 Description

This project builds and analyzes a **discrete-time Markov chain** for modelling the daily evolution of rainfall in Sydney, based on the *Rain in Australia* dataset (Kaggle, 10 years of data). All stages of a stochastic processes study are covered: defining the state space, estimating the transition matrix, analyzing structural properties, computing the stationary and limit distributions, and validating through Monte Carlo simulation.

📦 **Data source:** [Rain in Australia – Kaggle](https://www.kaggle.com/datasets/jsphyg/weather-dataset-rattle-package)

---

## 🎯 Objectives

- Discretizing the continuous variable *Rainfall (mm)* into 3 weather states
- Estimating the transition matrix using MLE (Maximum Likelihood Estimation)
- Analyzing chain properties: irreducibility, recurrence, aperiodicity, ergodicity
- Computing the stationary distribution and the limit distribution (P¹⁰⁰)
- Computing the mean recurrence time for each state
- Simulating a 365-day trajectory and replicating it 10,000 times

---

## 🗂️ Project Structure

```
📁 markov-sydney-rainfall/
├── 📄 proiect_lanturi_markov.docx   # Full project document
├── 📊 ppt_lanturi_markov.pptx       # Results presentation
├── 📜 script_proiect.R              # Complete R script
├── 📊 weatherAUS.xlsx               # Dataset (downloaded from Kaggle)
└── 📄 README.md
```

---

## 🧮 Methodology

### State Space

The `Rainfall` variable (mm/day) was discretized into 3 states:

| State | Condition | Symbol |
|---|---|---|
| **Dry** | Rainfall = 0 mm | 🌤 |
| **Light Rain** | 0 < Rainfall ≤ 2 mm | 🌦 |
| **Heavy Rain** | Rainfall > 2 mm | 🌧 |

### Estimated Transition Matrix

```
              Heavy_Rain  Light_Rain  Dry
Heavy_Rain       0.75       0.14     0.11
Light_Rain       0.48       0.30     0.22
Dry              0.27       0.36     0.37
```

### Structural Properties

| Property | Result |
|---|---|
| Irreducible | ✅ Yes — all states communicate |
| Recurrent | ✅ Yes — no transient states |
| Aperiodic | ✅ Yes — period = 1 for all states |
| **Ergodic** | ✅ Yes — admits a unique stationary distribution |

### Stationary Distribution

```
π = (Heavy Rain: 0.1788,  Light Rain: 0.2150,  Dry: 0.6062)
```

In the long run, Sydney is **dry ~60.6%** of the time, with light rain ~21.5% and heavy rain ~17.9%.

### Mean Recurrence Times

| State | Mean recurrence time |
|---|---|
| 🌤 Dry | ~1.65 days |
| 🌦 Light Rain | ~4.65 days |
| 🌧 Heavy Rain | ~5.59 days |

### Simulations

- **Single trajectory:** 365 days starting from the "Dry" state — relative frequencies converge to the stationary distribution
- **Monte Carlo replication:** 10,000 simulations × 100 steps — the distribution of final states validates the theoretical model

---

## ⚙️ Installation & Usage

### Required packages

```r
install.packages(c("tidyverse", "zoo", "readxl", "markovchain"))
```

### Running the script

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/jsphyg/weather-dataset-rattle-package) and save it as `weatherAUS.xlsx`
2. Update the file path in the script:
```r
cale_fisier <- "your/path/to/weatherAUS.xlsx"
```
3. Run `script_proiect.R` in RStudio or from the command line:
```bash
Rscript script_proiect.R
```

---

## 🛠️ Technologies

![R](https://img.shields.io/badge/R-4.x-276DC3?logo=r)
![RStudio](https://img.shields.io/badge/RStudio-IDE-75AADB?logo=rstudio)

| Package | Usage |
|---|---|
| `markovchain` | MLE estimation, structural properties, simulation |
| `tidyverse` | Filtering, mutate, pipes |
| `zoo` | LOCF imputation for missing values |
| `readxl` | Reading Excel files |

---

## 📊 Key Results

- The estimated Markov chain is **ergodic**, confirming the existence of a unique stationary distribution
- The limit distribution (P¹⁰⁰) **converges** to the stationary distribution, regardless of the initial state
- Monte Carlo simulations (10,000 replications) **validate** the theoretical model with negligible errors
- Dominant behavioral variables: **frequency of dry days** (~60%) and **rarity of heavy rain** (~18%)

---

*Academic project | Bucharest University of Economic Studies (ASE)*
