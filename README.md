## methods2021-8_v-team

### Analysis of Adverse Events among Adult Vaccinations reported to VAERS from 2019 to 2021

- The Vaccine Adverse Event Reporting System (VAERS) is a national vaccine safety post-marketing surveillance program, co-sponsored by the FDA and CDC, and serves an early warning system for detecting adverse events that were not detected in clinical trials in human subjects prior to marketing in the United States.

- This project seeks to classify reported events in VAERS as mild/moderate or serious, and use VAERS data to analyze the reporting of adverse events among vaccines administered to adults between 2019-2021. There are four research questions this project aims to address:

1. Among reports of all vaccine recipients from 2019-2021, which vaccines are most frequently reported in the VAERS dataset among adult patients? What are the symptoms/adverse events most commonly reported for this vaccine? 
2. Among these vaccines, what are the proportional reporting ratios for serious vs. non-serious events?
3. What are the relative frequencies of serious events (and general, all AEs) for groups of vaccine distributors?
4. What are the proportional reporting ratio of serious AEs between age groups across the emergency use authorized COVID-19 vaccines (i.e., Pfizer/BioNTech, Moderna, and Janssen)?

### Getting Started
This repository contains the following folder structure:
- "source" directory contains the input VAERS data files from 2019 to 2021 (last pulled 2021-03-28) that were used in this project analysis.
- "code" directory contains the Julia programs used in this project (in both .jl and .ipynb Jupyter Notebook formats).
- "dev" directory contains the intermediary data files produced during data processing and cleaning.
- "output" directory contains the output files produced during data analysis.

To replicate the analysis from start to finish, take the following steps:

1. Navigate to the "source" folder directory and unzip the following files:
    - 2019VAERSData.zip (3 .csv files)
    - 2020VAERSData.zip (3 .csv files)
    - 2021VAERSData.zip (3 .csv files)

2. To replicate data preparation, navigate to the "code" folder directory and run the following Julia programs in order:
    - 0_read-append-data.jl
    - 1_preprocessing.jl
    - 2_merge-data.jl
    - 3_processing-EDA.jl
    
3. Running the above programs should produce the file "19-21VAERSCOMB_clean.csv" in the "dev" folder directory. A "19-21VAERSCOMB_clean.zip" file containing the same .csv file is also included in the "dev" folder directory in this repository, if you want to skip to replicating the data analysis.

4. To replicate data analysis, navigate to the "code" folder directory and run the following Julia programs, each one corresponding to one of the 4 aims above:
    - For Aim 1: 4_analysis_aim1_ben.jl
    - For Aim 2: 4_analysis_aim2_emcmill2.jl
    - For Aim 3: 4_analysis_aim3_ytao.jl
    - For Aim 4: 4_analysis_aim4_ahuang.jl

### Acknowledgements
8_v-team Contributing Members:
- Andrew Huang
- Emma McMillan
- Ben Mosong
- Yanyu (Lily) Tao

Thanks to Neil Sarkar, Elizabeth Chen, Dilum Aluthge, and Michelle Mai for a wonderful methods2021 Spring semester!