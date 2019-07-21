SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaGenerarGestion
@ID		int,
@RID		int,
@GestionMov	varchar(20),
@GestionAsunto	varchar(255),
@GestionPara	varchar(10)

AS BEGIN
DECLARE
@Empresa		char(5),
@Sucursal		int,
/*  @Moneda		varchar(10),
@TipoCambio		float,
@ContactoTipo	varchar(20),
@Contacto		varchar(10),
@Prospecto		varchar(10),
@Cliente		varchar(10),
@Proveedor		varchar(10),
@Personal		varchar(10),
@Agente		varchar(10),*/
@GestionID		int
IF NULLIF(RTRIM(@GestionMov), '') IS NULL RETURN
SELECT @Empresa = c.Empresa, @Sucursal = c.Sucursal
FROM Campana c
WHERE c.ID = @ID
/*  SELECT @ContactoTipo = ContactoTipo, @Contacto = Contacto FROM CampanaD WHERE ID = @ID AND RID = @RID
IF UPPER(@ContactoTipo) = 'PROSPECTO' SELECT @Prospecto = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'CLIENTE'   SELECT @Cliente   = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'PROVEEDOR' SELECT @Proveedor = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'PERSONAL'  SELECT @Personal  = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'AGENTEL'   SELECT @Agente    = @Contacto
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg, Mon m
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
*/
INSERT Gestion (
UltimoCambio, Sucursal,  SucursalOrigen, OrigenTipo, Origen, OrigenID, Empresa,   Usuario,   Estatus,      Mov,         FechaEmision,   Concepto,   UEN,   Referencia,   Observaciones,   Asunto/*,   Moneda,  TipoCambio,  ContactoTipo,  Prospecto,  Cliente,  Proveedor,  Personal,  Agente*/)
SELECT GETDATE(),    @Sucursal, @Sucursal,      'CMP',      c.Mov,  c.MovID,  c.Empresa, c.Usuario, 'SINAFECTAR', @GestionMov, c.FechaEmision, c.Concepto, c.UEN, c.Referencia, c.Observaciones, @GestionAsunto/*, @Moneda, @TipoCambio, @ContactoTipo, @Prospecto, @Cliente, @Proveedor, @Personal, @Agente*/
FROM Campana c
WHERE c.ID = @ID
SELECT @GestionID = SCOPE_IDENTITY()
INSERT GestionPara (
ID,          Usuario,      Participacion, Sucursal,  SucursalOrigen)
VALUES (@GestionID, @GestionPara, 'Requerido',   @Sucursal, @Sucursal)
EXEC spAfectar 'GES', @GestionID, @EnSilencio = 1
RETURN
END

