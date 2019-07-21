SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spVentaPendienteGenerar
@Estacion	int,
@Empresa	char(5),
@Sucursal	int,
@Usuario	char(10),
@FechaEmision	datetime,
@Mov		char(20) = NULL

AS BEGIN
DECLARE
@Almacen	char(10),
@Moneda	char(10),
@Cliente	char(10),
@EnviarA	int,
@Condicion	varchar(50),
@Concepto	varchar(50),
@Agente	char(10),
@Proyecto	varchar(50),
@UEN	int,
@ID		int,
@Conteo	int
SELECT @Conteo = 0
IF NULLIF(NULLIF(RTRIM(@Mov), '0'), '') IS NULL
SELECT @Mov = VentaFactura
FROM EmpresaCfgMov
WHERE Empresa = @Empresa
SELECT ID, Renglon, RenglonSub
INTO #ListaIDRenglon
FROM ListaIDRenglon
WHERE Modulo = 'VTAS'
DECLARE crListaClientes CURSOR FOR
SELECT v.Moneda, v.Cliente, v.EnviarA, v.Almacen, v.Condicion, v.Concepto, v.Agente, v.Proyecto, v.UEN
FROM #ListaIDRenglon l, Venta v
WHERE l.ID = v.ID
GROUP BY v.Moneda, v.Cliente, v.EnviarA, v.Almacen, v.Condicion, v.Concepto, v.Agente, v.Proyecto, v.UEN
ORDER BY v.Moneda, v.Cliente, v.EnviarA, v.Almacen, v.Condicion, v.Concepto, v.Agente, v.Proyecto, v.UEN
OPEN crListaClientes
FETCH NEXT FROM crListaClientes INTO @Moneda, @Cliente, @EnviarA, @Almacen, @Condicion, @Concepto, @Agente, @Proyecto, @UEN
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
INSERT Venta (Sucursal,  Empresa,  Mov,  FechaEmision,  Moneda,  TipoCambio,   Almacen,  Cliente,  EnviarA,  Condicion,  Concepto,  Usuario,  Estatus,     Agente,  Proyecto,  UEN)
SELECT @Sucursal, @Empresa, @Mov, @FechaEmision, @Moneda, m.TipoCambio, @Almacen, @Cliente, @EnviarA, @Condicion, @Concepto, @Usuario, 'CONFIRMAR', @Agente, @Proyecto, @UEN
FROM Mon m
WHERE m.Moneda = @Moneda
SELECT @ID = SCOPE_IDENTITY()
DELETE ListaIDRenglon WHERE Estacion = @Estacion
INSERT ListaIDRenglon (Estacion,  Modulo, ID,  Renglon,  RenglonSub)
SELECT @Estacion, 'VTAS', l.ID, l.Renglon, l.RenglonSub
FROM #ListaIDRenglon l, Venta v
WHERE l.ID = v.ID AND v.Moneda = @Moneda AND v.Cliente = @Cliente AND ISNULL(v.EnviarA, 0) = ISNULL(@EnviarA, 0) AND v.Almacen = @Almacen AND ISNULL(v.Condicion, '') = ISNULL(@Condicion, '') AND ISNULL(v.Concepto, '') = ISNULL(@Concepto, '') AND ISNULL(v.Agente, '') = ISNULL(@Agente, '') AND ISNULL(v.Proyecto, '') = ISNULL(@Proyecto, '') AND ISNULL(v.UEN, 0) = ISNULL(@UEN, 0)
EXEC spVentaPendienteAceptar @Estacion, @ID
SELECT @Conteo = @Conteo + 1
END
FETCH NEXT FROM crListaClientes INTO @Moneda, @Cliente, @EnviarA, @Almacen, @Condicion, @Concepto, @Agente, @Proyecto, @UEN
END 
CLOSE crListaClientes
DEALLOCATE crListaClientes
SELECT 'Se Generaron '+LTRIM(CONVERT(char, @Conteo))+ ' '+RTRIM(@Mov)+'(s), por Confirmar.'
RETURN
END

