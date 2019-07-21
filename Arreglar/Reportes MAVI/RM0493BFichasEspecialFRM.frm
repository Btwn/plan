[Forma]
Clave=RM0493BFichasEspecialFRM
Icono=0
Modulos=(Todos)
ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
PosicionInicialIzquierda=362
PosicionInicialArriba=223
PosicionInicialAlturaCliente=285
PosicionInicialAncho=350
AccionesTamanoBoton=10x5
ListaAcciones=Generar Fichas<BR>Preliminar<BR>Imprimir<BR>Excel<BR>Atxt
AccionesDivision=S
BarraHerramientas=S
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.Ejercicio,Info.Ano)<BR>Asigna(Mavi.Quincena, si (Dia( Hoy ))  >= 15<BR>entonces Mes(hoy)*2 sino (Mes(hoy)*2)-1) Fin)<BR>Asigna(Mavi.NivelCobranza,Nulo)<BR>Asigna(Mavi.AgentesCob,Nulo)<BR>Asigna(Mavi.RM0493ATipoNivel,<T>TODO<T>)<BR>Asigna(Mavi.RM0493ID,Nulo)<BR>Asigna(Mavi.RM0493ID2,Nulo)
Nombre=RM0493BFichasEspecial
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
ListaEnCaptura=Mavi.Ejercicio<BR>Mavi.quincena<BR>Mavi.NivelCobranza<BR>Mavi.AgentesCob<BR>Mavi.RM0493ATipoNivel<BR>Mavi.RM0493ID<BR>Mavi.RM0493ID2
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Filtros.Mavi.Ejercicio]
Carpeta=Filtros
Clave=Mavi.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.quincena]
Carpeta=Filtros
Clave=Mavi.quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.NivelCobranza]
Carpeta=Filtros
Clave=Mavi.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.RM0493ID]
Carpeta=Filtros
Clave=Mavi.RM0493ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.RM0493ID2]
Carpeta=Filtros
Clave=Mavi.RM0493ID2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Generar Fichas]
Nombre=Generar Fichas
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar Fichas
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asinacion<BR>Aceptar
Antes=S
GuardarAntes=S
AntesExpresiones=Asigna(Mavi.Clave,0)<BR>Si SQL(<T>Select count(*) from MAVIRM0493FICHASCOBRO where Ejercicio = :tejercicio and Quincena = :tquince<T>,Mavi.Ejercicio,Mavi.quincena) > 0<BR>entonces<BR>    si Confirmacion( <T>Existen datos en esta quincena, ¿Desea sobreescribir?<T>,BotonAceptar,BotonCancelar) = 1<BR>     entonces<BR>          Asigna(Mavi.Clave,0)<BR>     sino<BR>         Asigna(Mavi.Clave,1)<BR>    fin<BR>fin
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
[Acciones.Generar Fichas.Asinacion]
Nombre=Asinacion
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar Fichas.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Imprimir.Imprimir]
Nombre=Imprimir
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0493BFichasEspecialRepImp
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
[Filtros.Mavi.RM0493ATipoNivel]
Carpeta=Filtros
Clave=Mavi.RM0493ATipoNivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.AgentesCob]
Carpeta=Filtros
Clave=Mavi.AgentesCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Atxt]
Nombre=Atxt
Boton=54
NombreEnBoton=S
NombreDesplegar=TXT
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>expresion<BR>Texto
[Acciones.Atxt.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Atxt.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.Clave,1)
[Acciones.Imprimir.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.Clave,1)
Activo=S
Visible=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=XLS
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Expresion<BR>AEXCEL
[Acciones.Excel.AEXCEL]
Nombre=AEXCEL
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0493BFichasEspecialRepXLS
Activo=S
Visible=S
[Acciones.Excel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.Clave,1)
[Acciones.Atxt.Texto]
Nombre=Texto
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0493BFichasEspecialRepTXT
Activo=S
Visible=S


