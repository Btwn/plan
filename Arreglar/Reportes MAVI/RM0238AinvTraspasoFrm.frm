[Forma]
Clave=RM0238AinvTraspasoFrm
Nombre=RM0238 Ordenes de Traspasos
Icono=634
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=435
PosicionInicialArriba=433
PosicionInicialAlturaCliente=156
PosicionInicialAncho=311
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Pre<BR>Cerr<BR>Actualisar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.AlmD,Nulo)<BR>Asigna(Info.AlmacenDestino,Nulo)<BR>Asigna(Mavi.RM0238STMovID,Nulo)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Info.AlmD<BR>Info.AlmacenDestino<BR>Mavi.RM0238STMovID
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Info.AlmacenDestino]
Carpeta=(Variables)
Clave=Info.AlmacenDestino
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Pre.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Pre.cerr]
Nombre=cerr
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Pre]
Nombre=Pre
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
NombreEnBoton=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Multiple=S
ListaAccionesMultiples=AsignaV<BR>AceptaV
[Acciones.Cerr]
Nombre=Cerr
Boton=23
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Actualisar]
Nombre=Actualisar
Boton=0
NombreDesplegar=&Actualisar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
ConAutoEjecutar=S
AutoEjecutarExpresion=2
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0238STMovID]
Carpeta=(Variables)
Clave=Mavi.RM0238STMovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Pre.AsignaV]
Nombre=AsignaV
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Pre.AceptaV]
Nombre=AceptaV
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=Si Info.FechaD > Info.FechaA Entonces Falso<BR>Sino Si ConDatos(Info.FechaD) y Vacio(Info.FechaA) Entonces Falso<BR>     Sino Si Vacio(Info.FechaD) y ConDatos(Info.FechaA) Entonces Falso<BR>          Sino Si Vacio(Mavi.RM0238STMovID) Entonces Falso<BR>               Sino Si Vacio(Info.AlmD) y ConDatos(Info.AlmacenDestino) Entonces Falso<BR>                    Sino Si ConDatos(Info.AlmD) y Vacio(Info.AlmacenDestino) Entonces Falso<BR>                         Sino Si Vacio(SQL(<T>Select Almacen From Alm Where Almacen = :tAl<T>,Info.AlmD)) y ConDatos(Info.AlmD) Entonces Falso<BR>                              Sino Si Vacio(SQL(<T>Select Almacen From Alm Where Almacen = :tAl<T>,Info.AlmacenDestino)) y ConDatos(Info.AlmacenDestino) Entonces Falso<BR>                                   Sino Si Vac<CONTINUA>
EjecucionCondicion002=<CONTINUA>io(SQL(<T>Select MovID From Inv Where Mov = :tMv And MovID = :tMvI And Estatus <> :tEst<T>,<T>Salida Traspaso<T>,Mavi.RM0238STMovID,<T>SINAFECTAR<T>)) Entonces Falso<BR>                                        Sino Verdadero<BR>                                        Fin<BR>                                   Fin<BR>                              Fin<BR>                         Fin<BR>                    Fin<BR>               Fin<BR>          Fin<BR>     Fin<BR>Fin
EjecucionMensaje=Si Info.FechaD > Info.FechaA Entonces <T>El Rango de fechas esta mal solicitado<T><BR>Sino Si ConDatos(Info.FechaD) y Vacio(Info.FechaA) Entonces <T>El Rango de fechas esta mal solicitado<T><BR>     Sino Si Vacio(Info.FechaD) y ConDatos(Info.FechaA) Entonces <T>El Rango de fechas esta mal solicitado<T><BR>          Sino Si Vacio(Mavi.RM0238STMovID) Entonces <T>Es Obligatorio el ID de la Salida Traspaso<T><BR>               Sino Si Vacio(Info.AlmD) y ConDatos(Info.AlmacenDestino) Entonces <T>Los Almacenes estan mal solicitados<T><BR>                    Sino Si ConDatos(Info.AlmD) y Vacio(Info.AlmacenDestino) Entonces <T>Los Almacenes estan mal solicitados<T><BR>                         Sino Si Vacio(SQL(<T>Select Almacen From Alm Where Almacen = :tAl<T>,Info.AlmD)) y ConDatos(Info.AlmD) Ent<CONTINUA>
EjecucionMensaje002=<CONTINUA>onces <T>El Almacen Origen Es Inválido<T><BR>                              Sino Si Vacio(SQL(<T>Select Almacen From Alm Where Almacen = :tAl<T>,Info.AlmacenDestino)) y ConDatos(Info.AlmacenDestino) Entonces <T>El Almacen Destino Es Inválido<T><BR>                                   Sino Si Vacio(SQL(<T>Select MovID From Inv Where Mov = :tMv And MovID = :tMvI And Estatus <> :tEst<T>,<T>Salida Traspaso<T>,Mavi.RM0238STMovID,<T>SINAFECTAR<T>)) Entonces <T>La Salida Traspaso No es Válida<T> <BR>                                        Fin<BR>                                   Fin<BR>                              Fin<BR>                         Fin<BR>                    Fin<BR>               Fin<BR>          Fin<BR>     Fin<BR>Fin
[(Variables).Info.AlmD]
Carpeta=(Variables)
Clave=Info.AlmD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


