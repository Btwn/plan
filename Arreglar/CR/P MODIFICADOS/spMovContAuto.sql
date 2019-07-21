SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spMovContAuto
@Empresa		char(5),
@Sucursal		int,
@Modulo		char(5),
@ID			int,
@Estatus		char(15),
@EstatusNuevo	char(15),
@Usuario		char(10),
@FechaEmision	datetime,
@FechaRegistro	datetime,
@Mov			char(20),
@MovID		varchar(20),
@MovTipo		char(20),
@IDGenerar		int,
@Ok			int		OUTPUT,
@OkRef		varchar(255)	OUTPUT

AS BEGIN
DECLARE
@ContMov			varchar(20),
@AfectarPresupuesto		varchar(30),
@EstatusContabilizar	varchar(15),
@EstatusMovTipo		varchar(15),
@ContAutoEmpresa		varchar(10)
SELECT @EstatusMovTipo = NULLIF(RTRIM(EstatusContabilizar), ''),
@AfectarPresupuesto = NULLIF(NULLIF(RTRIM(AfectarPresupuesto), ''), '(por Omision)')
FROM MovTipo WITH(NOLOCK)
WHERE Modulo = @Modulo AND Mov = @Mov
IF @EstatusMovTipo = '(por Omision) W'
BEGIN
SELECT @EstatusMovTipo = '(por Omision)'
UPDATE MovTipo WITH(ROWLOCK) SET EstatusContabilizar = '(por Omision)' WHERE EstatusContabilizar = '(por Omision) W'
END
SELECT @ContMov = NULLIF(RTRIM(ContMov), ''),
@EstatusContabilizar = NULLIF(RTRIM(EstatusContabilizar), ''),
@AfectarPresupuesto = ISNULL(@AfectarPresupuesto, ISNULL(NULLIF(RTRIM(AfectarPresupuesto), ''), 'No'))
FROM MovClave WITH(NOLOCK)
WHERE Clave = @MovTipo
IF UPPER(@EstatusMovTipo) NOT IN (NULL, '(POR OMISION)') SELECT @EstatusContabilizar = @EstatusMovTipo
IF EXISTS(SELECT * FROM MovTipoContAuto WITH(NOLOCK) WHERE Empresa = @Empresa  AND Modulo = @Modulo AND Clave IN ('('+RTRIM(@MovTipo)+')', @Mov)) SELECT @ContAutoEmpresa = @Empresa ELSE
IF EXISTS(SELECT * FROM MovTipoContAuto WITH(NOLOCK) WHERE Empresa = '(Todas)' AND Modulo = @Modulo AND Clave IN ('('+RTRIM(@MovTipo)+')', @Mov)) SELECT @ContAutoEmpresa = '(Todas)'
IF NOT(@ContMov IS NOT NULL AND (@EstatusNuevo = @EstatusContabilizar OR (@Estatus IN (@EstatusContabilizar, 'CONCLUIDO') AND @EstatusNuevo = 'CANCELADO')))
SELECT @ContAutoEmpresa = NULL
IF (@ContAutoEmpresa IS NOT NULL AND @ContMov IS NOT NULL) OR @AfectarPresupuesto <> 'No'
EXEC spContAuto @Empresa, @Sucursal, @Modulo,  @ID, @Estatus, @EstatusNuevo, @Usuario, @FechaEmision, @FechaRegistro, @Mov, @MovID, @MovTipo, @ContMov, @Ok OUTPUT, @OkRef OUTPUT, @ContAutoEmpresa = @ContAutoEmpresa
END

