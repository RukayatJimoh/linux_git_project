#!/bin/bash


# --- ETL Bash Script with Environment Variables ---

# Step 0: Check if the URL environment variable is set, otherwise use a default value
if [ -z "$CSV_URL" ]; then
  echo "Environment variable CSV_URL not set. Using default URL."
  CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
else
  echo "Using URL from environment variable CSV_URL: $CSV_URL"
fi

# Defining variables
RAW_DIR="./raw"
CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
FILE_NAME="annual-enterprise-survey-2023-financial-year-provisional.csv"
TRANSFORMED_DIR="transformed"
TRANSFORMED_FILE="2023_year_finance.csv"
GOLD_DIR="gold"
GOLD_FILE="2023_year_finance_gold.csv"


# Step 1: Extract - Create raw directory and download the CSV file
echo "Starting the ETL process..."

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

# Step 2: Create transformed and gold directories
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


# Step 3: Transform the CSV file
# Rename column and select specific columns
echo "Transforming file..."
awk -F, 'BEGIN {OFS=","} 
    NR==1 {
        # Find the index of Variable_code and rename it
        for (i=1; i<=NF; i++) {
            if ($i == "Variable_code") col=i;
        }
        # Print new header with renamed column
        print "year", "Value", "Units", "variable_code"
    }
    NR>1 {
        # Print the corresponding data for the selected columns
        print $1, $2, $3, $col
    }' "$RAW_DIR/$FILE_NAME" > "$TRANSFORMED_DIR/$TRANSFORMED_FILE"

# Check if the transformed file was successfully created
if [ -f "$TRANSFORMED_DIR/$TRANSFORMED_FILE" ]; then
    echo "File successfully transformed and saved as $TRANSFORMED_DIR/$TRANSFORMED_FILE"
else
    echo "Failed to transform the file."
    exit 1
fi

# Move the transformed file to the Gold directory
echo "Moving transformed file into Gold folder..."
mv "$TRANSFORMED_DIR/$TRANSFORMED_FILE" "$GOLD_DIR/$GOLD_FILE"

# Check if the file was moved successfully
if [ -f "$GOLD_DIR/$GOLD_FILE" ]; then
  echo "File has been moved to the Gold folder."
else
  echo "Failed to move file to the Gold folder."
  exit 1
fi



