from database import conectar_mysql, conectar_mongo
 
# RQF004
def obtener_usuarios():
    """Consultar todos los usuarios"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("SELECT idUsuario, nombreUsuario, rolUsuario, correoUsuario, estadoUsuario FROM Usuario")
        return cursor.fetchall()
    except Exception as e:
        print(f" obtener_usuarios → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF005
def modificar_rol_usuario(id_usuario, nuevo_rol):
    """Cambia el rol de un usuario: 'admin' o 'ayudante'"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Usuario SET rolUsuario = %s WHERE idUsuario = %s",
                       (nuevo_rol, id_usuario))
        conexion.commit()
        print(f"Rol de usuario {id_usuario} actualizado a {nuevo_rol}")
        return True
    except Exception as e:
        print(f"modificar_rol_usuario → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF006
def modificar_estado_usuario(id_usuario, nuevo_estado):
    """Cambia el estado de un usuario: 'activo' o 'inactivo'"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Usuario SET estadoUsuario = %s WHERE idUsuario = %s",
                       (nuevo_estado, id_usuario))
        conexion.commit()
        print(f"Estado de usuario {id_usuario} actualizado")
        return True
    except Exception as e:
        print(f"modificar_estado_usuario → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF007
def cambiar_contrasena_usuario(id_usuario, nueva_contrasena_hash):
    """Actualiza la contraseña hasheada de un usuario"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Usuario SET contrasenaUsuario = %s WHERE idUsuario = %s",
                       (nueva_contrasena_hash, id_usuario))
        conexion.commit()
        print(f"Contraseña de usuario {id_usuario} actualizada")
        return True
    except Exception as e:
        print(f"cambiar_contrasena_usuario → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF009
def obtener_programas():
    """Lista completa de programas con fase PHVA"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Programa")
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_programas → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF011
def obtener_responsables():
    """Lista completa de responsables"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Responsable")
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_responsables → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF013
def obtener_info_capacitacion(id_capacitacion):
    """Información general de una capacitación específica"""
    conexion = conectar_mysql()
    if conexion is None: return None
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT c.tema, c.actividad, p.nombrePrograma
            FROM Capacitacion c
            INNER JOIN Programa p ON c.idProgramaFK = p.idPrograma
            WHERE c.idCapacitacion = %s
        """, (id_capacitacion,))
        return cursor.fetchone()
    except Exception as e:
        print(f"obtener_info_capacitacion → {e}"); return None
    finally:
        cursor.close(); conexion.close()
 
# RQF014
def obtener_capacitaciones():
    """Lista completa de capacitaciones con programa"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT c.idCapacitacion, c.tema, c.actividad, c.duracion,
                   c.asistenciaProgramada, c.accidentesAsociados,
                   p.nombrePrograma, p.fasePHVA
            FROM Capacitacion c
            INNER JOIN Programa p ON c.idProgramaFK = p.idPrograma
        """)
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_capacitaciones → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF015
def modificar_capacitacion(id_capacitacion, nuevo_tema, nueva_actividad):
    """Modifica tema y actividad de una capacitación"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            UPDATE Capacitacion SET tema = %s, actividad = %s
            WHERE idCapacitacion = %s
        """, (nuevo_tema, nueva_actividad, id_capacitacion))
        conexion.commit()
        print(f"Capacitación {id_capacitacion} actualizada")
        return True
    except Exception as e:
        print(f"modificar_capacitacion → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF016
def modificar_lista_responsables(id_capacitacion, id_responsable, accion):
    """Llama a sp_modificar_lista_responsables. accion: 'agregar' o 'eliminar'"""
    conexion = conectar_mysql()
    if conexion is None: return "Error de conexión"
    try:
        cursor = conexion.cursor()
        args = [id_capacitacion, id_responsable, accion, ""]
        result_args = cursor.callproc("sp_modificar_lista_responsables", args)
        conexion.commit()
        mensaje = result_args[3]
        print(f"sp_modificar_lista_responsables → {mensaje}")
        return mensaje
    except Exception as e:
        print(f"modificar_lista_responsables → {e}"); conexion.rollback()
        return f"Error: {e}"
    finally:
        cursor.close(); conexion.close()
 
# RQF017
def modificar_nombre_responsable(id_responsable, nuevo_nombre):
    """Modifica el nombre de un responsable"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Responsable SET nombreResponsable = %s WHERE idResponsable = %s",
                       (nuevo_nombre, id_responsable))
        conexion.commit()
        print(f"Responsable {id_responsable} actualizado")
        return True
    except Exception as e:
        print(f"modificar_nombre_responsable → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF019
def obtener_info_programacion(id_programacion):
    """Información de una programación específica"""
    conexion = conectar_mysql()
    if conexion is None: return None
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT pr.fechaProgramada, pr.horaProgramada, pr.lugarProgramado,
                   pr.modalidadProgramada, pr.estadoProgramacion, c.tema
            FROM Programacion pr
            INNER JOIN Capacitacion c ON pr.idCapacitacionFK = c.idCapacitacion
            WHERE pr.idProgramacion = %s
        """, (id_programacion,))
        return cursor.fetchone()
    except Exception as e:
        print(f"obtener_info_programacion → {e}"); return None
    finally:
        cursor.close(); conexion.close()
 
# RQF020
def modificar_estado_programacion(id_programacion, nuevo_estado):
    """Cambia el estado de una programación: 'realizada', 'programada', 'cancelada'"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Programacion SET estadoProgramacion = %s WHERE idProgramacion = %s",
                       (nuevo_estado, id_programacion))
        conexion.commit()
        print(f"Estado de programación {id_programacion} → {nuevo_estado}")
        return True
    except Exception as e:
        print(f"modificar_estado_programacion → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF021
def modificar_fecha_hora_programacion(id_programacion, nueva_fecha, nueva_hora):
    """Modifica fecha y hora de una programación"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            UPDATE Programacion SET fechaProgramada = %s, horaProgramada = %s
            WHERE idProgramacion = %s
        """, (nueva_fecha, nueva_hora, id_programacion))
        conexion.commit()
        print(f"Fecha/hora de programación {id_programacion} actualizada")
        return True
    except Exception as e:
        print(f"modificar_fecha_hora_programacion → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF022
def modificar_modalidad_programacion(id_programacion, nueva_modalidad):
    """Cambia modalidad de una programación: 'presencial' o 'virtual'"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Programacion SET modalidadProgramada = %s WHERE idProgramacion = %s",
                       (nueva_modalidad, id_programacion))
        conexion.commit()
        print(f"Modalidad de programación {id_programacion} → {nueva_modalidad}")
        return True
    except Exception as e:
        print(f"modificar_modalidad_programacion → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF023
def modificar_lugar_programacion(id_programacion, nuevo_lugar):
    """Modifica el lugar de una programación"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Programacion SET lugarProgramado = %s WHERE idProgramacion = %s",
                       (nuevo_lugar, id_programacion))
        conexion.commit()
        print(f"Lugar de programación {id_programacion} actualizado")
        return True
    except Exception as e:
        print(f"modificar_lugar_programacion → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF025
def obtener_cargos():
    """Lista de todos los cargos"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("SELECT * FROM Cargo")
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_cargos → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF027
def obtener_centros_trabajo():
    """Lista de todos los centros de trabajo"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("SELECT * FROM CentroTrabajo")
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_centros_trabajo → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF029
def obtener_trabajadores():
    """Lista completa de trabajadores con cargo y centro de trabajo"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT t.idTrabajador, t.documentoTrabajador, t.nombreTrabajador,
                   t.empresaDondeTrabaja, c.nombreCargo,
                   ct.nombreCentroTrabajo, ct.ciudad
            FROM Trabajador t
            INNER JOIN Cargo c ON t.idCargoFK = c.idCargo
            INNER JOIN CentroTrabajo ct ON t.idCentroTrabajoFK = ct.idCentroTrabajo
        """)
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_trabajadores → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF030
def modificar_info_trabajador(id_trabajador, nuevo_nombre, nueva_empresa):
    """Modifica nombre y empresa de un trabajador"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            UPDATE Trabajador SET nombreTrabajador = %s, empresaDondeTrabaja = %s
            WHERE idTrabajador = %s
        """, (nuevo_nombre, nueva_empresa, id_trabajador))
        conexion.commit()
        print(f"Trabajador {id_trabajador} actualizado")
        return True
    except Exception as e:
        print(f"modificar_info_trabajador → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF031
def modificar_cargo_trabajador(documento, nuevo_id_cargo):
    """Modifica el cargo de un trabajador por su documento"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Trabajador SET idCargoFK = %s WHERE documentoTrabajador = %s",
                       (nuevo_id_cargo, documento))
        conexion.commit()
        print(f"Cargo del trabajador {documento} actualizado")
        return True
    except Exception as e:
        print(f"modificar_cargo_trabajador → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF032
def modificar_centro_trabajador(documento, nuevo_id_centro):
    """Modifica el centro de trabajo de un trabajador por su documento"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Trabajador SET idCentroTrabajoFK = %s WHERE documentoTrabajador = %s",
                       (nuevo_id_centro, documento))
        conexion.commit()
        print(f"Centro de trabajo del trabajador {documento} actualizado")
        return True
    except Exception as e:
        print(f"modificar_centro_trabajador → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF033
def obtener_trabajadores_por_cargo(id_cargo):
    """Trabajadores que ejercen un cargo específico"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT c.nombreCargo, t.nombreTrabajador, t.documentoTrabajador
            FROM Cargo c
            INNER JOIN Trabajador t ON t.idCargoFK = c.idCargo
            WHERE c.idCargo = %s
        """, (id_cargo,))
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_trabajadores_por_cargo → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF034
def obtener_trabajadores_por_centro(id_centro):
    """Trabajadores de un centro de trabajo específico"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT ct.nombreCentroTrabajo, t.nombreTrabajador, t.documentoTrabajador
            FROM CentroTrabajo ct
            INNER JOIN Trabajador t ON t.idCentroTrabajoFK = ct.idCentroTrabajo
            WHERE ct.idCentroTrabajo = %s
        """, (id_centro,))
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_trabajadores_por_centro → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF035
def obtener_trabajadores_por_ciudad(ciudad):
    """Trabajadores por ciudad"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT t.nombreTrabajador, t.documentoTrabajador, ct.ciudad
            FROM Trabajador t
            INNER JOIN CentroTrabajo ct ON ct.idCentroTrabajo = t.idCentroTrabajoFK
            WHERE ct.ciudad = %s
        """, (ciudad,))
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_trabajadores_por_ciudad → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF036
def agregar_trabajador_programacion(id_programacion, id_trabajador):
    """Llama a sp_agregar_trabajador_programacion"""
    conexion = conectar_mysql()
    if conexion is None: return "Error de conexión"
    try:
        cursor = conexion.cursor()
        args = [id_programacion, id_trabajador, ""]
        result_args = cursor.callproc("sp_agregar_trabajador_programacion", args)
        conexion.commit()
        mensaje = result_args[2]
        print(f"sp_agregar_trabajador_programacion → {mensaje}")
        return mensaje
    except Exception as e:
        print(f"agregar_trabajador_programacion → {e}"); conexion.rollback()
        return f"Error: {e}"
    finally:
        cursor.close(); conexion.close()
 
