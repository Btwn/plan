
[Forma]
Clave=RM0195COMSModificarComisionTCFrm
Icono=0
Modulos=(Todos)
Nombre=<T>Modificar Registro<T>
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=586
PosicionInicialArriba=315
PosicionInicialAlturaCliente=99
PosicionInicialAncho=194
VentanaSinIconosMarco=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir
[Principal]
Estilo=Ficha
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0195COMSComisionTCVis
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
ListaEnCaptura=RM0195COMSComisionTCTbl.TCPU<BR>RM0195COMSComisionTCTbl.TCMSI
CarpetaVisible=S

PermiteEditar=S



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
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Guardar Cambios<BR>Expresion<BR>Cerrar
ConCondicion=S
EjecucionCondicion=AvanzarCaptura<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Uen),Informacion(<T>Debe llenar el campo <UEN><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Mes),Informacion(<T>Debe llenar el campo <MES><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Anio),Informacion(<T>Debe llenar el campo <AÑO><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.TCPU),Informacion(<T>Debe llenar el campo <TCPU><T>) AbortarOperacion, verdadero)<BR>Si(Vacio(RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.TCMSI),Informacion(<T>Debe llenar el campo <TCMSI><T>) AbortarOperacion, verdadero)
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
ListaAccionesMultiples=Cancelar Cambios<BR>Expresion<BR>Cerrar
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Numero,)<BR>OtraForma(<T>RM0195COMSConsultaComisionTCFrm<T>,Forma.Accion(<T>Actualizar<T>))<BR><BR>Informacion(<T>SE ACTUALIZARON LOS CAMPOS DEL REGISTRO CON<T>+<BR>NuevaLinea +<BR><T>UEN = <T>+ RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Uen+<BR>NuevaLinea +<BR><T>MES = <T>+ RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Mes+<BR>NuevaLinea +<BR><T>AÑO = <T>+ RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.Anio+<BR>NuevaLinea + NuevaLinea +<BR><T>CON LOS SIGUIENTES VALORES:<T>+<BR>NuevaLinea +<BR><T>TCPU = <T>+ RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.TCPU+<BR>NuevaLinea +<BR><T>TCMSI = <T> + RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.TCMSI<BR>)
[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




[Acciones.Salir.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Numero,)



