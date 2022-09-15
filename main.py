from typing import Union
from fastapi import FastAPI
from pydantic import BaseModel
import Querys
import CargaCSVs

CargaCSVs.crear_CSVs()

app = FastAPI()

@app.get("/Pregunta1")
def Año_con_más_carreras():
    return Querys.Pregunta1()

@app.get("/Pregunta2")
def Piloto_con_mayor_cantidad_de_primeros_puestos():
    return Querys.Pregunta2()

@app.get("/Pregunta3")
def Nombre_del_circuito_más_corrido():
    return Querys.Pregunta3()

@app.get("/Pregunta4")
def Piloto_con_mayor_cantidad_de_puntos_con_constructor_Americano_o_Británico():
    return Querys.Pregunta4()

@app.get("/Query/")
def Insertar_Query_MySQL(Query: str):
    return (Querys.query(Query))
#Pregunta 1: select `year` from races group by `year` order by count(`year`) desc limit 1;
#Pregunta 2: SELECT CONCAT(d.forename, ' ',d.surname) FROM qualifying q JOIN drivers d ON q.driverId = d.driverId WHERE q.position = 1 GROUP BY q.driverId ORDER BY count(q.position) DESC LIMIT 1;
#Pregunta 3: SELECT c.name FROM races r JOIN circuits c ON (r.circuitId = c.circuitId) GROUP BY r.circuitId ORDER BY count(r.circuitId) DESC LIMIT 1;
#Pregunta 4: SELECT CONCAT(d.forename, ' ',d.surname) FROM results r JOIN constructors c ON (r.constructorId = c.constructorId) JOIN drivers d ON (r.driverId = d.driverId) WHERE c.nationality = 'British' OR c.nationality = 'American' GROUP BY r.driverId ORDER BY sum(r.points) DESC LIMIT 1;