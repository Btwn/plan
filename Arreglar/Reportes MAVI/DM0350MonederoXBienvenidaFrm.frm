
[Forma]
Clave=DM0350MonederoXBienvenidaFrm
Icono=746
Modulos=(Todos)


ListaCarpetas=DM0350MonederoXBienvenidaVis
CarpetaPrincipal=DM0350MonederoXBienvenidaVis
PosicionInicialAlturaCliente=173
PosicionInicialAncho=375
PosicionInicialIzquierda=495
PosicionInicialArriba=278
Nombre=PARÁMETROS BONO BIENVENIDA
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=CerrarBtn<BR>GuardarBtn<BR>Empty
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
VentanaAjustarZonas=S
[DM0350MonederoXBienvenidaVis]
Estilo=Ficha
Clave=DM0350MonederoXBienvenidaVis
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0350MonederoXBienvenidaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0350MonederoXBienvenidaTbl.ClientesFinales<BR>DM0350MonederoXBienvenidaTbl.CuotaXFinal<BR>DM0350MonederoXBienvenidaTbl.PlazoParaBono<BR>DM0350MonederoXBienvenidaTbl.BonoBienvenida






FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
[DM0350MonederoXBienvenidaVis.Columnas]
ClientesFinales=75
CuotaXFinal=64
CuotaGlobal=64
PlazoParaBono=75
BonoBienvenida=80
Usuario=64

Usr=64

Parametro=94
Valor=64
[Acciones.GuardarBtn]
Nombre=GuardarBtn
Boton=3
NombreDesplegar=&Guardar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
EnBarraHerramientas=S
NombreEnBoton=S

EspacioPrevio=S
[Acciones.CerrarBtn.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.CerrarBtn.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.CerrarBtn]
Nombre=CerrarBtn
Boton=23
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar<BR>Salir
Activo=S
Visible=S
NombreEnBoton=S

[Acciones.Empty]
Nombre=Empty
Boton=0
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S






[DM0350MonederoXBienvenidaVis.DM0350MonederoXBienvenidaTbl.ClientesFinales]
Carpeta=DM0350MonederoXBienvenidaVis
Clave=DM0350MonederoXBienvenidaTbl.ClientesFinales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0350MonederoXBienvenidaVis.DM0350MonederoXBienvenidaTbl.CuotaXFinal]
Carpeta=DM0350MonederoXBienvenidaVis
Clave=DM0350MonederoXBienvenidaTbl.CuotaXFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0350MonederoXBienvenidaVis.DM0350MonederoXBienvenidaTbl.PlazoParaBono]
Carpeta=DM0350MonederoXBienvenidaVis
Clave=DM0350MonederoXBienvenidaTbl.PlazoParaBono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0350MonederoXBienvenidaVis.DM0350MonederoXBienvenidaTbl.BonoBienvenida]
Carpeta=DM0350MonederoXBienvenidaVis
Clave=DM0350MonederoXBienvenidaTbl.BonoBienvenida
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
