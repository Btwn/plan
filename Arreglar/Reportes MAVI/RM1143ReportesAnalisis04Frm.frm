[Forma]
Clave=RM1143ReportesAnalisis04Frm
Icono=402
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialAlturaCliente=68
PosicionInicialAncho=324
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Enviar<BR>Cerrar
Nombre=RM1143 Reporte: Anexos Análisis
PosicionInicialIzquierda=478
PosicionInicialArriba=459
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
[(Variables).MAVI.RM1143Ejercicio]
Carpeta=(Variables)
Clave=MAVI.RM1143Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143Periodo]
Carpeta=(Variables)
Clave=MAVI.RM1143Periodo
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
LineaNueva=S
[Acciones.Enviar]
Nombre=Enviar
Boton=4
NombreEnBoton=S
NombreDesplegar=&Generar Archivo TXT
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Enviar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Enviar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1143ReportesAnalisis04RepXls
Activo=S
Visible=S
[Acciones.Enviar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