# RQF037: Agregar todos los trabajadores de un centro a una programación
def agregar_trabajadores_por_centro(id_programacion, id_centro):
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            INSERT INTO Asistencia (asistio, idProgramacionFK, idTrabajadorFK)
            SELECT 0, %s, t.idTrabajador
            FROM Trabajador t
            WHERE t.idCentroTrabajoFK = %s
        """, (id_programacion, id_centro))
        conexion.commit()
        print(f"Trabajadores del centro {id_centro} agregados a programación {id_programacion}")
        return True
    except Exception as e:
        print(f"agregar_trabajadores_por_centro → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF038: Agregar todos los trabajadores de una ciudad a una programación
def agregar_trabajadores_por_ciudad(id_programacion, ciudad):
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            INSERT INTO Asistencia (asistio, idProgramacionFK, idTrabajadorFK)
            SELECT 0, %s, t.idTrabajador
            FROM Trabajador t
            INNER JOIN CentroTrabajo ct ON t.idCentroTrabajoFK = ct.idCentroTrabajo
            WHERE ct.ciudad = %s
        """, (id_programacion, ciudad))
        conexion.commit()
        print(f"Trabajadores de {ciudad} agregados a programación {id_programacion}")
        return True
    except Exception as e:
        print(f"agregar_trabajadores_por_ciudad → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF039: Agregar todos los trabajadores de un cargo a una programación
def agregar_trabajadores_por_cargo(id_programacion, id_cargo):
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            INSERT INTO Asistencia (asistio, idProgramacionFK, idTrabajadorFK)
            SELECT 0, %s, t.idTrabajador
            FROM Trabajador t
            WHERE t.idCargoFK = %s
        """, (id_programacion, id_cargo))
        conexion.commit()
        print(f"Trabajadores del cargo {id_cargo} agregados a programación {id_programacion}")
        return True
    except Exception as e:
        print(f"agregar_trabajadores_por_cargo → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF040
def obtener_num_asistentes_programacion(id_programacion):
    """Número de asistentes citados a una programación"""
    conexion = conectar_mysql()
    if conexion is None: return 0
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT COUNT(*) AS totalAsistentes
            FROM Asistencia WHERE idProgramacionFK = %s
        """, (id_programacion,))
        return cursor.fetchone()
    except Exception as e:
        print(f"obtener_num_asistentes_programacion → {e}"); return 0
    finally:
        cursor.close(); conexion.close()
 
