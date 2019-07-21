SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilCobroAlta
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE
/***    DATOS A OBTENER DE XML    ***/
@Usuario        varchar(10),
@Contrasena     varchar(25),
@Cliente        varchar(10),
@FormaPago      varchar(50),
@Importe        money,
@Moneda         varchar(10),
@Concepto       varchar(50),
@Referencia     varchar(50),
@Observaciones  varchar(100),
@AutoAplicar    smallint,
/************************************/
/***  VARIABLES DE CONFIGURACION  ***/
@Empresa        varchar(5),
@Agente         varchar(10),
@MonedaCfg      char(10),
@MovCobro       varchar(20),
@MovAnticipo    varchar(20),
@Sucursal       int,
/************************************/
@TipoCambio     float,
@MonedaCte      varchar(10),
@TipoCambioCte  float,
@Mov            varchar(20),
@MovID          varchar(20),
@IDc            int,
@IDCxcCob		int,
@IDCxcAnt		int,
@OrigenTipo     varchar(10),
@MonedaFact		varchar(10),
@TipoCambioFact float,
@SaldoFact      money,
@SaldoCobro     money,
@ImporteAplica  money,
@MontoCobro		money,
@IDCxcD         int,
@FechaEmision   datetime,
@Renglon		float,
/*****   VARIABLES DE CURSOR DE DOCUMENTOS  *****/
@cID            int,
@cEmpresa       varchar(5),
@cMov           varchar(20),
@cMovID         varchar(20),
@cCliente       varchar(10),
@cSaldo         money,
/*****    VARIABLES DE CURSOR DE MONEDAS   *****/
@cMoneda		varchar(10),
@cTipoCambio	float,
@cOrden			int,
/***********************************************/
@Existe         int,
@ChecaSelec     int = 0
/*********************************************************************************/
SELECT  @Usuario = Usuario,
@Contrasena = Contrasena,
@Cliente = Cliente,
@FormaPago = Forma,
@Importe = Importe,
@Moneda = Moneda,
@Concepto = Concepto,
@Referencia = Referencia,
@Observaciones = Observaciones,
@AutoAplicar = AutoAplicar
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario			varchar(50), Contrasena		varchar(50), Cliente	varchar(50), Forma varchar(50),
Importe           varchar(50), Moneda			varchar(50), Concepto	varchar(50), Referencia varchar(50),
Observaciones		varchar(max),AutoAplicar    varchar(1))
SELECT  @Empresa = Empresa,
@Agente = Agente,
@MonedaCfg = MonedaBase,
@MovCobro = MovimientoCobro,
@MovAnticipo = MovimientoAnticipo,
@Sucursal = Sucursal
FROM  MovilUsuarioCfg WITH(NOLOCK)
WHERE  Usuario = @Usuario
SET @Sucursal = ISNULL(@Sucursal,0)
SET @FechaEmision = dbo.fnFechaSinHora(GETDATE())
/*****************     VALIDACION DE LOS CAMPOS REQUERIDOS     *******************/
SELECT @Existe = Count(*) FROM FormaPago WITH(NOLOCK) WHERE FormaPago = @FormaPago
IF @Existe < 1 AND @OK IS NULL
BEGIN
SET @Ok = 30530
SET @OkRef = 'La Forma de Pago Especificada no Existe'
END
IF @Importe IS NULL OR @Importe <= 0 AND @OK IS NULL
BEGIN
SET @Ok = 10060
SET @OkRef = 'El Importe debe ser mayor a $0.00'
END
IF @Moneda IS NULL OR @Moneda = '' AND @OK IS NULL
BEGIN
SELECT @Moneda = Moneda FROM Mon WITH(NOLOCK) WHERE Orden = 1
END
SET @Existe = Null
SELECT @Existe = Count(*) FROM Mon WITH(NOLOCK) WHERE Moneda = ISNULL(@Moneda,@MonedaCfg)
IF @Existe < 1 AND @OK IS NULL
BEGIN
SET @Ok = 10060
SET @OkRef = 'La Moneda Especificada no Existe'
END
SET @Existe = Null
SELECT @Existe = Count(*) FROM Cte WITH(NOLOCK) WHERE Cliente = @Cliente
IF @Existe < 1 AND @OK IS NULL
BEGIN
SET @Ok = 10060
SET @OkRef = 'El Cliente no Existe'
END
/*********************************************************************************/
SELECT @TipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = ISNULL(@Moneda,@MonedaCfg)
SELECT @MonedaCte = DefMoneda FROM Cte WITH(NOLOCK) WHERE Cliente = @Cliente
IF @MonedaCte IS NULL
SET @MonedaCte = @Moneda
SELECT @TipoCambioCte = TipoCambio FROM WITH(NOLOCK) Mon WHERE Moneda = @MonedaCte
IF @Referencia Like '% %'
EXEC spReferenciaEnMovMovID @Referencia, @Mov OUTPUT, @MovID OUTPUT
SELECT	@IDc = ID,
@SaldoFact = ISNULL(Saldo,0),
@MonedaFact = Moneda,
@OrigenTipo = OrigenTipo
FROM	CxcPendiente WITH(NOLOCK)
WHERE	Mov = @Mov
AND	MovID = @MovID
AND	Cliente = @Cliente
SELECT	@TipoCambioFact = Tipocambio FROM Mon WITH(NOLOCK) WHERE Moneda = @MonedaFact
SET @SaldoCobro = @Importe
/******     SI EL CHECK AUTOAPLICAR ESTA APAGADO SE REALIZA UN ANTICIPO     ******/
IF @AutoAplicar = 0 AND @OK IS NULL
BEGIN
INSERT INTO CXC(Empresa, Mov, Moneda, Cliente, AplicaManual, ConDesglose, GenerarPoliza, Indirecto, GenerarDinero, Sucursal,
Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, SucursalOrigen, FechaEmision, UltimoCambio,
Concepto, TipoCambio, Usuario, Referencia, ClienteMoneda, Vencimiento, FormaCobro, Importe, Impuestos, Agente,
OrigenTipo, Origen, OrigenID, Estatus,Observaciones, ClienteTipoCambio)
VALUES (@Empresa, @Mov, ISNULL(@Moneda,@MonedaCfg), @Cliente, 1, 0, 0, 0, 0, @Sucursal,
0, 0, 0, 0, 0, 0, 0, @Sucursal, @FechaEmision,@FechaEmision,
@Concepto, @TipoCambio, @Usuario, @Referencia, @MonedaCte, @FechaEmision, @FormaPago, @Importe, 0, @Agente,
@OrigenTipo, @Mov, @MovID, 'SINAFECTAR','Observacion CXC Anticipo'/*@Observaciones*/, @TipoCambioCte)
SELECT @IDCxcAnt = @@IDENTITY
END
/*********************************************************************************/
SELECT @ChecaSelec = ISNULL(COUNT(*),0) FROM WebCxCPendientesPaso WITH(NOLOCK)
WHERE Cliente = @Cliente
AND Seleccion = 'Si'
IF (@AutoAplicar = 1 or @ChecaSelec > 0) AND @OK IS NULL
BEGIN
IF @IDc IS NOT NULL
BEGIN
/*****     SE CALCULA EL IMPORTE A APLICAR PARA LA FACTURA DE REFERENCIA      *****/
IF (@Importe*@TipoCambio) >= (@SaldoFact*@TipoCambioFact)
BEGIN
SET @SaldoCobro = ROUND(((@Importe*@TipoCambio) - (@SaldoFact*@TipoCambioFact))/@TipoCambio,dbo.fnRedondeoMonetarios())
SET @ImporteAplica = @SaldoFact
END
IF (@Importe*@TipoCambio) < (@SaldoFact*@TipoCambioFact)
BEGIN
SET @SaldoCobro = 0
SET @ImporteAplica = ROUND((@Importe*@TipoCambio)/@TipoCambioFact,dbo.fnRedondeoMonetarios())
END
/*********************************************************************************/
INSERT INTO CXC(Empresa, Mov, Moneda, Cliente, AplicaManual, ConDesglose, GenerarPoliza, Indirecto, GenerarDinero, Sucursal,
Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, SucursalOrigen, FechaEmision, UltimoCambio,
Concepto, TipoCambio, Usuario, Referencia, ClienteMoneda, Vencimiento, FormaCobro, Importe, Impuestos, Agente,
OrigenTipo, Origen, OrigenID, Estatus, Observaciones, ClienteTipoCambio )
VALUES (@Empresa, @MovCobro, @MonedaFact, @Cliente, 1, 0, 0, 0, 0, @Sucursal,
0, 0, 0, 0, 0, 0, 0, 0, @FechaEmision, @FechaEmision,
@Concepto, @TipoCambioFact, @Usuario, @Referencia, @MonedaFact, @FechaEmision, @FormaPago, @ImporteAplica, 0, @Agente,
@OrigenTipo, @Mov, @MovID, 'SINAFECTAR', 'Observacion CXC Referencia' /*@Observaciones*/, @TipoCambioFact)
SELECT @IDCxcCob = @@IDENTITY
SET @MontoCobro = @ImporteAplica
SELECT @Renglon = MAX(Renglon) FROM CxcD WITH(NOLOCK) WHERE ID = @IDCxcCob
SET @Renglon = ISNULL(@Renglon,1024)
INSERT INTO CxcD(ID, Renglon, RenglonSub, Importe, Aplica, AplicaID,
Ligado, Sucursal, LigadoDR, Logico1, SucursalOrigen)
VALUES    (@IDCxcCob, @Renglon, 0, @ImporteAplica, @Mov, @MovID,
0, 0, 0, 0, 0)
END
/*****     SE AFECTA EL MOVIMIENTO SI YA NO QUEDA IMPORTE DISPONIBLE DEL COBRO     *****/
IF @IDCxcCob IS NOT NULL AND @SaldoCobro = 0
BEGIN
EXEC spAfectar 'CXC', @IDCxcCob, 'AFECTAR', 'TODO', NULL, @Usuario, @Ensilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @Ok = NULL, @OkRef = NULL
END
/***************************************************************************************/
IF @IDc IS NULL OR @SaldoCobro > 0 AND @OK IS NULL
BEGIN
SELECT  @Existe = C.ID
FROM    CxcPendiente C WITH(NOLOCK),
MovTipo MT WITH(NOLOCK)
WHERE   MT.Clave = 'CXC.F'
AND   C.Mov = MT.Mov AND MT.Modulo = 'CXC'
AND   C.Cliente = @Cliente
AND	C.Moneda = ISNULL(@MonedaFact,@Moneda)
AND	(C.Mov <> ISNULL(@Mov,'') OR C.MovID <> ISNULL(@MovID,''))
IF ISNULL(@Existe,0) > 0 AND @OK IS NULL
BEGIN
IF @IDc IS NULL
BEGIN
SET @ImporteAplica = @Importe
INSERT INTO CXC(Empresa, Mov, Moneda, Cliente, AplicaManual, ConDesglose, GenerarPoliza, Indirecto, GenerarDinero, Sucursal,
Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, SucursalOrigen, FechaEmision, UltimoCambio,
Concepto, TipoCambio, Usuario, Referencia, ClienteMoneda, Vencimiento, FormaCobro, Importe, Impuestos, Agente,
OrigenTipo, Origen, OrigenID, Estatus, Observaciones, ClienteTipoCambio )
VALUES (@Empresa, @MovCobro, ISNULL(@MonedaFact,@Moneda), @Cliente, 1, 0, 0, 0, 0, @Sucursal,
0, 0, 0, 0, 0, 0, 0, 0, @FechaEmision, @FechaEmision,
@Concepto, ISNULL(@TipoCambioFact,@TipoCambio),  @Usuario, @Referencia, ISNULL(@MonedaFact,@Moneda), @FechaEmision, @FormaPago, @ImporteAplica, 0, @Agente,
@OrigenTipo, @Mov, @MovID, 'SINAFECTAR', 'Observacion CXC Importe' /*@Observaciones*/, ISNULL(@TipoCambioFact,@TipoCambio))
SELECT @IDCxcCob = @@IDENTITY
END
IF @ChecaSelec > 0
BEGIN
DECLARE CrDocumentos CURSOR FOR
SELECT	C.Id, C.Empresa, C.Mov, C.MovID, C.Cliente, C.Saldo
FROM  CxcPendiente C WITH(NOLOCK)
JOIN  MovTipo MT WITH(NOLOCK) ON C.Mov = MT.Mov AND MT.Modulo = 'CXC'
WHERE  MT.Clave = 'CXC.F'
AND  C.Cliente = @Cliente
AND	C.Moneda = ISNULL(@MonedaFact,@Moneda)
AND (C.Mov <> ISNULL(@Mov,'') OR C.MovID <> ISNULL(@MovID,''))
AND  C.Id in (Select IdCxC from WebCxCPendientesPaso WITH(NOLOCK) Where Cliente = @Cliente and Seleccion = 'Si')
ORDER BY  C.FechaEmision ASC
END ELSE
BEGIN
DECLARE CrDocumentos CURSOR FOR
SELECT	C.Id, C.Empresa, C.Mov, C.MovID, C.Cliente, C.Saldo
FROM  CxcPendiente C WITH(NOLOCK)
JOIN  MovTipo MT WITH(NOLOCK) ON C.Mov = MT.Mov AND MT.Modulo = 'CXC'
WHERE  MT.Clave = 'CXC.F'
AND  C.Cliente = @Cliente
AND	C.Moneda = ISNULL(@MonedaFact,@Moneda)
AND (C.Mov <> ISNULL(@Mov,'') OR C.MovID <> ISNULL(@MovID,''))
ORDER BY  C.FechaEmision ASC
END
OPEN CrDocumentos
FETCH CrDocumentos INTO @cID,@cEmpresa,@cMov,@cMovID,@cCliente,@cSaldo
WHILE @@FETCH_STATUS = 0 AND @SaldoCobro > 0
BEGIN
IF @cMov <> ISNULL(@Mov,'') OR @cMovID <> ISNULL(@MovID,'')
BEGIN
SET @Importe = @SaldoCobro
IF (@Importe*@TipoCambio) >= (@cSaldo*ISNULL(@TipoCambioFact,@TipoCambio))
BEGIN
SET @SaldoCobro = ROUND(((@Importe*@TipoCambio) - (@cSaldo*ISNULL(@TipoCambioFact,@TipoCambio)))/@TipoCambio, dbo.fnRedondeoMonetarios())
SET @ImporteAplica = ROUND(@cSaldo,dbo.fnRedondeoMonetarios())
SET @MontoCobro = ROUND(ISNULL(@MontoCobro,0)+@ImporteAplica,dbo.fnRedondeoMonetarios())
END
IF (@Importe*@TipoCambio) < (@cSaldo*ISNULL(@TipoCambioFact,@TipoCambio))
BEGIN
SET @SaldoCobro = 0
SET @ImporteAplica = ROUND((@Importe*@TipoCambio)/ISNULL(@TipoCambioFact,@TipoCambio),dbo.fnRedondeoMonetarios())
SET @MontoCobro = ROUND(ISNULL(@MontoCobro,0)+@ImporteAplica,dbo.fnRedondeoMonetarios())
END
SELECT @Renglon = MAX(Renglon)+1024 FROM CxcD WITH(NOLOCK) WHERE ID = @IDCxcCob
SET @Renglon = ISNULL(@Renglon,1024)
INSERT INTO CxcD(ID, Renglon, RenglonSub, Importe, Aplica, AplicaID,
Ligado, Sucursal, LigadoDR, Logico1, SucursalOrigen)
VALUES(@IDCxcCob, @Renglon, 0, @ImporteAplica, @cMov, @cMovID,
0, 0, 0, 0, 0)
END
FETCH CrDocumentos INTO @cID,@cEmpresa,@cMov,@cMovID,@cCliente,@cSaldo
END
UPDATE Cxc WITH(NOLOCK) SET Importe = @MontoCobro WHERE ID = @IDCxcCob
CLOSE CrDocumentos
DEALLOCATE CrDocumentos
END
/*****     SI NO EXISTEN DOCUMENTOS CON EL MISMO TIPO DE MONEDA     *****/
IF @IDCxcCob IS NOT NULL
BEGIN
EXEC spAfectar 'CXC', @IDCxcCob, 'AFECTAR', 'TODO', NULL, @Usuario, @Ensilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @Ok = NULL, @OkRef = NULL
END
/*********************************************************************************************************/
IF (ISNULL(@Existe,0) < 1 OR @SaldoCobro > 0) AND @OK IS NULL
BEGIN
SELECT  @Existe = C.ID
FROM  CxcPendiente C WITH(NOLOCK),
MovTipo MT WITH(NOLOCK)
WHERE  MT.Clave = 'CXC.F'
AND  C.Mov = MT.Mov AND MT.Modulo = 'CXC'
AND  C.Cliente = @Cliente
AND  C.Moneda <> ISNULL(@MonedaFact,@Moneda)
AND (C.Mov <> ISNULL(@Mov,'') OR C.MovID <> ISNULL(@MovID,''))
IF ISNULL(@Existe,0) < 1
BEGIN
INSERT INTO CXC(Empresa, Mov, Moneda, Cliente, AplicaManual, ConDesglose, GenerarPoliza, Indirecto, GenerarDinero, Sucursal,
Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, SucursalOrigen, FechaEmision, UltimoCambio,
Concepto, TipoCambio, Usuario, Referencia, ClienteMoneda, Vencimiento, FormaCobro, Importe, Impuestos, Agente,
OrigenTipo, Origen, OrigenID, Estatus,Observaciones, ClienteTipoCambio)
VALUES (@Empresa, @MovAnticipo, ISNULL(@Moneda,@MonedaCfg), @Cliente, 1, 0, 0, 0, 0, @Sucursal,
0, 0, 0, 0, 0, 0, 0, 0, @FechaEmision, @FechaEmision,
@Concepto, @TipoCambio, @Usuario, @Referencia, @MonedaCte, @FechaEmision, @FormaPago, @SaldoCobro, 0, @Agente,
@OrigenTipo, @Mov, @MovID, 'SINAFECTAR', 'Observacion CXC SaldoCobro' /*@Observaciones*/, @TipoCambioCte)
SELECT @IDCxcAnt = @@IDENTITY
SET @SaldoCobro = 0
END
IF ISNULL(@Existe,0) > 0 AND @OK IS NULL
BEGIN
DECLARE CrMonedas CURSOR FOR
SELECT  DISTINCT
C.Moneda,
M.Orden
FROM  CxcPendiente C WITH(NOLOCK),
MovTipo MT WITH(NOLOCK),
Mon M WITH(NOLOCK)
WHERE  MT.Clave = 'CXC.F'
AND  C.Mov = MT.Mov AND MT.Modulo = 'CXC'
AND  C.Cliente = @Cliente
AND	C.Moneda <> ISNULL(@MonedaFact,@Moneda)
AND	C.Moneda = M.Moneda
AND (C.Mov <> ISNULL(@Mov,'') OR C.MovID <> ISNULL(@MovID,''))
ORDER BY  M.Orden ASC
OPEN CrMonedas
FETCH CrMonedas INTO @cMoneda, @cOrden
WHILE @@FETCH_STATUS = 0 AND @SaldoCobro > 0
BEGIN
SELECT @cTipoCambio = TipoCambio FROM Mon WITH(NOLOCK) WHERE Moneda = @cMoneda
SET @MontoCobro = 0
INSERT INTO CXC(Empresa, Mov, Moneda, Cliente, AplicaManual, ConDesglose, GenerarPoliza, Indirecto, GenerarDinero, Sucursal,
Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, SucursalOrigen, FechaEmision, UltimoCambio,
Concepto, TipoCambio, Usuario, Referencia, ClienteMoneda, Vencimiento, FormaCobro, Importe, Impuestos, Agente,
OrigenTipo, Origen, OrigenID, Estatus, Observaciones, ClienteTipoCambio )
VALUES (@Empresa, @MovCobro, @cMoneda, @Cliente, 1, 0, 0, 0, 0, @Sucursal,
0, 0, 0, 0, 0, 0, 0, 0, @FechaEmision, @FechaEmision,
@Concepto, @cTipoCambio, @Usuario,@Referencia, @cMoneda, @FechaEmision, @FormaPago, @ImporteAplica, 0, @Agente,
@OrigenTipo, @Mov, @MovID, 'SINAFECTAR', 'Observacion CXC cTipoCambio'/*@Observaciones*/, @cTipoCambio)
SELECT  @IDCxcCob = @@IDENTITY
DECLARE CrDocumentos CURSOR FOR
SELECT	C.Id, C.Empresa, C.Mov, C.MovID, C.Cliente, C.Saldo
FROM  CxcPendiente C WITH(NOLOCK)
JOIN  MovTipo MT WITH(NOLOCK) ON C.Mov = MT.Mov AND MT.Modulo = 'CXC'
WHERE  MT.Clave = 'CXC.F'
AND  C.Cliente = @Cliente
AND	C.Moneda = @cMoneda
AND (C.Mov <> ISNULL(@Mov,'') OR C.MovID <> ISNULL(@MovID,''))
ORDER BY  C.FechaEmision ASC
OPEN CrDocumentos
FETCH CrDocumentos INTO @cID,@cEmpresa,@cMov,@cMovID,@cCliente,@cSaldo
WHILE @@FETCH_STATUS = 0 AND @SaldoCobro > 0
BEGIN
SET @Importe = @SaldoCobro
IF (@Importe*@TipoCambio) >= (@cSaldo*@cTipoCambio)
BEGIN
SET @SaldoCobro = ROUND(((@Importe*@TipoCambio) - (@cSaldo*@cTipoCambio))/@TipoCambio, dbo.fnRedondeoMonetarios())
SET @ImporteAplica = ROUND(@cSaldo, dbo.fnRedondeoMonetarios())
SET @MontoCobro = ROUND(ISNULL(@MontoCobro,0)+@ImporteAplica, dbo.fnRedondeoMonetarios())
END
IF (@Importe*@TipoCambio) < (@cSaldo*@cTipoCambio)
BEGIN
SET @SaldoCobro = 0
SET @ImporteAplica = ROUND((@Importe*@TipoCambio)/@cTipoCambio, dbo.fnRedondeoMonetarios())
SET @MontoCobro = ROUND(ISNULL(@MontoCobro,0)+@ImporteAplica, dbo.fnRedondeoMonetarios())
END
SELECT @Renglon = MAX(Renglon)+1024 FROM CxcD WITH(NOLOCK) WHERE ID = @IDCxcCob
SET @Renglon = ISNULL(@Renglon,1024)
INSERT INTO CxcD(ID, Renglon, RenglonSub, Importe, Aplica, AplicaID,
Ligado, Sucursal, LigadoDR, Logico1, SucursalOrigen)
VALUES(@IDCxcCob, @Renglon, 0, @ImporteAplica, @cMov, @cMovID,
0, 0, 0, 0, 0)
FETCH CrDocumentos INTO @cID,@cEmpresa,@cMov,@cMovID,@cCliente,@cSaldo
END
CLOSE CrDocumentos
DEALLOCATE CrDocumentos
UPDATE Cxc WITH(NOLOCK) SET Importe = @MontoCobro WHERE ID = @IDCxcCob
IF @IDCxcCob IS NOT NULL
BEGIN
EXEC spAfectar 'CXC', @IDCxcCob, 'AFECTAR', 'TODO', NULL, @Usuario, @Ensilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @Ok = NULL, @OkRef = NULL
END
FETCH CrMonedas INTO @cMoneda, @cOrden
END
CLOSE CrMonedas
DEALLOCATE CrMonedas
END
END
END
END
/*****     SE REALIZA UN ANTICIPO SI EL IMPORTE DEL COBRO TIENE ALG˜N
SOBRANTE A˜N DESPUÉS DE HABERLO APLICADO A LOS DOCUMENTOS    *****/
IF @SaldoCobro > 0 AND @OK IS NULL
BEGIN
INSERT INTO CXC(Empresa, Mov, Moneda, Cliente, AplicaManual, ConDesglose, GenerarPoliza, Indirecto, GenerarDinero, Sucursal,
Logico1, Logico2, Logico3, Logico4, Logico5, Logico6, ConTramites, SucursalOrigen, FechaEmision, UltimoCambio,
Concepto, TipoCambio, Usuario, Referencia, ClienteMoneda, Vencimiento, FormaCobro, Importe, Impuestos, Agente,
OrigenTipo, Origen, OrigenID, Estatus, Observaciones, ClienteTipoCambio)
VALUES (@Empresa, @MovAnticipo, ISNULL(@Moneda,@MonedaCfg), @Cliente, 1, 0, 0, 0, 0, @Sucursal,
0, 0, 0, 0, 0, 0, 0, 0, @FechaEmision, @FechaEmision,
@Concepto, @TipoCambio, @Usuario, @Referencia, @MonedaCte, @FechaEmision, @FormaPago, @SaldoCobro, 0, @Agente,
@OrigenTipo, @Mov, @MovID, 'SINAFECTAR', 'Observacion CXC SaldoCobro' /* @Observaciones*/, @TipoCambioCte)
SELECT @IDCxcAnt = @@IDENTITY
END
/****************************************************************************/
IF @IDCxcAnt IS NOT NULL
BEGIN
EXEC spAfectar 'CXC', @IDCxcAnt, 'AFECTAR', 'TODO', NULL, @Usuario, @Ensilencio = 1, @Ok = @Ok OUTPUT, @OkRef = @OkRef OUTPUT
SELECT @Ok = NULL, @OkRef = NULL
END
END

