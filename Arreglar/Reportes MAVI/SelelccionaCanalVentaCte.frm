[Forma]
Clave=SelelccionaCanalVentaCte
Icono=0
Modulos=(Todos)
Nombre=Nuevo Canal
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=504
PosicionInicialArriba=451
PosicionInicialAlturaCliente=84
PosicionInicialAncho=272
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.CanalVentaMavi, Nulo))
ExpresionesAlCerrar=Si(Info.Categoria <> <T>INSTITUCIONES<T>, Asigna(Info.Categoria, Nulo))
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
ListaEnCaptura=Info.CanalVentaMAVI
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=87
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaAlineacion=Izquierda
PermiteEditar=S
[(Variables).Info.CanalVentaMAVI]
Carpeta=(Variables)
Clave=Info.CanalVentaMAVI
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
NombreDesplegar=&Aceptar
GuardarAntes=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Nuevo<BR>Cerrar<BR>Institusiones


[CanalVentaVarMavi.Columnas]
ID=64
Cadena=229

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Nuevo]
Nombre=Nuevo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S

Expresion=Asigna(Info.Categoria, SQL(<T>SELECT Categoria FROM VentasCanalMavi WHERE ID=:ncanal<T>, Info.CanalVentaMavi))<BR>EjecutarSQL(<T>spAltaCanalCteExiste :tcliente, :ncanal<T>, Info.Cliente, Info.CanalVentaMavi)<BR>Si(Info.CanalVentaMavi=76 Y ConDatos(info.Cliente) Y (medio(info.Cliente,1,1) en(<T>C<T>, <T>P<T>)),Forma(<T>DM0264ClientesD<T>),Falso)<BR>Si(Info.CanalVentaMavi=76 Y ConDatos(info.Cliente) Y (medio(info.Cliente,1,1) en(<T>C<T>, <T>P<T>)),EjecutarSQL(<T>EXEC SPCREDIAsignacionTipoDIMA :tCliente<T>,Info.Cliente))
EjecucionCondicion=Si Vacio(SQL(<T>SELECT ID FROM VentasCanalMAVI WHERE ID=:ncanal<T>, Info.CanalVentaMavi))<BR>  Entonces<BR>    Error(<T>Canal de Venta No Valido<T>)<BR>  Sino<BR>    Si No Vacio(SQL(<T>SELECT ID FROM CteEnviarA WHERE Cliente=:tcliente AND ID=:ncanal<T>, Info.Cliente, Info.CanalVentaMavi))<BR>      Entonces<BR>        Error(<T>El Canal de Venta Ya Existe<T>)<BR>    Fin<BR>Fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Aceptar.Institusiones]
Nombre=Institusiones
Boton=0
TipoAccion=Formas
;ClaveAccion=SeleccionaCteCanalInst
ClaveAccion=DM0138MaviCteExpressDatosNominales
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Info.Categoria en (<T>INSTITUCIONES<T>)

[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