# RQF041
def obtener_lista_asistentes_programacion(id_programacion):
    """Lista de trabajadores citados a una programación"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT t.nombreTrabajador, t.documentoTrabajador, a.asistio
            FROM Asistencia a
            INNER JOIN Trabajador t ON a.idTrabajadorFK = t.idTrabajador
            WHERE a.idProgramacionFK = %s
        """, (id_programacion,))
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_lista_asistentes_programacion → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF042
def obtener_programaciones_por_estado(estado):
    """Programaciones filtradas por estado: 'realizada', 'programada', 'cancelada'"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT pr.idProgramacion, pr.fechaProgramada, pr.horaProgramada,
                   pr.lugarProgramado, pr.modalidadProgramada, c.tema
            FROM Programacion pr
            INNER JOIN Capacitacion c ON pr.idCapacitacionFK = c.idCapacitacion
            WHERE pr.estadoProgramacion = %s
        """, (estado,))
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_programaciones_por_estado → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF043
def obtener_programaciones_por_fechas(fecha_inicio, fecha_fin):
    """Programaciones en un rango de fechas"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT pr.idProgramacion, pr.fechaProgramada, pr.horaProgramada,
                   pr.estadoProgramacion, c.tema
            FROM Programacion pr
            INNER JOIN Capacitacion c ON pr.idCapacitacionFK = c.idCapacitacion
            WHERE pr.fechaProgramada BETWEEN %s AND %s
            ORDER BY pr.fechaProgramada
        """, (fecha_inicio, fecha_fin))
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_programaciones_por_fechas → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF044
def eliminar_asistencia_no_realizada(id_programacion, id_trabajador):
    """Elimina un registro de asistencia no realizada (asistio = 0)"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            DELETE FROM Asistencia
            WHERE idProgramacionFK = %s AND idTrabajadorFK = %s AND asistio = 0
        """, (id_programacion, id_trabajador))
        conexion.commit()
        print(f"Asistencia eliminada: programación {id_programacion}, trabajador {id_trabajador}")
        return True
    except Exception as e:
        print(f"eliminar_asistencia_no_realizada → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF045
def registrar_asistencia(id_trabajador, id_programacion, fecha, evaluacion, comentarios):
    """Llama a sp_registrar_asistencia y retorna el mensaje del procedimiento"""
    conexion = conectar_mysql()
    if conexion is None: return "Error de conexión"
    try:
        cursor = conexion.cursor()
        args = [id_trabajador, id_programacion, fecha, evaluacion, comentarios, ""]
        result_args = cursor.callproc("sp_registrar_asistencia", args)
        conexion.commit()
        mensaje = result_args[5]  # El OUT p_mensaje queda en posición 5
        print(f"sp_registrar_asistencia → {mensaje}")
        return mensaje
    except Exception as e:
        print(f"registrar_asistencia → {e}"); conexion.rollback()
        return f"Error: {e}"
    finally:
        cursor.close(); conexion.close()
 
# RQF046
def registrar_comentarios_asistencia(id_trabajador, id_programacion, evaluacion, comentarios):
    """Registra evaluación y comentarios de un trabajador a una programación"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            UPDATE Asistencia SET evaluacionCapacitador = %s, comentariosCapacitacion = %s
            WHERE idTrabajadorFK = %s AND idProgramacionFK = %s
        """, (evaluacion, comentarios, id_trabajador, id_programacion))
        conexion.commit()
        print(f"Comentarios registrados para trabajador {id_trabajador}")
        return True
    except Exception as e:
        print(f"registrar_comentarios_asistencia → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF047 / RQF048 / RQF049
def obtener_estadisticas_trabajador(id_trabajador):
    """Capacitaciones programadas, asistidas y % cumplimiento de un trabajador"""
    conexion = conectar_mysql()
    if conexion is None: return None
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT
                COUNT(*) AS totalProgramadas,
                COUNT(CASE WHEN asistio = 1 THEN 1 END) AS totalAsistidas,
                ROUND(COUNT(CASE WHEN asistio = 1 THEN 1 END) * 100.0 / COUNT(*), 1) AS porcentaje
            FROM Asistencia WHERE idTrabajadorFK = %s
        """, (id_trabajador,))
        return cursor.fetchone()
    except Exception as e:
        print(f"obtener_estadisticas_trabajador → {e}"); return None
    finally:
        cursor.close(); conexion.close()
 
# RQF050
def obtener_promedio_evaluacion(id_programacion):
    """Promedio de evaluaciones de los trabajadores a una programación"""
    conexion = conectar_mysql()
    if conexion is None: return None
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT ROUND(AVG(evaluacionCapacitador), 2) AS promedio
            FROM Asistencia WHERE idProgramacionFK = %s
        """, (id_programacion,))
        return cursor.fetchone()
    except Exception as e:
        print(f"obtener_promedio_evaluacion → {e}"); return None
    finally:
        cursor.close(); conexion.close()
 
