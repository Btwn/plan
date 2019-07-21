[Forma]
Clave=DM0117CrediCanalVentaFrm
Nombre=Canal de Venta
Icono=0
Modulos=(Todos)
ListaCarpetas=CanalVentaMavi
CarpetaPrincipal=CanalVentaMavi
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialIzquierda=477
PosicionInicialArriba=444
PosicionInicialAlturaCliente=97
PosicionInicialAncho=325
BarraHerramientas=S
ExpresionesAlMostrar=asigna(Mavi.DM0117CanalVenta,nulo)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraAcciones=S
TipoAccion=Ventana
Activo=S
Visible=S
NombreEnBoton=S
ClaveAccion=Seleccionar
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>datosCteRelacion<BR>Cerrar
[Sucursal.Columnas]
Sucursal=57
Nombre=208
;ListaEnCaptura=(Lista)

;[CanalVentaVarMavi.ListaEnCaptura]
;(Inicio)=ID
;ID=Cadena
;Cadena=(Fin)


[CanalVentaVarMavi.Columnas]
Clave=64
Cadena=229
ID=64

[CanalVentaMavi]
Estilo=Ficha
Clave=CanalVentaMavi
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
ListaEnCaptura=Mavi.DM0117CanalVenta
PermiteEditar=S
[CanalVentaMavi.Mavi.DM0117CanalVenta]
Carpeta=CanalVentaMavi
Clave=Mavi.DM0117CanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar.datosCteRelacion]
Nombre=datosCteRelacion
Boton=0
TipoAccion=formas
ClaveAccion=DM0117CrediCteCapturaFrm
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>    (Mavi.DM0117CanalVenta=Nulo)<BR>Entonces<BR>    Falso<BR>Sino<BR>    Si (sql(<T>SELECT COUNT(*) FROM dbo.VentasCanalMAVI WHERE ID=:tcanal<T>,Mavi.DM0117CanalVenta)=0)<BR>    Entonces                                                                        <BR>        Falso<BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Fin
EjecucionMensaje=<T>Canal Venta no Valido<T>
[Acciones.Seleccionar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


