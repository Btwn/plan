[Forma]
Clave=RM1143PlazasFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=RM1143PlazasVis
CarpetaPrincipal=RM1143PlazasVis
PosicionInicialAlturaCliente=739
PosicionInicialAncho=767
PosicionInicialIzquierda=256
PosicionInicialArriba=123
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Cerrar
VentanaSinIconosMarco=S
ExpresionesAlCerrar=Asigna(Info.Numero,1)
[RM1143PlazasVis]
Estilo=Hoja
Clave=RM1143PlazasVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1143PlazasVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Plaza<BR>Descripcion
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[RM1143PlazasVis.Plaza]
Carpeta=RM1143PlazasVis
Clave=Plaza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1143PlazasVis.Descripcion]
Carpeta=RM1143PlazasVis
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[RM1143PlazasVis.Columnas]
Plaza=124
Descripcion=604
0=124
1=215
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Seleccionar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccionar/Aceptar]
Nombre=Seleccionar/Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>    Condatos(MAVI.RM1143Plazas)<BR>Entonces<BR>    Asigna(MAVI.RM1143Descrip,EjecutarSQL(<T>SELECT Descripcion FROM COMERCIALIZADORA..PLAZA WHERE Plaza = :tPlaza<T>,MAVI.RM1143Plazas))<BR>Fin
[Acciones.Seleccionar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
[Acciones.Seleccionar.AsignarV]
Nombre=AsignarV
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Selec]
Nombre=Selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(MAVI.RM1143Plazas,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar.AceptarV]
Nombre=AceptarV
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.Seleccionar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Seleccionar.i]
Nombre=i
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.rt]
Nombre=rt
Boton=0
TipoAccion=Expresion
Expresion=Informacion(MAVI.RM1143Plazas)
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=OtraForma(<T>RM1143AgregarCCXPlazaFrm<T>,Forma.Accion(<T>Asignar<T>))
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna Valor<BR>Selecciona
[Acciones.PRUEBA.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.PRUEBA.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Aceptar
[Acciones.Otra.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=OtraForma(<T>RM1143AgregarCCXPlazaFrm<T>,Forma.accion(<T>Expresion<T>))
[Acciones.Otra.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(MAVI.RM1143Plazas,RM1143PlazasVis:Plaza)
[Acciones.Seleccionar.seleciona]
Nombre=seleciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.Seleccionar.Asignacion]
Nombre=Asignacion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Numero,1)
[Acciones.Seleccionar.Asigna Valor]
Nombre=Asigna Valor
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(MAVI.RM1143Plazas,RM1143PlazasVis:Plaza)<BR>Asigna(MAVI.RM1143Descrip,RM1143PlazasVis:Descripcion)
[Acciones.Seleccionar.Selecciona]
Nombre=Selecciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.prueba.f]
Nombre=f
Boton=0
TipoAccion=Expresion
Expresion=Asigna(MAVI.RM1143Plazas,RM1143PlazasVis:Plaza)
Activo=S
Visible=S
[Acciones.prueba.g]
Nombre=g
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

