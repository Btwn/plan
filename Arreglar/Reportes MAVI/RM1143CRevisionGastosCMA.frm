[Forma]
Clave=RM1143CRevisionGastosCMA
Nombre=RM1143C Revision Gasto CMA
Icono=102
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=342
PosicionInicialArriba=275
PosicionInicialAlturaCliente=82
PosicionInicialAncho=416
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=TXT<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1143Periodo,1)<BR>Asigna(Mavi.RM1143Ejercicio,año(hoy))
[Lista]
Estilo=Ficha
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=MAVI.RM1143Ejercicio<BR>MAVI.RM1143Periodo
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Lista.MAVI.RM1143Ejercicio]
Carpeta=Lista
Clave=MAVI.RM1143Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.MAVI.RM1143Periodo]
Carpeta=Lista
Clave=MAVI.RM1143Periodo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.Excel]
Nombre=Excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1143CRevisionGastosCMARepXls
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Mavi.RM1143Periodo <= 12
EjecucionMensaje=<T>Periodo no valido<T>
[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.TXT.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.TXT.TXT]
Nombre=TXT
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1143CRevisionGastosCMARepTXT
[Acciones.TXT.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.TXT]
Nombre=TXT
Boton=55
NombreEnBoton=S
NombreDesplegar=Enviar a TXT
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ListaAccionesMultiples=Asignar<BR>TXT<BR>Cerrar
Activo=S
Visible=S


