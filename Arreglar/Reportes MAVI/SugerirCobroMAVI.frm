[Forma]
Clave=SugerirCobroMAVI
Nombre=Sugerir
Icono=5
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=528
PosicionInicialArriba=440
PosicionInicialAlturaCliente=105
PosicionInicialAncho=223
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(info.Cantidad, 0)<BR>SI(SQL(<T>Select dbo.fn_MaviDM0169cobroSegurosvida(:tclie)<T>,Info.Acreditado) = 0,Asigna(Info.Importe,SQL(<T>Select dbo.fn_MaviDM0169sugerirImporte(:tclie)<T>,Info.Acreditado)),Asigna(Info.Importe,Info.Importe))

[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Info.SugerirCobro<BR>Info.Importe
CarpetaVisible=S

[(Variables).Info.Importe]
Carpeta=(Variables)
Clave=Info.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=<T>&Aceptar<T>
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=VariablesAsignar<BR>Expresion<BR>Cerrar

[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=<T>&Cancelar<T>
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

[(Variables).Info.SugerirCobro]
Carpeta=(Variables)
Clave=Info.SugerirCobro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.VariablesAsignar]
Nombre=VariablesAsignar
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
Expresion=Si<BR>((Info.Importe < 1) y (Info.SugerirCobro en (<T>Por Factura<T>,<T>Importe Especifico<T>))) <BR>Entonces<BR>Informacion(<T>El importe debe ser mayor a cero<T>)<BR>Sino<BR> (Si Info.SugerirCobro = <T>Por Factura<T> Entonces<BR>   Forma(<T>CxcFacturaCteMavi<T>)<BR>Sino<BR>  Forma(<T>NegociaMoratoriosMavi<T>)<BR>Fin) <BR>Fin

[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
