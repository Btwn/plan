[Forma]
Clave=RM1143ReportesAnalisis03Frm
Nombre=RM1143 Reporte: Revisión de Gastos MAVI
Icono=128
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=452
PosicionInicialArriba=457
PosicionInicialAlturaCliente=72
PosicionInicialAncho=375
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM1143Periodo,1)<BR>Asigna(Mavi.RM1143Ejercicio,año(hoy))
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
ListaEnCaptura=MAVI.RM1143Periodo<BR>MAVI.RM1143Ejercicio
CarpetaVisible=S
[(Variables).MAVI.RM1143Periodo]
Carpeta=(Variables)
Clave=MAVI.RM1143Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143Ejercicio]
Carpeta=(Variables)
Clave=MAVI.RM1143Ejercicio
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Enviar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Enviar.Enviar]
Nombre=Enviar
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1143ReportesAnalisis03RepXls
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Mavi.RM1143Periodo<=12
EjecucionMensaje=<T>EL PERIODO NO ES VALIDO<T>
[Acciones.Enviar.Cerrar]
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
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Generar.Generar]
Nombre=Generar
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1143ReportesAnalisis03RepXls
[Acciones.Generar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Generar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Generar]
Nombre=Generar
Boton=4
NombreEnBoton=S
NombreDesplegar=&Generar Archivo TXT
Multiple=S
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=MachoteNormal
ListaAccionesMultiples=Variables Asignar<BR>Generar<BR>Cerrar
Activo=S
Visible=S

