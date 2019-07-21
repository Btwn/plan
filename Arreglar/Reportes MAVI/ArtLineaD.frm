[Forma]
Clave=ArtLineaD
Nombre=ArtLineaD
Icono=0
Modulos=(Todos)
MovModulo=ArtLineaD
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=415
PosicionInicialArriba=328
PosicionInicialAlturaCliente=73
PosicionInicialAncho=536
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar Cambios<BR>AbrirForma<BR>Cerrar
IniciarAgregando=S
[Vista]
Estilo=Ficha
Clave=Vista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ArtLineaD
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ArtLineaD.ID<BR>ArtLineaD.ArtTipo<BR>ArtLineaD.CanalVenta
CarpetaVisible=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
[Vista.ArtLineaD.ID]
Carpeta=Vista
Clave=ArtLineaD.ID
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Vista.ArtLineaD.ArtTipo]
Carpeta=Vista
Clave=ArtLineaD.ArtTipo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Vista.ArtLineaD.CanalVenta]
Carpeta=Vista
Clave=ArtLineaD.CanalVenta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Vista.Columnas]
ID=64
ArtTipo=304
CanalVenta=64
[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Guardar<BR>Expresion<BR>Cerrar
[Acciones.Guardar Cambios.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si Condatos(ArtLineaD:ArtLineaD.ID) y Condatos(ArtLineaD:ArtLineaD.ArtTipo)  y Condatos(ArtLineaD:ArtLineaD.CanalVenta)<BR> Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>Son necesarios todos los campos<T>)<BR>   Abortaroperacion<BR>Fin
[Acciones.Guardar Cambios.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Informacion(<T>Registro Agregado<T>, BotonAceptar)
[Acciones.Guardar Cambios.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
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
EspacioPrevio=S
[Acciones.AbrirForma]
Nombre=AbrirForma
Boton=66
NombreEnBoton=S
NombreDesplegar=Explorador
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=ExplorarLineasportipoycanalventafrm
Activo=S
Visible=S
EspacioPrevio=S

