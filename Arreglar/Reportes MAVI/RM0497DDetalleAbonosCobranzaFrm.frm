[Forma]
Clave=RM0497DDetalleAbonosCobranzaFrm
Nombre=RM0497D Detalle de Abonos de Recuperación
Icono=145
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=491
PosicionInicialArriba=247
PosicionInicialAlturaCliente=239
PosicionInicialAncho=455
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM0497BEQCobCampo,Nulo)<BR>Asigna(Mavi.RM0497BQuincenaCobranza,si  Año(Hoy) > 15 entonces Mes(Hoy)*2 sino (Mes(Hoy)*2)-1 fin) <BR>Asigna(Mavi.RM0497BAgenteCobCampo,Nulo)<BR>Asigna(Info.Ejercicio, Año(hoy))<BR>Asigna(Mavi.RM0497BNivelCob,Nulo)<BR>Asigna(Mavi.DM0207Division,Nulo)<BR>Asigna(Mavi.Rm0497BZona,Nulo)<BR>Asigna(Mavi.Rm0497BTipo,Nulo)
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
CarpetaVisible=S
FichaEspacioEntreLineas=7
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=(Lista)
PermiteEditar=S
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=(Lista)
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
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
ConCondicion=S
EjecucionConError=S
Visible=S

EjecucionCondicion=Condatos(Mavi.RM0497BQuincenaCobranza) y Condatos(Info.Ejercicio)
EjecucionMensaje=<T>Los Campos  Ejercicio y Quincena Cobranza son Obligatorios<T><BR>Asigna(Mavi.RM0497NivelCob,<T><T>)
[(Variables).Mavi.RM0497BQuincenaCobranza]
Carpeta=(Variables)
Clave=Mavi.RM0497BQuincenaCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0497BNivelCob]
Carpeta=(Variables)
Clave=Mavi.RM0497BNivelCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.RM0497BEQCobCampo]
Carpeta=(Variables)
Clave=Mavi.RM0497BEQCobCampo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro






[Niveles.Columnas]
Nombre=261




[(Variables).MAvi.DM0207Division]
Carpeta=(Variables)
Clave=MAvi.DM0207Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.RM0497BZona]
Carpeta=(Variables)
Clave=Mavi.RM0497BZona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro










[Division.Columnas]
Division=284

[Vista.Columnas]
Zona=94







[Acciones.Imprimir.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Imprimir.Imprime]
Nombre=Imprime
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=ReporteImpresora(<T>RM0497DDetalleAbonosCobranzaRepImp<T>)
[Acciones.Imprimir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Condatos(Mavi.RM0497BQuincenaCobranza) y Condatos(Info.Ejercicio)
EjecucionMensaje=<T>Los Campos  Ejercicio y Quincena Cobranza son Obligatorios<T><BR>Asigna(Mavi.RM0497NivelCob,<T><T>)
EjecucionConError=S
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreEnBoton=S
NombreDesplegar=&Imprimir
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S



[Acciones.Excel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel.AExcel]
Nombre=AExcel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0497DDetalleAbonosCobranzaRepXls
Activo=S
Visible=S

[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Condatos(Mavi.RM0497BQuincenaCobranza) y Condatos(Info.Ejercicio)
EjecucionMensaje=<T>Los Campos  Ejercicio y Quincena Cobranza son Obligatorios<T><BR>Asigna(Mavi.RM0497NivelCob,<T><T>)
EjecucionConError=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S

[Acciones.TXT.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.TXT.GenerarTXT]
Nombre=GenerarTXT
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0497DDetalleAbonosCobranzaTXTRep
Activo=S
Visible=S

[Acciones.TXT.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S

EjecucionCondicion=Condatos(Mavi.RM0497BQuincenaCobranza) y Condatos(Info.Ejercicio)
EjecucionMensaje=<T>Los Campos  Ejercicio y Quincena Cobranza son Obligatorios<T><BR>Asigna(Mavi.RM0497NivelCob,<T><T>)
[Acciones.TXT]
Nombre=TXT
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S

[Acciones.Excel.ListaAccionesMultiples]
(Inicio)=Asigna
Asigna=AExcel
AExcel=Cerrar
Cerrar=(Fin)


[Acciones.TXT.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=GenerarTXT
GenerarTXT=Cerrar
Cerrar=(Fin)



[Acciones.Preliminar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Cerrar
Cerrar=(Fin)


[Acciones.Imprimir.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Imprime
Imprime=Cerrar
Cerrar=(Fin)








[(Variables).ListaEnCaptura]
(Inicio)=Info.Ejercicio
Info.Ejercicio=Mavi.RM0497BQuincenaCobranza
Mavi.RM0497BQuincenaCobranza=MAvi.DM0207Division
MAvi.DM0207Division=Mavi.RM0497BZona
Mavi.RM0497BZona=Mavi.RM0497BNivelCob
Mavi.RM0497BNivelCob=Mavi.RM0497BEQCobCampo
Mavi.RM0497BEQCobCampo=Mavi.RM0497BTipo
Mavi.RM0497BTipo=(Fin)

[(Variables).Mavi.RM0497BTipo]
Carpeta=(Variables)
Clave=Mavi.RM0497BTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

















[Forma.ListaAcciones]
(Inicio)=Preliminar
Preliminar=Excel
Excel=TXT
TXT=Imprimir
Imprimir=Cerrar
Cerrar=(Fin)


