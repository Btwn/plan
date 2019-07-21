[Forma]
Clave=FinalINTFMavi
Nombre=Reporte Final
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
AccionesTamanoBoton=15x5
ListaCarpetas=FinalINTFMavi
CarpetaPrincipal=FinalINTFMavi
ListaAcciones=Cerrar<BR>Aceptar
PosicionInicialAlturaCliente=107
PosicionInicialAncho=246
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=319
PosicionInicialArriba=289
AccionesCentro=S
BarraHerramientas=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=&Generar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraAcciones=S
EnBarraHerramientas=S
Multiple=S
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
Expresion=ReportePantalla(<T>ReporteFinalMavi<T>,{info.FechaD},{info.FechaA})
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[FinalINTFMavi]
Estilo=Ficha
Clave=FinalINTFMavi
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[FinalINTFMavi.Info.FechaD]
Carpeta=FinalINTFMavi
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FinalINTFMavi.Info.FechaA]
Carpeta=FinalINTFMavi
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


