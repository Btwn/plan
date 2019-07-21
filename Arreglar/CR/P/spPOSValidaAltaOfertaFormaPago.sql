SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSValidaAltaOfertaFormaPago
@ID					int,
@Empresa			varchar(5),
@Estatus			varchar(15),
@TodasSucursales	bit,
@Sucursal			int,
@FormaPago			varchar(50),
@Descuento			float,
@MontoMinimo		float,
@FechaD				datetime,
@FechaA				datetime,
@HoraD				varchar(5),
@HoraA				varchar(5)

AS
BEGIN
DECLARE
@Resultado		bit
SET @Resultado = 0
IF @TodasSucursales = 1
BEGIN
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA' AND  FormaPago = @FormaPago  AND FechaD <= @FechaA AND FechaA >= @FechaD)
BEGIN
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA'
AND FormaPago = @FormaPago AND FechaD <= @FechaA AND FechaA >= @FechaD
AND (NULLIF(HoraD,'') IS NULL OR NULLIF(HoraA,'') IS NULL))
SELECT @Resultado = 1
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA'
AND FormaPago = @FormaPago AND FechaD <= @FechaA AND FechaA >= @FechaD
AND ((dbo.fnHoraEnEntero(@HoraD) + 1 BETWEEN dbo.fnHoraEnEntero(HoraD)
AND dbo.fnHoraEnEntero(ISNULL(HoraA,'12:00'))) OR
(dbo.fnHoraEnEntero(ISNULL(@HoraA,'12:00')) - 1 BETWEEN dbo.fnHoraEnEntero(HoraD)
AND dbo.fnHoraEnEntero(ISNULL(HoraA,'12:00')))))
SELECT @Resultado = 1
IF NULLIF(@HoraD,'') IS NULL OR NULLIF(@HoraA,'')IS NULL
SELECT @Resultado = 1
END
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA'
AND FormaPago = @FormaPago AND NULLIF(FechaA,'') IS NULL)
SELECT @Resultado = 1
END
ELSE
BEGIN
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA'
AND FormaPago = @FormaPago AND ((Sucursal = @Sucursal)OR (ISNULL(TodasSucursales,1) = 1))
AND FechaD <= @FechaA AND FechaA >= @FechaD)
BEGIN
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA'
AND FormaPago = @FormaPago AND ((Sucursal = @Sucursal)OR (ISNULL(TodasSucursales,1) = 1))
AND FechaD <= @FechaA AND FechaA >= @FechaD AND (NULLIF(HoraD,'') IS NULL OR NULLIF(HoraA,'') IS NULL))
SELECT @Resultado = 1
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA'
AND FormaPago = @FormaPago AND ((Sucursal = @Sucursal)OR (ISNULL(TodasSucursales,1) = 1))
AND FechaD <= @FechaA AND FechaA >= @FechaD AND ((dbo.fnHoraEnEntero(@HoraD) + 1 BETWEEN dbo.fnHoraEnEntero(HoraD)
AND dbo.fnHoraEnEntero(ISNULL(HoraA,'12:00'))) OR
(dbo.fnHoraEnEntero(ISNULL(@HoraA,'12:00')) - 1 BETWEEN dbo.fnHoraEnEntero(HoraD)
AND dbo.fnHoraEnEntero(ISNULL(HoraA,'12:00')))))
SELECT @Resultado = 1
IF NULLIF(@HoraD,'') IS NULL OR NULLIF(@HoraA,'')IS NULL
SELECT @Resultado = 1
END
IF EXISTS(SELECT * FROM  POSOfertaFormaPago WHERE ID <> @ID AND Estatus = 'ACTIVA'
AND FormaPago = @FormaPago AND ((Sucursal = @Sucursal) OR (ISNULL(TodasSucursales,1) = 1)) AND NULLIF(FechaA,'') IS NULL)
SELECT @Resultado = 1
END
SELECT @Resultado
END

