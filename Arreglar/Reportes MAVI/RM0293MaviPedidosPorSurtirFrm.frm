[Forma]
Clave=RM0293MaviPedidosPorSurtirFrm
Nombre=RM293 Pedidos Pendientes por Surtir
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=513
PosicionInicialArriba=282
PosicionInicialAlturaCliente=177
PosicionInicialAncho=334
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR><BR>asigna(Mavi.NomAgentes,sql(<T>select Acceso From Usuario where usuario = :tnombresiwis <T>, USUARIO))<BR><BR>SI (sql(<T>Select COUNT(Nombre) From TablaStd Where TablaSt = :tperfiliwis and nombre = :tn<T>, <T>CFG PERFILES RM293<T>,{Mavi.NomAgentes})) = 0<BR>    ENTONCES<BR>        Asigna(Mavi.SucursalD,Sucursal)<BR>        Asigna(Mavi.SucursalA,Sucursal)<BR><BR>SINO<BR>        Asigna(Mavi.SucursalD,Nulo)<BR>        Asigna(Mavi.SucursalA,Nulo)<BR>FIN<BR><BR>Asigna(Info.Cliente,Nulo)<BR>Asigna(Mavi.sw,0)
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.SucursalD<BR>Mavi.SucursalA<BR>Info.Cliente
CarpetaVisible=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.SucursalD]
Carpeta=(Variables)
Clave=Mavi.SucursalD
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Editar=S

[(Variables).Mavi.SucursalA]
Carpeta=(Variables)
Clave=Mavi.SucursalA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=cerrar
Activo=S
Visible=S
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Actualiza]
Nombre=Actualiza
Boton=0
NombreDesplegar=&Actualiza
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1









[Forma.ListaAcciones]
(Inicio)=Preliminar
Preliminar=Cerrar
Cerrar=Actualiza
Actualiza=(Fin)

