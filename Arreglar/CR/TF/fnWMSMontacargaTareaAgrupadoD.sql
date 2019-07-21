SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION dbo.fnWMSMontacargaTareaAgrupadoD(@Estacion int)
RETURNS @WMSMontacargaTareaAgrupadoD TABLE
(ID                              int identity,
Mov                             varchar(20) NULL,
Estacion						int NULL,
Almacen                         varchar(20) NULL,
Tarima                          varchar(20) NULL,
NoCajas                         float NULL,
Sucursal                        int NULL,
NomSucursal                     varchar(20) NULL,
Pasillo                         varchar(20) NULL,
PosicionOrigen                  varchar(10) NULL,
PosicionDestino                 varchar(10) NULL,
Articulo                        varchar(20) NULL,
Descripcion1                    varchar(255) NULL,
Montacarga                      varchar(20) NULL,
Cuenta                          varchar(20) NULL,
Guia                            int NULL
)
AS BEGIN
DECLARE
@IDAgrupar AS TABLE (ID int, IDO int)
INSERT INTO @WMSMontacargaTareaAgrupadoD
SELECT Mov,
Estacion,
Almacen,
Tarima,
SUM(ISNULL(NoCajas,0)),
Sucursal,
NomSucursal,
Pasillo,
PosicionOrigen,
PosicionDestino,
Articulo,
Descripcion1,
Montacarga,
Cuenta,
Guia
FROM  dbo.fnWMSMontacargaTareaAgrupado (@Estacion)
GROUP BY  Mov,
Estacion,
Almacen,
Tarima,
Sucursal,
NomSucursal,
Pasillo,
PosicionOrigen,
PosicionDestino,
Articulo,
Descripcion1,
Montacarga,
Cuenta,
Guia
RETURN
END

