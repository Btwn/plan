SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spActivoFijoVerificar
@ID               		int,
@Accion			char(20),
@Empresa          		char(5),
@Usuario			char(10),
@Modulo	      		char(5),
@Mov              		char(20),
@MovID			varchar(20),
@MovTipo	      		char(20),
@MovMoneda			char(10),
@FechaEmision		datetime,
@Condicion			varchar(50),
@Vencimiento		datetime,
@Estatus			char(15),
@EstatusNuevo		char(15),
@Ejercicio	      		int,
@Periodo	      		int,
@Personal			char(10),
@Espacio			char(10),
@ContUso			varchar(20),
@ContUso2			varchar(20),
@ContUso3			varchar(20),
@Todo			bit,
@Revaluar			bit,
@ValorMercado		bit,
@CfgTabla			varchar(50),
@Conexion			bit,
@SincroFinal		bit,
@Sucursal			int,
@FormaPago			varchar(50),
@Ok               		int          OUTPUT,
@OkRef            		varchar(255) OUTPUT,
@SubClave			varchar(20) = NULL,
@SubClaveFiscal		int	    = NULL

AS BEGIN
DECLARE
@Articulo			char(20),
@Serie			varchar(50),
@ActivoFEstatus		char(15),
@SeguroVence		datetime,
@MantenimientoVence	datetime,
@VidaUtil			int,
@DepreciacionMeses		int,
@Moneda			char(10),
@AFEspacio			char(10),
@AFResponsable		char(10),
@AFContUso			varchar(20),
@AFContUso2		varchar(20),
@AFContUso3		varchar(20),
@AFCategoria		varchar(50)
IF @Accion = 'CANCELAR'
BEGIN
IF @Conexion = 0
IF EXISTS (SELECT * FROM MovFlujo WHERE Cancelado = 0 AND Empresa = @Empresa AND DModulo = @Modulo AND DID = @ID AND OModulo <> DModulo)
SELECT @Ok = 60070
END ELSE
BEGIN
IF @MovTipo IN ('AF.A', 'AF.D') AND @Ok IS NULL
IF (@Personal IS NULL AND @Espacio IS NULL AND @ContUso IS NULL AND @ContUso2 IS NULL AND @ContUso3 IS NULL) OR (@Personal IS NOT NULL AND @Espacio IS NOT NULL AND @ContUso IS NOT NULL AND @ContUso2 IS NOT NULL AND @ContUso3 IS NOT NULL) SELECT @Ok = 55105
IF @MovTipo IN ('AF.PM', 'AF.PS') AND @Ok IS NULL
EXEC spVerificarVencimiento @Condicion, @Vencimiento, @FechaEmision, @Ok OUTPUT
IF @MovTipo IN('AF.PS', 'AF.PM', 'AF.RE', 'AF.MA') AND @Ok IS NULL AND NULLIF(@FormaPago, '') IS NOT NULL
BEGIN
IF dbo.fnFormaPagoVerificar(@Empresa, @FormaPago, @Modulo, @Mov, @Usuario, '(Forma Pago)', 0) = 0
SELECT @Ok = 30600, @OkRef = dbo.fnIdiomaTraducir(@Usuario, 'Forma Pago') + '. ' + @FormaPago
END
IF @Ok IS NOT NULL RETURN
IF @MovTipo IN ('AF.DP', 'AF.RV') AND @Todo = 1 RETURN
DECLARE crVerificarActivoFijo CURSOR FOR
SELECT NULLIF(RTRIM(d.Articulo), ''), NULLIF(RTRIM(d.Serie), ''), NULLIF(RTRIM(af.Estatus), ''), af.MantenimientoVence, af.SeguroVence,
ISNULL(CASE @SubClaveFiscal WHEN 1 THEN af.VidaUtilF	  WHEN 2 THEN af.VidaUtilF2	     ELSE af.VidaUtil END, 0),
ISNULL(CASE @SubClaveFiscal WHEN 1 THEN af.DepreciacionMesesF WHEN 2 THEN af.DepreciacionMesesF2 ELSE af.DepreciacionMeses END, 0),
RTRIM(af.Moneda), NULLIF(RTRIM(af.Responsable), ''), NULLIF(RTRIM(af.Espacio), ''), NULLIF(RTRIM(af.CentroCostos), ''), NULLIF(RTRIM(af.Categoria), ''),
NULLIF(RTRIM(af.ContUso2), ''), NULLIF(RTRIM(af.ContUso3), '')
FROM ActivoFijoD d
LEFT OUTER JOIN ActivoF af ON d.Articulo = af.Articulo AND d.Serie = af.Serie AND af.Empresa = @Empresa
WHERE d.ID = @ID
OPEN crVerificarActivoFijo
FETCH NEXT FROM crVerificarActivoFijo INTO @Articulo, @Serie, @ActivoFEstatus, @MantenimientoVence, @SeguroVence, @VidaUtil, @DepreciacionMeses, @Moneda, @AFResponsable, @AFEspacio, @AFContUso, @AFCategoria, @AFContUso2, @AFContUso3
IF @@FETCH_STATUS = -1 SELECT @Ok = 60010
WHILE @@FETCH_STATUS <> -1 AND @Ok IS NULL
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
IF @MovTipo IN ('AF.DP', 'AF.DT', 'AF.RV')
IF (SELECT UPPER(Propietario) FROM ActivoFCat WHERE Categoria = @AFCategoria) <> 'EMPRESA' SELECT @Ok = 44190
IF @MovTipo IN ('AF.DP', 'AF.DT') AND (@VidaUtil - @DepreciacionMeses) <= 0 SELECT @Ok = 44080 ELSE
IF @ActivoFEstatus IN (NULL, 'INACTIVO') SELECT @Ok = 44030 ELSE
IF @MovTipo = 'AF.RE' AND @Estatus = 'PENDIENTE' AND @ActivoFEstatus <> 'REPARACION'    SELECT @Ok = 44050 ELSE
IF @MovTipo = 'AF.MA' AND @Estatus = 'PENDIENTE' AND @ActivoFEstatus <> 'MANTENIMIENTO' SELECT @Ok = 44060 ELSE
IF @Estatus IN ('CONCLUIDO', 'VIGENTE') AND @ActivoFEstatus <> 'ACTIVO' SELECT @Ok = 44030
IF @MovTipo = 'AF.PM' AND @Estatus = 'VIGENTE' AND @MantenimientoVence IS NOT NULL AND @FechaEmision < @MantenimientoVence SELECT @Ok = 44070 ELSE
IF @MovTipo = 'AF.PS' AND @Estatus = 'VIGENTE' AND @SeguroVence IS NOT NULL AND @FechaEmision < @SeguroVence SELECT @Ok = 44070 ELSE
IF @MovTipo IN ('AF.DP', 'AF.DT', 'AF.RV') AND @MovMoneda <> @Moneda SELECT @Ok = 44090
IF @MovTipo IN ('AF.A', 'AF.D')
BEGIN
IF @Espacio IS NOT NULL AND @Ok IS NULL
BEGIN
IF @MovTipo = 'AF.A' AND @AFEspacio IS NOT NULL  SELECT @Ok = 44130 ELSE
IF @MovTipo = 'AF.D' AND @AFEspacio IS NULL      SELECT @Ok = 44140 ELSE
IF @MovTipo = 'AF.D' AND @AFEspacio <> @Espacio  SELECT @Ok = 44150
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie) + ' ('+RTRIM(@AFEspacio)+')'
END
IF @Personal IS NOT NULL AND @Ok IS NULL
BEGIN
IF @MovTipo = 'AF.A' AND @AFResponsable IS NOT NULL  SELECT @Ok = 44130 ELSE
IF @MovTipo = 'AF.D' AND @AFResponsable IS NULL      SELECT @Ok = 44140 ELSE
IF @MovTipo = 'AF.D' AND @AFResponsable <> @Personal SELECT @Ok = 44150
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie) + ' ('+RTRIM(@AFResponsable)+')'
END
IF @ContUso IS NOT NULL AND @Ok IS NULL
BEGIN
IF @MovTipo = 'AF.A' AND @AFContUso IS NOT NULL SELECT @Ok = 44130 ELSE
IF @MovTipo = 'AF.D' AND @AFContUso IS NULL     SELECT @Ok = 44140 ELSE
IF @MovTipo = 'AF.D' AND @AFContUso <> @ContUso SELECT @Ok = 44150
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie) + ' ('+RTRIM(@AFContUso)+')'
END
IF @ContUso2 IS NOT NULL AND @Ok IS NULL
BEGIN
IF @MovTipo = 'AF.A' AND @AFContUso2 IS NOT NULL  SELECT @Ok = 44130 ELSE
IF @MovTipo = 'AF.D' AND @AFContUso2 IS NULL      SELECT @Ok = 44140 ELSE
IF @MovTipo = 'AF.D' AND @AFContUso2 <> @ContUso2 SELECT @Ok = 44150
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie) + ' ('+RTRIM(@AFContUso2)+')'
END
IF @ContUso3 IS NOT NULL AND @Ok IS NULL
BEGIN
IF @MovTipo = 'AF.A' AND @AFContUso3 IS NOT NULL  SELECT @Ok = 44130 ELSE
IF @MovTipo = 'AF.D' AND @AFContUso3 IS NULL      SELECT @Ok = 44140 ELSE
IF @MovTipo = 'AF.D' AND @AFContUso3 <> @ContUso3 SELECT @Ok = 44150
IF @Ok IS NOT NULL SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie) + ' ('+RTRIM(@AFContUso3)+')'
END
END
IF @Ok IS NOT NULL AND @OkRef IS NULL
SELECT @OkRef = RTRIM(@Articulo)+' - '+RTRIM(@Serie)
END
FETCH NEXT FROM crVerificarActivoFijo INTO @Articulo, @Serie, @ActivoFEstatus, @MantenimientoVence, @SeguroVence, @VidaUtil, @DepreciacionMeses, @Moneda, @AFResponsable, @AFEspacio, @AFContUso, @AFCategoria, @AFContUso2, @AFContUso3
IF @@ERROR <> 0 SELECT @Ok = 1
END  
CLOSE crVerificarActivoFijo
DEALLOCATE crVerificarActivoFijo
END
RETURN
END

