import csv
from pathlib import Path

csv_folder = Path(r'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions')

def escape_sql(value):
    if value is None or str(value).strip() == '':
        return 'NULL'
    s = str(value).replace("'", "''")
    return f"'{s}'"

def csv_to_sql_inserts(csv_file, table_name):
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
        return ""
        
    if not rows:
        return ""
    
    columns = list(rows[0].keys())
    col_list = ', '.join([f'[{col}]' for col in columns])
    
    sql_statements = [f"-- Insert {len(rows)} rows into {table_name}"]
    
    for row in rows:
        values = []
        for col in columns:
            val = row.get(col, '')
            values.append(escape_sql(val))
        
        val_list = ','.join(values)
        sql = f"INSERT INTO dbo.{table_name} ({col_list}) VALUES ({val_list});"
        sql_statements.append(sql)
    
    return '\n'.join(sql_statements)

# Generate SQL for all tables
output_sql = "SET NOCOUNT ON;\n\n"

# Generate inserts for each table
tables = [
    ('peaks.csv', 'peaks'),
    ('exped.csv', 'exped'),
    ('members.csv', 'members'),
    ('refer.csv', 'refer'),
    ('himalayan_data_dictionary.csv', 'himalayan_data_dictionary')
]

for csv_file, table_name in tables:
    csv_path = csv_folder / csv_file
    if csv_path.exists():
        print(f"Processing {csv_file}...")
        sql = csv_to_sql_inserts(csv_path, table_name)
        output_sql += f"\n{sql}\n\n"

# Write to file
output_file = csv_folder.parent / 'insert_data.sql'
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(output_sql)

print(f"✓ Generated SQL file: {output_file}")
print(f"  Size: {len(output_sql) / 1024 / 1024:.2f} MB")
print(f"\nRun the generated SQL file to insert all data into the database.")
