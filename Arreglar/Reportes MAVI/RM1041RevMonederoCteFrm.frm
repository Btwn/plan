[Forma]
Clave=RM1041RevMonederoCteFrm
Nombre=RM1041 Revisión Monedero/Cliente
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Mavi.RM1041CtaMonedero<BR>TextoAyuda
CarpetaPrincipal=Mavi.RM1041CtaMonedero
PosicionInicialAlturaCliente=240
PosicionInicialAncho=591
ListaAcciones=Expresiontxt<BR>Prelimiar<BR>Excel
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=344
PosicionInicialArriba=373
PosicionCol1=335
ExpresionesAlMostrar=Asigna(Info.Clase, <T>Para obtener:<T>)<BR>Asigna(Info.Clase1,<T>* Los diferentes Clientes de cada Monedero: <T>)<BR>Asigna(Info.Clase3,<T>   Seleccione (Todos) en Cuenta Monedero y deje vacio Cliente<T>)<BR>Asigna(Info.Clase2,<T>* Los diferentes Monederos de cada Cliente: <T>)<BR>Asigna(Info.Clase4,<T>   Seleccione (Todos) en Cliente y deje vacio Cuenta Monedero<T>)<BR>Asigna(Info.Clase5,<T>*Hasta Cantidad en 0,igual a todo, otro numero hasta ese valor<T>)<BR>Asigna(Mavi.RM1041CtaMonedero,<T>(Todos)<T>)<BR>Asigna(Mavi.RM1041Cliente,nulo)<BR>Asigna(Mavi.RM1041Filtro,2)<BR>Asigna(Mavi.RM1041Filtro2,0)<BR>Asigna(Info.FechaD,nulo)<BR>Asigna(Info.FechaA,nulo)
[Mavi.RM1041CtaMonedero]
Estilo=Ficha
Clave=Mavi.RM1041CtaMonedero
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1041CtaMonedero<BR>Mavi.RM1041Cliente<BR>Mavi.RM1041Filtro<BR>Mavi.RM1041Filtro2<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
FichaEspacioEntreLineas=3
FichaEspacioNombres=0
FichaColorFondo=Plata
PestanaOtroNombre=S
PestanaNombre=Revisión Monedero/Cliente
PermiteEditar=S
FichaNombres=Izquierda
FichaEspacioNombresAuto=S
[Mavi.RM1041CtaMonedero.Mavi.RM1041CtaMonedero]
Carpeta=Mavi.RM1041CtaMonedero
Clave=Mavi.RM1041CtaMonedero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si<BR>   ConDatos( Info.FechaD) y  ConDatos( Info.FechaA)<BR>    Entonces<BR>        Si<BR>          Info.FechaD <= Info.FechaA<BR>            Entonces<BR>               ReporteImpresora(<T>RM1041RevMonederoCteRepImp<T>)<BR>            Sino<BR>               Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
[Mavi.RM1041CtaMonedero.Mavi.RM1041Cliente]
Carpeta=Mavi.RM1041CtaMonedero
Clave=Mavi.RM1041Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[TextoAyuda]
Estilo=Ficha
Clave=TextoAyuda
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=$00EFEFEF
ListaEnCaptura=Info.Clase<BR>Info.Clase1<BR>Info.Clase3<BR>Info.Clase2<BR>Info.Clase4<BR>Info.Clase5
CarpetaVisible=S
FichaEspacioEntreLineas=8
FichaEspacioNombres=0
FichaColorFondo=Plata
[TextoAyuda.Info.Clase]
Carpeta=TextoAyuda
Clave=Info.Clase
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=40
ColorFondo=$00EFEFEF
ColorFuente=Negro
[TextoAyuda.Info.Clase1]
Carpeta=TextoAyuda
Clave=Info.Clase1
Editar=S
LineaNueva=S
Tamano=40
ColorFondo=$00EFEFEF
ColorFuente=Negro
[TextoAyuda.Info.Clase2]
Carpeta=TextoAyuda
Clave=Info.Clase2
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=40
ColorFondo=$00F2F2F2
ColorFuente=Negro
EspacioPrevio=N
[Mavi.RM1041CtaMonedero.Mavi.RM1041Filtro]
Carpeta=Mavi.RM1041CtaMonedero
Clave=Mavi.RM1041Filtro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[TextoAyuda.Info.Clase3]
Carpeta=TextoAyuda
Clave=Info.Clase3
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=45
ColorFondo=Blanco
ColorFuente=Negro
[TextoAyuda.Info.Clase4]
Carpeta=TextoAyuda
Clave=Info.Clase4
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=45
ColorFondo=Blanco
ColorFuente=Negro
[Mavi.RM1041CtaMonedero.Info.FechaD]
Carpeta=Mavi.RM1041CtaMonedero
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[Mavi.RM1041CtaMonedero.Info.FechaA]
Carpeta=Mavi.RM1041CtaMonedero
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresiontxt.ejecucion]
Nombre=ejecucion
Boton=0
TipoAccion=Expresion
Expresion=Si<BR>   ConDatos( Info.FechaD) y  ConDatos( Info.FechaA)<BR>    Entonces<BR>        Si<BR>          Info.FechaD <= Info.FechaA<BR>            Entonces<BR>               ReporteImpresora(<T>RM1041RevMonederoCteRepImp<T>)<BR>            Sino<BR>               Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
[Acciones.Expresiontxt]
Nombre=Expresiontxt
Boton=75
NombreEnBoton=S
NombreDesplegar=&Generar Txt
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>ejecucion<BR>cierra
Activo=S
Visible=S
[Acciones.Expresiontxt.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Expresiontxt.cierra]
Nombre=cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
[Mavi.RM1041CtaMonedero.Mavi.RM1041Filtro2]
Carpeta=Mavi.RM1041CtaMonedero
Clave=Mavi.RM1041Filtro2
Editar=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[TextoAyuda.Info.Clase5]
Carpeta=TextoAyuda
Clave=Info.Clase5
Editar=S
LineaNueva=S
Tamano=45
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Prelimiar]
Nombre=Prelimiar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Prelimiar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
[Acciones.Prelimiar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Prelimiar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>   ConDatos( Info.FechaD) y  ConDatos( Info.FechaA)<BR>    Entonces<BR>        Si<BR>          Info.FechaD <= Info.FechaA<BR>            Entonces<BR>               ReportePantalla(<T>RM1041RevMonederoCtePreRep<T>)<BR>            Sino<BR>               Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Si<BR>   ConDatos( Info.FechaD) y  ConDatos( Info.FechaA)<BR>    Entonces<BR>        Si<BR>          Info.FechaD <= Info.FechaA<BR>            Entonces<BR>               ReporteExcel(<T>RM1041RevMonederoCteRep<T>)<BR>            Sino<BR>               Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
Activo=S
Visible=S
[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
Activo=S
Visible=S
[Acciones.Prelimiar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



