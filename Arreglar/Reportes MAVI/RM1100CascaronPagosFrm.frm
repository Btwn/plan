
[Forma]
Clave=RM1100CascaronPagosFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=vista
CarpetaPrincipal=vista

Nombre=RM1100 Actualizar Referencia(s)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guaradar<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
VentanaSinIconosMarco=S
ExpresionesAlCerrar=EjecutarSQL( <T>SP_RM1100ValidaCompraPagos :nID, :tMov, :nOpc<T>,0,<T>Pago<T>,2 )
[vista]
Estilo=Hoja
Clave=vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1100CascaronPagosVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Rojo
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
ListaEnCaptura=RM1100CascaronPagos.ID<BR>RM1100CascaronPagos.Aplica<BR>RM1100CascaronPagos.AplicaID<BR>RM1100CascaronPagos.RefCompra

[vista.RM1100CascaronPagos.ID]
Carpeta=vista
Clave=RM1100CascaronPagos.ID
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[vista.RM1100CascaronPagos.Aplica]
Carpeta=vista
Clave=RM1100CascaronPagos.Aplica
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[vista.RM1100CascaronPagos.AplicaID]
Carpeta=vista
Clave=RM1100CascaronPagos.AplicaID
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[vista.RM1100CascaronPagos.RefCompra]
Carpeta=vista
Clave=RM1100CascaronPagos.RefCompra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Rojo

[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=cancelar<BR>cerrar
[Acciones.Guaradar]
Nombre=Guaradar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=guarda<BR>expresion<BR>actualizar
[Acciones.Guaradar.guarda]
Nombre=guarda
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=GuardarCambios<BR>EjecutarSQL(<T>EXEC SP_RM1100ActualizaReferencia<T>)

[Acciones.Guaradar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo, SQLEnLista(<T>SELECT VALIDACION FROM RM1100CascaronPagos<T>))<BR>Si<BR> Vacio(Info.Dialogo)<BR>Entonces<BR>  Informacion(<T>Información Actualizada<T>)<BR>  Verdadero<BR>Sino<BR>  Informacion(SQLEnLista(<T>SELECT VALIDACION FROM RM1100CascaronPagos<T>))<BR>  AbortarOperacion<BR>Fin
Activo=S
Visible=S

[Acciones.Guaradar.actualizar]
Nombre=actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Cancelar.cancelar]
Nombre=cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cancelar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

