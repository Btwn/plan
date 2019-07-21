[Forma]
Clave=RM1128SucursalFrm
Nombre=RM1128Sucursal
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialAlturaCliente=667
PosicionInicialAncho=232
ListaCarpetas=Suc
CarpetaPrincipal=Suc
CarpetasMultilinea=S
ListaAcciones=Busca<BR>Selec
PosicionInicialIzquierda=429
PosicionInicialArriba=228
VentanaBloquearAjuste=S
[Suc]
Estilo=Iconos
Clave=Suc
PermiteLocalizar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1128SucursalVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
ListaEnCaptura=NombreSucursal
IconosNombre=RM1128SucursalVis:Sucursal
[Acciones.Busca]
Nombre=Busca
Boton=68
NombreEnBoton=S
NombreDesplegar=&Buscar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
[Acciones.Selec]
Nombre=Selec
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Regis<BR>Selec
[Suc.Columnas]
Sucursal=64
Nombre=604
0=-2
1=-2
[Acciones.Selec.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selec.Regis]
Nombre=Regis
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Suc<T>)
Activo=S
Visible=S
[Acciones.Selec.Selec]
Nombre=Selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1128SucMoti,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Suc.NombreSucursal]
Carpeta=Suc
Clave=NombreSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

