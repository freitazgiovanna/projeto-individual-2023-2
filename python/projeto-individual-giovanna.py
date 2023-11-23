import psutil
import mysql.connector
from datetime import datetime
import time

def get_uptime():
    # Obtém o tempo de inicialização do sistema
    uptime_seconds = psutil.boot_time()
    
    # Calcula a diferença entre o tempo atual e o tempo de inicialização
    uptime_timedelta = datetime.now() - datetime.fromtimestamp(uptime_seconds)
    
    return uptime_timedelta

def format_timedelta(td):
    # Formata a diferença de tempo para uma string mais legível
    days, seconds = td.days, td.seconds
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    seconds = seconds % 60
    
    return f"{days} dias, {hours} horas, {minutes} minutos, {seconds} segundos"

while True:
    # Tempo de atividade do sistema
    uptime = get_uptime()
    formatted_uptime = format_timedelta(uptime)

    # Conectar ao banco de dados MySQL
    mydb = mysql.connector.connect(
        host='localhost',
        port='3306',
        user='aluno',
        password='sptech',
        database='secureATM'
    )

    if mydb.is_connected():
        print("-----------------------------------------")
        print(f"| Tempo de atividade do sistema: {formatted_uptime} |")
        
        # Criar um cursor
        mycursor = mydb.cursor()

        idATM = 1  # Substitua pelo valor correto
        ATMAgencia = 1  # Substitua pelo valor correto
        AgenciaEmpresa = 1 # Substitua pelo valor correto

        # Inserir tempo de atividade no banco de dados
        sql_query = """INSERT INTO tempoAtividade (atividade, fk__idATM, fk__ATMAgencia, fk__AgenciaEmpresa)
            VALUES (%s, %s, %s, %s)"""
        mycursor.execute(sql_query, (str(formatted_uptime), idATM, ATMAgencia, AgenciaEmpresa))

        # Fazer commit da transação
        mydb.commit()

        # Fechar o cursor e a conexão
        mycursor.close()
        mydb.close()
    else:
        print("Não foi possível conectar ao banco de dados.")

    # Aguardar 5 segundos antes da próxima iteração
    time.sleep(5)
