SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spOportunidadActividadEliminar
@ID					int,
@Renglon			int,
@RenglonSub			int,
@IDGestion			int,
@Tipo				varchar(20),
@Clave				varchar(50),
@PorcentajeAvance	float,
@Ok					int			 = NULL OUTPUT,
@OkRef				varchar(255) = NULL OUTPUT

AS
BEGIN
DECLARE @OkDesc           	varchar(255),
@OkTipo           	varchar(50)
IF @IDGestion IS NOT NULL
SELECT @Ok = 14083, @OkRef = @Clave
IF @Ok IS NULL
DELETE OportunidadD WHERE ID = @ID AND Renglon = @Renglon AND RenglonSub = @RenglonSub
IF @Ok IS NULL
SELECT @OkRef = NULL
ELSE
SELECT @OkDesc = Descripcion,
@OkTipo = Tipo
FROM MensajeLista
WHERE Mensaje = @Ok
SELECT @Ok, @OkDesc, @OkTipo, @OkRef, NULL
RETURN
END

