
[Forma]
Clave=GenerarComprobanteFiscal
Icono=0
Modulos=(Todos)
Nombre=Genera Comprobante Fiscal

ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=409
PosicionInicialArriba=254
PosicionInicialAlturaCliente=250
PosicionInicialAncho=267
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=(Lista)
AccionesCentro=S
AccionesDivision=S
[Variables]
Estilo=Ficha
Clave=Variables
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)

CarpetaVisible=S


[Variables.Info.FechaD]
Carpeta=Variables
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Variables.Info.FechaA]
Carpeta=Variables
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.Aceptar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Ejecutar]
Nombre=Ejecutar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si(Info.ModuloCFDFlex=<T>VENTAS<T>, Asigna(Info.ModuloCFDFlex, <T>VTAS<T>))<BR>Si((Info.ModuloCFDFlex=<T>CXC<T>) y (Info.MovCFDFlex en(<T>Factura<T>,<T>Factura Mayoreo<T>,<T>Factura VIU<T>)),Si(Precaucion(<T>Modulo Incorrecto para el Movimiento Asignado<T>, BotonCancelar)=BotonCancelar, AbortarOperacion))<BR>EjecutarSQLAnimado( <T>spCFDFlexRegenerar :tmod, :tmov, :ffechad, :ffechaa,:nId,:nMax, NULL, NULL<T>, Info.ModuloCFDFlex, Info.MovCFDFlex, Info.FechaD, Info.FechaA, Info.IDInicialCFD, Info.MaxCFD)
[Acciones.Aceptar.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Expresion
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S
NombreEnBoton=S
GuardarAntes=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S






[Variables.Info.ModuloCFDFlex]
Carpeta=Variables
Clave=Info.ModuloCFDFlex
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




[Variables.ListaEnCaptura]
(Inicio)=Info.ModuloCFDFlex
Info.ModuloCFDFlex=Info.MovCFDFlex
Info.MovCFDFlex=Info.FechaD
Info.FechaD=Info.FechaA
Info.FechaA=Info.IDInicialCFD
Info.IDInicialCFD=Info.MaxCFD
Info.MaxCFD=(Fin)

[Variables.Info.MovCFDFlex]
Carpeta=Variables
Clave=Info.MovCFDFlex
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Variables.Info.IDInicialCFD]
Carpeta=Variables
Clave=Info.IDInicialCFD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Variables.Info.MaxCFD]
Carpeta=Variables
Clave=Info.MaxCFD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[MovCFD.Columnas]
Mov=212
























[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=Guardar
Guardar=Ejecutar
Ejecutar=Salir
Salir=(Fin)

[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cancelar
Cancelar=(Fin)
