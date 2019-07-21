[Forma]
Clave=RM1143PrincipalFrm
Nombre=RM1143 Reporte Rentabilidad: Concentradora
Icono=150
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=445
PosicionInicialArriba=449
PosicionInicialAlturaCliente=88
PosicionInicialAncho=390
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=RepExcel<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1143Periodo,1)<BR>Asigna(Mavi.RM1143Ejercicio,año(hoy))
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
ListaEnCaptura=MAVI.RM1143Periodo<BR>MAVI.RM1143Ejercicio
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).MAVI.RM1143Periodo]
Carpeta=(Variables)
Clave=MAVI.RM1143Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
Efectos=[Negritas]
ColorFuente=Negro
[(Variables).MAVI.RM1143Ejercicio]
Carpeta=(Variables)
Clave=MAVI.RM1143Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFuente=$FFFFFFFF
Efectos=[Negritas]
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
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.Excel]
Nombre=Excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1143ReporteConcentradoraRepXls
Activo=S
Visible=S
[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.RepExcel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RepExcel]
Nombre=RepExcel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar a Excel
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Reporte<BR>Cerrar
Activo=S
Visible=S
[Acciones.RepExcel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.RepExcel.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1143ReporteConcentradoraRepXls
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Mavi.RM1143Periodo<=12
EjecucionMensaje=<T>EL PERIODO NO ES VALIDO<T>


