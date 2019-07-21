[Forma]
Clave=RM1065ResumenCtasResulOpefrm
Nombre=<T>Resumen de Cuentas de Resultado Operativo<T>
Icono=0
Modulos=(Todos)
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=437
PosicionInicialArriba=324
PosicionInicialAlturaCliente=191
PosicionInicialAncho=383
BarraAcciones=S
AccionesTamanoBoton=15x5
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=Acept<BR>cerr<BR>Excel
AccionesCentro=S
AccionesDivision=S
BarraHerramientas=S
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=5
FichaEspacioNombres=89
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Periodo<BR>Info.Ano
CarpetaVisible=S
FichaMarco=S
PermiteEditar=S
[Variables.Info.Periodo]
Carpeta=Variables
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.Ano]
Carpeta=Variables
Clave=Info.Ano
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Acept.ASIG]
Nombre=ASIG
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Acept.CERRAR]
Nombre=CERRAR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=ConDatos(Info.Periodo) y ConDatos(Info.Ano)
EjecucionMensaje=<T>Debe Seleccionar Periodo y Año<T>
[Acciones.Acept]
Nombre=Acept
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
EspacioPrevio=S
ListaAccionesMultiples=ASIG<BR>CERRAR
Activo=S
Visible=S
[Acciones.cerr]
Nombre=cerr
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Excel.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.xls]
Nombre=xls
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1065ResumenCtasResulOperativasrepxls
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=ConDatos(Info.Ano)   y  ConDatos(Info.Periodo)
EjecucionMensaje=<T>Debe Seleccionar Periodo Y Ejercicio<T>
EjecucionConError=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar a E&xcel
Multiple=S
EspacioPrevio=S
ListaAccionesMultiples=asigna<BR>xls<BR>cerrar
Activo=S
Visible=S
EnBarraHerramientas=S
[Acciones.Excel.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

