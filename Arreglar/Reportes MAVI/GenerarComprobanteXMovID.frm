
[Forma]
Clave=GenerarComprobanteXMovID
Icono=0
Modulos=(Todos)
Nombre=Genera Comprobante Fiscal X MovID

ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=420
PosicionInicialArriba=260
PosicionInicialAlturaCliente=170
PosicionInicialAncho=300
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
Expresion=Si(Info.ModuloCFDFlex=<T>VENTAS<T>, Asigna(Info.ModuloCFDFlex, <T>VTAS<T>))<BR>Si((Info.ModuloCFDFlex=<T>CXC<T>) y (Info.MovCFDFlex en(<T>Factura<T>,<T>Factura Mayoreo<T>,<T>Factura VIU<T>)),Si(Precaucion(<T>Modulo Incorrecto para el Movimiento Asignado<T>, BotonCancelar)=BotonCancelar, AbortarOperacion))<BR>EjecutarSQLAnimado( <T>spCFDFlexGenenarXMovID :tmod, :tmov, :tmovid, NULL, NULL<T>, Info.ModuloCFDFlex, Info.MovCFDFlex, Info.MovIDCFDFlex)
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
Info.MovCFDFlex=Info.MovIDCFDFlex
Info.MovIDCFDFlex=(Fin)

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

[Variables.Info.MovIDCFDFlex]
Carpeta=Variables
Clave=Info.MovIDCFDFlex
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
