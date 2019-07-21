[Forma]
Clave=RM0195ReporteVecoTxtFRM
Icono=132
Modulos=(Todos)
Nombre=RM0195ReporteTXT
ListaCarpetas=filtros
CarpetaPrincipal=filtros
PosicionInicialAlturaCliente=128
PosicionInicialAncho=306
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar<BR>&Cerrar<BR>Capturar
BarraHerramientas=S
PosicionInicialIzquierda=530
PosicionInicialArriba=300
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[filtros]
Estilo=Ficha
Clave=filtros
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
CarpetaVisible=S
ListaEnCaptura=Info.FechaEDMAVI<BR>Info.FechaEAMAVI
[Acciones.Generar]
Nombre=Generar
Boton=17
NombreEnBoton=S
NombreDesplegar=Generar TXT
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=repo

ConCondicion=S
EjecucionCondicion=Forma.Accion(<T>Capturar<T>)<BR><BR>Si<BR>  SQL(<T>SELECT DATEDIFF(dd,0,:tFechaInicial)<T>,FechaEnTexto(Info.FechaEDMAVI,<T>aaaa/mm/dd<T>,<T>Ingles<T>))<BR>  ><BR>  SQL(<T>SELECT DATEDIFF(dd,0,:tFechaInicial)<T>,FechaEnTexto(Info.FechaEAMAVI,<T>aaaa/mm/dd<T>,<T>Ingles<T>))<BR>Entonces<BR>  Informacion(<T>La fecha del campo <De la fecha> no puede ser mayor al campo <A la fecha><T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.&Cerrar]
Nombre=&Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Generar.repo]
Nombre=repo
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0195AReporteVecoTxtRep
Activo=S
Visible=S
[filtros.Info.FechaEDMAVI]
Carpeta=filtros
Clave=Info.FechaEDMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[filtros.Info.FechaEAMAVI]
Carpeta=filtros
Clave=Info.FechaEAMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

