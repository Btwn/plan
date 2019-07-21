
[Forma]
Clave=DM0264ConfigRedDimaFrm
Icono=0
Modulos=(Todos)
Nombre=Configuracion Red Dima

ListaCarpetas=Vista
CarpetaPrincipal=Vista
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=109
PosicionInicialAncho=272
ListaAcciones=Guardar<BR>Cerrar
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=547
PosicionInicialArriba=310
[Vista]
Estilo=Ficha
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0264ConfigRedDimaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S



ListaEnCaptura=DM0264ConfigRedDimaTbl.NumFinales<BR>DM0264ConfigRedDimaTbl.Cuota
PermiteEditar=S
[Vista.Columnas]
NumFinales=64
Cuota=64
TiempoDias=64

[Acciones.Guardar.Historico]
Nombre=Historico
Boton=0
TipoAccion=Expresion
Expresion=Asigna( Usuario,DM0264ConfigRedDimaVis:DM0264ConfigRedDimaTbl.Usuario )<BR>  Asigna( Sucursal, DM0264ConfigRedDimaVis:DM0264ConfigRedDimaTbl.Sucursal )
Activo=S
Visible=S


[Vista.DM0264ConfigRedDimaTbl.NumFinales]
Carpeta=Vista
Clave=DM0264ConfigRedDimaTbl.NumFinales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Vista.DM0264ConfigRedDimaTbl.Cuota]
Carpeta=Vista
Clave=DM0264ConfigRedDimaTbl.Cuota
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

