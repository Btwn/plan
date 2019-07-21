[Forma]
Clave=GenerarLayoutsMAVI
Nombre=Generar Layouts
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
AccionesTamanoBoton=15x5
ListaCarpetas=GenerarLayoutsMAVI
CarpetaPrincipal=GenerarLayoutsMAVI
ListaAcciones=Cerrar<BR>Aceptar
PosicionInicialAlturaCliente=176
PosicionInicialAncho=248
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=516
PosicionInicialArriba=407
AccionesCentro=S
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Info.Empresa,<T>MAVI<T>)<BR>Asigna(Mavi.InstitucionMavi_A,12)<BR>ASigna(Info.Ejercicio, año(ahora) )<BR>Asigna(Info.Periodo,1)<BR>Asigna(Info.Quincena,1)
[GenerarLayoutsMAVI]
Estilo=Ficha
Clave=GenerarLayoutsMAVI
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=Info.Empresa<BR>Mavi.InstitucionMavi_A<BR>Info.Ejercicio<BR>Info.Periodo<BR>Info.Quincena
PermiteEditar=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
[GenerarLayoutsMAVI.Info.Periodo]
Carpeta=GenerarLayoutsMAVI
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[GenerarLayoutsMAVI.Info.Ejercicio]
Carpeta=GenerarLayoutsMAVI
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[GenerarLayoutsMAVI.Info.Empresa]
Carpeta=GenerarLayoutsMAVI
Clave=Info.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=&Generar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraAcciones=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
EspacioPrevio=S
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=//Asigna(Mavi.institucionMAVI_A,<T>20<T>)     <BR>ReportePantalla(sql(<T>select MaviNomRep from ventascanalmavi where id=:tinst<T>,Mavi.institucionMAVI_A), <T>{info.empresa}<T>,<T>{Mavi.InstitucionMAVI_A}<T>,{info.ejercicio},{info.periodo},{Info.Quincena} )
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[GenerarLayoutsMAVI.Mavi.InstitucionMavi_A]
Carpeta=GenerarLayoutsMAVI
Clave=Mavi.InstitucionMavi_A
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[GenerarLayoutsMAVI.Info.Quincena]
Carpeta=GenerarLayoutsMAVI
Clave=Info.Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


