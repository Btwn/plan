SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spDesglosarPrecioCImpuestos
@Articulo     varchar(20),
@Usuario      varchar(10),
@Empresa      varchar(5),
@Sucursal     int,
@Importe      float  OUTPUT,
@Cliente      varchar(10)= NULL,
@Modulo       varchar(5)= NULL,
@Mov          varchar(20)= NULL,
@Impuesto1    float = NULL OUTPUT,
@Impuesto2    float = NULL OUTPUT,
@Impuesto3    float = NULL OUTPUT,
@Impuestos	float = NULL OUTPUT

AS BEGIN
DECLARE
@ZonaImpuestoUsuario   varchar(50),
@ZonaImpuestoCliente   varchar(50),
@ZonaImpuesto          varchar(50),
@FechaEmision          datetime,
@EnviarA               int,
@Impuesto3Base         float,
@Impuesto2Base         float,
@Impuesto2BaseImpuesto1 float,
@Impuesto2Info         bit,
@Impuesto3Info         bit,
@cfgImpuestoIncluido   bit,
@eCommerceImpuestoIncluido bit
SELECT @cfgImpuestoIncluido = ISNULL(VentaPreciosImpuestoIncluido,0) FROM EmpresaCfg WHERE Empresa = @Empresa
SELECT @FechaEmision = dbo.fnFechaSinHora(GETDATE())
SELECT @eCommerceImpuestoIncluido = ISNULL(eCommerceImpuestoIncluido,0) FROM Sucursal WHERE Sucursal = @Sucursal
SELECT @ZonaImpuestoUsuario = u.DefZonaImpuesto
FROM Usuario u
WHERE u.Usuario = @Usuario
SELECT @ZonaImpuestoCliente = ZonaImpuesto
FROM Cte WHERE Cliente = @Cliente
SELECT @ZonaImpuesto = ISNULL(NULLIF(@ZonaImpuestoCliente,''),NULLIF(@ZonaImpuestoUsuario,'') )
SELECT @Impuesto1 = a.Impuesto1, @Impuesto2 = a.Impuesto2, @Impuesto3 = a.Impuesto3
FROM Art a
WHERE a.Articulo = @Articulo
EXEC spZonaImp @ZonaImpuesto, @Impuesto1 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto2 OUTPUT
EXEC spZonaImp @ZonaImpuesto, @Impuesto3 OUTPUT
EXEC spTipoImpuesto @Modulo, 0, @Mov, @FechaEmision, @Empresa, @Sucursal, @Cliente, @EnviarA, @Articulo = @Articulo, @EnSilencio = 1, @Impuesto1 = @Impuesto1 OUTPUT, @Impuesto2 = @Impuesto2 OUTPUT, @Impuesto3 = @Impuesto3 OUTPUT
SELECT @Impuesto2Info = Impuesto2Info,@Impuesto3Info = Impuesto3Info, @Impuesto2Info = Impuesto2Info
FROM Version
SELECT @Impuesto2Base = CASE WHEN @Impuesto2Info=1 THEN 0.0 ELSE @Impuesto2 END,
@Impuesto3Base = CASE WHEN @Impuesto3Info=1 THEN 0.0 ELSE @Impuesto3 END,
@Impuesto2BaseImpuesto1 = CASE WHEN @Impuesto2Info=1 OR @Impuesto2BaseImpuesto1=0 THEN 0.0 ELSE @Impuesto2 END
IF (@cfgImpuestoIncluido = 1 AND @eCommerceImpuestoIncluido =1)
BEGIN
SELECT @Impuestos = @Importe - (@Importe-ISNULL(@Impuesto3,0.0))/ (1.0 + (ISNULL(@Impuesto2, 0.0)/100) + ((ISNULL(@Impuesto1,0.0)/100) * (1+(ISNULL(@Impuesto2, 0.0)/100))))
END
IF(@cfgImpuestoIncluido = 0 AND @eCommerceImpuestoIncluido =0 )
BEGIN
SELECT @Impuestos = dbo.fnWebPrecioConImpuestos(@Importe,@Impuesto1,@Impuesto2,@Impuesto3) - @Importe
END
IF @cfgImpuestoIncluido = 1 AND @eCommerceImpuestoIncluido =0
BEGIN
SELECT @Impuestos = @Importe - (@Importe-ISNULL(@Impuesto3,0.0))/ (1.0 + (ISNULL(@Impuesto2, 0.0)/100) + ((ISNULL(@Impuesto1,0.0)/100) * (1+(ISNULL(@Impuesto2, 0.0)/100))))
SELECT @Importe = (@Importe-ISNULL(@Impuesto3,0.0))/ (1.0 + (ISNULL(@Impuesto2, 0.0)/100) + ((ISNULL(@Impuesto1,0.0)/100) * (1+(ISNULL(@Impuesto2, 0.0)/100))))
END
IF @cfgImpuestoIncluido = 0 AND @eCommerceImpuestoIncluido =1
BEGIN
SELECT @Impuestos = dbo.fnWebPrecioConImpuestos(@Importe,@Impuesto1,@Impuesto2,@Impuesto3) - @Importe
SELECT @Importe = dbo.fnWebPrecioConImpuestos(@Importe,@Impuesto1,@Impuesto2,@Impuesto3)
END
RETURN
END

