[Forma]
Clave=RM1079ExisVtasBacOrdfrm
Nombre=RM1079 Existencias, Ventas y BackOrder
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=185
PosicionInicialAncho=377
ListaAcciones=sucur<BR>txt<BR>cerrar
PosicionInicialIzquierda=487
PosicionInicialArriba=258
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
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
ListaEnCaptura=Mavi.RM1079SucursalesFiltro<BR>Mavi.RM1079GrupoFiltro<BR>Mavi.RM1079FamiliaFiltro<BR>Mavi.RM1079LineaFiltro
CarpetaVisible=S
[(Variables).Mavi.RM1079SucursalesFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1079SucursalesFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1079GrupoFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1079GrupoFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1079FamiliaFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1079FamiliaFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1079LineaFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1079LineaFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.txt.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.txt.acept]
Nombre=acept
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.txt]
Nombre=txt
Boton=88
NombreEnBoton=S
NombreDesplegar=Generar &Txt
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=asig<BR>acept
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.sucur]
Nombre=sucur
Boton=18
NombreEnBoton=S
NombreDesplegar=Configurar &Sucursales
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=RM1079SucursalEstadosFrm
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=SQL(<T>select Count(Acceso)  from Usuario where Usuario=:tUsr and Acceso in (<T>+Comillas(<T>COMPR_GERA<T>)+<T>,<T>+Comillas(<T>COMPR_AUXA<T>)+<T>)<T>,Usuario) > 0

