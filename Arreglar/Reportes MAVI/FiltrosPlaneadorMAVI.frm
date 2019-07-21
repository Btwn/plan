[Forma]
Clave=FiltrosPlaneadorMAVI
Nombre=Filtros Planeador
Icono=0
Modulos=(Todos)
MovModulo=COMS
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Procesar
PosicionInicialIzquierda=525
PosicionInicialArriba=448
PosicionInicialAlturaCliente=94
PosicionInicialAncho=230
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna(Info.Proveedor, Nulo)<BR>Asigna(Info.Articulo, Nulo)<BR>EjecutarSQL( <T>sp_EliminaTabla :nEst<T>,  EstacionTrabajo  )
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
ListaEnCaptura=Info.Proveedor<BR>Info.Articulo
CarpetaVisible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Procesar]
Nombre=Procesar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Procesar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
[Acciones.Procesar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si ConDatos( Info.Proveedor) y ConDatos( Info.Articulo)<BR>Entonces<BR>  ProcesarSQL(<T>SpValidaPlaneadorMAVI :tEmp, :tProv, :tArt, :nEst<T>, Empresa, Info.Proveedor, Info.Articulo,  EstacionTrabajo )<BR>Fin<BR>Asigna(Info.Cantidad,0)<BR>Si ConDatos(Info.Proveedor) Entonces<BR>//  ProcesarSQL(<T>SpCorrePlaneadorMAVI  :tProv<T>, Info.Proveedor)<BR>  Asigna(Info.Cantidad, SQL(<T>SELECT COUNT(*) FROM PlaneadorMacroMavi WHERE Proveedor = :tProv<T>, Info.Proveedor))<BR>  Si Info.Cantidad > 0 Entonces<BR>    ProcesarSQL(<T>SpCorrePlaneadorMAVI  :tProv<T>, Info.Proveedor)<BR>    Asigna(Info.Proveedor, nulo)<BR>  Sino<BR>    Si Info.Cantidad = 0 Entonces<BR>      EjecutarSQL(<T>SpPlaneadorMAVI :tEmp, :tProv, :tArt, :nEst<T>, Empresa, Info.Proveedor, Info.Articulo,  EstacionTrabajo )<BR>    Fin<BR><CONTINUA>
Expresion002=<CONTINUA>  Fin<BR>Sino<BR>  Si ConDatos(Info.Articulo) Entonces<BR>    Asigna(Info.Proveedor, SQL(<T>SELECT Proveedor FROM Art WHERE Articulo=:tArt<T>,Info.Articulo))<BR>    Asigna(Info.Cantidad, SQL(<T>SELECT COUNT(*) FROM PlaneadorMacroMavi WHERE Proveedor = :tProv<T>, Info.Proveedor))<BR>    Si Info.Cantidad > 0 Entonces<BR>      ProcesarSQL(<T>SpCorrePlaneadorMAVI  :tProv<T>, Info.Proveedor)<BR>      Asigna(Info.Proveedor, nulo)<BR>    Sino<BR>      Si Info.Cantidad = 0 Entonces<BR>        Asigna(Info.Proveedor, nulo)<BR>        EjecutarSQL(<T>SpPlaneadorMAVI :tEmp, :tProv, :tArt, :nEst<T>, Empresa, Info.Proveedor, Info.Articulo,  EstacionTrabajo )<BR>        Asigna(Info.Proveedor, SQL(<T>SELECT Proveedor FROM Art WHERE Articulo=:tArt<T>,Info.Articulo)) <BR>    Fin<BR>  Fin<BR>Fin<BR><BR><BR>//<CONTINUA>
Expresion003=<CONTINUA>OtraForma(<T>PlaneadorMacroMAVI<T>, ActualizarVista)
[Acciones.Procesar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
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
[(Variables).Info.Articulo]
Carpeta=(Variables)
Clave=Info.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Procesar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

