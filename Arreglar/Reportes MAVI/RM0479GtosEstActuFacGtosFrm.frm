[Forma]
Clave=RM0479GtosEstActuFacGtosFrm
Nombre=RM0479 Situación Actual Facturas de Gastos
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
PosicionInicialAltura=392
PosicionInicialAncho=377
ListaAcciones=Preliminar<BR>Cerrar
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=451
PosicionInicialArriba=314
SinCondicionDespliege=S
MovModulo=GAS
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
BarraHerramientas=S
PosicionInicialAlturaCliente=357
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna(Info.AcreedorD, SQL(<T>SELECT Min(Proveedor) FROM Prov Where Rama =:trama<T>, <T>ACRE<T>))<BR>Asigna(Info.AcreedorA, SQL(<T>SELECT Max(Proveedor) FROM Prov Where Rama =:trama<T>, <T>ACRE<T>))<BR>Asigna(Info.MovClaveAfecta, <T><T>)<BR>Asigna(Info.Modulo, <T>GAS<T>)<BR>Asigna(Info.Moneda, Config.ContMoneda)<BR>Asigna(Info.ProvCat, <T>(Todos)<T>)<BR>Asigna(Info.ProvFam, <T>(Todos)<T>)<BR>/*Asigna(Info.Estatus, <T>Concluido<T>)*/<BR>Asigna(Info.Sucursal, Nulo)<BR>Asigna(Info.UEN, Nulo)<BR>Asigna(Info.Desglosar, <T>No<T>)<BR>Asigna(Mavi.TexFvenciEmi, <T>Emision<T>)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.AcreedorD<BR>Info.AcreedorA<BR>Info.ProvCat<BR>Info.ProvFam<BR>Info.Sucursal<BR>Info.UEN<BR>Info.MovClaveAfecta<BR>Info.Moneda<BR>Info.Estatus<BR>Mavi.RM0479ReferenciaFilt<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.TexFvenciEmi
CarpetaVisible=S
FichaEspacioEntreLineas=7
FichaEspacioNombres=105
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Blanco
FichaAlineacionDerecha=S
FichaEspacioNombresAuto=S
PermiteEditar=S

[(Variables).Info.Sucursal]
Carpeta=(Variables)
Clave=Info.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[(Variables).Info.Moneda]
Carpeta=(Variables)
Clave=Info.Moneda
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.Estatus]
Carpeta=(Variables)
Clave=Info.Estatus
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S


[(Variables).Info.AcreedorD]
Carpeta=(Variables)
Clave=Info.AcreedorD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.AcreedorA]
Carpeta=(Variables)
Clave=Info.AcreedorA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.ProvCat]
Carpeta=(Variables)
Clave=Info.ProvCat
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.ProvFam]
Carpeta=(Variables)
Clave=Info.ProvFam
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

[Acciones.Imprimir.Variables Asignar]
Nombre=Variables Asignar
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

[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar

[Acciones.Imprimir.mis_GastoAnalisisMov]
Nombre=mis_GastoAnalisisMov
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=mis_GastoAnalisisMov

[Acciones.Preliminar.mis_GastoAnalisisMov]
Nombre=mis_GastoAnalisisMov
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=mis_GastoAnalisisMov

[(Variables).Info.UEN]
Carpeta=(Variables)
Clave=Info.UEN
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.MovClaveAfecta]
Carpeta=(Variables)
Clave=Info.MovClaveAfecta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.TexFvenciEmi]
Carpeta=(Variables)
Clave=Mavi.TexFvenciEmi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (vacio(Info.FechaD)y vacio(Info.FechaA)) o (condatos(info.fechad) y vacio(info.fechaa))
EjecucionMensaje=Si ((Info.FechaA)<(Info.FechaD)) ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>
EjecucionConError=S
Visible=S
[(Variables).Mavi.RM0479ReferenciaFilt]
Carpeta=(Variables)
Clave=Mavi.RM0479ReferenciaFilt
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

