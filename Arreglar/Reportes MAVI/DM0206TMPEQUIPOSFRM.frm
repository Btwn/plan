[Forma]
Clave=DM0206TMPEQUIPOSFRM
Nombre=<T>Importador Tabla Equipos Vista preeliminar<T>
Icono=730
Modulos=(Todos)
ListaCarpetas=tablaAmortizacion
CarpetaPrincipal=tablaAmortizacion
PosicionInicialAlturaCliente=319
PosicionInicialAncho=597
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Importador<BR>Guardar<BR>CerrarImpo<BR>Limpiar
PosicionInicialIzquierda=329
PosicionInicialArriba=224
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=EjecutarSql(<T>Sp_Limpiar :tTbl<T>,<T>TMPEQUIPOS<T>)<BR>Forma.ActualizarForma
[tablaAmortizacion]
Estilo=Hoja
Clave=tablaAmortizacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0206TMPEQUIPOSVISTA
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=TMPEQUIPOS.equipo<BR>TMPEQUIPOS.Nomina<BR>TMPEQUIPOS.Cargo<BR>TMPEQUIPOS.Mensaje
CarpetaVisible=S
PermiteEditar=S
[tablaAmortizacion.TMPEQUIPOS.equipo]
Carpeta=tablaAmortizacion
Clave=TMPEQUIPOS.equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[tablaAmortizacion.TMPEQUIPOS.Nomina]
Carpeta=tablaAmortizacion
Clave=TMPEQUIPOS.Nomina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[tablaAmortizacion.TMPEQUIPOS.Cargo]
Carpeta=tablaAmortizacion
Clave=TMPEQUIPOS.Cargo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[tablaAmortizacion.Columnas]
equipo=124
Nomina=124
Cargo=123
Mensaje=178
[Acciones.Importador]
Nombre=Importador
Boton=115
NombreDesplegar=&Importador
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar 
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Actualizar Forma<BR>saver<BR>Validador
[Acciones.CerrarImpo]
Nombre=CerrarImpo
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=borrar<BR>Cerrar
[Acciones.Guardar.saver]
Nombre=saver
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Guardar.Validador]
Nombre=Validador
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarForma<BR>EjecutarSQL(<T>SP_validador :tTABLA,:tTIPO1,:tTIPO2,:tTIPO3,:tGrupo,:tImportador<T>,<T>TMPEQUIPOS<T>,<T>VENDEDOR<T>,<T>JEFE ADMVO<T>,<T>AUXILIAR<T>,mavi.Grupo,mavi.importador)<BR>Forma.ActualizarForma<BR><BR>Si<BR>  SQL(<T>select count(*) from tmpequipos<T>)<=0<BR>Entonces<BR>   error(<T>debe de incluir informacion en la vista preliminar<T>,1)<BR>Sino<BR>   Si<BR>  SQL(<T>select count(*) from tmpequipos where mensaje is not null<T>)=0<BR>Entonces<BR>    informacion(<T>Importación existosa del tipo <T>+mavi.importador+<T>  y de la categoría <T>+mavi.Grupo)<BR>    EjecutarSql(<T>sp_Importador :tTabla,:tGrupo<T>,mavi.importador,Mavi.Grupo)<BR>Sino<BR>             Forma.ActualizarForma<BR>    // Asigna(mavi.validador, EjecutarSQL(<T>SP_validador<T>) )<BR>        Error(<CONTINUA>
Expresion002=<CONTINUA><T>Archivo con datos incorrectos<BR>  favor de validar los registros con la leyenda validar<BR>  posibles correcciones :<BR>      1.-Equi validar el equipo exista<BR>      2.-Tip  validar el tipo del agente,<BR>      y validar que el equipo y tipo corresponda a la categoria<BR>      3.-Cat  validar el agente corresponda a la categoria:<BR>      * Ventas Instituciones<BR>      * Ventas Avanzadas<BR>      * Reactivacion Ventas<BR>      ó el equipo corresponda a la categoria: <T>+ Mavi.Grupo+<T><BR>      Cuando el agente tiene solo la leyenda de (VALIDAR: CAT,TIP), puede ser<BR>      que el agente no esta dado de alta, favor de capturar en Cuetas -> Agentes.<T><BR>      ,1)<BR>        //informacion(  )<BR><BR>    Fin<BR>Fin
[tablaAmortizacion.TMPEQUIPOS.Mensaje]
Carpeta=tablaAmortizacion
Clave=TMPEQUIPOS.Mensaje
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=120
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Limpiar]
Nombre=Limpiar
Boton=32
NombreDesplegar=&Limpiar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Expresion=ejecutarSQL(<T>Sp_Limpiar :tTbl<T>,<T>TMPEQUIPOS<T>)<BR>Forma.ActualizarForma
[Acciones.CerrarImpo.borrar]
Nombre=borrar
Boton=0
TipoAccion=Expresion
Expresion=ejecutarSQL(<T>Sp_Limpiar :tTbl<T>,<T>TMPEQUIPOS<T>)<BR>Forma.ActualizarForma
Activo=S
Visible=S
[Acciones.CerrarImpo.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

