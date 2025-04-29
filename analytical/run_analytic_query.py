import psycopg2
import sys
import re

def extract_total_exec_time(plan_text):
    """
    Procura pela linha com 'Execution Time' no plano do EXPLAIN ANALYZE.
    """
    match = re.search(r'Execution Time: ([\d.]+) ms', plan_text)
    if match:
        return float(match.group(1))
    return None

def run_query(filepath, repetitions):
    conn = psycopg2.connect(
        dbname="abd",
        user="postgres",
        password="postgres", ### mudar para a password do seu postgres 
        host="localhost",
        port="5432"
    )
    conn.autocommit = True 
    with open(filepath, 'r') as f:
        sql = f.read()

    total = 0
    print(f"\n== Executando {filepath} {repetitions}x com EXPLAIN ANALYZE ==\n")

    for i in range(2):
        cur = conn.cursor()
        cur.execute(sql)
        cur.close()    
    print("Runs de inicialização concluidas.")

    for i in range(repetitions):
        cur = conn.cursor()
        cur.execute(sql)
        plan = "\n".join(row[0] for row in cur.fetchall())

        exec_time = extract_total_exec_time(plan)
        if exec_time is not None:
            print(f"Run {i+1}: {exec_time:.2f} ms (medido no plano)")
            total += exec_time
        else:
            print(f"Run {i+1}: ERRO ao extrair tempo do plano!")

        cur.close()

    conn.close()

    avg = total / repetitions
    print(f"\n🏁 Tempo médio (EXPLAIN): {avg:.2f} ms em {repetitions} execuções.")

# ------------------------------
# Argumentos: ficheiro.sql num_repetições
# ------------------------------
if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python run_analytic_query.py qX.sql 5")
        sys.exit(1)

    filepath = sys.argv[1]
    reps = int(sys.argv[2])

    run_query(filepath, reps)
