[Forma]
Clave=RM0493AFichasAvalFRM
Icono=0
Modulos=(Todos)
ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
PosicionInicialIzquierda=340
PosicionInicialArriba=210
PosicionInicialAlturaCliente=197
PosicionInicialAncho=280
AccionesTamanoBoton=10x5
ListaAcciones=Generar Fichas<BR>Preliminar<BR>Imprimir
AccionesDivision=S
BarraHerramientas=S
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
Nombre=RM0493A Fichas Avales
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Info.Ejercicio,Info.Ano)<BR>Asigna(Mavi.Rm0493AQuincena, si (Dia( Hoy ))  >= 15<BR>entonces Mes(hoy)*2 sino (Mes(hoy)*2)-1) Fin)<BR>Asigna(Mavi.RM0493ANivelCob,Nulo)<BR>Asigna(Mavi.RM0493AAgentesCob,Nulo)<BR>Asigna(Mavi.RM0493ADESD,Nulo)<BR>Asigna(Mavi.RM0493AHAST,Nulo)
[Filtros]
Estilo=Ficha
Clave=Filtros
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Ejercicio<BR>Mavi.RM0493AQuincena<BR>Mavi.RM0493ANivelCob<BR>Mavi.RM0493AAgentesCob<BR>Mavi.RM0493ADESD<BR>Mavi.RM0493AHAST
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaAlineacionDerecha=S
[Acciones.Generar Fichas]
Nombre=Generar Fichas
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar Fichas
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignacion<BR>Aceptar
Antes=S
GuardarAntes=S
AntesExpresiones=Asigna(Mavi.Clave,0)<BR>Si SQL(<T>Select count(*) from RM0493AFICHASCOBROAVAL where Ejercicio = :tejercicio and Quincena = :tquince<T>,Info.Ejercicio,Mavi.RM0493AQuincena) > 0<BR>entonces<BR>    si Confirmacion( <T>Existen datos en esta quincena, ¿Desea sobreescribir?<T>,BotonAceptar,BotonCancelar) = 1<BR>     entonces<BR>          Asigna(Mavi.Clave,0)<BR>     sino<BR>         Asigna(Mavi.Clave,1)<BR>    fin<BR>fin
[Acciones.Preliminar]
Nombre=Preliminar
Boton=56
NombreEnBoton=S
NombreDesplegar=Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Variables Asig<BR>Expresion<BR>Aceptar
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreEnBoton=S
NombreDesplegar=&Imprimir
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=asignar<BR>expresion<BR>Imprimir
[Acciones.Imprimir.Imprimir]
Nombre=Imprimir
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0493AFichasAvalRepImp
Activo=S
Visible=S
[Acciones.Imprimir.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Preliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.Clave,1)
[Acciones.Preliminar.Variables Asig]
Nombre=Variables Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar Fichas.Asignacion]
Nombre=Asignacion
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Filtros.Mavi.RM0493ANivelCob]
Carpeta=Filtros
Clave=Mavi.RM0493ANivelCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.RM0493AAgentesCob]
Carpeta=Filtros
Clave=Mavi.RM0493AAgentesCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.RM0493ADESD]
Carpeta=Filtros
Clave=Mavi.RM0493ADESD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.RM0493AHAST]
Carpeta=Filtros
Clave=Mavi.RM0493AHAST
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Generar Fichas.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Asigna(Mavi.Quincena ,SI sql(<T>select DAY(getdate())<T>) > 15<BR>entonces (sql(<T>select MONTh(getdate())<T>) *2) sino ((sql(<T>select MONTH(getdate())<T>)*2)-1)) Fin)<BR><BR><BR>Si Info.Ejercicio = SQL(<T>SELECT YEAR(GETDATE())<T>) y Mavi.RM0493AQuincena = Mavi.Quincena<BR>entonces<BR> verdadero<BR>sino<BR> falso<BR>fin
EjecucionMensaje=<T>SOLO SE PUEDE EJECUTAR LA QUINCENA ACTUAL<T>
[Filtros.Mavi.RM0493AQuincena]
Carpeta=Filtros
Clave=Mavi.RM0493AQuincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Info.Ejercicio]
Carpeta=Filtros
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Imprimir.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.Clave,1)


