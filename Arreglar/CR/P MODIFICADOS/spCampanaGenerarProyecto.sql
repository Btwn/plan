SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCampanaGenerarProyecto
@ID		int,
@RID		int,
@ProyectoMov	varchar(20),
@Plantilla	varchar(50)

AS BEGIN
DECLARE
@Empresa		char(5),
@Sucursal		int,
@Moneda		varchar(10),
@TipoCambio		float,
@ContactoTipo	varchar(20),
@Contacto		varchar(10),
@Prospecto		varchar(10),
@Cliente		varchar(10),
@Proveedor		varchar(10),
@Personal		varchar(10),
@Agente		varchar(10),
@ProyectoID		int
IF NULLIF(RTRIM(@ProyectoMov), '') IS NULL RETURN
SELECT @Plantilla = NULLIF(RTRIM(@Plantilla), '')
SELECT @ContactoTipo = ContactoTipo, @Contacto = Contacto FROM CampanaD WITH (NOLOCK) WHERE ID = @ID AND RID = @RID
IF UPPER(@ContactoTipo) = 'PROSPECTO' SELECT @Prospecto = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'CLIENTE'   SELECT @Cliente   = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'PROVEEDOR' SELECT @Proveedor = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'PERSONAL'  SELECT @Personal  = @Contacto ELSE
IF UPPER(@ContactoTipo) = 'AGENTEL'   SELECT @Agente    = @Contacto
SELECT @Empresa = c.Empresa, @Sucursal = c.Sucursal
FROM Campana c WITH (NOLOCK)
WHERE c.ID = @ID
SELECT @Moneda = m.Moneda, @TipoCambio = m.TipoCambio
FROM EmpresaCfg cfg WITH (NOLOCK), Mon m WITH (NOLOCK)
WHERE cfg.Empresa = @Empresa AND m.Moneda = cfg.ContMoneda
INSERT Proyecto (
UltimoCambio, Sucursal,  SucursalOrigen, OrigenTipo, Origen, OrigenID, Empresa,   Usuario,   Estatus,     Mov,          FechaEmision,   Concepto,   UEN,   Referencia,   Observaciones,   Moneda,  TipoCambio,  ContactoTipo,  Prospecto,  Cliente,  Proveedor,  Personal,  Agente)
SELECT GETDATE(),    @Sucursal, @Sucursal,      'CMP',      c.Mov,  c.MovID,  c.Empresa, c.Usuario, 'CONFIRMAR', @ProyectoMov, c.FechaEmision, c.Concepto, c.UEN, c.Referencia, c.Observaciones, @Moneda, @TipoCambio, @ContactoTipo, @Prospecto, @Cliente, @Proveedor, @Personal, @Agente
FROM Campana c WITH (NOLOCK)
WHERE c.ID = @ID
SELECT @ProyectoID = SCOPE_IDENTITY()
IF @Plantilla IS NOT NULL
EXEC spProyectoNuevo NULL, @ProyectoID, @Plantilla, @Sucursal
RETURN
END

