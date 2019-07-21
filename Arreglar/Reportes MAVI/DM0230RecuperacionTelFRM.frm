[Forma]
Clave=DM0230RecuperacionTelFRM
Nombre=Recuperacion Cobranza Telefonica
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=274
PosicionInicialArriba=321
PosicionInicialAlturaCliente=90
PosicionInicialAncho=748
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>EnvioExcel<BR>TxT<BR>SubirCSV<BR>ResultadoGestion<BR>Usuarios_Nuxiba<BR>EliminarRegistro<BR>Cerrar<BR>Imprimir
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.quincena,<BR>        Si Dia(Hoy) > 16 Entonces<BR>             (Mes(Hoy))*2<BR>        Sino<BR>             (Mes(Hoy)*2)-1<BR>        Fin)<BR>    Asigna(Info.Ejercicio, Año(Hoy))<BR>    Asigna(Mavi.DM0500BCuotasPer,<T>CONCENTRADO<T>)<BR>Asigna(Mavi.DM0230CanalVenta,NULO)
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
ListaEnCaptura=Info.Ejercicio<BR>Mavi.quincena<BR>Mavi.DM0500BCuotasPer<BR>Mavi.DM0230CanalVenta
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=7
FichaEspacioNombres=110
FichaColorFondo=Blanco
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
[(Variables).Mavi.quincena]
Carpeta=(Variables)
Clave=Mavi.quincena
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0500BCuotasPer]
Carpeta=(Variables)
Clave=Mavi.DM0500BCuotasPer
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>Expresion
[Acciones.EnvioExcel]
Nombre=EnvioExcel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Envio a Excel
Multiple=S
EnBarraHerramientas=S
TipoAccion=Reportes Excel
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>EnvExcel
[Acciones.SubirCSV]
Nombre=SubirCSV
Boton=75
NombreEnBoton=S
NombreDesplegar=&Subir XLS Contestadas
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Aceptar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna( Info.Cantidad, 1 )<BR>Si<BR>    Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>Entonces<BR>     ReportePantalla(<T>DM0230RecupTelDetalladoREP<T>)<BR>Sino<BR>    ReportePantalla(<T>DM0230RecupTelConcentradoREP<T>)<BR>FIN
EjecucionCondicion=Si<BR>  ConDatos(Info.Ejercicio) y ConDatos(Mavi.quincena) y ConDatos(Mavi.DM0500BCuotasPer)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>Los filtros Ejercicio, Quincena y Reporte General, son obligatorios<T>)<BR>  Falso<BR>Fin
[Acciones.EnvioExcel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.EnvioExcel.EnvExcel]
Nombre=EnvExcel
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna( Info.Cantidad, 1 )<BR>Si<BR>    Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>Entonces<BR>     ReporteExcel(<T>DM0230RecupTelDetalladoREPXls<T>)<BR>Sino<BR>     ReporteExcel(<T>DM0230RecupTelConcentradoREPXls<T>)<BR>FIN
EjecucionCondicion=Si<BR>  ConDatos(Info.Ejercicio) y ConDatos(Mavi.quincena) y ConDatos(Mavi.DM0500BCuotasPer)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>Los filtros Ejercicio, Quincena y Reporte General, son obligatorios<T>)<BR>  Falso<BR>Fin
[Acciones.SubirCSV.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=DM0230RecuperacionCtesFRM
[Acciones.ResultadoGestion]
Nombre=ResultadoGestion
Boton=-1
NombreEnBoton=S
NombreDesplegar=&Resultado Gestión
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=DM0230ResultadoGestionFrm
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Aceptar
[Acciones.SubirCSV.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.ResultadoGestion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=DM0230ResultadoGestionFrm
[Acciones.ResultadoGestion.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.TxT]
Nombre=TxT
Boton=54
NombreEnBoton=S
NombreDesplegar=&TxT
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>Expresion
[Acciones.TxT.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.TxT.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Info.Cantidad, 0 )<BR>Si<BR>    Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>Entonces<BR>    ReporteImpresora( <T>DM0230RecupTelDetalladoREPTXT<T> ) <BR>Sino<BR>    ReporteImpresora(<T>DM0230RecupTelConcentradoREPTXT<T>)<BR>FIN
ConCondicion=S
EjecucionCondicion=Si<BR>  ConDatos(Info.Ejercicio) y ConDatos(Mavi.quincena) y ConDatos(Mavi.DM0500BCuotasPer)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>Los filtros Ejercicio, Quincena y Reporte General, son obligatorios<T>)<BR>  Falso<BR>Fin
[Acciones.Imprimir]
Nombre=Imprimir
Boton=0
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=DM0230RecupTelConcentradoREPTXT
Activo=S
Visible=S
[Acciones.Usuarios_Nuxiba]
Nombre=Usuarios_Nuxiba
Boton=80
NombreDesplegar=Usuarios Nuxiba
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0311ImportacionNuxibaFrm
Activo=S
Visible=S
NombreEnBoton=S


[Acciones.EliminarRegistro]
Nombre=EliminarRegistro
Boton=0
NombreEnBoton=S
NombreDesplegar=&Eliminar registro
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=DM0230EliminacionRegistroFrm
Activo=S
Visible=S

[(Variables).Mavi.DM0230CanalVenta]
Carpeta=(Variables)
Clave=Mavi.DM0230CanalVenta
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

