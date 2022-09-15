import pymysql

def Pregunta1():
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='PIDTS03', password='abc123')
    cursor = conexion.cursor()
    cursor.execute("select `year`, count(`year`) as Numero_carreras from races group by `year` order by Numero_carreras desc limit 1;")
    for dato in cursor:
        pass
    conexion.close()
    return("Año con mas carreras: "+str(dato[0]))

def Pregunta2():
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='PIDTS03', password='abc123')
    cursor = conexion.cursor()
    cursor.execute(" SELECT drivers.driverId, count(qualifying.position) as Cantidad_primeros_puestos, drivers.forename as Nombre, drivers.surname as Apellido FROM qualifying JOIN drivers ON qualifying.driverId = drivers.driverId WHERE position = 1 GROUP BY driverId ORDER BY Cantidad_primeros_puestos DESC LIMIT 1;")
    for dato in cursor:
        pass
    conexion.close()
    return("Piloto con mayor cantidad de primeros puestos:"+ dato[2]+' '+dato[3])

def Pregunta3():
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='PIDTS03', password='abc123')
    cursor = conexion.cursor()
    cursor.execute(" SELECT count(r.circuitId) as CantidadCarreras, c.name FROM races r JOIN circuits c ON (r.circuitId = c.circuitId) GROUP BY r.circuitId ORDER BY count(r.circuitId) DESC LIMIT 1;")
    for dato in cursor:
        pass
    conexion.close()
    return("Nombre del circuito más corrido:"+' '+ dato[1])

def Pregunta4():
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='PIDTS03', password='abc123')
    cursor = conexion.cursor()
    cursor.execute(" SELECT sum(r.points) as Puntaje_total, c.nationality as Nacionalidad_del_constructor, c.name as Nombre, d.forename as Nombre, d.surname as Apellido FROM results r JOIN constructors c ON (r.constructorId = c.constructorId) JOIN drivers d ON (r.driverId = d.driverId) WHERE c.nationality = 'British' OR c.nationality = 'American' GROUP BY r.driverId ORDER BY Puntaje_total DESC LIMIT 1;")
    for dato in cursor:
        pass
    conexion.close()
    return("Piloto con mayor cantidad de puntos (constructor Americano o Británico):"+ str(dato[3])+' '+str(dato[4]))

def query(query_):
    conexion = pymysql.connect (host='localhost', database='pidts03', user ='PIDTS03', password='abc123')
    cursor = conexion.cursor()
    cursor.execute(query_)
    salida = []
    for dato in cursor:
        salida.append(dato[0])
    return (salida)