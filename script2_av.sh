#!/usr/bin/env bash
set -euo pipefail

MY_NAME="AnaMaciel"
MAIN_DIR="$(pwd)/Project_ibbc_$MY_NAME"
RAW_DATA="$MAIN_DIR/raw_data"
TRIMS="$MAIN_DIR/trims"
LOGS="$MAIN_DIR/logs"
RESULTS="$MAIN_DIR/results"

INPUT_DIR=~/aulas_IBBC/Exame
SAMPLE_LIST="$INPUT_DIR/samples2.txt"
THREADS=4

mkdir -p "$RAW_DATA" "$TRIMS" "$LOGS" \
         "$RESULTS/raw_fastqc" "$RESULTS/trim_fastqc" "$RESULTS/multiqc"

### Create samples2.txt
echo "[INFO] Generating samples2.txt from $INPUT_DIR..."
if ! ls "$INPUT_DIR"/*.fastq.gz >/dev/null 2>&1; then
    echo "[ERROR]  No .fastq.gz files were found in $INPUT_DIR"
    exit 1
fi

# # Preference: use 'find' with -printf (GNU find). If -printf is not available, use fallback.
if find "$INPUT_DIR" -maxdepth 1 -type f -name "*.fastq.gz" -printf "%f\n" >/dev/null 2>&1; then
    find "$INPUT_DIR" -maxdepth 1 -type f -name "*.fastq.gz" -printf "%f\n" | sort > "$SAMPLE_LIST"
else
    # Portable fallback (without -printf
    ls -1 "$INPUT_DIR"/*.fastq.gz | xargs -n1 basename | sort > "$SAMPLE_LIST"
fi

echo "[INFO] samples2.txt created at: $SAMPLE_LIST"
echo "[INFO] Contents (first lines):"
head "$SAMPLE_LIST" || true


echo "[INFO] Copying FASTQ files..."
cp "$INPUT_DIR"/*.fastq.gz "$RAW_DATA"

echo "[INFO] Running FastQC on raw data..."
fastqc "$RAW_DATA"/*.fastq.gz --outdir "$RESULTS/raw_fastqc" --threads "$THREADS" >> "$LOGS/fastqc_raw.log" 2>&1

echo "[INFO] Running FASTP..."
# Group by prefix (before _1 or _2), keeping compatibility with the current format
prefixes=$(awk -F'_1|_2' '{print $1}' "$SAMPLE_LIST" | sort -u)

for prefix in $prefixes; do
    # Be robust if ls finds nothing
    r1=$(ls "$RAW_DATA/${prefix}"*_1*.fastq.gz 2>/dev/null || true)
    r2=$(ls "$RAW_DATA/${prefix}"*_2*.fastq.gz 2>/dev/null || true)

    if [[ -z "$r1" || -z "$r2" ]]; then
        echo "[WARN] Missing pair for $prefix — skipping" | tee -a "$LOGS/fastp.log"
        continue
    fi

    out_r1="$TRIMS/${prefix}_trimmed_R1.fastq.gz"
    out_r2="$TRIMS/${prefix}_trimmed_R2.fastq.gz"

    echo "[INFO] Running fastp on sample: $prefix"
    fastp -i "$r1" -I "$r2" -o "$out_r1" -O "$out_r2" \
          --thread "$THREADS" --detect_adapter_for_pe \
          --length_required 50 \
          --html "$LOGS/fastp_${prefix}.html" --json "$LOGS/fastp_${prefix}.json" \
          >> "$LOGS/fastp.log" 2>&1
done

#FastQC after trimming 
echo "[INFO] Running FastQC after trimming..."
fastqc "$TRIMS"/*.fastq.gz --outdir "$RESULTS/trim_fastqc" --threads "$THREADS" >> "$LOGS/fastqc_trim.log" 2>&1

# MultiQC
echo "[INFO] Running MultiQC..."
multiqc "$RESULTS" -o "$RESULTS/multiqc" >> "$LOGS/multiqc.log" 2>&1
echo "[INFO] Done!"
