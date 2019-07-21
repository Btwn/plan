[Forma]
Clave=RM0956CxcForEnvInfCobroFrm
Nombre=RM0956 Envio de Información a Cobro (FIDE,FONACOT)
Icono=61
Modulos=(Todos)
ListaCarpetas=ExploraVar
CarpetaPrincipal=ExploraVar
PosicionInicialAlturaCliente=110
PosicionInicialAncho=490
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=331
PosicionInicialArriba=360
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaBloquearAjuste=S
VentanaEscCerrar=S
ListaAcciones=Acepta<BR>Preliminar<BR>Cancela
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna(Info.Reemplazar,<T>Si<T>)<BR>Asigna(Info.CategoriaCanal,<T>CREDITO EXTERNO<T>)
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
ListaEnCaptura=Mavi.NumCanalVenta<BR>Mavi.Sucursal
PermiteEditar=S
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
[ExploraVar.Mavi.NumCanalVenta]
Carpeta=ExploraVar
Clave=Mavi.NumCanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
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
ListaAccionesMultiples=AsignaV<BR>AceptaV
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
EjecucionCondicion=(  ConDatos(Mavi.NumCanalVenta) )y<BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>CREDITO EXTERNO<T>)= 1)
EjecucionMensaje=Si Vacio(Mavi.NumCanalVenta)  Entonces <T>El Canal de Venta es Requerido<T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>CREDITO EXTERNO<T>))<BR>                       Entonces <T>El Canal de Venta no es de Credito Externo<T><BR>                    Fin<BR>               Fin<BR>          Fin
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=AsignaExp<BR>Explorar<BR>CerrarV
ActivoCondicion=Info.Conteo=1
VisibleCondicion=Info.Conteo=1
[Acciones.Preliminar.CerrarV]
Nombre=CerrarV
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(  ConDatos(Mavi.NumCanalVenta))y<BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>CREDITO EXTERNO<T>)= 1)
EjecucionMensaje=Si Vacio(Mavi.NumCanalVenta) Entonces <T>El Canal de Venta  es Requerido <T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>CREDITO EXTERNO<T>))<BR>                       Entonces <T>El Canal de Venta no es de Credito Externo<T><BR>                    Fin<BR> Fin
[Acciones.Preliminar.Explorar]
Nombre=Explorar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Forma(<T>RM0956CxcExpEnvInfCobroFrm<T>)<BR>Asigna(Info.Conteo,Info.Conteo+1)
EjecucionCondicion=(  ConDatos(Mavi.NumCanalVenta)  )y<BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>CREDITO EXTERNO<T>)= 1)
EjecucionMensaje=Si Vacio(Mavi.NumCanalVenta)  Entonces <T>El Canal de Venta  es Requerido <T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>CREDITO EXTERNO<T>))<BR>                       Entonces <T>El Canal de Venta no es de Credito Externo<T><BR>                    Fin<BR> Fin
[Acciones.Preliminar.AsignaExp]
Nombre=AsignaExp
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
;[ExploraVar.Mavi.RM0755BSeccionCobranza]
;Carpeta=ExploraVar
;Clave=Mavi.RM0755BSeccionCobranza
;Editar=S
;LineaNueva=S
;ValidaNombre=S
;3D=S
;Tamano=20
;ColorFondo=Blanco
;ColorFuente=Negro
[ExploraVar.Mavi.Sucursal]
Carpeta=ExploraVar
Clave=Mavi.Sucursal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


