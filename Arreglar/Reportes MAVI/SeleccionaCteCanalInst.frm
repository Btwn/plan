
[Forma]
Clave=SeleccionaCteCanalInst
Icono=0
Modulos=(Todos)
Nombre=Datos Instituciones

ListaCarpetas=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetaPrincipal=(Variables)
ListaAcciones=Aceptar
PosicionInicialAlturaCliente=115
PosicionInicialAncho=280
PosicionInicialIzquierda=500
PosicionInicialArriba=324
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna(Info.RFCInst, Nulo)<BR>Asigna(Info.NominaInst, Nulo)
ExpresionesAlCerrar=Asigna(Info.Categoria, Nulo)
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
ListaEnCaptura=(Lista)

CarpetaVisible=S
[(Variables).ListaEnCaptura]
(Inicio)=Info.NominaInst
Info.NominaInst=Info.RFCInst
Info.RFCInst=(Fin)

[(Variables).Info.NominaInst]
Carpeta=(Variables)
Clave=Info.NominaInst
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.RFCInst]
Carpeta=(Variables)
Clave=Info.RFCInst
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreDesplegar=&Guardar y Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S

GuardarAntes=S
Multiple=S
ListaAccionesMultiples=(Lista)
ConCondicion=S
EjecucionCondicion=ConDatos(Info.NominaInst) y ConDatos(Info.RFCInst)
EjecucionMensaje=<T>Los Datos Son Necesarios<T>
EjecucionConError=S

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
















Expresion=Si //SQL(<T>SELECT Categoria FROM  VentasCanalMavi WHERE ID=:nid<T>,Info.CanalVentaMAVI) = <T>INSTITUCIONES<T><BR>  Info.Categoria =  <T>INSTITUCIONES<T><BR>  Entonces<BR>     //EjecutarSQL(<T>UPDATE CteEnviarA SET Nomina=:tnomina, RFCInstitucion=:trfc WHERE Cliente=:tcliente AND ID=:tcanal<T>, Info.NominaInst, Info.RFCInst, Info.Cliente, Info.CanalVentaMAVI)<BR>     EjecutarSQL(<T>spActualizaCanalCteExistInst :tcliente, :tcanal, :trfc, :tnomina<T>, Info.Cliente, Info.CanalVentaMAVI, Info.RFCInst,  Info.NominaInst)<BR>Fin
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S







[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Guardar
Guardar=Cerrar
Cerrar=(Fin)

