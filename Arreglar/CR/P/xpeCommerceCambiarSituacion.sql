SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpeCommerceCambiarSituacion
@Modulo              char(5),
@ID                  int,
@Situacion           char(50),
@SituacionFecha      datetime,
@Usuario             char(10),
@SituacionUsuario    varchar(10) = NULL,
@SituacionNota       varchar(100) = NULL
AS BEGIN
DECLARE
@eCommerce   bit,
@OrigenID    int ,
@Sucursal    int,
@Mov         varchar(20),
@MovID       varchar(20),
@Estatus     varchar(15),
@eCommerceSucursal varchar(20)
SELECT @eCommerce = dbo.fneCommerceOrigen(@Modulo,@ID,1)
IF ISNULL(@eCommerce,0) = 1
AND EXISTS (SELECT * FROM WebSituacionEstatus w WHERE w.Modulo = @Modulo AND 
w.Mov = CASE   WHEN @Modulo = 'CONT' THEN (SELECT Mov FROM  Cont        WHERE ID = @ID)
WHEN @Modulo = 'VTAS' THEN (SELECT Mov FROM  Venta       WHERE ID = @ID)
WHEN @Modulo = 'PROD' THEN (SELECT Mov FROM  Prod        WHERE ID = @ID)
WHEN @Modulo = 'COMS' THEN (SELECT Mov FROM  Compra      WHERE ID = @ID)
WHEN @Modulo = 'INV'  THEN (SELECT Mov FROM  Inv         WHERE ID = @ID)
WHEN @Modulo = 'CXC'  THEN (SELECT Mov FROM  Cxc         WHERE ID = @ID)
WHEN @Modulo = 'CXP'  THEN (SELECT Mov FROM  Cxp         WHERE ID = @ID)
WHEN @Modulo = 'AGENT'THEN (SELECT Mov FROM  Agent       WHERE ID = @ID)
WHEN @Modulo = 'GAS'  THEN (SELECT Mov FROM  Gasto       WHERE ID = @ID)
WHEN @Modulo = 'DIN'  THEN (SELECT Mov FROM  Dinero      WHERE ID = @ID)
WHEN @Modulo = 'EMB'  THEN (SELECT Mov FROM  Embarque    WHERE ID = @ID)
WHEN @Modulo = 'NOM'  THEN (SELECT Mov FROM  Nomina      WHERE ID = @ID)
WHEN @Modulo = 'RH'   THEN (SELECT Mov FROM  RH          WHERE ID = @ID)
WHEN @Modulo = 'ASIS' THEN (SELECT Mov FROM  Asiste      WHERE ID = @ID)
WHEN @Modulo = 'AF'   THEN (SELECT Mov FROM  ActivoFijo  WHERE ID = @ID)
WHEN @Modulo = 'PC'   THEN (SELECT Mov FROM  PC          WHERE ID = @ID)
WHEN @Modulo = 'VALE' THEN (SELECT Mov FROM  Vale        WHERE ID = @ID)
WHEN @Modulo = 'ST'   THEN (SELECT Mov FROM  Soporte     WHERE ID = @ID)
WHEN @Modulo = 'CAM'  THEN (SELECT Mov FROM  Cambio      WHERE ID = @ID) END
)
BEGIN
DECLARE crSucursal CURSOR local FOR
SELECT Sucursal, eCommerceSucursal
FROM Sucursal
WHERE eCommerce = 1 AND NULLIF(eCommerceSucursal,'') IS NOT NULL
OPEN crSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT @OrigenID = ISNULL(dbo.fneCommerceIDOrigen(@Modulo,@ID,1),@ID)
EXEC spMovInfo @ID, @Modulo, @Mov = @Mov OUTPUT, @MovID = @MovID OUTPUT, @Estatus = @Estatus OUTPUT
EXEC speCommerceSolicitudISWebMovSituacion @OrigenID,@Modulo,@ID, @Estatus, @Sucursal, @eCommerceSucursal
FETCH NEXT FROM crSucursal INTO @Sucursal, @eCommerceSucursal
END
CLOSE crSucursal
DEALLOCATE crSucursal
END
RETURN
END

