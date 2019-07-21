[Forma]
Clave=RM1143GastosGCambiosFrm
Icono=112
Modulos=(Todos)
ListaCarpetas=RM1143GastosGCambiosVis
CarpetaPrincipal=RM1143GastosGCambiosVis
PosicionInicialIzquierda=470
PosicionInicialArriba=88
PosicionInicialAlturaCliente=810
PosicionInicialAncho=339
Nombre=RM1143 Cambios Centros de Costos
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Importar<BR>Guardar Cambios
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
MenuTouchScreen=S
VentanaBloquearAjuste=S
[RM1143GastosGCambiosVis]
Estilo=Hoja
Clave=RM1143GastosGCambiosVis
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1143GastosGCambiosVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaTitulosEnBold=S
HojaFondoGris=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM1143GastosGCambiosTbl.ID<BR>RM1143GastosGCambiosTbl.Renglon<BR>RM1143GastosGCambiosTbl.ContUso
CarpetaVisible=S
[RM1143GastosGCambiosVis.RM1143GastosGCambiosTbl.ID]
Carpeta=RM1143GastosGCambiosVis
Clave=RM1143GastosGCambiosTbl.ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[RM1143GastosGCambiosVis.RM1143GastosGCambiosTbl.Renglon]
Carpeta=RM1143GastosGCambiosVis
Clave=RM1143GastosGCambiosTbl.Renglon
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[RM1143GastosGCambiosVis.RM1143GastosGCambiosTbl.ContUso]
Carpeta=RM1143GastosGCambiosVis
Clave=RM1143GastosGCambiosTbl.ContUso
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1143GastosGCambiosVis.Columnas]
ID=92
Renglon=98
ContUso=109
[Acciones.Importar]
Nombre=Importar
Boton=115
NombreEnBoton=S
NombreDesplegar=&Importar de Excel
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Enviar/Recibir Excel<BR>Actualizar Vista
[Acciones.Importar.Enviar/Recibir Excel]
Nombre=Enviar/Recibir Excel
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.Importar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
Antes=S
AntesExpresiones=Si (Vacio(RM1143GastosGCambiosVis:RM1143GastosGCambiosTbl.ID) O Vacio(RM1143GastosGCambiosVis:RM1143GastosGCambiosTbl.Renglon) O Vacio(RM1143GastosGCambiosVis:RM1143GastosGCambiosTbl.ContUso))<BR>ENTONCES<BR>    Error(<T>No se pueden ingresar campos vacios<T>)<BR>    AbortarOperacion<BR>SINO<BR>    Informacion(<T>Almacenamiento Concluido<T>)<BR>    Verdadero<BR>FIN
[Acciones.Importar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>EXEC SP_RM1143GastosGCambios<T>) 
Activo=S
Visible=S

