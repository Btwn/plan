
[Forma]
Clave=DM0336VTASGestionarPedidosDeMagentoPrincipalFrm
Icono=94
Modulos=(Todos)
MovModulo=VTAS

ListaCarpetas=Factura<BR>Filtros
CarpetaPrincipal=Factura
PosicionInicialAlturaCliente=325
PosicionInicialAncho=1173
Nombre=Administrar Pedidos En Magento
PosicionCol1=950
PosicionInicialIzquierda=53
PosicionInicialArriba=330
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=cambiarEstatus<BR>Cancelar<BR>CapturarDatos<BR>Buscar<BR>LimpiarVariables
AccionesCentro=S
AccionesDivision=S
PosicionSec1=448
PosicionSec2=130
BarraHerramientas=S

ExpresionesAlMostrar=Asigna(Info.Numero,)<BR>Asigna(Mavi.DM0336NumeroPedidoEcommerce,)<BR>Asigna(Mavi.DM0336TrackingNumber,)<BR>Asigna(Mavi.DM0336MetodoEnvio,)
[DM0336COMSDatosFacturaMagentoVis.Columnas]
IDEcommerce=100
Mov=124
MovID=124
Direccion=209
DireccionNumero=81
DireccionNumeroInt=84
CodigoPostal=74
Delegacion=168
Colonia=170
Estado=162
Telefono=94
Articulo=124
Importe=70

NumeroDeFactura=131
NumeroPedido=99
[Acciones.Buscar]
Nombre=Buscar
Boton=0
NombreEnBoton=S
NombreDesplegar=Buscar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=BuscarFactura
ConCondicion=S

EjecucionCondicion=Forma.accion(<T>CapturarDatos<T>)<BR>Si(Vacio(Mavi.DM0336NumeroPedidoEcommerce),Informacion(<T>Debe llenar el campo <Numero De Pedido E-Commerce><T>) AbortarOperacion,verdadero)
[Acciones.Buscar.BuscarFactura]
Nombre=BuscarFactura
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S















Expresion=Forma.Accion(<T>LimpiarVariables<T>)<BR><BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM Venta V       <BR>       JOIN(<BR>        SELECT Mov,MovId FROM Venta WITH(NOLOCK)<BR>        WHERE Sucursal IN (41,90)<BR>        AND Mov = :tMov<BR>        AND Estatus = :tEstatus)Pedidos<BR>        ON Origen=Pedidos.Mov<BR>        AND OrigenId=Pedidos.MovID<BR>       WHERE ReferenciaOrdenCompra = :tNumeroPedido<BR>       AND V.Mov IN (:tTipoMovimiento , :tTipoMov)<BR>       AND V.Estatus = :t<T>,<T>PEDIDO<T>,<T>CONCLUIDO<T>,Mavi.DM0336NumeroPedidoEcommerce,<T>Factura<T>,<T>Factura VIU<T>,<T>CONCLUIDO<T>) > 0<BR>Entonces<BR>  Asigna(Info.Numero,1)<BR>  ActualizarVista(<T>DM0336VTASDatosFacturaMagentoVis<T>)<BR><BR>  Si<BR>    SQL(<T>SELECT COUNT(*) FROM TrWDM0285_CteRecoge WITH(NOLOCK) WHERE idEcommerce = :tNumeroPedido<T>,Mavi.DM0336NumeroPedidoEcommerce) > 0<BR>  Entonces<BR>    Asigna(Mavi.DM0336MetodoEnvio,<T>SUCURSAL<T>)<BR>  Fin<BR><BR>  //ActualizarForma<BR>Sino<BR>    Asigna(Info.Numero,0)<BR>    ActualizarForma<BR>    Informacion(<T>No se encontro ninguna factura con<T>+ NuevaLinea + <T>el numero de pedido: <T>+Mavi.DM0336NumeroPedidoEcommerce)<BR>  Fin<BR>Fin
[trackingNumber.DM0336.TrackingNumber]
Carpeta=trackingNumber
Clave=DM0336.TrackingNumber
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.cambiarEstatus]
Nombre=cambiarEstatus
Boton=71
NombreEnBoton=S
NombreDesplegar=Cambiar Estatus En Magento
EnBarraHerramientas=S
Activo=S
Visible=S

