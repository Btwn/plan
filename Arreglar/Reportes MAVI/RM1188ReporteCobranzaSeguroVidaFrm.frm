
[Forma]
Clave=RM1188ReporteCobranzaSeguroVidaFrm
Icono=570
Modulos=(Todos)
Nombre=REPORTE DE RECUPERACION SEGUROS DE VIDA
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
ListaAcciones=Excel<BR>Txt
PosicionInicialIzquierda=144
PosicionInicialArriba=91
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
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
ListaEnCaptura=Info.Ejercicio<BR>Info.MesSTMAVI<BR>Mavi.RM1188Division<BR>Mavi.RM1188Agente<BR>Mavi.RM1188Categoria
CarpetaVisible=S

PermiteEditar=S
FichaEspacioEntreLineas=16
FichaEspacioNombres=28
FichaColorFondo=Plata
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaAlineacionDerecha=S

[(Variables).Mavi.RM1188Division]
Carpeta=(Variables)
Clave=Mavi.RM1188Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1188Agente]
Carpeta=(Variables)
Clave=Mavi.RM1188Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1188Categoria]
Carpeta=(Variables)
Clave=Mavi.RM1188Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Excel.AsignarV]
Nombre=AsignarV
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsignarV<BR>ExcelV
Activo=S
Visible=S

[Acciones.Txt.AsignarT]
Nombre=AsignarT
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Txt]
Nombre=Txt
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsignarT<BR>TxtT
Activo=S
Visible=S

[Acciones.Excel.ExcelV]
Nombre=ExcelV
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1188ReporteCobranzaSeguroVidaRepXls
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
EjecucionCondicion=si(ConDatos(Info.Ejercicio) y Info.Ejercicio<><T>0<T>,si(ConDatos(Info.MesSTMAVI),verdadero,falso),Falso)
EjecucionMensaje=<T>Ejercicio y Mes son Obligatorio<T>
[Acciones.Txt.TxtT]
Nombre=TxtT
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1188ReporteCobranzaSeguroVidaRepTxt
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S

EjecucionCondicion=si(ConDatos(Info.Ejercicio) y Info.Ejercicio<>0,si(ConDatos(Info.MesSTMAVI),verdadero,falso),Falso)
EjecucionMensaje=<T>Ejercicio y Mes son obligatorios<T>
[Vista.Columnas]
division=214

Division=214
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.MesSTMAVI]
Carpeta=(Variables)
Clave=Info.MesSTMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


