SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spGastoAppCE
@MacAddress varchar(50),
@OkRef		varchar(255) OUTPUT

AS
BEGIN
DECLARE
@Empresa			char(5),
@Sucursal			int,
@Usuario			varchar(10),
@Proveedor			varchar(10),
@RenglonID			int,
@Modulo				char(5),
@FechaEmision		datetime,
@Folio				varchar(20),
@Serie				varchar(20),
@Moneda				varchar(10),
@TipoCambio			float,
@RFC 				varchar(20),
@RFCReceptor		varchar(20),
@Nombre				varchar(100),
@Direccion			varchar(100),
@DireccionNum		varchar(20),
@Colonia			varchar(100),
@Poblacion			varchar(100),
@Delegacion			varchar(100),
@Estado 			varchar(30),
@Pais				varchar(30),
@CodigoPostal		varchar(15),
@Concepto			varchar(50),
@ConceptoAPP		varchar(50),
@Referencia			varchar(50),
@Importe			money,
@Impuestos			money,
@Retencion			money,
@Retencion2			money,
@Retencion3			money,
@CentroCostos		varchar(20),
@IEPS				money,
@UUID 				varchar(50),
@Documento			varchar(max),
@Mov				varchar(20),
@FechaTrabajo		datetime,
@ID					int,
@Renglon			int,
@Impuesto1			float,
@AcreedorRef		varchar(10),
@ContRelacionarComp bit,
@Ok			 		int,
@AnticipoMov		varchar(20),
@AnticipoMovID		varchar(20),
@Clase				varchar(50),
@SubClase			varchar(50),
@Observaciones		varchar(100),
@AltaAcreedor		bit
SELECT
@Empresa      = Empresa,
@Sucursal     = Sucursal,
@Usuario      = Usuario,
@Proveedor    = Proveedor,
@CentroCostos = CentroCostos,
@AltaAcreedor = AltaAcreedor
FROM MacAddressAPP
WHERE MacAddress= @MacAddress
IF		EXISTS(SELECT * FROM MacAddressAPP WHERE MacAddressAPP.MacAddress= @MacAddress AND MacAddressAPP.Activa = 0)  SELECT @Ok = 10060, @OkRef = 'Cuenta Inactiva, Comuniquese con el administrador del sistema'         ELSE
IF NOT	EXISTS(SELECT * FROM MacAddressAPP WHERE MacAddressAPP.MacAddress= @MacAddress)                               SELECT @Ok = 10060, @OkRef = 'No Existe su Cuenta, Comuniquese con el administrador del sistema'     ELSE
IF NOT	EXISTS(SELECT * FROM MovAPP        WHERE MovAPP.MacAddress= @MacAddress)                                      SELECT @Ok = 10060, @OkRef = 'No hay Nada que afectar'
SELECT @RFCReceptor = Empresa.RFC FROM Empresa WHERE Empresa = @Empresa
SELECT @Mov = GastoComprobante FROM EmpresaCfgMov  WHERE EmpresaCfgMov.Empresa = @Empresa
SELECT @Moneda = ContMoneda, @TipoCambio = Mon.TipoCambio  FROM EmpresaCfg JOIN Mon ON EmpresaCfg.ContMoneda = Mon.Moneda WHERE EmpresaCfg.Empresa = @Empresa
SELECT @FechaTrabajo = dbo.fnFechaSinHora(GETDATE()), @Renglon = 0.00
SELECT @ContRelacionarComp = ContRelacionarComp FROM MovTipo WHERE Mov = @Mov AND Modulo = 'GAS'
EXEC spGASAnticipoPendienteAPP @Empresa, @Proveedor, @AnticipoMov OUTPUT, @AnticipoMovID  OUTPUT, @Clase OUTPUT, @SubClase OUTPUT, @Observaciones OUTPUT
BEGIN TRANSACTION
IF @Ok IS NULL
BEGIN
INSERT INTO Gasto (Empresa, Mov, FechaEmision, Moneda, TipoCambio, Usuario, Estatus, Acreedor, Sucursal, OrigenTipo, MovAplica, MovAplicaID, Clase, Subclase, Observaciones)
VALUES (@Empresa, @Mov, @FechaTrabajo, @Moneda, @TipoCambio, @Usuario, 'CONFIRMAR', @Proveedor, @Sucursal, 'APP', @AnticipoMov, @AnticipoMovID, @Clase, @SubClase, @Observaciones)
SELECT @ID = SCOPE_IDENTITY()
DECLARE crGastoD CURSOR FOR
SELECT
MovAPP.ID,
MovAPP.Modulo,
MovAPP.FechaEmision,
RTRIM(LTRIM(REPLACE(MovAPP.RFCReceptor,'|',''))),
RTRIM(LTRIM(REPLACE(MovAPP.Folio,'|',''))),
RTRIM(LTRIM(REPLACE(MovAPP.Serie,'|',''))),
RTRIM(LTRIM(REPLACE(MovAPP.RFC,'|',''))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.Nombre,'|','')))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.Direccion,'|','')))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.DireccionNum,'|','')))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.Colonia,'|','')))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.Poblacion,'|','')))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.Delegacion,'|','')))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.Estado,'|','')))),
RTRIM(LTRIM(REPLACE(MovAPP.Pais,'|',''))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.CodigoPostal,'|','')))),
UPPER(RTRIM(LTRIM(REPLACE(MovAPP.Concepto,'|','')))),
RTRIM(LTRIM(MovAPP.Importe)),
RTRIM(LTRIM(MovAPP.Impuesto)),
RTRIM(LTRIM(MovAPP.Retencion)),
RTRIM(LTRIM(MovAPP.Retencion2)),
RTRIM(LTRIM(MovAPP.Retencion3)),
RTRIM(LTRIM(MovAPP.UUID)),
MovAPP.Documento
FROM MovAPP
WHERE MovAPP.MacAddress = @MacAddress
ORDER BY MovAPP.ID
OPEN crGastoD
FETCH NEXT FROM crGastoD INTO  @RenglonID, @Modulo, @FechaEmision, @RFCReceptor, @Folio, @Serie, @RFC, @Nombre, @Direccion, @DireccionNum, @Colonia, @Poblacion, @Delegacion, @Estado, @Pais,
@CodigoPostal, @ConceptoAPP, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @UUID, @Documento
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SELECT @Renglon = @Renglon + 2048, @AcreedorRef = NULL, @Referencia =  RTRIM(LTRIM(ISNULL(REPLACE(@Serie,'.', ''),' ')))+' '+RTRIM(LTRIM(ISNULL(@Folio,' ')))
SELECT @Impuesto1 = dbo.fnMenor(ROUND(dbo.fnPorcentajeImporte(@Importe, @Impuestos),0.00), 16)
IF @Impuesto1 = 0.00 SELECT @Impuesto1 = NULL
SELECT @RFCReceptor = REPLACE(@RFCReceptor, '-','')
IF NOT EXISTS (SELECT * FROM Empresa WHERE Empresa = @Empresa AND RTRIM(LTRIM(RFC)) = @RFCReceptor) SELECT @Ok = 10060, @OkRef = 'Este Documento no es de esta empresa, RFC: '+@RFC+' Concepto:'+@ConceptoAPP ELSE
IF EXISTS (SELECT * FROM MovAPP WHERE MovAPP.MacAddress = @MacAddress AND ID <> @RenglonID AND RTRIM(LTRIM(MovAPP.UUID)) = @UUID)  SELECT @Ok = 10060, @OkRef = 'xml Duplicados'
SELECT @Concepto = @ConceptoAPP
SELECT @AcreedorRef = Proveedor FROM Prov WHERE RTRIM(LTRIM(RFC)) = @RFC
EXEC spConceptoAPP @Modulo, @Concepto OUTPUT
IF @Ok IS NULL
BEGIN
IF  @AcreedorRef IS NULL AND NULLIF(RTRIM( @RFC), '') IS NOT NULL AND NULLIF(RTRIM(@Nombre), '') IS NOT NULL AND @AltaAcreedor = 1
BEGIN
EXEC spAgregarProveedorAPP '(CONSECUTIVO)', @Nombre, @Direccion, @Poblacion, @Colonia, NULL, @Delegacion, @Estado, @Pais, @CodigoPostal, @RFC, NULL, NULL, NULL, NULL, NULL, NULL, 'Acreedor',  'Pesos', NULL, NULL, @Empresa, @AcreedorRef OUTPUT
END
INSERT INTO GastoD (ID, Renglon, Concepto, Fecha, Cantidad, Precio, Importe, Impuestos, Retencion, Retencion2, Retencion3, Impuesto1,  Referencia, ContUso, AcreedorRef, DescripcionExtra)
VALUES (@ID, @Renglon, @Concepto, @FechaEmision, 1, @Importe, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @Impuesto1, @Referencia, @CentroCostos, @AcreedorRef, @ConceptoAPP)
IF  NULLIF(RTRIM( @RFC), '') IS NOT NULL AND @ContRelacionarComp = 1 AND NULLIF(RTRIM(@UUID), '') IS NOT NULL
BEGIN
EXEC spContSatAsociarAPP  @MacAddress,  @Modulo, @ID, @Empresa, @FechaEmision, @Mov, @RFCReceptor, @RFC, @Importe, @UUID,
@Moneda, @TipoCambio, @Usuario, NULL, @Documento, @Ok OUTPUT, @OkRef OUTPUT
END
IF @Ok IS NULL DELETE MovAPP WHERE MacAddress = @MacAddress AND ID = @RenglonID
END
END
FETCH NEXT FROM crGastoD INTO  @RenglonID, @Modulo, @FechaEmision, @RFCReceptor, @Folio, @Serie, @RFC, @Nombre, @Direccion, @DireccionNum, @Colonia, @Poblacion, @Delegacion, @Estado, @Pais,
@CodigoPostal, @ConceptoAPP, @Importe, @Impuestos, @Retencion, @Retencion2, @Retencion3, @UUID, @Documento
END
CLOSE crGastoD
DEALLOCATE crGastoD
END
IF @Ok IS NULL
SELECT @OkRef = 'Ok'
IF @Ok IS NULL
COMMIT TRANSACTION
ELSE
ROLLBACK TRANSACTION
IF @OK IS NOT NULL
BEGIN
DELETE MovAPP WHERE MacAddress = @MacAddress
END
RETURN
END

