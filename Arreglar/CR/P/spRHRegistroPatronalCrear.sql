SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spRHRegistroPatronalCrear
@ID              int

AS BEGIN
DECLARE
@Ok                 int,
@OkRef              varchar(255),
@Personal           varchar(10),
@Empresa            varchar(5),
@Sucursal           int,
@Categoria          varchar(50),
@Departamento       varchar(50),
@Puesto             varchar(20),
@Propiedad          varchar(50),
@Valor              varchar(255),
@Renglon            float
SELECT @Propiedad = 'Registro Patronal', @Renglon = 0.0
DECLARE crPersonal CURSOR LOCAL FOR
SELECT Renglon FROM RHD WHERE ID = @ID
OPEN crPersonal
FETCH NEXT FROM crPersonal INTO @Renglon
WHILE @@FETCH_STATUS = 0 AND @Ok IS NULL
BEGIN
SELECT @Personal      = r.Personal,
@Empresa       = p.Empresa,
@Sucursal      = r.SucursalTrabajo,
@Categoria     = r.Categoria,
@Departamento  = r.Departamento,
@Puesto        = r.Puesto
FROM RHD r
JOIN Personal p ON r.Personal = p.Personal
WHERE r.ID = @ID AND r.Renglon = @Renglon
EXEC spPersonalPropValor @Empresa, @Sucursal, @Categoria, @Puesto, @Personal, @Propiedad, @Valor OUTPUT
IF NULLIF(@Valor, '') IS NOT NULL
IF NOT EXISTS(SELECT * FROM RHRegistroPatronal WHERE ID = @ID AND RegistroPatronal = @Valor)
INSERT RHRegistroPatronal(ID, RegistroPatronal, Estatus)
VALUES(@ID, @Valor, 'SINAFECTAR')
FETCH NEXT FROM crPersonal INTO @Renglon
END
CLOSE crPersonal
DEALLOCATE crPersonal
RETURN
END

