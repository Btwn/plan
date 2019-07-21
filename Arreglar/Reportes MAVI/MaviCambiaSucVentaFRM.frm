[Forma]
Clave=MaviCambiaSucVentaFRM
Nombre=Cambia la Sucursal de Venta
Icono=634
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=505
PosicionInicialArriba=462
PosicionInicialAlturaCliente=73
PosicionInicialAncho=269
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guarda
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlCerrar=Asigna(Temp.Num,Nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviSVVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Venta.SucursalVenta<BR>Sucursal.Nombre
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=Venta.ID = {Info.ID}
[Acciones.Guarda.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guarda.Ejecuta]
Nombre=Ejecuta
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=EjecutarSQL(<T>Exec SP_MaviAlteraSucVenta <T>&Info.Sucursal&<T>,<T>&Mavi.ID)
EjecucionCondicion=Condatos(Info.Sucursal)
[Acciones.Guarda.CEra]
Nombre=CEra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Guarda]
Nombre=Guarda
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar y Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Aceptar
GuardarAntes=S
[(Variables).Venta.SucursalVenta]
Carpeta=(Variables)
Clave=Venta.SucursalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S
[(Variables).Sucursal.Nombre]
Carpeta=(Variables)
Clave=Sucursal.Nombre
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Gris


