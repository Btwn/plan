
[Forma]
Clave=DM0285EComTemporadasFrm
Icono=65
Modulos=(Todos)






ListaCarpetas=(Variables)<BR>Listado
CarpetaPrincipal=Listado
PosicionInicialIzquierda=433
PosicionInicialArriba=122
PosicionInicialAlturaCliente=501
PosicionInicialAncho=584
PosicionSec1=89
Nombre=Temporadas Ecommerce
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar<BR>ListaPrioridad<BR>Cerrar
PosicionCol1=381

BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Info.UEN, nulo )<BR> Asigna( Mavi.Dm0285Concepto, <T><T> )<BR> Asigna( Info.FechaD, nulo )<BR> Asigna( Info.FechaA, nulo )
[Ficha.DM0285EComTemporadas.uen]
Carpeta=Ficha
Clave=DM0285EComTemporadas.uen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Ficha.DM0285EComTemporadas.concepto]
Carpeta=Ficha
Clave=DM0285EComTemporadas.concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=70
ColorFondo=Blanco

[Ficha.DM0285EComTemporadas.fechaInicio]
Carpeta=Ficha
Clave=DM0285EComTemporadas.fechaInicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Ficha.DM0285EComTemporadas.fechaFin]
Carpeta=Ficha
Clave=DM0285EComTemporadas.fechaFin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Listado]
Estilo=Hoja
Clave=Listado
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=Dm0285EComTemporadasVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0285EComTemporadasTbl.uen<BR>DM0285EComTemporadasTbl.concepto<BR>DM0285EComTemporadasTbl.fechaInicio<BR>DM0285EComTemporadasTbl.fechaFin

GuardarPorRegistro=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática




HojaConfirmarEliminar=S
[Listado.Columnas]
uen=68
concepto=265
fechaInicio=101
fechaFin=99

id=31
UEN=68
Concepto=265
FechaInicio=101
FechaFin=99
[Acciones.Agregar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Acciones.Cerrar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
Multiple=S
EnMenu=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S

NombreDesplegar=&Cerrar
EspacioPrevio=S
NombreEnBoton=S
EnBarraHerramientas=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
Multiple=S
EnMenu=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
Activo=S
Visible=S
NombreDesplegar=&Guardar

NombreEnBoton=S
EnBarraHerramientas=S

[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.UEN<BR>Mavi.Dm0285Concepto<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

[(Variables).Info.UEN]
Carpeta=(Variables)
Clave=Info.UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.Dm0285Concepto]
Carpeta=(Variables)
Clave=Mavi.Dm0285Concepto
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.Columnas]
UEN=44
Nombre=185

[Acciones.Guardar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S





Expresion=SI  ConDatos(Info.UEN) y ConDatos(Mavi.Dm0285Concepto)y ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR><BR>Entonces   <BR><BR>   SI Info.FechaD   < Info.FechaA<BR>   Entonces<BR>        SI SQL(<T>SELECT COUNT(0) FROM TcWDM0285_ECommerceTemporada WHERE UEN = :nUen AND CONCEPTO=:tConc AND fechaInicio= :tFIni AND fechaFin= :tFFin<T>, Info.UEN, Mavi.Dm0285Concepto, FechaFormatoServidor(Info.FechaD), FechaFormatoServidor(Info.FechaA)) =0<BR>        ENTONCES<BR>        EjecutarSQL(<T>Exec SpWDM0285_InsertTemporada :nUen, :tConc, :tFIni, :tFFin<T>, Info.UEN, Mavi.Dm0285Concepto, FechaFormatoServidor(Info.FechaD), FechaFormatoServidor(Info.FechaA))<BR>        actualizarvista(<T>Dm0285EComTemporadasVis<T>)<BR>        SINO<BR>            Error(<T>Registro ya existe<T>)                   <BR>            AbortarOperacion<BR>         FIN<BR> Asigna( Info.UEN, nulo )<BR> Asigna( Mavi.Dm0285Concepto, <T><T> )<BR> Asigna( Info.FechaD, nulo )<BR> Asigna( Info.FechaA, nulo )<BR><BR> Sino<BR>          Error(<T>Fecha de inicio de ser menor que la fecha de final<T>)<BR>          AbortarOperacion<BR>   Fin<BR>                                                                                           <BR>Sino<BR>    Error(<T>Por favor capture los datos para continuar<T>)<BR>    abortarOperacion<BR>Fin
[Listado.DM0285EComTemporadasTbl.uen]
Carpeta=Listado
Clave=DM0285EComTemporadasTbl.uen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Listado.DM0285EComTemporadasTbl.concepto]
Carpeta=Listado
Clave=DM0285EComTemporadasTbl.concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=70
ColorFondo=Blanco

[Listado.DM0285EComTemporadasTbl.fechaInicio]
Carpeta=Listado
Clave=DM0285EComTemporadasTbl.fechaInicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Listado.DM0285EComTemporadasTbl.fechaFin]
Carpeta=Listado
Clave=DM0285EComTemporadasTbl.fechaFin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Acciones.ListaPrioridad]
Nombre=ListaPrioridad
Boton=18
NombreEnBoton=S
NombreDesplegar=Listas De Prioridad
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=DM0285COMSListaPrioridadFrm

[Acciones.Eliminar.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Eliminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar Temporada
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>  Confirmacion( <T>¿Desea eliminar el registro?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>Entonces<BR>  Verdadero<BR>Sino                                                                                       <BR>  AbortarOperacion<BR>Fin

