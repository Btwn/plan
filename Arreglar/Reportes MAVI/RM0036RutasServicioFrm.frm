[Forma]
Clave=RM0036RutasServicioFrm
Nombre=RM036A Rutas de Servicio
Icono=134
Modulos=(Todos)
PosicionInicialIzquierda=465
PosicionInicialArriba=382
PosicionInicialAlturaCliente=162
PosicionInicialAncho=349
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Refresca
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
ExpresionesAlMostrar=Asigna(Mavi.RM0036SucursalCliente,Nulo)<BR>Asigna(Mavi.RM0036RecoleccionEntrega,Nulo)<BR>Asigna(Mavi.RM0036FamiliasVentaRutas,Nulo)<BR>Asigna(Mavi.RM0036OrdServReparar,Nulo)<BR>Asigna(Mavi.RM0036Agente,Nulo)<BR>Asigna(Mavi.RM0036Vehiculos,Nulo)
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Cerrar<BR>TipoUsuario
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(ConDatos(Mavi.RM0036Agente) y ConDatos(Mavi.RM0036Vehiculos))
EjecucionMensaje=<T>Debe Proporcionar Agente y Vehiculo para Continuar<T>
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0036Agente<BR>Mavi.RM0036Vehiculos<BR>Mavi.RM0036SucursalCliente<BR>Mavi.RM0036RecoleccionEntrega<BR>Mavi.RM0036FamiliasVentaRutas<BR>Mavi.RM0036OrdServReparar
CarpetaVisible=S
[Acciones.Refresca]
Nombre=Refresca
Boton=0
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1
[Acciones.Preliminar.TipoUsuario]
Nombre=TipoUsuario
Boton=0
TipoAccion=Expresion
Expresion=Informacion(Usuario.Configuracion)<BR>Informacion(Usuario.Acceso)
Activo=S
Visible=S
[(Variables).Mavi.RM0036Agente]
Carpeta=(Variables)
Clave=Mavi.RM0036Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0036Vehiculos]
Carpeta=(Variables)
Clave=Mavi.RM0036Vehiculos
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0036SucursalCliente]
Carpeta=(Variables)
Clave=Mavi.RM0036SucursalCliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0036RecoleccionEntrega]
Carpeta=(Variables)
Clave=Mavi.RM0036RecoleccionEntrega
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0036FamiliasVentaRutas]
Carpeta=(Variables)
Clave=Mavi.RM0036FamiliasVentaRutas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0036OrdServReparar]
Carpeta=(Variables)
Clave=Mavi.RM0036OrdServReparar
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

