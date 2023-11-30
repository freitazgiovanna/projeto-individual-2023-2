import psutil
import mysql.connector
from datetime import datetime, timedelta
import time

# Função para autenticar o usuário
def autenticar_usuario(mycursor, email, senha):
    sql_query = "SELECT idUsuario FROM Usuario WHERE Email = %s AND Senha = %s"
    mycursor.execute(sql_query, (email, senha))
    result = mycursor.fetchone()
    return result

# Função para exibir a lista de ATMs disponíveis
def exibir_atms_disponiveis(mycursor):
    mycursor.execute("SELECT idATM, Modelo FROM ATM")
    atms_disponiveis = mycursor.fetchall()
    print("ATMs disponíveis para monitoramento:")
    for atm in atms_disponiveis:
        print(f"ATM ID: {atm[0]}, Modelo: {atm[1]}")

# Função para obter informações do ATM
def get_atm_info(mycursor, atm_id):
    sql_query = "SELECT fkAgenciaEmp, AgenciaID FROM ATM WHERE idATM = %s"
    mycursor.execute(sql_query, (atm_id,))
    result = mycursor.fetchone()
    return result

# Função para obter o tempo de atividade do sistema
def get_uptime():
    uptime_seconds = psutil.boot_time()
    uptime_timedelta = datetime.now() - datetime.fromtimestamp(uptime_seconds)
    return uptime_timedelta

# Função para formatar a diferença de tempo
def format_timedelta(td):
    days, seconds = td.days, td.seconds
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    seconds = seconds % 60
    return f"{days} dias, {hours} horas, {minutes} minutos, {seconds} segundos"

# ...

# Conectar ao banco de dados
mydb = mysql.connector.connect(host='localhost', port="3306", user="giba", password="fgandb25", database='secureATM')

if mydb.is_connected():
    print("------------------------------------------------------------")
    print("| Bem-vindo(a) à Secure ATM. Por favor, faça o login.       |")
    print("------------------------------------------------------------")

    # Solicitar e verificar e-mail e senha
    email = input("Digite o seu e-mail: ")
    senha = input("Digite a sua senha: ")

    mycursor = mydb.cursor()
    usuario_autenticado = autenticar_usuario(mycursor, email, senha)

    if usuario_autenticado:
        print("\nOlá! Selecione o ATM que você quer monitorar:")
        
        # Exibir ATMs disponíveis
        exibir_atms_disponiveis(mycursor)
        
        # Permitir ao usuário escolher um ATM para monitoramento
        atm_escolhido = input("Escolha o ATM pelo ID para monitorar:")
        
        # Obter informações do ATM escolhido
        atm_info = get_atm_info(mycursor, atm_escolhido)
        
        if atm_info:
            fk_AgenciaEmpresa, fk_ATMAgencia = atm_info
            print("\nMonitoramento iniciado.")

            while True:
                uptime = get_uptime()
                formatted_uptime = format_timedelta(uptime)

                # Coleta de dados da máquina
                cpu_percent = psutil.cpu_percent()
                ram_percent = psutil.virtual_memory().percent
                disk_percent = psutil.disk_usage('/').percent

                # Lista de variáveis que carregam os dados colhidos que serão inseridos nessa iteração EM ORDEM
                dados_insert_cpu = [cpu_percent]
                dados_insert_ram = [ram_percent]
                dados_insert_disk = [disk_percent]

                print("-----------------------------------------")
                print(f"| Tempo de atividade do sistema: {formatted_uptime} |")

                # Abre cursor permitindo inserção
                mycursor = mydb.cursor()

                # Armazenar fks em variáveis para a inserção
                fk_idATM = atm_escolhido
                fk_ATMAgencia = fk_ATMAgencia
                fk_AgenciaEmpresa = fk_AgenciaEmpresa

                sql_query = """INSERT INTO tempoAtividade (atividade, fk__idATM, fk__ATMAgencia, fk__AgenciaEmpresa)
                VALUES (%s, %s, %s, %s)"""
                mycursor.execute(sql_query, (str(formatted_uptime), fk_idATM, fk_ATMAgencia, fk_AgenciaEmpresa))

                # Inserção dados CPU
                sql_query_cpu = "INSERT INTO leitura (DataRegistro, Valor, Componente_ID, ATMComp_ID, APIID) VALUES (current_timestamp(), %s, 3, %s, 2)"
                mycursor.execute(sql_query_cpu, (dados_insert_cpu[0], fk_idATM))
                mydb.commit()

                # Inserção dados RAM
                sql_query_ram = "INSERT INTO leitura (DataRegistro, Valor, Componente_ID, ATMComp_ID, APIID) VALUES (current_timestamp(), %s, 1, %s, 2)"
                mycursor.execute(sql_query_ram, (dados_insert_ram[0], fk_idATM))
                mydb.commit()

                # Inserção dados DISCO
                sql_query_disk = "INSERT INTO leitura (DataRegistro, Valor, Componente_ID, ATMComp_ID, APIID) VALUES (current_timestamp(), %s, 2, %s, 2)"
                mycursor.execute(sql_query_disk, (dados_insert_disk[0], fk_idATM))
                mydb.commit()

                print(f"CPU: {cpu_percent}% | RAM: {ram_percent}% | Disco: {disk_percent}%")

                # Aguarda 10 segundos antes da próxima coleta e inserção
                time.sleep(10)
else:
    print("Não foi possível conectar ao banco de dados.")

# Fechar a conexão com o banco
mydb.close()
