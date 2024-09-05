#!/bin/bash

# Defining variables
RAW_DIR="./raw"
CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
FILE_NAME="annual-enterprise-survey-2023-financial-year-provisional.csv"
TRANSFORMED_DIR="transformed"
TRANSFORMED_FILE="2023_year_finance.csv"
GOLD_DIR="gold"
GOLD_FILE="2023_year_finance_gold.csv"

# Creating raw directory
if [ ! -d "$RAW_DIR" ]; then
    echo "Creating directory $RAW_DIR ..."
    mkdir "$RAW_DIR"
fi

# Download the CSV file
echo "Downloading $FILE_NAME from $CSV_URL..."
curl -o "$RAW_DIR/$FILE_NAME" "$CSV_URL"

# Check if file was successfully downloaded
if [ -f "$RAW_DIR/$FILE_NAME" ]; then
    echo "File $FILE_NAME has been saved into the directory $RAW_DIR"
else
    echo "Failed to download $FILE_NAME."
fi

# Creating transformed directory
if [ ! -d "$TRANSFORMED_DIR" ]; then
    echo "Creating directory $TRANSFORMED_DIR ..."
    mkdir "$TRANSFORMED_DIR"
fi

# Creating the gold directory 
if [ ! -d "$GOLD_DIR" ]; then
    echo "Creating directory $GOLD_DIR ..." 
    mkdir "$GOLD_DIR"
fi