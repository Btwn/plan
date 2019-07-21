[Forma]
Clave=RM0497BCobranPromoFrm
Nombre=RM0497B Recuperación Diaria de Cobranza
Icono=145
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=467
PosicionInicialArriba=247
PosicionInicialAlturaCliente=267
PosicionInicialAncho=431
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
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=(Lista)
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


















[Acciones.Preliminar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Cerrar
Cerrar=(Fin)










[Acciones.Imprimir.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Imprimir.Imp]
Nombre=Imp
Boton=0
TipoAccion=Expresion
Expresion=ReporteImpresora(<T>RM0497BCobranPromoRep<T>)
Activo=S
Visible=S

[Acciones.Imprimir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Imprimir.ListaAccionesMultiples]
(Inicio)=Asigna
Asigna=Imp
Imp=Cerrar
Cerrar=(Fin)








[Acciones.Excel.AsignaCampos]
Nombre=AsignaCampos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel.AExcel]
Nombre=AExcel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0497BCobranPromoRepXLS
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

[Acciones.Texto]
Nombre=Texto
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S


ListaAccionesMultiples=(Lista)

[Acciones.Texto.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Texto.GeneraArchivo]
Nombre=GeneraArchivo
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0497BCobranPromoRepTXT
Activo=S
Visible=S

[Acciones.Texto.Cerrar]
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



[Acciones.Excel.ListaAccionesMultiples]
(Inicio)=AsignaCampos
AsignaCampos=AExcel
AExcel=Cerrar
Cerrar=(Fin)




[Acciones.Texto.ListaAccionesMultiples]
(Inicio)=Asigna
Asigna=GeneraArchivo
GeneraArchivo=Cerrar
Cerrar=(Fin)



















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




[(Variables).ListaEnCaptura]
(Inicio)=Info.Ejercicio
Info.Ejercicio=Mavi.RM0497BQuincenaCobranza
Mavi.RM0497BQuincenaCobranza=MAvi.DM0207Division
MAvi.DM0207Division=Mavi.RM0497BZona
Mavi.RM0497BZona=Mavi.RM0497BNivelCob
Mavi.RM0497BNivelCob=Mavi.RM0497BEQCobCampo
Mavi.RM0497BEQCobCampo=Mavi.RM0497BTipo
Mavi.RM0497BTipo=(Fin)













[Forma.ListaAcciones]
(Inicio)=Preliminar
Preliminar=Excel
Excel=Texto
Texto=Cerrar
Cerrar=(Fin)


