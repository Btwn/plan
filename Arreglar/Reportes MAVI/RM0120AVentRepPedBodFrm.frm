[Forma]
Clave=RM0120AVentRepPedBodFrm
Nombre=RM120A Reporte de Pedidos en Bodega
Icono=152
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=432
PosicionInicialArriba=369
PosicionInicialAlturaCliente=189
PosicionInicialAncho=339
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>act
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=asigna(mavi.rm0120agerencia,<T><T>)<BR>asigna(mavi.rm0120adivision,<T><T>)<BR>asigna(mavi.rm0120aequipo,<T><T>)<BR>asigna(mavi.rm0120asucursalve,<T><T>)<BR>asigna(mavi.rm0120asucursal,nulo)<BR>asigna(mavi.rm0120acelula,<T><T>)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0120AGerencia<BR>Mavi.RM0120ADivision<BR>Mavi.RM0120ACelula<BR>Mavi.RM0120AEquipo<BR>Mavi.RM0120ASucursalVE<BR>Mavi.RM0120ASucursal
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
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
[(Variables).Mavi.RM0120AGerencia]
Carpeta=(Variables)
Clave=Mavi.RM0120AGerencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0120ADivision]
Carpeta=(Variables)
Clave=Mavi.RM0120ADivision
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0120ACelula]
Carpeta=(Variables)
Clave=Mavi.RM0120ACelula
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0120AEquipo]
Carpeta=(Variables)
Clave=Mavi.RM0120AEquipo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0120ASucursalVE]
Carpeta=(Variables)
Clave=Mavi.RM0120ASucursalVE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0120ASucursal]
Carpeta=(Variables)
Clave=Mavi.RM0120ASucursal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.act]
Nombre=act
Boton=0
NombreDesplegar=act
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1


