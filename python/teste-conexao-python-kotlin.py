import subprocess
import time
import mysql.connector

def run_kotlin():
    kotlin_script_path = "C:\\Users\\Aluno\\Desktop\\Arquivos Temporários\\projeto-individual\\target\\projeto-individual-1.0-SNAPSHOT-jar-with-dependencies"
    kotlin_process = subprocess.Popen(["java", "-jar", kotlin_script_path])
    kotlin_process.wait()

def run_python():
    python_script_path = "C:\\Users\\Aluno\\Downloads\\projetoindividual\\projeto-individual-giovanna.py"
    python_process = subprocess.Popen(["python", python_script_path])
    python_process.wait()

while True:
    run_kotlin()
    run_python()
    time.sleep(5)
