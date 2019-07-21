[Forma]
Clave=RM1045PagosIvaIsrFrm
Nombre=RM1045 Pagos Iva Isr
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=122
PosicionInicialAncho=292
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
PosicionInicialIzquierda=494
PosicionInicialArriba=432
ListaAcciones=Excel<BR>Cerrar
ExpresionesAlMostrar=Asigna(Info.Proveedor,<T><T>)<BR>Asigna(Info.FechaD,SQL(<T>select cast(cast(getdate() as int) as datetime)<T>))<BR>Asigna(Info.FechaA,SQL(<T>select cast(cast(getdate() as int) as datetime)<T>))
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
ListaEnCaptura=Info.Proveedor<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[(Variables).Info.Proveedor]
Carpeta=(Variables)
Clave=Info.Proveedor
Editar=S
LineaNueva=S
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
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.relacion]
Nombre=relacion
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1045PagosIvaIsrRep
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=CONDATOS(Info.FechaD) y condatos(Info.FechaA) y (Info.FechaD <= Info.FechaA)
EjecucionMensaje=<T>Rango de Fechas invalido<T>
EjecucionConError=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ListaAccionesMultiples=Variables Asignar<BR>RM1045PagosIvaIsrRep<BR>Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Excel.RM1045PagosIvaIsrRep]
Nombre=RM1045PagosIvaIsrRep
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1045PagosIvaIsrRep
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=ConDatos(Info.FechaD) y ConDatos(Info.FechaA) y (Info.FechaA>=Info.FechaD)
EjecucionMensaje=<T>Seleccione Rango de Fechas Valido...<T>

