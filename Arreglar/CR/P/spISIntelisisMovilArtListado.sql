SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.spISIntelisisMovilArtListado
@ID				int,
@iSolicitud		int,
@Version		float,
@Resultado		varchar(max) = NULL OUTPUT,
@Ok				int = NULL OUTPUT,
@OkRef			varchar(255) = NULL OUTPUT

AS BEGIN
BEGIN TRY
DECLARE
@Agente		    varchar(10),
@Cliente	    varchar(100),
@Usuario	    varchar(10),
@Articulo	    varchar(20),
@Empresa        char(5),
@Sucursal       int,
@Movimiento     varchar(20),
@Moneda         char(10),
@GUID           varchar(50),
@ArticuloOferta varchar(20)
DECLARE @XMLArt XML, @XOpciones XML, @XOpcion XML, @XListaPrecios XML, @XDetalle XML
SELECT @Usuario = Usuario,
@Cliente = Cliente
FROM OPENXML (@iSolicitud,'/Intelisis/Solicitud')
WITH (Usuario varchar(10), Cliente varchar(100))
SELECT @Agente     = Agente,
@Empresa    = Empresa,
@Sucursal    = Sucursal,
@Movimiento = Movimiento
FROM MovilUsuarioCfg
WHERE Usuario = @Usuario
IF ISNULL(@Sucursal,0) = 0
SET @Sucursal = 0
SET @Resultado = '<MovilArtListado>'
SELECT @Moneda      = ContMoneda,
@GUID        = @@SPID
FROM EmpresaCfg C
WHERE c.Empresa = @Empresa
DELETE OfertaMovilTemp WHERE GUID = @GUID
INSERT OfertaMovilTemp(
GUID,		         Empresa,	  Sucursal,				Almacen,
Agente,		     Movimiento,  Moneda,				ListaPrecios,
Articulo,	         SubCuenta,   Unidad,				PrecioSugerido,
Precio,		     Descuento,	  DescuentoImporte,		Comision,
ComisionPorcentaje, OfertaID)
SELECT DISTINCT @GUID GUID,		c.Empresa,				@Sucursal Sucursal,				null,
c.Agente,					@Movimiento Movimiento,	ISNULL(NULLIF(e.DefMoneda,''),  ISNULL(lp.Moneda,@Moneda)) Moneda,	ISNULL(ISNULL(NULLIF(d.ListaPreciosEsp,''),e.ListaPreciosEsp), lp.Lista) ListaPreciosEsp,
lp.Articulo,				NULL SubCuenta,			a.Unidad,						lp.Precio PrecioSugerido,			lp.Precio,
0.00 Descuento,		    0.00 DescuentoImporte,	0.00 Comision,					0.00 ComisionPorcentaje,			NULL OfertaID
FROM Campana c
JOIN CampanaD d on c.ID = d.ID
JOIN Cte e on d.Contacto = e.Cliente
JOIN CampanaTipoSituacion t on d.Situacion = t.Situacion
JOIN MovTipo m on c.Mov = m.Mov AND m.Modulo = 'CMP'
JOIN ListaPreciosD lp ON ISNULL(ISNULL(NULLIF(d.ListaPreciosEsp,''),e.ListaPreciosEsp), lp.Lista) = lp.Lista
JOIN Art a ON lp.Articulo = a.Articulo AND a.ESTATUS = 'ALTA'
JOIN SaldoU s ON a.Articulo = s.Cuenta AND s.Empresa = @Empresa
JOIN Alm al ON s.Grupo = al.Almacen AND al.Sucursal = @Sucursal
WHERE m.Clave = 'CMP.A' AND c.Estatus ='PENDIENTE' AND t.AccionMovil IN('Sincronizado','Por Sincronizar') AND c.Agente = @Agente AND e.Nombre = ISNULL(@Cliente, e.Nombre)
INSERT OfertaMovilTemp(
GUID,		         Empresa,	  Sucursal,				Almacen,
Agente,		     Movimiento,  Moneda,				ListaPrecios,
Articulo,	         SubCuenta,   Unidad,				PrecioSugerido,
Precio,		     Descuento,	  DescuentoImporte,		Comision,
ComisionPorcentaje, OfertaID)
SELECT DISTINCT @GUID,    @Empresa,	  ISNULL(@Sucursal, 0),			 MT.Almacen,
c.Agente,	         @Movimiento, ISNULL(NULLIF(c.DefMoneda,''), ISNULL(pd.Moneda,@Moneda)), ISNULL(c.ListaPreciosEsp,''),
pd.Articulo,        NULL,		  a.Unidad,					     pd.Precio,
pd.Precio,	         0.00,		  0.00,						     0.00,
0.00,	             NULL
FROM Cte c
JOIN ListaPrecios p ON c.ListaPreciosEsp = p.Lista
JOIN ListaPreciosD pd ON p.Lista = pd.Lista
JOIN Art a ON pd.Articulo = a.Articulo AND a.ESTATUS = 'ALTA'
LEFT JOIN OfertaMovilTemp MT ON a.Articulo = MT.Articulo AND c.ListaPreciosEsp = MT.ListaPrecios AND MT.GUID = @GUID
WHERE c.Agente = @Agente AND MT.Articulo IS NULL AND MT.Sucursal = @Sucursal
INSERT OfertaMovilTemp(
GUID,		         Empresa,	  Sucursal,				MT.Almacen,
Agente,		     Movimiento,  Moneda,				ListaPrecios,
Articulo,	         SubCuenta,   Unidad,				PrecioSugerido,
Precio,		     Descuento,	  DescuentoImporte,		Comision,
ComisionPorcentaje, OfertaID)
SELECT DISTINCT @GUID,    @Empresa,	  ISNULL(@Sucursal, 0),			 NULL,
c.Agente,	         @Movimiento, ISNULL(@Moneda,''),            ISNULL(c.ListaPreciosEsp,''),
pd.Articulo,        NULL,		  a.Unidad,					     pd.Precio,
pd.Precio,	         0.00,		  0.00,						     0.00,
0.00,	             NULL
FROM CteEnviarA c
JOIN ListaPrecios p ON c.ListaPreciosEsp = p.Lista
JOIN ListaPreciosD pd ON p.Lista = pd.Lista
JOIN Art a ON pd.Articulo = a.Articulo AND a.ESTATUS = 'ALTA'
LEFT JOIN OfertaMovilTemp MT ON a.Articulo = MT.Articulo AND c.ListaPreciosEsp = MT.ListaPrecios AND MT.GUID = @GUID
WHERE c.Agente = @Agente AND MT.Articulo IS NULL AND MT.Sucursal = @Sucursal
DECLARE @Result TABLE(ID int identity(1,1), Parcial varchar(max)NOT NULL)
INSERT @Result(Parcial)VALUES(@Resultado)
IF @@Version LIKE '%2005%' OR @@Version LIKE '%2008%' OR @@Version LIKE '%2012%' OR @@Version LIKE '%2014%' OR @@Version LIKE '%2016%'
BEGIN
DECLARE crArticulos CURSOR FOR
SELECT Articulo
FROM OfertaMovilTemp
WHERE GUID = @@SPID
GROUP BY Articulo
OPEN crArticulos
FETCH NEXT FROM crArticulos INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT @Result(Parcial)
SELECT ISNULL(CAST(dbo.fnISGetArtOpcion(@Articulo, @Agente, @GUID) AS NVARCHAR(MAX)),'')
FETCH NEXT FROM crArticulos INTO @Articulo
END
CLOSE crArticulos
DEALLOCATE crArticulos
SELECT @Resultado = dbo.clrconcatenate(Parcial)
FROM @Result
SET @Resultado = @Resultado + '</MovilArtListado>'
END
ELSE
BEGIN
DECLARE crArticulos CURSOR FOR
SELECT Articulo
FROM OfertaMovilTemp
WHERE GUID = @@SPID
GROUP BY Articulo
OPEN crArticulos
FETCH NEXT FROM crArticulos INTO @Articulo
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @Resultado = @Resultado + ISNULL(CAST(dbo.fnISGetArtOpcion(@Articulo, @Agente, @GUID) AS NVARCHAR(MAX)),'')
FETCH NEXT FROM crArticulos INTO @Articulo
END
CLOSE crArticulos
DEALLOCATE crArticulos
SET @Resultado = @Resultado + '</MovilArtListado>'
END
END TRY
BEGIN CATCH
SELECT @OkRef = REPLACE(ERROR_MESSAGE(), '"', ''), @Ok = 1
select ERROR_MESSAGE()
END CATCH
IF @Ok IS NOT NULL
SET @OkRef = (SELECT Descripcion FROM MensajeLista WHERE Mensaje = @Ok)
END

