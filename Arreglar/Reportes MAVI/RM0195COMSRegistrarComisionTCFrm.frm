
[Forma]
Clave=RM0195COMSRegistrarComisionTCFrm
Icono=91
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=544
PosicionInicialArriba=398
PosicionInicialAlturaCliente=189
PosicionInicialAncho=191
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
IniciarAgregando=S
VentanaSinIconosMarco=S
Nombre=<T>Nuevo Registro<T>
[Principal]
Estilo=Ficha
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0195COMSComisionTCVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=10
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM0195COMSComisionTCTbl.Uen<BR>RM0195COMSComisionTCTbl.Mes<BR>RM0195COMSComisionTCTbl.Anio<BR>RM0195COMSComisionTCTbl.TCPU<BR>RM0195COMSComisionTCTbl.TCMSI
CarpetaVisible=S

[Principal.RM0195COMSComisionTCTbl.Uen]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.Uen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.Mes]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.Mes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.Anio]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.Anio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.TCPU]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.TCPU
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.TCMSI]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.TCMSI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Guardar<BR>Actualizar<BR>Cerrar
ConCondicion=S
EjecucionCondicion=AvanzarCaptura<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Uen),Informacion(<T>Debe llenar el campo <UEN><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Mes),Informacion(<T>Debe llenar el campo <MES><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Anio),Informacion(<T>Debe llenar el campo <AÑO><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.TCPU),Informacion(<T>Debe llenar el campo <TCPU><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.TCMSI),Informacion(<T>Debe llenar el campo <TCMSI><T>) AbortarOperacion, verdadero)<BR><BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM COMSHComisionTarjetaCredito WITH(NOLOCK) WHERE Uen = :nUen AND Mes = :nMes AND Anio = :nAnio<T>,<BR>      RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Uen,<BR>      RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Mes,<BR>      RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Anio) > 0<BR>Entonces<BR>  Informacion(<T>Ya existe un registro con la misma <UEN>, <MES> y <AÑO><T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin                                                                          
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Expresion=OtraForma(<T>RM0195COMSConsultaComisionTCFrm<T>,Forma.Accion(<T>Actualizar<T>))
Activo=S
Visible=S

[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

