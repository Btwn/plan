
[Forma]
Clave=ContSATInfoCompDinero
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
Nombre=Información Complementaria

ListaCarpetas=Cheque<BR>Transferencia<BR>OtroMetodoPago<BR>ChequeD<BR>TransferenciaD<BR>OtrosMetodosD
CarpetaPrincipal=Cheque
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=154
PosicionInicialArriba=136
PosicionInicialAlturaCliente=457
PosicionInicialAncho=1058
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
BarraHerramientas=S
Comentarios=Lista(ContSatDinero:ContSatDinero.BeneficiarioNombre,Info.Mov,Info.ID)
ExpresionesAlMostrar=EjecutarSQL(<T>spContSATDineroActualizarCtaDineroRfc :nID<T>, Info.ID)<BR>Asigna(Info.Visible,SQL(<T>SELECT CASE WHEN MetodoPagoSAT IN (2,3) THEN MetodoPagoSAT ELSE 0 END FROM FormaPago WHERE FormaPago = :tFormaPago<T>, Info.FormaPago))
ExpresionesAlCerrar=Si<BR>  Info.Estatus <> EstatusSinAfectar<BR>Entonces<BR>  EjecutarSQL(<T>spActualizarContSatDinero :tEmpresa,:tModulo, :nID<T>,Empresa,<T>DIN<T>,Info.ID)<BR>Fin
ExpresionesAlActivar=ActualizarForma
[Cheque]
Estilo=Hoja
Pestana=S
Clave=Cheque
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATDinero
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco

PestanaOtroNombre=S
PestanaNombre=Cheque
ListaEnCaptura=ContSATDinero.BeneficiarioNombre<BR>ContSATDinero.NumeroCheque<BR>ContSATDinero.RFCReceptor
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
FiltroGeneral=ContSATDinero.ID = {Info.ID}
CondicionVisible=(SQL(<T>SELECT ConDesglose FROM Dinero WHERE ID = :nID<T>, Info.ID) = 0)<BR>y<BR>(SQL(<T>SELECT B.MetodoPagoSAT FROM Dinero A JOIN FormaPago B ON A.FormaPago = B.FormaPago AND A.ID = :nID<T>, Info.ID) = 2)
[Transferencia]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Transferencia
Clave=Transferencia
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATDinero
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco

Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
ListaEnCaptura=ContSATDinero.BeneficiarioNombre<BR>ContSATDinero.CtaBeneficiario<BR>ContSATDinero.Institucion<BR>ContSATDinero.RFCReceptor
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
FiltroGeneral=ContSATDinero.ID = {Info.ID}
CondicionVisible=(SQL(<T>SELECT ConDesglose FROM Dinero WHERE ID = :nID<T>, Info.ID) = 0)<BR>y<BR>(SQL(<T>SELECT B.MetodoPagoSAT FROM Dinero A JOIN FormaPago B ON A.FormaPago = B.FormaPago AND A.ID = :nID<T>, Info.ID) = 3)
[OtroMetodoPago]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Otro Método de Pago
Clave=OtroMetodoPago
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATDinero
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco

Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
ListaEnCaptura=ContSATDinero.BeneficiarioNombre<BR>ContSATDinero.RFCReceptor
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
FiltroGeneral=ContSATDinero.ID = {Info.ID}
CondicionVisible=(SQL(<T>SELECT ConDesglose FROM Dinero WHERE ID = :nID<T>, Info.ID) = 0)<BR>y<BR>(SQL(<T>SELECT COUNT(*) FROM Dinero A JOIN FormaPago B ON A.FormaPago = B.FormaPago AND A.ID = :nID AND B.MetodoPagoSAT NOT IN (2,3) <T>, Info.ID) <> 0 )
[Cheque.ContSATDinero.BeneficiarioNombre]
Carpeta=Cheque
Clave=ContSATDinero.BeneficiarioNombre
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Cheque.ContSATDinero.NumeroCheque]
Carpeta=Cheque
Clave=ContSATDinero.NumeroCheque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Cheque.ContSATDinero.RFCReceptor]
Carpeta=Cheque
Clave=ContSATDinero.RFCReceptor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Transferencia.ContSATDinero.BeneficiarioNombre]
Carpeta=Transferencia
Clave=ContSATDinero.BeneficiarioNombre
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Transferencia.ContSATDinero.CtaBeneficiario]
Carpeta=Transferencia
Clave=ContSATDinero.CtaBeneficiario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Transferencia.ContSATDinero.Institucion]
Carpeta=Transferencia
Clave=ContSATDinero.Institucion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Transferencia.ContSATDinero.RFCReceptor]
Carpeta=Transferencia
Clave=ContSATDinero.RFCReceptor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Guardar y Cerrar
Multiple=S
Activo=S
Visible=S

