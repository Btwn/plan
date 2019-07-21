[Forma]
Clave=DM0206TMPGTECELDIVFRM
Icono=730
Modulos=(Todos)
ListaCarpetas=tablaAmortizacion
CarpetaPrincipal=tablaAmortizacion
PosicionInicialAlturaCliente=273
PosicionInicialAncho=481
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Importar<BR>Guardar<BR>Cerrar<BR>Limpiar
PosicionInicialIzquierda=589
PosicionInicialArriba=267
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=EjecutarSql(<T>Sp_Limpiar :tTBL<T>,<T>TMPGTECELDIV<T>)<BR>Forma.ActualizarForma
Nombre=<T>Importador Tabla Gerentes, Celula, Divisional Vista preeliminar<T>
[tablaAmortizacion]
Estilo=Hoja
Clave=tablaAmortizacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0206TMPGTECELDIVVISTA
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
ListaEnCaptura=TMPGTECELDIV.equipo<BR>TMPGTECELDIV.Nomina<BR>TMPGTECELDIV.Mensaje
CarpetaVisible=S
PermiteEditar=S
[tablaAmortizacion.TMPGTECELDIV.equipo]
Carpeta=tablaAmortizacion
Clave=TMPGTECELDIV.equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[tablaAmortizacion.TMPGTECELDIV.Nomina]
Carpeta=tablaAmortizacion
Clave=TMPGTECELDIV.Nomina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[tablaAmortizacion.Columnas]
equipo=160
Nomina=124
Mensaje=105
[Acciones.Importar]
Nombre=Importar
Boton=115
NombreEnBoton=S
NombreDesplegar=&Importador
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=controles Captura
ClaveAccion=enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=GUarda<BR>actualizar<BR>Validador
NombreEnBoton=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=borrar<BR>Cerrar
[Acciones.Guardar.actualizar]
Nombre=actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Guardar.GUarda]
Nombre=GUarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[tablaAmortizacion.TMPGTECELDIV.Mensaje]
Carpeta=tablaAmortizacion
Clave=TMPGTECELDIV.Mensaje
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Validador]
Nombre=Validador
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarForma<BR>EjecutarSQL(<T>SP_validador :tTABLA,:tTIPO1,:tTIPO2,:tTIPO3,:tGrupo,:tImp<T>,<T>TMPGTECELDIV<T>,<T>NULL<T>,<T>NULL<T>,<T>NULL<T>,Mavi.Grupo,mavi.importador)<BR>Forma.ActualizarForma<BR><BR>Si<BR>  SQL(<T>select count(*) from tmpgteceldiv <T>)=0<BR>Entonces<BR>  Error(<T>debe de incluir informacion en la vista preliminar<T>,6)<BR>Sino<BR>   Si<BR>  SQL(<T>select count(*) from TMPGTECELDIV where mensaje is not null<T>)=0<BR>Entonces<BR> informacion(<T>importación Existosa del tipo <T>+mavi.importador+<T> y de la categoría <T>+mavi.Grupo)<BR> EjecutarSql(<T>sp_importador :tTipo,:tGrupo<T>,mavi.importador,mavi.Grupo)<BR> Forma.ActualizarForma<BR>Sino<BR>         Forma.ActualizarForma<BR>    // Asigna(mavi.validador, EjecutarSQL(<T>SP_validador<T>) )                <BR><CONTINUA>
Expresion002=<CONTINUA>        Error(<T>Archivo con datos incorrectos<BR>  favor de validar los registros con la leyenda validar<BR>  posibles correcciones :<BR>      1.-Equi validar el equipo exista<BR>      2.-Tip  validar el tipo del agente,<BR>      y validar que el tipo corresponda a la categoría<BR>      3.-Cat  validar el agente corresponda a la categoria:<BR>      * Ventas Instituciones<BR>      * Ventas Avanzadas<BR>      * Reactivacion Ventas<BR>      ó el equipo pertenezca a la categoria: <T>+ Mavi.Grupo+<T><BR>      Cuando el agente tiene solo la leyenda de (VALIDAR: CAT,TIP), puede ser<BR>      que el agente no esta dado de alta, favor de capturar en Cuetas -> Agentes.<T>,1)<BR>        //informacion(  )<BR><BR>Fin<BR>Fin
[Acciones.Cerrar.borrar]
Nombre=borrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSql(<T>Sp_limpiar :tTbl<T>,<T>TMPGTECELDIV<T>)<BR>Forma.ActualizarForma
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Limpiar]
Nombre=Limpiar
Boton=32
NombreDesplegar=&Limpiar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Expresion=EjecutarSql(<T>Sp_Limpiar :tTBL<T>,<T>TMPGTECELDIV<T>)<BR>Forma.ActualizarForma

