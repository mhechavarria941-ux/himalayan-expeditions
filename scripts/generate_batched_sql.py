import csv
from pathlib import Path

csv_folder = Path(r'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions')

def escape_sql(value):
    if value is None or str(value).strip() == '':
        return 'NULL'
    s = str(value).replace("'", "''")
    return f"'{s}'"

def csv_to_sql_inserts_batched(csv_file, table_name, batch_size=1000):
    """Generate SQL inserts in batches"""
    # Try multiple encodings
    encodings = ['utf-8', 'latin-1', 'iso-8859-1', 'cp1252']
    
    for encoding in encodings:
        try:
            with open(csv_file, 'r', encoding=encoding) as f:
                reader = csv.DictReader(f)
                rows = list(reader)
            break
        except (UnicodeDecodeError, LookupError):
            continue
    else:
        print(f"WARNING: Could not decode {csv_file}")
        return []
    
    if not rows:
        return []
    
    columns = list(rows[0].keys())
    col_list = ', '.join([f'[{col}]' for col in columns])
    
    batches = []
    current_batch = [f"-- Batch: {table_name}"]
    
    for idx, row in enumerate(rows):
        values = []
        for col in columns:
            val = row.get(col, '')
            values.append(escape_sql(val))
        
        val_list = ', '.join(values)
        sql = f"INSERT INTO dbo.{table_name} ({col_list}) VALUES ({val_list});"
        current_batch.append(sql)
        
        if len(current_batch) > batch_size:
            batches.append('\n'.join(current_batch))
            current_batch = [f"-- Batch continuation: {table_name}"]
    
    if len(current_batch) > 1:
        batches.append('\n'.join(current_batch))
    
    return batches

# Generate batched SQL files
output_project = csv_folder.parent

for table_file, table_name in [
    ('peaks.csv', 'peaks'),
    ('exped.csv', 'exped'),
    ('members.csv', 'members'),
    ('refer.csv', 'refer'),
    ('himalayan_data_dictionary.csv', 'himalayan_data_dictionary')
]:
    csv_path = csv_folder / table_file
    if csv_path.exists():
        print(f"Processing {table_file}...")
        batches = csv_to_sql_inserts_batched(csv_path, table_name, batch_size=500)
        
        for batch_idx, batch in enumerate(batches):
            output_file = output_project / f'insert_{table_name}_{batch_idx:03d}.sql'
            header = "SET NOCOUNT ON;\n\n"
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(header + batch + "\n\nSELECT 'Batch " + str(batch_idx) + " completed' AS Status;")
            print(f"  Generated: {output_file.name}")

print("\nGenerated individual batch files for each table.")
print("Execute them in this order:")
print("  1. insert_peaks_*.sql")
print("  2. insert_exped_*.sql")
print("  3. insert_himalayan_data_dictionary_*.sql")
print("  4. insert_refer_*.sql")
print("  5. insert_members_*.sql")