ListaAccionesMultiples=Expresion<BR>Aceptar

EnBarraHerramientas=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  Info.Estatus <> EstatusSinAfectar<BR>Entonces<BR>  EjecutarSQL(<T>spActualizarContSatDinero :tEmpresa,:tModulo, :nID<T>,Empresa,<T>DIN<T>,Info.ID)<BR>Fin
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar/Cancelar Cambios
Activo=S
Visible=S
EspacioPrevio=S

[OtroMetodoPago.ContSATDinero.BeneficiarioNombre]
Carpeta=OtroMetodoPago
Clave=ContSATDinero.BeneficiarioNombre
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[OtroMetodoPago.ContSATDinero.RFCReceptor]
Carpeta=OtroMetodoPago
Clave=ContSATDinero.RFCReceptor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Lista.Columnas]
0=84
1=111
2=283
3=-2



[Cheque.Columnas]
BeneficiarioNombre=604
NumeroCheque=336
RFCReceptor=124

[Transferencia.Columnas]
BeneficiarioNombre=234
CtaBeneficiario=124
Institucion=124
RFCReceptor=124

[OtroMetodoPago.Columnas]
BeneficiarioNombre=241
RFCReceptor=124

[Detalle.Columnas]
Aplica=101
AplicaID=63
Referencia=105
BeneficiarioNombre=165
RFCReceptor=124
NumeroCheque=114
CtaBeneficiario=137
Institucion=150

[ChequeD]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Cheque
Clave=ChequeD
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATDineroDCheque
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ContSATDineroD.NumeroCheque<BR>ContSATDineroD.RFCReceptor
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General

GuardarAlSalir=S
FiltroGeneral={<T>ContSatDineroD.ID =<T>} {Info.ID}
CondicionVisible=(SQL(<T>SELECT ConDesglose FROM Dinero WHERE ID = :nID AND ConDesglose = 1<T>, Info.ID) )
[ChequeD.ContSATDineroD.NumeroCheque]
Carpeta=ChequeD
Clave=ContSATDineroD.NumeroCheque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ChequeD.ContSATDineroD.RFCReceptor]
Carpeta=ChequeD
Clave=ContSATDineroD.RFCReceptor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[ChequeD.Columnas]
NumeroCheque=145
RFCReceptor=124

Importe=64
[TransferenciaD]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Transferencia
Clave=TransferenciaD
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATDineroDTransferencia
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco

Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General



ListaEnCaptura=ContSATDineroD.RFCReceptor<BR>ContSATDineroD.CtaBeneficiario<BR>ContSATDineroD.Institucion
GuardarAlSalir=S
FiltroGeneral={<T>ContSatDineroD.ID =<T>} {Info.ID}
CondicionVisible=(SQL(<T>SELECT ConDesglose FROM Dinero WHERE ID = :nID AND ConDesglose = 1<T>, Info.ID) )
[TransferenciaD.Columnas]
RFCReceptor=124
CtaBeneficiario=124
Institucion=169

Importe=64
ID=64
[OtrosMetodosD]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Otro Método de Pago
Clave=OtrosMetodosD
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATDineroDOtroMetodo
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General


ListaEnCaptura=ContSATDineroD.RFCReceptor
FiltroGeneral={<T>ContSatDineroD.ID =<T>} {Info.ID}
CondicionVisible=(SQL(<T>SELECT ConDesglose FROM Dinero WHERE ID = :nID AND ConDesglose = 1<T>, Info.ID) )
[OtrosMetodosD.Columnas]
RFCReceptor=124

Importe=64






[TransferenciaD.ContSATDineroD.RFCReceptor]
Carpeta=TransferenciaD
Clave=ContSATDineroD.RFCReceptor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[TransferenciaD.ContSATDineroD.CtaBeneficiario]
Carpeta=TransferenciaD
Clave=ContSATDineroD.CtaBeneficiario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[TransferenciaD.ContSATDineroD.Institucion]
Carpeta=TransferenciaD
Clave=ContSATDineroD.Institucion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[OtrosMetodosD.ContSATDineroD.RFCReceptor]
Carpeta=OtrosMetodosD
Clave=ContSATDineroD.RFCReceptor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco



