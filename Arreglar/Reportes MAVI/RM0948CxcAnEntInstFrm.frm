[Forma]
Clave=RM0948CxcAnEntInstFrm
Nombre=RM0948 Análisis de Enteros de Instituciones
Icono=61
Modulos=(Todos)
ListaCarpetas=ExploraVar
CarpetaPrincipal=ExploraVar
PosicionInicialAlturaCliente=182
PosicionInicialAncho=345
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=467
PosicionInicialArriba=402
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaBloquearAjuste=S
VentanaEscCerrar=S
ListaAcciones=(Lista)
VentanaExclusiva=S
ExpresionesAlMostrar=Si(Info.Ejercicio=0,Asigna(Info.Ejercicio,año(hoy)),)<BR>Si(Mavi.DM0169FiltroPeriodo=<T>0<T>,Asigna(Mavi.DM0169FiltroPeriodo,mes(hoy)),)<BR>Asigna(Info.Reemplazar,<T>Si<T>)<BR>Asigna(Info.CategoriaCanal,<T>INSTITUCIONES<T>)<BR>Si(Info.Conteo=1,Asigna(Mavi.RM0948Coincide,Nulo))<BR>Si(Info.Conteo=1,Asigna(Mavi.RM0948Aplicado,Nulo))<BR>Asigna(Mavi.DM0500BCuotasPer,<T>CONCENTRADO<T>)
[ExploraVar]
Estilo=Ficha
Clave=ExploraVar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=(Lista)
PermiteEditar=S
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
[ExploraVar.Info.Ejercicio]
Carpeta=ExploraVar
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[ExploraVar.Mavi.NumCanalVenta]
Carpeta=ExploraVar
Clave=Mavi.NumCanalVenta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[ExploraVar.Mavi.RM0948Coincide]
Carpeta=ExploraVar
Clave=Mavi.RM0948Coincide
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[ExploraVar.Mavi.RM0948Aplicado]
Carpeta=ExploraVar
Clave=Mavi.RM0948Aplicado
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Acepta]
Nombre=Acepta
Boton=7
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Multiple=S
ListaAccionesMultiples=AsignaV<BR>var<BR>AceptaV
Visible=S
ActivoCondicion=Info.Conteo>1
[Acciones.Cancela]
Nombre=Cancela
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Acepta.AsignaV]
Nombre=AsignaV
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Acepta.AceptaV]
Nombre=AceptaV
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=( ConDatos(Info.Ejercicio) y ConDatos(Mavi.DM0169FiltroPeriodo) y ConDatos(Mavi.NumCanalVenta)) y                    <BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)= 1)
EjecucionMensaje=Si Vacio(Info.Ejercicio) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>Sino Si Vacio(Mavi.DM0169FiltroPeriodo) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>     Sino Si (Mavi.DM0169FiltroPeriodo <= <T>0<T>) o (Mavi.DM0169FiltroPeriodo >= <T>13<T>) Entonces <T>El Periodo está fuera del rango<T><BR>          Sino Si Vacio(Mavi.NumCanalVenta) Entonces <T>El Canal de Venta es Requerido<T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>))<BR>                       Entonces <T>El Canal de Venta no es de Instituciones<T><BR>                    Fin<BR>               Fin<BR>          Fin<BR>     Fin<BR>Fin
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=(Lista)
ActivoCondicion=Info.Conteo=1
VisibleCondicion=Info.Conteo=1
[Acciones.Preliminar.CerrarV]
Nombre=CerrarV
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Preliminar.Explorar]
Nombre=Explorar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.DM0169FiltroPeriodo, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroPeriodo) )<BR>Asigna(Mavi.DM0169FiltroQuincena, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroQuincena) )<BR>Si<BR>    Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>Entonces<BR>    Forma(<T>RM0948DetalleEntInstFrm<T>)<BR>Sino<BR>    Forma(<T>RM0948CxcExpEntInstFrm<T>)<BR>FIN<BR>Asigna(Info.Conteo,Info.Conteo+1)
EjecucionCondicion=( ConDatos(Info.Ejercicio) y ConDatos(Mavi.DM0169FiltroPeriodo) y ConDatos(Mavi.NumCanalVenta) )y<BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)= 1)
EjecucionMensaje=Si Vacio(Info.Ejercicio) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>Sino Si Vacio(Mavi.DM0169FiltroPeriodo) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>     Sino Si (Mavi.DM0169FiltroPeriodo <= <T>0<T>) o (Mavi.DM0169FiltroPeriodo >= <T>13<T>) Entonces <T>El Periodo está fuera del rango<T><BR>          Sino Si Vacio(Mavi.NumCanalVenta) Entonces <T>El Canal de Venta es Requerido<T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>))<BR>                       Entonces <T>El Canal de Venta no es de Instituciones<T><BR>                    Fin<BR>               Fin<BR>          Fin<BR>     Fin<BR>Fin
[Acciones.Preliminar.AsignaExp]
Nombre=AsignaExp
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[ExploraVar.Mavi.DM0169FiltroPeriodo]
Carpeta=ExploraVar
Clave=Mavi.DM0169FiltroPeriodo
Editar=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[ExploraVar.Mavi.DM0169FiltroQuincena]
Carpeta=ExploraVar
Clave=Mavi.DM0169FiltroQuincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Acepta.var]
Nombre=var
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0169FiltroPeriodo, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroPeriodo) )<BR>Asigna(Mavi.DM0169FiltroQuincena, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroQuincena) )




[ExploraVar.ListaEnCaptura]
(Inicio)=Info.Ejercicio
Info.Ejercicio=Mavi.DM0169FiltroPeriodo
Mavi.DM0169FiltroPeriodo=Mavi.DM0169FiltroQuincena
Mavi.DM0169FiltroQuincena=Mavi.NumCanalVenta
Mavi.NumCanalVenta=Mavi.RM0948Coincide
Mavi.RM0948Coincide=Mavi.RM0948Aplicado
Mavi.RM0948Aplicado=Mavi.DM0500BCuotasPer
Mavi.DM0500BCuotasPer=(Fin)

[ExploraVar.Mavi.DM0500BCuotasPer]
Carpeta=ExploraVar
Clave=Mavi.DM0500BCuotasPer
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




[Explora.Columnas]
0=85
1=51
2=48
3=64
4=156
5=67
6=259
7=77
8=77
9=74
10=263
11=303
12=-2



[Acciones.Preliminar.ListaAccionesMultiples]
(Inicio)=AsignaExp
AsignaExp=Explorar
Explorar=CerrarV
CerrarV=(Fin)









[Forma.ListaAcciones]
(Inicio)=Acepta
Acepta=Preliminar
Preliminar=Cancela
Cancela=(Fin)


