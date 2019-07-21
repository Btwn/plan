[Forma]
Clave=RM1050EnlaceNuxibaFRM
Nombre=RM1050EnlaceNuxiba
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=707
PosicionInicialArriba=218
PosicionInicialAlturaCliente=206
PosicionInicialAncho=323
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Generar TXT<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=asigna(Mavi.Ejercicio,SQL(<T>Select Year(Getdate())<T>))<BR>asigna(Mavi.QuincenaCobranza,SQL(<T>Select DBO.Fn_MaviNumQuincena(Getdate())<T>))<BR>asigna(Mavi.RM0492NivelesLista,<T><T>)<BR>asigna(Mavi.AgentesCob,<T><T>)<BR>asigna(Mavi.RM0946did,nulo)<BR>asigna(Mavi.RM0946dih,nulo)<BR>asigna(Mavi.RM0946dvd,nulo)<BR>asigna(Mavi.RM0946dvh,nulo)
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
ListaEnCaptura=Mavi.Ejercicio<BR>Mavi.QuincenaCobranza<BR>Mavi.RM0492NivelesLista<BR>Mavi.AgentesCob<BR>Mavi.RM0946did<BR>Mavi.RM0946dih<BR>Mavi.RM0946dvd<BR>Mavi.RM0946dvh
CarpetaVisible=S
[(Variables).Mavi.Ejercicio]
Carpeta=(Variables)
Clave=Mavi.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0492NivelesLista]
Carpeta=(Variables)
Clave=Mavi.RM0492NivelesLista
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.AgentesCob]
Carpeta=(Variables)
Clave=Mavi.AgentesCob
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0946did]
Carpeta=(Variables)
Clave=Mavi.RM0946did
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0946dih]
Carpeta=(Variables)
Clave=Mavi.RM0946dih
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0946dvd]
Carpeta=(Variables)
Clave=Mavi.RM0946dvd
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0946dvh]
Carpeta=(Variables)
Clave=Mavi.RM0946dvh
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Generar TXT]
Nombre=Generar TXT
Boton=1
NombreEnBoton=S
NombreDesplegar=&Generar TXT
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=ASI<BR>rep<BR>CERRAR
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.QuincenaCobranza]
Carpeta=(Variables)
Clave=Mavi.QuincenaCobranza
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Generar TXT.ASI]
Nombre=ASI
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar TXT.CERRAR]
Nombre=CERRAR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Generar TXT.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1050EnlaceNuxibaIMPRep
Activo=S
Visible=S

