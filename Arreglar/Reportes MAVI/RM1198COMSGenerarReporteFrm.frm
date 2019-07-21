
[Forma]
Clave=RM1198COMSGenerarReporteFrm
Icono=134
Modulos=(Todos)
MovModulo=COMS
Nombre=<T>Generar Reporte CSV Magento<T>



ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=121
PosicionInicialAncho=384
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=448
PosicionInicialArriba=432
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar
ExpresionesAlMostrar=Asigna(Mavi.RM1198TiendaVirtual,)
[Principal]
Estilo=Ficha
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1198TiendaVirtual
CarpetaVisible=S

[Principal.Mavi.RM1198TiendaVirtual]
Carpeta=Principal
Clave=Mavi.RM1198TiendaVirtual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Capturar<BR>Reporte<BR>Mensaje
[Acciones.Guardar.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Guardar.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1198COMSCsvMagentoRepTxt
Activo=S
Visible=S

[Acciones.Guardar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1198TiendaVirtual,)