ConCondicion=S
TipoAccion=Expresion
Expresion=Si<BR>  (SQL(<T>SELECT COUNT(*)<BR>       FROM Venta<BR>       WHERE ReferenciaOrdenCompra = :tNumeroPedido<BR>       AND Mov IN (:tTipoMovimiento , :tTipoMovimiento2)<BR>       AND Estatus = :t<T>,Mavi.DM0336NumeroPedidoEcommerce,<T>Factura<T>,<T>Factura VIU<T>,<T>CONCLUIDO<T>) > 0)<BR>  y<BR>  ConDatos(Mavi.DM0336TrackingNumber)<BR>Entonces<BR>  //Cambiar de estatus de en <T>proceso<T> a <T>enviado<T> de los pedidos en Magento con Tracking Number<BR>  Ejecutar(<T>PlugIns\ActualizaEcommers.exe <T>+<T>VTASPEDIDO<T>+<T> <T>+Mavi.DM0336NumeroPedidoEcommerce+<T> <T>+<T>ENVIADO<T>+<T> <T>+Mavi.DM0336TrackingNumber+<T> <T>+(Minusculas(Mavi.DM0336MetodoEnvio)))<BR><BR>  //Insertar el tracking number en la tabla VTASHEstatusEstafeta<BR>  EjecutarSQL(<T>SPVTASGuardarEstatusGuias :tID, :tTN, :tEstatus, :fFecha<T>,<BR><BR>  SQL(<T>SELECT ID<BR>  FROM Venta WITH(NOLOCK)<BR>  WHERE Mov IN (:tMov1,:tMov2)<BR>  AND ReferenciaOrdenCompra = :tIDEcommerce<T>,<T>FACTURA<T>,<T>FACTURA VIU<T>,Mavi.DM0336NumeroPedidoEcommerce),<BR><BR>  Mavi.DM0336TrackingNumber,<BR><BR>  <T>ENVIADO A PAQUETERIA<T>,<BR><BR>  SQL(<T>SELECT e.FechaRegistro<BR>  FROM Venta V WITH(NOLOCK)<BR>  INNER JOIN EmbarqueMov m WITH (NOLOCK)<BR>      ON v.mov = m.mov<BR>      AND v.MovID = m.movid<BR>    INNER JOIN EmbarqueD d WITH (NOLOCK)<BR>      ON d.EmbarqueMov = m.ID<BR>    INNER JOIN Embarque e WITH (NOLOCK)<BR>      ON e.ID = d.ID<BR>  WHERE V.Mov IN (:tMov1, :tMov2)<BR>  AND ReferenciaOrdenCompra = :tIDEcommerce<T>,<BR>  <T>FACTURA<T>,<BR>  <T>FACTURA VIU<T>,<BR>  Mavi.DM0336NumeroPedidoEcommerce))<BR><BR>Sino<BR>  Si<BR>    (SQL(<T>SELECT COUNT(*)<BR>         FROM Venta<BR>         WHERE ReferenciaOrdenCompra = :tNumeroPedido<BR>         AND Mov IN (:tTipoMovimiento , :tTipoMovimiento2)<BR>         AND Estatus = :t<T>,Mavi.DM0336NumeroPedidoEcommerce,<T>Factura<T>,<T>Factura VIU<T>,<T>CONCLUIDO<T>) > 0)<BR>    y<BR>    Vacio(Mavi.DM0336TrackingNumber)<BR>  Entonces<BR>    //Cambiar de estatus de en <T>proceso<T> a <T>enviado<T> de los pedidos en Magento sin Tracking Number<BR>    Ejecutar(<T>PlugIns\ActualizaEcommers.exe <T>+<T>VTASPEDIDO<T>+<T> <T>+Mavi.DM0336NumeroPedidoEcommerce+<T> <T>+<T>ENVIADO<T>+<T> <T>+<T>STN<T>+<T> <T>+(Minusculas(Mavi.DM0336MetodoEnvio)))<BR>  Sino<BR>    Informacion(<T>No se ha podido encontrar el pedido: <T>+Mavi.DM0336NumeroPedidoEcommerce)<BR>  Fin<BR>Fin
EjecucionCondicion=Forma.Accion(<T>CapturarDatos<T>)<BR><BR>Si(Vacio(Mavi.DM0336NumeroPedidoEcommerce),<BR>   Informacion(<T>Debe llenar el campo <Numero De Pedido E-Commerce><T>) AbortarOperacion,<BR>   verdadero)<BR><BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM TrWDM0285_CteRecoge WITH(NOLOCK) WHERE idEcommerce = :tNumeroPedido<T>,Mavi.DM0336NumeroPedidoEcommerce) > 0<BR>Entonces<BR>  Asigna(Mavi.DM0336MetodoEnvio,<T>SUCURSAL<T>)<BR>  Verdadero<BR>Fin<BR><BR>Si<BR>  (SQL(<T>SELECT COUNT(*) FROM TrWDM0285_CteRecoge WITH(NOLOCK) WHERE idEcommerce = :tNumeroPedido<T>,Mavi.DM0336NumeroPedidoEcommerce) = 0)<BR>  y<BR>  (Mavi.DM0336MetodoEnvio = <T>SUCURSAL<T>)<BR>  y<BR>  (ConDatos(Mavi.DM0336MetodoEnvio))<BR>Entonces                                                           <BR>  Informacion(<T>El valor del campo <Transportista> es incorrecto<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>Si<BR>  Vacio(Mavi.DM0336MetodoEnvio)<BR>Entonces<BR>  Informacion(<T>Debe llenar el campo <Transportista><T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>Si<BR>  (minusculas(Mavi.DM0336MetodoEnvio) = <T>estafeta<T>) y Vacio(Mavi.DM0336TrackingNumber)<BR>Entonces<BR>  Informacion(<T>Debe llenar el campo <Tracking Number><T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.CapturarDatos]
Nombre=CapturarDatos
Boton=0
NombreDesplegar=Capturar Pedido
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Cancelar]
Nombre=Cancelar
Boton=21
NombreEnBoton=S
NombreDesplegar=Cancelar Pedido
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0336VTASSeleccionarPedidoVisFrm
Activo=S
Visible=S
EspacioPrevio=S

ConCondicion=S


EjecucionCondicion=Forma.accion(<T>CapturarDatos<T>)<BR>Si(Vacio(Mavi.DM0336NumeroPedidoEcommerce),Informacion(<T>Debe llenar el campo <Numero De Pedido E-Commerce><T>) AbortarOperacion,verdadero)<BR><BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM Venta<BR>       WHERE Sucursal IN (41,90)<BR>       AND Estatus = :tEstatus<BR>       AND Mov = :tMov<BR>       AND ReferenciaOrdenCompra = :tIDEcommerce<T>,<T>PENDIENTE<T>,<T>Pedido<T>,Mavi.DM0336NumeroPedidoEcommerce)>0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El numero de pedido a cancelar no existe<T>)<BR>  AbortarOperacion<BR>Fin                                                                                               
[Factura]
Estilo=Hoja
Clave=Factura
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0336VTASDatosFacturaMagentoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=NumeroPedido<BR>NumeroDeFactura<BR>Direccion<BR>DireccionNumero<BR>DireccionNumeroInt<BR>CodigoPostal<BR>Delegacion<BR>Colonia<BR>Estado<BR>Telefono<BR>Articulo<BR>Importe

