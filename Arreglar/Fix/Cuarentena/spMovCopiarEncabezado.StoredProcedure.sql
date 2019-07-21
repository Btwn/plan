SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMovCopiarEncabezado]
 @Sucursal INT
,@Modulo CHAR(5)
,@ID INT
,@Empresa CHAR(5)
,@Mov CHAR(20)
,@MovID VARCHAR(20)
,@Usuario CHAR(10)
,@FechaEmision DATETIME
,@Estatus CHAR(15)
,@Moneda CHAR(10)
,@TipoCambio FLOAT
,@Almacen CHAR(10)
,@AlmacenDestino CHAR(10)
,@GenerarDirecto BIT
,@GenerarMov CHAR(20)
,@GenerarMovID VARCHAR(20)
,@GenerarID INT OUTPUT
,@Ok INT OUTPUT
,@CopiarBitacora BIT = 0
,@CopiarSucursalDestino BIT = 0
AS
BEGIN
	DECLARE
		@Contacto CHAR(10)
	   ,@Condicion VARCHAR(50)
	   ,@Vencimiento DATETIME
	   ,@OrigenTipo CHAR(10)
	   ,@Origen CHAR(20)
	   ,@OrigenID VARCHAR(20)
	   ,@UsarSucursalMovOrigen BIT
	   ,@AC BIT
	   ,@CfgTipoCambio VARCHAR(20)
	EXEC spExtraerFecha @FechaEmision OUTPUT
	SELECT @CfgTipoCambio = TipoCambio
	FROM EmpresaCfgModulo
	WHERE Empresa = @Empresa
	AND Modulo = @Modulo

	IF @CfgTipoCambio = 'Venta'
		SELECT @TipoCambio = TipoCambioVenta
		FROM Mon
		WHERE Moneda = @Moneda
	ELSE

	IF @CfgTipoCambio = 'Compra'
		SELECT @TipoCambio = TipoCambioCompra
		FROM Mon
		WHERE Moneda = @Moneda

	SELECT @UsarSucursalMovOrigen = UsarSucursalMovOrigen
		  ,@AC = AC
	FROM EmpresaGral
	WHERE Empresa = @Empresa

	IF @UsarSucursalMovOrigen = 0
		SELECT @Sucursal = Sucursal
		FROM UsuarioSucursal
		WHERE Usuario = @Usuario

	IF @Mov IS NOT NULL
		AND @MovID IS NOT NULL
		SELECT @OrigenTipo = @Modulo
			  ,@Origen = @Mov
			  ,@OrigenID = @MovID

	IF @Modulo = 'CONT'
		INSERT Cont (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, FechaContable, Concepto, Proyecto, UEN, Intercompania, Moneda, TipoCambio, Referencia, Observaciones, AfectarPresupuesto)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Intercompania
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,AfectarPresupuesto
			FROM Cont
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'VTAS'
		INSERT Venta (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Directo, Almacen, AlmacenDestino, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Prioridad, Codigo, Cliente, EnviarA, Agente, AgenteServicio, FormaEnvio, FechaRequerida, HoraRequerida, FechaOriginal, FechaOrdenCompra, ReferenciaOrdenCompra, OrdenCompra, Condicion, Vencimiento, CtaDinero, Descuento, DescuentoGlobal, ServicioTipo, ServicioArticulo, ServicioSerie, ServicioContrato, ServicioContratoID, ServicioContratoTipo, ServicioGarantia, ServicioDescripcion, ServicioFlotilla, ServicioRampa, ServicioIdentificador, ServicioFecha, ServicioPlacas, ServicioKms, ServicioSiniestro, Atencion, Departamento, ZonaImpuesto, ListaPreciosEsp, GenerarOP, DesglosarImpuestos, DesglosarImpuesto2, ExcluirPlaneacion, ConVigencia, VigenciaDesde, VigenciaHasta, Bonificacion, Causa, Periodicidad, SubModulo, ContUso, Espacio, AutoCorrida, AutoCorridaHora, AutoCorridaServicio, AutoCorridaRol, AutoCorridaOrigen, AutoCorridaDestino, AutoCorridaKms, AutoCorridaLts, AutoCorridaRuta, AutoBoleto, AutoKms, AutoKmsActuales, AutoBomba, AutoBombaContador, GastoAcreedor, GastoConcepto, Comentarios, ServicioTipoOrden, ServicioTipoOperacion, ServicioExpress, ServicioDemerito, ServicioDeducible, ServicioDeducibleImporte, ServicioNumero, ServicioNumeroEconomico, ServicioAseguradora, SucursalVenta, RenglonID, AF, AFArticulo, AFSerie, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoValorMoneda, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Clase, SubClase, EndosarA, LineaCredito, TipoAmortizacion, TipoTasa, TieneTasaEsp, TasaEsp, Comisiones, ComisionesIVA, AgenteComision, ServicioPoliza, FormaPagoTipo, SobrePrecio, AfectaComisionMAVI, FormaCobro, NoCtaPago, CteFinal, IdEcommerce, PagoDIE, ReporteDescuento)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,@GenerarDirecto
				  ,@Almacen
				  ,@AlmacenDestino
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Prioridad
				  ,Codigo
				  ,Cliente
				  ,EnviarA
				  ,Agente
				  ,AgenteServicio
				  ,FormaEnvio
				  ,FechaRequerida
				  ,HoraRequerida
				  ,FechaOriginal
				  ,FechaOrdenCompra
				  ,ReferenciaOrdenCompra
				  ,OrdenCompra
				  ,Condicion
				  ,Vencimiento
				  ,CtaDinero
				  ,Descuento
				  ,DescuentoGlobal
				  ,ServicioTipo
				  ,ServicioArticulo
				  ,ServicioSerie
				  ,ServicioContrato
				  ,ServicioContratoID
				  ,ServicioContratoTipo
				  ,ServicioGarantia
				  ,ServicioDescripcion
				  ,ServicioFlotilla
				  ,ServicioRampa
				  ,ServicioIdentificador
				  ,ServicioFecha
				  ,ServicioPlacas
				  ,ServicioKms
				  ,ServicioSiniestro
				  ,Atencion
				  ,Departamento
				  ,ZonaImpuesto
				  ,ListaPreciosEsp
				  ,GenerarOP
				  ,DesglosarImpuestos
				  ,DesglosarImpuesto2
				  ,ExcluirPlaneacion
				  ,ConVigencia
				  ,VigenciaDesde
				  ,VigenciaHasta
				  ,Bonificacion
				  ,Causa
				  ,Periodicidad
				  ,SubModulo
				  ,ContUso
				  ,Espacio
				  ,AutoCorrida
				  ,AutoCorridaHora
				  ,AutoCorridaServicio
				  ,AutoCorridaRol
				  ,AutoCorridaOrigen
				  ,AutoCorridaDestino
				  ,AutoCorridaKms
				  ,AutoCorridaLts
				  ,AutoCorridaRuta
				  ,AutoBoleto
				  ,AutoKms
				  ,AutoKmsActuales
				  ,AutoBomba
				  ,AutoBombaContador
				  ,GastoAcreedor
				  ,GastoConcepto
				  ,Comentarios
				  ,ServicioTipoOrden
				  ,ServicioTipoOperacion
				  ,ServicioExpress
				  ,ServicioDemerito
				  ,ServicioDeducible
				  ,ServicioDeducibleImporte
				  ,ServicioNumero
				  ,ServicioNumeroEconomico
				  ,ServicioAseguradora
				  ,SucursalVenta
				  ,RenglonID
				  ,AF
				  ,AFArticulo
				  ,AFSerie
				  ,ContratoTipo
				  ,ContratoDescripcion
				  ,ContratoSerie
				  ,ContratoValor
				  ,ContratoValorMoneda
				  ,ContratoSeguro
				  ,ContratoVencimiento
				  ,ContratoResponsable
				  ,Clase
				  ,SubClase
				  ,EndosarA
				  ,LineaCredito
				  ,TipoAmortizacion
				  ,TipoTasa
				  ,TieneTasaEsp
				  ,TasaEsp
				  ,Comisiones
				  ,ComisionesIVA
				  ,AgenteComision
				  ,ServicioPoliza
				  ,FormaPagoTipo
				  ,SobrePrecio
				  ,AfectaComisionMAVI
				  ,FormaCobro
				  ,NoCtaPago
				  ,CteFinal
				  ,IdEcommerce
					,PagoDIE
					,ReporteDescuento
			FROM Venta
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'PROD'
		INSERT Prod (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Directo, Almacen, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Prioridad, AutoReservar, VerDestino, FechaInicio, FechaEntrega, RenglonID)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,@GenerarDirecto
				  ,@Almacen
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Prioridad
				  ,AutoReservar
				  ,VerDestino
				  ,FechaInicio
				  ,FechaEntrega
				  ,RenglonID
			FROM Prod
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'COMS'
		INSERT Compra (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Directo, Almacen, Concepto, Proyecto, Actividad, UEN, Moneda, TipoCambio, Referencia, Observaciones, Prioridad, Proveedor, FormaEnvio, FechaEntrega, FechaRequerida, Condicion, Vencimiento, Instruccion, Agente, Descuento, DescuentoGlobal, Atencion, ZonaImpuesto, Idioma, ListaPreciosEsp, RenglonID, FormaEntrega, CancelarPendiente, LineaCredito, TipoAmortizacion, TipoTasa, TieneTasaEsp, TasaEsp, Comisiones, ComisionesIVA, AutoCargos, Cliente)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,@GenerarDirecto
				  ,@Almacen
				  ,Concepto
				  ,Proyecto
				  ,Actividad
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Prioridad
				  ,Proveedor
				  ,FormaEnvio
				  ,FechaEntrega
				  ,FechaRequerida
				  ,Condicion
				  ,Vencimiento
				  ,Instruccion
				  ,Agente
				  ,Descuento
				  ,DescuentoGlobal
				  ,Atencion
				  ,ZonaImpuesto
				  ,Idioma
				  ,ListaPreciosEsp
				  ,RenglonID
				  ,FormaEntrega
				  ,CancelarPendiente
				  ,LineaCredito
				  ,TipoAmortizacion
				  ,TipoTasa
				  ,TieneTasaEsp
				  ,TasaEsp
				  ,Comisiones
				  ,ComisionesIVA
				  ,AutoCargos
				  ,Cliente
			FROM Compra
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'INV'
		INSERT Inv (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Directo, Almacen, AlmacenDestino, Concepto, Proyecto, Actividad, UEN, Moneda, TipoCambio, Referencia, Observaciones, AlmacenTransito, Largo, Condicion, Vencimiento, FormaEnvio, VerLote, VerDestino, RenglonID, Agente, Personal, ContUsoMAVI, IDOrdTrasMavi)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,@GenerarDirecto
				  ,@Almacen
				  ,@AlmacenDestino
				  ,Concepto
				  ,Proyecto
				  ,Actividad
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,AlmacenTransito
				  ,Largo
				  ,Condicion
				  ,Vencimiento
				  ,FormaEnvio
				  ,VerLote
				  ,VerDestino
				  ,RenglonID
				  ,Agente
				  ,Personal
				  ,ContUsoMAVI
				  ,IDOrdTrasMavi
			FROM Inv
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'DIN'
		INSERT Dinero (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Directo, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, BeneficiarioNombre, LeyendaCheque, Beneficiario, CtaDinero, CtaDineroDestino, ConDesglose, Importe, Comisiones, Impuestos, FormaPago, FechaProgramada, Cajero, Contacto, ContactoTipo, TipoCambioDestino, ProveedorAutoEndoso, CargoBancario, CargoBancarioIVA, Prioridad, Comentarios, Nota, FechaOrigen, Vencimiento, Tasa, TasaDias, TasaRetencion, Retencion, ContUso, Cliente, ClienteEnviarA, Proveedor, InteresTipo, Titulo, TituloValor, ValorOrigen)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN d.SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,@GenerarDirecto
				  ,d.Concepto
				  ,d.Proyecto
				  ,d.UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, d.TipoCambio)
				  ,d.Referencia
				  ,d.Observaciones
				  ,d.BeneficiarioNombre
				  ,d.LeyendaCheque
				  ,d.Beneficiario
				  ,d.CtaDinero
				  ,d.CtaDineroDestino
				  ,d.ConDesglose
				  ,d.Importe
				  ,d.Comisiones
				  ,d.Impuestos
				  ,d.FormaPago
				  ,d.FechaProgramada
				  ,d.Cajero
				  ,d.Contacto
				  ,d.ContactoTipo
				  ,d.TipoCambioDestino
				  ,d.ProveedorAutoEndoso
				  ,d.CargoBancario
				  ,d.CargoBancarioIVA
				  ,d.Prioridad
				  ,d.Comentarios
				  ,d.Nota
				  ,d.FechaOrigen
				  ,d.Vencimiento
				  ,d.Tasa
				  ,d.TasaDias
				  ,d.TasaRetencion
				  ,d.Retencion
				  ,d.ContUso
				  ,d.Cliente
				  ,d.ClienteEnviarA
				  ,d.Proveedor
				  ,d.InteresTipo
				  ,d.Titulo
				  ,t.Valor
				  ,d.ValorOrigen
			FROM Dinero d
			LEFT OUTER JOIN Titulo t
				ON t.Titulo = d.Titulo
			WHERE d.ID = @ID
	ELSE

	IF @Modulo = 'CXC'
		INSERT Cxc (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Codigo, Cliente, ClienteEnviarA, ClienteMoneda, ClienteTipoCambio, CtaDinero, Cobrador, PersonalCobrador, FormaCobro, Importe, Impuestos, AplicaManual, Agente, MovAplica, MovAplicaID, ConDesglose, FormaCobro1, FormaCobro2, FormaCobro3, FormaCobro4, FormaCobro5, Importe1, Importe2, Importe3, Importe4, Importe5, Referencia1, Referencia2, Referencia3, Referencia4, Referencia5, Cambio, DelEfectivo, Cajero, FechaOriginal, Comentarios, Nota, VIN, ContUso)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,CASE
					   WHEN OrigenTipo = 'CAM' THEN Cxc.TipoCambio
					   ELSE ISNULL(@TipoCambio, Cxc.TipoCambio)
				   END
				  ,Referencia
				  ,Observaciones
				  ,Codigo
				  ,Cliente
				  ,ClienteEnviarA
				  ,ClienteMoneda
				  ,CASE
					   WHEN OrigenTipo = 'CAM' THEN ClienteTipoCambio
					   ELSE CASE @CfgTipoCambio
							   WHEN 'Venta' THEN ms.TipoCambioVenta
							   WHEN 'Compra' THEN ms.TipoCambioCompra
							   ELSE ms.TipoCambio
						   END
				   END
				  ,CtaDinero
				  ,Cobrador
				  ,PersonalCobrador
				  ,FormaCobro
				  ,Importe
				  ,Impuestos
				  ,AplicaManual
				  ,Agente
				  ,MovAplica
				  ,MovAplicaID
				  ,ConDesglose
				  ,FormaCobro1
				  ,FormaCobro2
				  ,FormaCobro3
				  ,FormaCobro4
				  ,FormaCobro5
				  ,Importe1
				  ,Importe2
				  ,Importe3
				  ,Importe4
				  ,Importe5
				  ,Referencia1
				  ,Referencia2
				  ,Referencia3
				  ,Referencia4
				  ,Referencia5
				  ,Cambio
				  ,DelEfectivo
				  ,Cajero
				  ,FechaOriginal
				  ,Comentarios
				  ,Nota
				  ,VIN
				  ,ContUso
			FROM Cxc
				,Mon ms
			WHERE ms.Moneda = ClienteMoneda
			AND ID = @ID
	ELSE

	IF @Modulo = 'CXP'
		INSERT Cxp (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Proveedor, ProveedorSucursal, ProveedorMoneda, ProveedorTipoCambio, CtaDinero, FormaPago, Importe, Impuestos, AplicaManual, Beneficiario, MovAplica, MovAplicaID, Cajero, ProveedorAutoEndoso, Comentarios, Nota, VIN, ContUso)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,CASE
					   WHEN OrigenTipo = 'CAM' THEN Cxp.TipoCambio
					   ELSE ISNULL(@TipoCambio, Cxp.TipoCambio)
				   END
				  ,Referencia
				  ,Observaciones
				  ,Proveedor
				  ,ProveedorSucursal
				  ,ProveedorMoneda
				  ,CASE
					   WHEN OrigenTipo = 'CAM' THEN ProveedorTipoCambio
					   ELSE CASE @CfgTipoCambio
							   WHEN 'Venta' THEN ms.TipoCambioVenta
							   WHEN 'Compra' THEN ms.TipoCambioCompra
							   ELSE ms.TipoCambio
						   END
				   END
				  ,CtaDinero
				  ,FormaPago
				  ,Importe
				  ,Impuestos
				  ,AplicaManual
				  ,Beneficiario
				  ,MovAplica
				  ,MovAplicaID
				  ,Cajero
				  ,ProveedorAutoEndoso
				  ,Comentarios
				  ,Nota
				  ,VIN
				  ,ContUso
			FROM Cxp
				,Mon ms
			WHERE ms.Moneda = ProveedorMoneda
			AND ID = @ID
	ELSE

	IF @Modulo = 'AGENT'
		INSERT Agent (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Agente, CtaDinero, FormaPago, Importe)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Agente
				  ,CtaDinero
				  ,FormaPago
				  ,Importe
			FROM Agent
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'GAS'
		INSERT Gasto (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Observaciones, Acreedor, Clase, SubClase, CtaDinero, FormaPago, Condicion, Importe, Impuestos, MovAplica, MovAplicaID, Periodicidad, TieneRetencion, CXP, FechaRequerida, Actividad, AF, AFArticulo, AFSerie, ConVigencia, VigenciaDesde, VigenciaHasta, ContratoTipo, ContratoDescripcion, ContratoSerie, ContratoValor, ContratoValorMoneda, ContratoSeguro, ContratoVencimiento, ContratoResponsable, Prioridad, AnexoModulo, AnexoID, Comentarios, Nota, ClienteRef, ArticuloRef)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Observaciones
				  ,Acreedor
				  ,Clase
				  ,SubClase
				  ,CtaDinero
				  ,FormaPago
				  ,Condicion
				  ,Importe
				  ,Impuestos
				  ,MovAplica
				  ,MovAplicaID
				  ,Periodicidad
				  ,TieneRetencion
				  ,CXP
				  ,FechaRequerida
				  ,Actividad
				  ,AF
				  ,AFArticulo
				  ,AFSerie
				  ,ConVigencia
				  ,VigenciaDesde
				  ,VigenciaHasta
				  ,ContratoTipo
				  ,ContratoDescripcion
				  ,ContratoSerie
				  ,ContratoValor
				  ,ContratoValorMoneda
				  ,ContratoSeguro
				  ,ContratoVencimiento
				  ,ContratoResponsable
				  ,Prioridad
				  ,AnexoModulo
				  ,AnexoID
				  ,Comentarios
				  ,Nota
				  ,ClienteRef
				  ,ArticuloRef
			FROM Gasto
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'EMB'
		INSERT Embarque (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Referencia, Observaciones, Vehiculo, Ruta, Agente, FechaSalida, FechaRetorno, CtaDinero, Proveedor, Importe, Impuestos, Condicion, Vencimiento, PersonalCobrador)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,Vehiculo
				  ,Ruta
				  ,Agente
				  ,FechaSalida
				  ,FechaRetorno
				  ,CtaDinero
				  ,Proveedor
				  ,Importe
				  ,Impuestos
				  ,Condicion
				  ,Vencimiento
				  ,PersonalCobrador
			FROM Embarque
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'NOM'
		INSERT Nomina (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Observaciones, Condicion, PeriodoTipo, FechaD, FechaA, FechaOrigen)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Observaciones
				  ,Condicion
				  ,PeriodoTipo
				  ,FechaD
				  ,FechaA
				  ,FechaOrigen
			FROM Nomina
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'RH'
		INSERT RH (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Evaluacion)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Evaluacion
			FROM RH
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'ASIS'
		INSERT Asiste (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Localidad, FechaD, FechaA)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Localidad
				  ,FechaD
				  ,FechaA
			FROM Asiste
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'AF'
		INSERT ActivoFijo (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Proveedor, Condicion, Vencimiento, Importe, Impuestos, FormaPago, CtaDinero, Todo, Revaluar, ValorMercado, Personal, Espacio, ContUso)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Proveedor
				  ,Condicion
				  ,Vencimiento
				  ,Importe
				  ,Impuestos
				  ,FormaPago
				  ,CtaDinero
				  ,Todo
				  ,Revaluar
				  ,ValorMercado
				  ,Personal
				  ,Espacio
				  ,ContUso
			FROM ActivoFijo
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'PC'
		INSERT PC (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, ListaModificar, Recalcular, Parcial, Proveedor, Metodo, Monto)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,ListaModificar
				  ,Recalcular
				  ,Parcial
				  ,Proveedor
				  ,Metodo
				  ,Monto
			FROM PC
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'OFER'
		INSERT Oferta (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, FechaD, FechaA, HoraD, HoraA, DiasEsp, Tipo, Forma, Usar, TieneVolumen, MontoMinimo, TodasSucursales, Categoria, Grupo, Familia, Linea, Fabricante, Porcentaje)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,FechaD
				  ,FechaA
				  ,HoraD
				  ,HoraA
				  ,DiasEsp
				  ,Tipo
				  ,Forma
				  ,Usar
				  ,TieneVolumen
				  ,MontoMinimo
				  ,TodasSucursales
				  ,Categoria
				  ,Grupo
				  ,Familia
				  ,Linea
				  ,Fabricante
				  ,Porcentaje
			FROM Oferta
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'VALE'
		INSERT Vale (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Cliente, Agente, Condicion, Vencimiento, Tipo, Precio, Cantidad, Importe, FechaInicio, Descuento, DescuentoGlobal, CtaDinero)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Cliente
				  ,Agente
				  ,Condicion
				  ,Vencimiento
				  ,Tipo
				  ,Precio
				  ,Cantidad
				  ,Importe
				  ,GETDATE()
				  ,Descuento
				  ,DescuentoGlobal
				  ,CtaDinero
			FROM Vale
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'CR'
		INSERT CR (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Caja, Cajero, FechaD, FechaA)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Caja
				  ,Cajero
				  ,FechaD
				  ,FechaA
			FROM CR
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'ST'
		INSERT Soporte (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Referencia, Observaciones, Cliente, EnviarA, Agente, Contacto, Telefono, Extencion, Fax, eMail, UsuarioResponsable, TieneContrato, Prioridad, Clase, Subclase, Titulo, Problema, Solucion, Comentarios, Proveedor, Personal, Vencimiento, ReferenciaInicial, CondicionPago, Importe, Estado, CondicionEntrega, FechaInicio, FechaTermino, Version, Tiempo, TiempoUnidad, SubModulo, Espacio, VIN, ServicioTipo, FechaRequerida, Direccion, DireccionNumero, EntreCalles, Plano, Delegacion, Colonia, Poblacion, PaisEstado, Pais, Zona, CodigoPostal, Reporte, Articulo, Causa, Clase1, Clase2, Clase3, Clase4, Clase5)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,Cliente
				  ,EnviarA
				  ,Agente
				  ,Contacto
				  ,Telefono
				  ,Extencion
				  ,Fax
				  ,eMail
				  ,UsuarioResponsable
				  ,TieneContrato
				  ,Prioridad
				  ,Clase
				  ,Subclase
				  ,Titulo
				  ,Problema
				  ,Solucion
				  ,Comentarios
				  ,Proveedor
				  ,Personal
				  ,@FechaEmision
				  ,ReferenciaInicial
				  ,CondicionPago
				  ,Importe
				  ,'No comenzado'
				  ,CondicionEntrega
				  ,FechaInicio
				  ,FechaTermino
				  ,Version
				  ,Tiempo
				  ,TiempoUnidad
				  ,SubModulo
				  ,Espacio
				  ,VIN
				  ,ServicioTipo
				  ,FechaRequerida
				  ,Direccion
				  ,DireccionNumero
				  ,EntreCalles
				  ,Plano
				  ,Delegacion
				  ,Colonia
				  ,Poblacion
				  ,PaisEstado
				  ,Pais
				  ,Zona
				  ,CodigoPostal
				  ,Reporte
				  ,Articulo
				  ,Causa
				  ,Clase1
				  ,Clase2
				  ,Clase3
				  ,Clase4
				  ,Clase5
			FROM Soporte
			WHERE ID = @ID
	ELSE

	IF @Modulo = 'CAP'
		INSERT Capital (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Agente)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Agente
			FROM Capital
			WHERE ID = @ID

	IF @Modulo = 'INC'
		INSERT Incidencia (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, FechaAplicacion, Personal, NominaConcepto, FechaD, FechaA, Cantidad, Valor, Porcentaje, Acreedor, Vencimiento, Repetir, Prorratear, Frecuencia, Veces)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,FechaAplicacion
				  ,Personal
				  ,NominaConcepto
				  ,FechaD
				  ,FechaA
				  ,Cantidad
				  ,Valor
				  ,Porcentaje
				  ,Acreedor
				  ,Vencimiento
				  ,Repetir
				  ,Prorratear
				  ,Frecuencia
				  ,Veces
			FROM Incidencia
			WHERE ID = @ID

	IF @Modulo = 'CONC'
		INSERT Conciliacion (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, CtaDinero, FechaD, FechaA)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,CtaDinero
				  ,FechaD
				  ,FechaA
			FROM Conciliacion
			WHERE ID = @ID

	IF @Modulo = 'PPTO'
		INSERT Presup (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
			FROM Presup
			WHERE ID = @ID

	IF @Modulo = 'CREDI'
		INSERT Credito (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Vencimiento, TipoAmortizacion, TipoTasa, Comisiones, ComisionesIVA, Deudor, Acreedor, Importe, CtaDinero, FormaPago, LineaCreditoEsp, LineaCredito, LineaCreditoFondeo, TieneTasaEsp, TasaEsp)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Vencimiento
				  ,TipoAmortizacion
				  ,TipoTasa
				  ,Comisiones
				  ,ComisionesIVA
				  ,Deudor
				  ,Acreedor
				  ,Importe
				  ,CtaDinero
				  ,FormaPago
				  ,LineaCreditoEsp
				  ,LineaCredito
				  ,LineaCreditoFondeo
				  ,TieneTasaEsp
				  ,TasaEsp
			FROM Credito
			WHERE ID = @ID

	IF @Modulo = 'WMS'
		INSERT WMS (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Referencia, Observaciones, Almacen, Agente, Contenedor)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,Almacen
				  ,Agente
				  ,Contenedor
			FROM WMS
			WHERE ID = @ID

	IF @Modulo = 'RSS'
		INSERT RSS (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Referencia, Observaciones, Canal, Titulo, Hipervinculo, Descripcion, Comentarios, Autor, Categoria, ArtOrigen, Adjunto, AdjuntoURL, AdjuntoTamano, AdjuntoTipo, FechaPublicacion)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,Canal
				  ,Titulo
				  ,Hipervinculo
				  ,Descripcion
				  ,Comentarios
				  ,Autor
				  ,Categoria
				  ,ArtOrigen
				  ,Adjunto
				  ,AdjuntoURL
				  ,AdjuntoTamano
				  ,AdjuntoTipo
				  ,GETDATE()
			FROM RSS
			WHERE ID = @ID

	IF @Modulo = 'CMP'
		INSERT Campana (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Referencia, Observaciones, Asunto, Agente, CampanaTipo, TieneVigencia, FechaD, FechaA)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,Asunto
				  ,Agente
				  ,CampanaTipo
				  ,TieneVigencia
				  ,FechaD
				  ,FechaA
			FROM Campana
			WHERE ID = @ID

	IF @Modulo = 'FIS'
		INSERT Fiscal (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Moneda, TipoCambio, Referencia, Observaciones, Acreedor, Condicion, Vencimiento)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,Referencia
				  ,Observaciones
				  ,Acreedor
				  ,Condicion
				  ,Vencimiento
			FROM Fiscal
			WHERE ID = @ID

	IF @Modulo = 'FRM'
		INSERT FormaExtra (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Referencia, Observaciones, FormaTipo, Aplica, AplicaClave)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,FormaTipo
				  ,Aplica
				  ,AplicaClave
			FROM FormaExtra
			WHERE ID = @ID

	IF @Modulo = 'PROY'
		INSERT Proyecto (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, UEN, Referencia, Observaciones, Moneda, TipoCambio, ContactoTipo, Prospecto, Cliente, Proveedor, Personal, Agente, Riesgo, ProyectoRama, Supervisor, Comienzo, Fin, DiasHabiles, HorasDia, MontoEstimado, ProyectoReestructurar, Reestructurar, Comentarios)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,@Moneda
				  ,ISNULL(@TipoCambio, TipoCambio)
				  ,ContactoTipo
				  ,Prospecto
				  ,Cliente
				  ,Proveedor
				  ,Personal
				  ,Agente
				  ,Riesgo
				  ,ProyectoRama
				  ,Supervisor
				  ,Comienzo
				  ,Fin
				  ,DiasHabiles
				  ,HorasDia
				  ,MontoEstimado
				  ,ProyectoReestructurar
				  ,0
				  ,Comentarios
			FROM Proyecto
			WHERE ID = @ID

	IF @Modulo = 'CAM'
		INSERT Cambio (UltimoCambio, Sucursal, SucursalOrigen, SucursalDestino, OrigenTipo, Origen, OrigenID, Empresa, Usuario, Estatus, Mov, MovID, FechaEmision, Concepto, Proyecto, UEN, Referencia, Observaciones, Cliente, Agente, Condicion, Vencimiento)
			SELECT GETDATE()
				  ,@Sucursal
				  ,@Sucursal
				  ,CASE
					   WHEN @CopiarSucursalDestino = 1 THEN SucursalDestino
					   ELSE @Sucursal
				   END
				  ,@OrigenTipo
				  ,@Origen
				  ,@OrigenID
				  ,@Empresa
				  ,@Usuario
				  ,@Estatus
				  ,@GenerarMov
				  ,@GenerarMovID
				  ,@FechaEmision
				  ,Concepto
				  ,Proyecto
				  ,UEN
				  ,Referencia
				  ,Observaciones
				  ,Cliente
				  ,Agente
				  ,Condicion
				  ,Vencimiento
			FROM Cambio
			WHERE ID = @ID

	SELECT @GenerarID = @@IDENTITY

	IF @AC = 1
		EXEC spCopiarTablaAmortizacionGuia @Modulo
										  ,@ID
										  ,@Modulo
										  ,@GenerarID

	EXEC spMovCopiarFormaAnexo @Modulo
							  ,@ID
							  ,@Modulo
							  ,@GenerarID
	EXEC spMovCopiarAnexos @Sucursal
						  ,@Modulo
						  ,@ID
						  ,@Modulo
						  ,@GenerarID
						  ,@CopiarBitacora
	EXEC xpMovCopiarEncabezado @Sucursal
							  ,@Modulo
							  ,@ID
							  ,@Empresa
							  ,@Mov
							  ,@MovID
							  ,@Usuario
							  ,@FechaEmision
							  ,@Estatus
							  ,@Moneda
							  ,@TipoCambio
							  ,@Almacen
							  ,@AlmacenDestino
							  ,@GenerarDirecto
							  ,@GenerarMov
							  ,@GenerarMovID
							  ,@GenerarID
							  ,@Ok OUTPUT
							  ,@CopiarBitacora

	IF EXISTS (SELECT * FROM EmpresaCfgModulo WHERE Empresa = @Empresa AND Modulo = @Modulo AND UPPER(Tiempos) = 'SI')
		INSERT MovTiempo (Modulo, Sucursal, ID, Usuario, FechaInicio, FechaComenzo, Estatus)
			VALUES (@Modulo, @Sucursal, @GenerarID, @Usuario, GETDATE(), GETDATE(), @Estatus)

END
GO