# RQF051
def registrar_accidente_capacitacion(id_capacitacion):
    """Suma 1 accidente a la capacitación indicada"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            UPDATE Capacitacion SET accidentesAsociados = accidentesAsociados + 1
            WHERE idCapacitacion = %s
        """, (id_capacitacion,))
        conexion.commit()
        print(f"Accidente registrado en capacitación {id_capacitacion}")
        return True
    except Exception as e:
        print(f"registrar_accidente_capacitacion → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 
# RQF052
def obtener_accidentes_capacitacion(id_capacitacion):
    """Número de accidentes asociados a una capacitación"""
    conexion = conectar_mysql()
    if conexion is None: return None
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT SUM(accidentesAsociados) AS totalAccidentes
            FROM Capacitacion WHERE idCapacitacion = %s
        """, (id_capacitacion,))
        return cursor.fetchone()
    except Exception as e:
        print(f"obtener_accidentes_capacitacion → {e}"); return None
    finally:
        cursor.close(); conexion.close()
 
# RQF053
def obtener_porcentaje_cumplimiento(id_programa, fecha_inicio, fecha_fin):
    """Porcentaje de cumplimiento por programa y rango de fechas"""
    conexion = conectar_mysql()
    if conexion is None: return None
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT nombrePrograma,
                fn_num_asistentes_fechas(%s, %s, %s)        AS numAsistentes,
                fn_asistencia_programada_fechas(%s, %s, %s) AS asistenciaProgramada,
                fn_porcentaje_cumplimiento_fechas(%s, %s, %s) AS porcentajeCumplimiento
            FROM Programa WHERE idPrograma = %s
        """, (id_programa, fecha_inicio, fecha_fin,
              id_programa, fecha_inicio, fecha_fin,
              id_programa, fecha_inicio, fecha_fin,
              id_programa))
        return cursor.fetchone()
    except Exception as e:
        print(f"obtener_porcentaje_cumplimiento → {e}"); return None
    finally:
        cursor.close(); conexion.close()
 
