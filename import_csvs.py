import csv
import pyodbc
from pathlib import Path

# SQL Server connection details
server = 'cap2761cricardomolina.database.windows.net'
database = 'Final_Project'
username = 'admin_ct'
password = 'Demo123456'

# Connection string
conn_str = f'Driver={{ODBC Driver 17 for SQL Server}};Server={server};Database={database};UID={username};PWD={password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;'

# CSV folder path
csv_folder = Path(r'C:\Users\Ricar\OneDrive - Miami Dade College\CAP2761C Intermidiate Analitics\FINAL PROJECT\Himalayan+Expeditions')

def escape_sql_string(value):
    """Escape single quotes in SQL strings"""
    if value is None or value == '':
        return 'NULL'
    value = str(value).replace("'", "''")
    return f"'{value}'"

def import_csv_to_sql(csv_file, table_name, conn):
    """Import CSV file to SQL Server table"""
    cursor = conn.cursor()
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        rows = list(reader)
        
        print(f"\nImporting {len(rows)} rows from {csv_file.name} to {table_name}")
        
        # Get columns from CSV
        columns = list(rows[0].keys()) if rows else []
        col_list = ', '.join([f'[{col}]' for col in columns])
        
        for idx, row in enumerate(rows):
            values = []
            for col in columns:
                val = row.get(col, '')
                values.append(escape_sql_string(val))
            
            val_list = ', '.join(values)
            sql = f"INSERT INTO dbo.{table_name} ({col_list}) VALUES ({val_list})"
            
            try:
                cursor.execute(sql)
            except Exception as e:
                print(f"  Error on row {idx + 1}: {e}")
                print(f"  SQL: {sql[:200]}...")
        
        cursor.commit()
        print(f"  Successfully imported {len(rows)} rows")

try:
    conn = pyodbc.connect(conn_str)
    
    # Import each CSV file
    import_csv_to_sql(csv_folder / 'peaks.csv', 'peaks', conn)
    import_csv_to_sql(csv_folder / 'exped.csv', 'exped', conn)
    import_csv_to_sql(csv_folder / 'members.csv', 'members', conn)
    import_csv_to_sql(csv_folder / 'refer.csv', 'refer', conn)
    import_csv_to_sql(csv_folder / 'himalayan_data_dictionary.csv', 'himalayan_data_dictionary', conn)
    
    conn.close()
    print("\n✓ All CSV files imported successfully!")
    
except Exception as e:
    print(f"Connection error: {e}")
