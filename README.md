---
title: "README"
output: html_document
---
**README - script1_av.sh script2_av.sh  script3_av.sh  **
   

**Script 1 - script1_av.sh**     
# Run the script1_av.sh (bash script1_av.sh)     
## This script creates the main project folder and subdirectories for organizing data and results.
Defines a custom name (MY_NAME) for the project.
Creates a main directory,in the current working directory.
Creates the following subfolders:

raw_data – for original FASTQ files.
trims – for trimmed FASTQ files.
logs – for log files from processing steps.
results – for analysis outputs
## It show a message after the process complete.   

**Script 2 - script2_av.sh**  
# Processes raw sequencing data: quality control, trimming, and summary reporting
# Before run the script its necessary activate the conda environment:  
```bash
conda activate tools_qc  
```           
# Run the script2_av.sh (bash script2_av.sh)        
*fastqc/fastp/multiqc*  
Creates additional subfolders inside results for FastQC and MultiQC reports.
Generates a samples2.txt file listing all FASTQ files found in the input directory.If the .gz files is present in the folder Exame. This way the files can be switch easly.   
Copies raw FASTQ files from ~/aulas_IBBC/Exame to raw_data.
Runs FastQC on raw data for quality assessment.
Runs fastp for adapter trimming and quality filtering:
-Produces trimmed FASTQ files in trims.  If the first trims is not suficient its necessary to add more filter or change the already written and run it again.  
-Generates HTML and JSON reports for each sample.

Runs FastQC again on trimmed data.
Runs MultiQC to aggregate all QC reports into a single summary.

In order the script work is necessary have the Input directory: ~/aulas_IBBC/Exame containing .fastq.gz files

**Script 3 - script3_av.sh**  
# Run the script3_av.sh (bash script3_av.sh)     
#Archives the results and logs for easy sharing or backup.  
Creates a compressed tarball named <MY_NAME>_results.zip containing:
-results folder (QC reports and summaries)
-logs folder (processing logs)
