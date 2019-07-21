SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fneDocCXCReferenciaMetodoCobro
(
@ID               int,
@Ref              bit
)
RETURNS varchar(100)
AS
BEGIN
DECLARE
@FormaCobro     varchar(50),
@Referencia     varchar(50),
@FormaCobro1    varchar(50),
@Referencia1    varchar(50),
@FormaCobro2    varchar(50),
@Referencia2    varchar(50),
@FormaCobro3    varchar(50),
@Referencia3    varchar(50),
@FormaCobro4    varchar(50),
@Referencia4    varchar(50),
@FormaCobro5    varchar(50),
@Referencia5    varchar(50),
@Importe1       float,
@Importe2       float,
@Importe3       float,
@Importe4       float,
@Importe5       float,
@Cliente		varchar(10),
@Resultado      varchar(max),
@InfoPago		varchar(100),
@InfoFormaPago	varchar(50),
@EnviarA		int,
@Empresa		char(5),
@IDR            int,
@FormaCobroRef  varchar(50),
@ReferenciaRef  varchar(50),
@ValidarMetodoPago bit,
@MovTipo		 varchar(20)
SELECT @MovTipo = Clave  FROM CXC c JOIN MovTipo mt ON Mt.Modulo = 'CXC' AND mt.Mov = c.Mov WHERE c.ID = @ID
SELECT @ValidarMetodoPago = 0
IF @MovTipo = 'CXC.C' SELECT @ValidarMetodoPago = 1
SELECT
@Resultado   = '',
@FormaCobro  = ISNULL(FormaCobro,''),
@Referencia  = NULL,
@FormaCobro1 = NULLIF(FormaCobro1,''),
@Referencia1 = NULLIF(Referencia1,''),
@FormaCobro2 = NULLIF(FormaCobro2,''),
@Referencia2 = NULLIF(Referencia2,''),
@FormaCobro3 = NULLIF(FormaCobro3,''),
@Referencia3 = NULLIF(Referencia3,''),
@FormaCobro4 = NULLIF(FormaCobro4,''),
@Referencia4 = NULLIF(Referencia4,''),
@FormaCobro5 = NULLIF(FormaCobro5,''),
@Referencia5 = NULLIF(Referencia5,''),
@Cliente     = ISNULL(Cliente,''),
@EnviarA     = ClienteEnviarA,
@Empresa     = Empresa,
@Importe1    = ISNULL(Importe1,0),
@Importe2    = ISNULL(Importe2,0),
@Importe3    = ISNULL(Importe3,0),
@Importe4    = ISNULL(Importe4,0),
@Importe5    = ISNULL(Importe5,0)
FROM Cxc
WHERE ID = @ID
SELECT @FormaCobro1 = ClaveSAT FROM FormaPago WHERE FormaPago = @FormaCobro1
SELECT @FormaCobro2 = ClaveSAT FROM FormaPago WHERE FormaPago = @FormaCobro2
SELECT @FormaCobro3 = ClaveSAT FROM FormaPago WHERE FormaPago = @FormaCobro3
SELECT @FormaCobro4 = ClaveSAT FROM FormaPago WHERE FormaPago = @FormaCobro4
SELECT @FormaCobro5 = ClaveSAT FROM FormaPago WHERE FormaPago = @FormaCobro5
SELECT @FormaCobro = ClaveSAT FROM FormaPago WHERE FormaPago = @FormaCobro
DECLARE @DatosTemp TABLE (Importe float,   FormaCobro varchar(50), Referencia varchar(50))
INSERT INTO @DatosTemp SELECT @Importe1, @FormaCobro1, @Referencia1
INSERT INTO @DatosTemp SELECT @Importe2, @FormaCobro2, @Referencia2
INSERT INTO @DatosTemp SELECT @Importe3, @FormaCobro3, @Referencia3
INSERT INTO @DatosTemp SELECT @Importe4, @FormaCobro4, @Referencia4
INSERT INTO @DatosTemp SELECT @Importe5, @FormaCobro5, @Referencia5
IF @Resultado IS NULL
SELECT @Resultado  = ''
DECLARE @Datos TABLE (ID int identity(1,1), FormaCobro varchar(50), Referencia varchar(50))
INSERT INTO @Datos(FormaCobro, Referencia) SELECT FormaCobro, Referencia FROM @DatosTemp ORDER BY Importe DESC
SELECT @IDR = MIN(ID) FROM @Datos
WHILE @IDR IS NOT NULL
BEGIN
SELECT @FormaCobroRef = FormaCobro, @ReferenciaRef = Referencia FROM @Datos WHERE ID = @IDR
IF @Ref = 1
BEGIN
IF @FormaCobroRef IS NOT NULL AND @ReferenciaRef IS NOT NULL
SELECT @Resultado = @Resultado + ISNULL(dbo.fneDocEsNumero(RIGHT(@ReferenciaRef,4)),'No Aplica') + ','
END
ELSE
BEGIN
IF @FormaCobroRef IS NOT NULL AND @ReferenciaRef IS NOT NULL
SELECT @Resultado = @Resultado + @FormaCobroRef + ','
END
SELECT @IDR = MIN(ID) FROM @Datos WHERE ID > @IDR
END
IF SUBSTRING(@Resultado, LEN(@Resultado), 1)  = ','
SET @Resultado = SUBSTRING(@Resultado, 1, LEN(@Resultado)-1)
IF NULLIF(@Resultado,'') IS NULL
BEGIN
SELECT @InfoFormaPago = InfoFormaPago FROM CteEmpresaCFD WHERE Cliente = @Cliente AND Empresa = @Empresa
IF @Ref = 1
SELECT @Resultado = dbo.fneDocEsNumero(RIGHT(NULLIF(CuentaPago,''),4)) FROM CteCFDFormaPago WHERE Cliente = @Cliente AND Empresa = @Empresa AND FormaPago = @InfoFormaPago
ELSE
SELECT @Resultado = FormaPago.ClaveSAT FROM CteCFDFormaPago LEFT JOIN FormaPago ON CteCFDFormaPago.FormaPago = FormaPago.FormaPago  WHERE CteCFDFormaPago.Cliente = @Cliente AND CteCFDFormaPago.Empresa = @Empresa  AND CteCFDFormaPago.FormaPago = @InfoFormaPago
END
IF NULLIF(@Resultado,'') IS NULL
BEGIN
IF @EnviarA IS NOT NULL
SELECT @InfoPago = InfoPago,
@InfoFormaPago = InfoFormaPago
FROM CteEnviarACFD
WHERE Cliente = @Cliente
AND EnviarA = @EnviarA
IF @InfoPago IS NULL OR @InfoFormaPago IS NULL
SELECT @InfoPago = InfoPago,
@InfoFormaPago = InfoFormaPago
FROM CteCFD
WHERE Cliente = @Cliente
SELECT @FormaCobro = NULLIF(FormaPago.ClaveSAT,''),
@Referencia = ISNULL(dbo.fneDocEsNumero(RIGHT(NULLIF(CuentaPago,''),4)),'No Aplica')
FROM CteCFDInfoPagoD
LEFT JOIN FormaPago ON CteCFDInfoPagoD.FormaPago = FormaPago.FormaPago
WHERE CteCFDInfoPagoD.Cliente = @Cliente
AND CteCFDInfoPagoD.InfoPago = @InfoPago
AND CteCFDInfoPagoD.FormaPago = @InfoFormaPago
END
IF NULLIF(@Resultado,'') IS NULL
BEGIN
IF @Ref = 1
BEGIN
SET @Resultado = dbo.fneDocEsNumero(RIGHT(@Referencia,4))
IF @Resultado IS NULL
SELECT @Resultado = dbo.fneDocEsNumero(RIGHT(Cta,4)) FROM CteCFD WHERE Cliente = @Cliente
END
ELSE
SET @Resultado = ISNULL(@FormaCobro, '')
END
IF ISNULL(@Resultado,'') = '' AND @Ref != 1
SELECT @Resultado = ISNULL(NULLIF(SATFormaPago.Clave,''), '') FROM Cxc JOIN Condicion ON Cxc.Condicion = Condicion.Condicion
LEFT JOIN SATFormaPago ON Condicion.CFD_formaDePago = SATFormaPago.Descripcion WHERE Cxc.ID = @ID
IF NULLIF(@Resultado,'') IS NULL
BEGIN
IF @Ref = 1
SET @Resultado = ISNULL(NULLIF(@Referencia,''),'No Aplica')
ELSE
BEGIN
IF NULLIF(@FormaCobroref,'') IS NULL AND @ValidarMetodoPago = 0
SET @Resultado = ISNULL(NULLIF(@FormaCobro,''), 'NA')
END
END
SET @Resultado = dbo.fnxpeDocCXCReferenciaMetodoCobro(@ID, @Ref, @Resultado)
RETURN RTRIM(LTRIM(@Resultado))
END

