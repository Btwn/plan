
[Forma]
Clave=ContSATComprobante
Icono=0
CarpetaPrincipal=ContSATComprobante
Modulos=(Todos)

ListaCarpetas=ContSATComprobante
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=484
PosicionInicialAncho=923
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=221
PosicionInicialArriba=123
Comentarios=Lista(Info.Ejercicio,Info.Periodo,Info.Mov)
Nombre=Información Comprobantes
BarraAyuda=S
BarraAyudaBold=S
ListaAcciones=Aceptare<BR>Cancelar
[ContSATComprobante]
Estilo=Hoja
Clave=ContSATComprobante
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATComprobante
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ContSATComprobante.UUID<BR>ContSATComprobante.Monto<BR>ContSATComprobante.RFC<BR>ContSATComprobante.Moneda<BR>ContSATComprobante.TipoCambio

CarpetaVisible=S
Filtros=S

FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General




MenuLocal=S
ListaAcciones=Desasociar
FiltroGeneral=ContSATComprobante.ContID  = {Info.ID}
[ContSATComprobante.ContSATComprobante.UUID]
Carpeta=ContSATComprobante
Clave=ContSATComprobante.UUID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ContSATComprobante.ContSATComprobante.Monto]
Carpeta=ContSATComprobante
Clave=ContSATComprobante.Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[ContSATComprobante.ContSATComprobante.RFC]
Carpeta=ContSATComprobante
Clave=ContSATComprobante.RFC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y Cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[ContSATComprobante.Columnas]
Modulo=64
ModuloID=64
ContID=64
ModuloRenglon=77
UUID=235
Monto=170
RFC=193

EsCheque=64
EsTransferencia=81
Moneda=78
TipoCambio=84
[ContSATCheque.Columnas]
Modulo=64
ModuloID=64
ContID=64
ModuloRenglon=77
CtaOrigen=94
BancoOrigen=145
Monto=64
Fecha=94
Beneficiario=228
NumeroCheque=110
RFC=138



[Acciones.Cheque]
Nombre=Cheque
Boton=61
NombreEnBoton=S
NombreDesplegar=Cheque
EnBarraHerramientas=S
TipoAccion=Expresion


EspacioPrevio=S
Activo=S
Expresion=Asigna(Info.ID,ContSATComprobante:ContSATComprobante.ContID)<BR>FormaModal(<T>ContSATCheque<T>)
VisibleCondicion=Info.Tipo = <T>Egresos<T>
[ContSATTranferencia.Columnas]
Modulo=64
ModuloID=64
ContID=64
ModuloRenglon=77
CtaOrigen=112
BancoOrigen=140
CtaDestino=184
BancoDestino=136
Monto=64
Fecha=94
Beneficiario=136
RFC=137

[Acciones.Transferencia]
Nombre=Transferencia
Boton=96
NombreEnBoton=S
NombreDesplegar=Transferencia
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Expresion















EspacioPrevio=S
Activo=S



Expresion=Asigna(Info.ID,ContSATComprobante:ContSATComprobante.ContID)<BR>FormaModal(<T>ContSATTranferencia<T>)
VisibleCondicion=Info.Tipo = <T>Egresos<T>
[ContSATComprobante.ListaEnCaptura]
(Inicio)=ContSATComprobante.UUID
ContSATComprobante.UUID=ContSATComprobante.Monto
ContSATComprobante.Monto=ContSATComprobante.RFC
ContSATComprobante.RFC=(Fin)






























[Acciones.Aceptar.ValidaRFC]
Nombre=ValidaRFC
Boton=0
TipoAccion=Expresion
Expresion=Asigna( Info.ID, SQL( <T>DECLARE @OkRegistro INT;<BR>                       EXEC spRegistroOk :tCual, :tRFC, :tEmpresa, 1, @OkRegistro OUTPUT<BR>                       SELECT @OkRegistro<T>, <T>RFC<T>, ContSATComprobante:ContSATComprobante.RFC, Empresa))
Activo=S
Visible=S

[Acciones.Aceptar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S



EjecucionCondicion=Info.Id <> 0
EjecucionMensaje=<T>El RFC es invalido validar.<T>


[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=ValidaRFC
ValidaRFC=Guardar
Guardar=(Fin)





































































[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cheque
Cheque=Transferencia
Transferencia=(Fin)
[Acciones.Aceptare]
Nombre=Aceptare
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

GuardarAntes=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar/Cancelar Cambios
Activo=S
Visible=S

[Acciones.Desasociar]
Nombre=Desasociar
Boton=0
NombreDesplegar=Desasociar Comprobante
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Si<BR>   Precaucion(<T>El documento se desasociará del movimiento. ¿Desea Continuar?<T>, BotonNo, BotonSi ) = BotonSi<BR>Entonces<BR>    Si<BR>        ConDatos(ContSATComprobante:CFDValidoMovLista.ID)<BR>    Entonces<BR>        EjecutarSQL(<T>spDesasociarDocumento :tEmpresa, :tModulo, :nModuloID, :nID <T>, Empresa, ContSATComprobante:ContSATComprobante.Modulo, ContSATComprobante:ContSATComprobante.ModuloID, ContSATComprobante:CFDValidoMovLista.ID )<BR>    Sino<BR>        EjecutarSQL(<T>spDesasociarDocumento :tEmpresa, :tModulo, :nModuloID, :nID, 1 <T>, Empresa, ContSATComprobante:ContSATComprobante.Modulo, ContSATComprobante:ContSATComprobante.ModuloID, ContSATComprobante:ContSATComprobante.ID )<BR>    Fin<BR><BR>   Forma.ActualizarVista( <T>ContSATComprobante<T> )<BR>Fin
ActivoCondicion=ConDatos(ContSATComprobante:ContSATComprobante.ModuloID)
[ContSATComprobante.ContSATComprobante.Moneda]
Carpeta=ContSATComprobante
Clave=ContSATComprobante.Moneda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[ContSATComprobante.ContSATComprobante.TipoCambio]
Carpeta=ContSATComprobante
Clave=ContSATComprobante.TipoCambio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

