[Forma]
Clave=CondicionPlaneadorMAVI
Nombre=Condicion
Icono=0
Modulos=(Todos)
MovModulo=COMS
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar/Aceptar
PosicionInicialIzquierda=440
PosicionInicialArriba=358
PosicionInicialAlturaCliente=109
PosicionInicialAncho=271
ExpresionesAlMostrar=Asigna(Info.CondicionMavi, Nulo)
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
ListaEnCaptura=Info.CondicionMavi<BR>Mavi.DM0169RefCompra
CarpetaVisible=S
[(Variables).Info.CondicionMavi]
Carpeta=(Variables)
Clave=Info.CondicionMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar/Aceptar]
Nombre=Seleccionar/Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=Aceptar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
[Acciones.Seleccionar/Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar/Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si (Info.CondicionMavi <> Nulo) y (Mavi.DM0169RefCompra <>  Nulo )  Entonces<BR>       ProcesarSQL(<T>spInsertaSolCompraMAVI :tEmp, :tUsuario, :tCond, :nEst, :tRef<T>, Empresa, Usuario, Info.CondicionMavi,  EstacionTrabajo,Mavi.DM0169RefCompra )<BR>    //   EjecutarSQL(<T>SpTraspasoHistoricoPlaneadorMAVI<T>)<BR>      // EjecutarSQL( <T>sp_EliminaTabla<T> )<BR>       OtraForma(<T>PlaneadorMacroMAVI<T>, ActualizarVista)<BR>    Sino<BR>      Precaucion( <T>Proporcione condicion de pago Y/O Referencia...<T>)<BR>    Fin
[Acciones.Seleccionar/Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.DM0169RefCompra]
Carpeta=(Variables)
Clave=Mavi.DM0169RefCompra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

