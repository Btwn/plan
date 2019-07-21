[Forma]
Clave=RM1090PrincipalFRM
Nombre=RM1090 Clientes Saldo 0
Icono=44
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=92
PosicionInicialAncho=600
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=340
PosicionInicialArriba=447
ExpresionesAlMostrar=Asigna(Mavi.RM1090Canal,<T><T>)<BR>Asigna(Mavi.RM1090Poblacion,<T><T>)<BR>Asigna(Mavi.RM1090DVD,0)<BR>Asigna(Mavi.RM1090DVH,0)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Excel<BR>Cerrar
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
ListaEnCaptura=Mavi.RM1090Canal<BR>Mavi.RM1090Poblacion<BR>Mavi.RM1090DVD<BR>Mavi.RM1090DVH
CarpetaVisible=S
[(Variables).Mavi.RM1090Canal]
Carpeta=(Variables)
Clave=Mavi.RM1090Canal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1090Poblacion]
Carpeta=(Variables)
Clave=Mavi.RM1090Poblacion
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1090DVD]
Carpeta=(Variables)
Clave=Mavi.RM1090DVD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1090DVH]
Carpeta=(Variables)
Clave=Mavi.RM1090DVH
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.RM1090CteSaldoCeroREP]
Nombre=RM1090CteSaldoCeroREP
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1090CteSaldoCeroREP
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>RM1090CteSaldoCeroREP<BR>Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.RM1090CteSaldoCeroREP]
Nombre=RM1090CteSaldoCeroREP
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1090CteSaldoCeroREP
Activo=S
Visible=S
[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>RM1090CteSaldoCeroREP<BR>Cerrar
Activo=S
Visible=S