PestanaNombre=Factura
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CondicionVisible=Si<BR>  Info.Numero = 1<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin
[Factura.NumeroDeFactura]
Carpeta=Factura
Clave=NumeroDeFactura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco

[Factura.NumeroPedido]
Carpeta=Factura
Clave=NumeroPedido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Factura.Direccion]
Carpeta=Factura
Clave=Direccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Factura.DireccionNumero]
Carpeta=Factura
Clave=DireccionNumero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Factura.DireccionNumeroInt]
Carpeta=Factura
Clave=DireccionNumeroInt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Factura.CodigoPostal]
Carpeta=Factura
Clave=CodigoPostal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Factura.Delegacion]
Carpeta=Factura
Clave=Delegacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Factura.Colonia]
Carpeta=Factura
Clave=Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Factura.Estado]
Carpeta=Factura
Clave=Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Factura.Telefono]
Carpeta=Factura
Clave=Telefono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Factura.Articulo]
Carpeta=Factura
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Factura.Importe]
Carpeta=Factura
Clave=Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Factura.Columnas]
NumeroDeFactura=134
NumeroPedido=127
Direccion=228
DireccionNumero=61
DireccionNumeroInt=87
CodigoPostal=76
Delegacion=238
Colonia=190
Estado=184
Telefono=102
Articulo=102
Importe=69


[Pedido.NumeroPedido]
Carpeta=Pedido
Clave=NumeroPedido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Pedido.NumeroDeFactura]
Carpeta=Pedido
Clave=NumeroDeFactura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco

[Pedido.Direccion]
Carpeta=Pedido
Clave=Direccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Pedido.DireccionNumero]
Carpeta=Pedido
Clave=DireccionNumero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Pedido.DireccionNumeroInt]
Carpeta=Pedido
Clave=DireccionNumeroInt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Pedido.CodigoPostal]
Carpeta=Pedido
Clave=CodigoPostal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Pedido.Delegacion]
Carpeta=Pedido
Clave=Delegacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Pedido.Colonia]
Carpeta=Pedido
Clave=Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Pedido.Estado]
Carpeta=Pedido
Clave=Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Pedido.Telefono]
Carpeta=Pedido
Clave=Telefono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Pedido.Articulo]
Carpeta=Pedido
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Pedido.Importe]
Carpeta=Pedido
Clave=Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Pedido.Columnas]
NumeroPedido=124
NumeroDeFactura=128
Direccion=283
DireccionNumero=79
DireccionNumeroInt=91
CodigoPostal=81
Delegacion=245
Colonia=243
Estado=205
Telefono=94
Articulo=124
Importe=69

[Filtros]
Estilo=Ficha
Clave=Filtros
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0336NumeroPedidoEcommerce<BR>Mavi.DM0336TrackingNumber<BR>Mavi.DM0336MetodoEnvio
CarpetaVisible=S

[Filtros.Mavi.DM0336NumeroPedidoEcommerce]
Carpeta=Filtros
Clave=Mavi.DM0336NumeroPedidoEcommerce
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.DM0336TrackingNumber]
Carpeta=Filtros
Clave=Mavi.DM0336TrackingNumber
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.DM0336MetodoEnvio]
Carpeta=Filtros
Clave=Mavi.DM0336MetodoEnvio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco


[FIltro.Columnas]
Nombre=604

[Filtros.Columnas]
Nombre=378



[Acciones.LimpiarVariables]
Nombre=LimpiarVariables
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0336MetodoEnvio,)<BR>Asigna(Mavi.DM0336TrackingNumber,)

