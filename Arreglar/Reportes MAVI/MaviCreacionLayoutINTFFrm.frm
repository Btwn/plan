[Forma]
Clave=MaviCreacionLayoutINTFFrm
Nombre=Layout Buró INTF
Icono=573
Modulos=(Todos)
MovModulo=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=CreacionLayoutINTF
CarpetaPrincipal=CreacionLayoutINTF
PosicionInicialIzquierda=515
PosicionInicialArriba=442
PosicionInicialAlturaCliente=105
PosicionInicialAncho=250
ListaAcciones=Cerrar<BR>Aceptar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=&Generar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
EspacioPrevio=S
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQLAnimado(<T>SP_MaviLayoutBuroCred :fDes, :fHas, :fRep <T>, Info.FechaD, Info.FechaA, Info.FechaA)<BR>GuardarLista(SQLEnLista(<T>Select * From ##FBuroCreditoMavi<T>), <T><T>,<T>INTF001.txt<T>, <T>txt<T>, <T>Archivos de Texto<T>, <T>Archivos de Texto<T>)<BR>Informacion(<T>Archivo .txt creado<T> )
[CreacionLayoutINTF]
Estilo=Ficha
Clave=CreacionLayoutINTF
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=5
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[CreacionLayoutINTF.Info.FechaD]
Carpeta=CreacionLayoutINTF
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CreacionLayoutINTF.Info.FechaA]
Carpeta=CreacionLayoutINTF
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