# RQF054
def obtener_trabajadores_externos():
    """Trabajadores que NO pertenecen a TGI (contratistas)"""
    conexion = conectar_mysql()
    if conexion is None: return []
    try:
        cursor = conexion.cursor(dictionary=True)
        cursor.execute("""
            SELECT t.nombreTrabajador, t.documentoTrabajador,
                   t.empresaDondeTrabaja, c.nombreCargo, ct.ciudad
            FROM Trabajador t
            INNER JOIN Cargo c ON t.idCargoFK = c.idCargo
            INNER JOIN CentroTrabajo ct ON t.idCentroTrabajoFK = ct.idCentroTrabajo
            WHERE t.empresaDondeTrabaja <> 'TGI'
        """)
        return cursor.fetchall()
    except Exception as e:
        print(f"obtener_trabajadores_externos → {e}"); return []
    finally:
        cursor.close(); conexion.close()
 
# RQF055
def modificar_fase_phva(id_programa, nueva_fase):
    """Modifica la fase PHVA de un programa: 'planear','hacer','verificar','actuar'"""
    conexion = conectar_mysql()
    if conexion is None: return False
    try:
        cursor = conexion.cursor()
        cursor.execute("UPDATE Programa SET fasePHVA = %s WHERE idPrograma = %s",
                       (nueva_fase, id_programa))
        conexion.commit()
        print(f"Fase PHVA del programa {id_programa} → {nueva_fase}")
        return True
    except Exception as e:
        print(f"modificar_fase_phva → {e}"); conexion.rollback(); return False
    finally:
        cursor.close(); conexion.close()
 

if __name__ == "__main__":
    print("\n── Trabajadores (primeros 3) ──")
    for t in obtener_trabajadores()[:3]:
        print(t)
 
    print("\n── Capacitaciones (primeras 3) ──")
    for c in obtener_capacitaciones()[:3]:
        print(c)
 
    print("\n── Programaciones realizadas ──")
    for p in obtener_programaciones_por_estado("realizada")[:3]:
        print(p)
 
    print("\n── Cumplimiento Programa 7 (2026) ──")
    print(obtener_porcentaje_cumplimiento(7, "2026-01-01", "2026-12-31"))
 
    print("\n── Trabajadores externos ──")
    for e in obtener_trabajadores_externos()[:3]:
        print(e)