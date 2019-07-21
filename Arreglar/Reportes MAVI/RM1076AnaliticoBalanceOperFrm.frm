[Forma]
Clave=RM1076AnaliticoBalanceOperFrm
Nombre=RM1076 Analitico Balance Operativo
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=200
PosicionInicialAncho=378
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Excel<BR>Cerrar<BR>Preli<BR>txt
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Periodo<BR>Info.Ano<BR>Mavi.RM1076cuentaFiltro<BR>Mavi.RM1076RubroFiltro<BR>Mavi.RM1076ConceptoFiltro
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Info.Periodo]
Carpeta=(Variables)
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Ano]
Carpeta=(Variables)
Clave=Info.Ano
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1076cuentaFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1076cuentaFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1076ConceptoFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1076ConceptoFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1076RubroFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1076RubroFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Excel.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Excel
Activo=S
Visible=S
ClaveAccion=RM1076AnaliticoBalanceOpeXlsRep
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Enviar a E&xcel
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asig<BR>rep
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
[Acciones.Preli]
Nombre=Preli
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
[Acciones.txt]
Nombre=txt
Boton=96
NombreEnBoton=S
NombreDesplegar=Generar &Txt
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asign<BR>repo
[Acciones.txt.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.txt.repo]
Nombre=repo
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1076AsciiAnaliticoBalanceOpeRep
Activo=S
Visible=S


