<?php
header('Content-Type: application/json');

// ---------- CONECTAR CON LA BASE DE DATOS ----------

// -- PARA CELULAR FÍSICO --
/*function conectarBD() {
    $conexion = new mysqli("192.168.0.71", "", "", "hamburgueseria");

    if ($conexion->connect_error) {
        die(json_encode(["error" => "Fallo la conexión: " . $conexion->connect_error]));
    }

    return $conexion;
}*/

/*function conectarBD() {
    $host = "ankaraburger.kesug.com"; // lo que diga tu panel
    $user = "if0_39346449";    // tu usuario MySQL
    $pass = "endemini1973";       // la que te da
    $dbname = "if0_39346449_hamburgueseria"; // nombre completo

    $conexion = new mysqli($host, $user, $pass, $dbname);
    if ($conexion->connect_error) {
        die("Error de conexión: " . $conexion->connect_error);
    }
    return $conexion;
}*/


// -- PARA ANDROID STUDIO --
function conectarBD() {
    $conexion = new mysqli("localhost", "", "", "hamburgueseria");

    if ($conexion->connect_error) {
        die(json_encode(["error" => "Fallo la conexión: " . $conexion->connect_error]));
    }

    return $conexion;
}

// ---------- OBTENER PRODUCTOS ----------

function obtenerProductos() {
    $conexion = conectarBD();

    $sql = "SELECT id_Producto, Nombre, Descripcion, Imagen, Precio FROM producto WHERE Disponible = 1";
    $resultado = $conexion->query($sql);

    $productos = [];

    while ($producto = $resultado->fetch_assoc()) {
        $idProducto = $producto['id_Producto'];

        $sqlIng = "SELECT i.NombreIngrediente, iep.Cantidad 
                   FROM IngredientesEnProducto iep
                   JOIN Ingrediente i ON iep.id_Ingrediente = i.id_Ingrediente
                   WHERE iep.id_Producto = $idProducto";

        $resIng = $conexion->query($sqlIng);

        $ingredientes = [];
        while ($filaIng = $resIng->fetch_assoc()) {
            $ingredientes[$filaIng['NombreIngrediente']] = (int)$filaIng['Cantidad'];
        }

        if (empty($ingredientes)) {
            $ingredientes = new stdClass();
        }

        $productos[] = [
            "nombre_Producto" => $producto["Nombre"],
            "imagen" => $producto["Imagen"],
            "descripcion" => $producto["Descripcion"],
            "precio_unitario" => (float)$producto["Precio"],
            "ingredientes" => $ingredientes
        ];
    }

    echo json_encode($productos, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
}

// ---------- OBTENER MESAS ----------

function obtenerMesas() {
    $conexion = conectarBD();

    $sql = "SELECT * FROM mesa";
    $resultado = $conexion->query($sql);

    $mesas = [];

    while ($row = $resultado->fetch_assoc()) {
        $mesas[] = $row;
    }

    echo json_encode($mesas, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
}

// ---------- MODIFICAR ESTADO DE MESA ----------

function cambiarEstadoMesa($idMesa, $estadoNuevo) {
    $conexion = conectarBD();

    $sql = "UPDATE mesa SET EstadoPedido = $estadoNuevo WHERE id_Mesa = $idMesa";
    $resultado = $conexion->query($sql);

    if ($resultado === TRUE) {
        echo json_encode(["success" => true, "message" => "Estado actualizado correctamente"]);
    } else {
        echo json_encode(["success" => false, "error" => $conexion->error]);
    }
}

// ---------- OBTENER ESTADO DE MESA ----------

function obtenerEstadoMesa($idMesa) {
    $conexion = conectarBD();

    $sql = "SELECT EstadoPedido FROM mesa WHERE id_Mesa = $idMesa";
    $estado = $conexion->query($sql);

    if ($estado === TRUE) {
        echo json_encode(["success" => true, "message" => "Estado devuelto correctamente"]);
    } else {
        echo json_encode(["success" => false, "error" => $conexion->error]);
    }

    echo json_encode($estado, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
}

// ---------- BUSCAR PRODUCTO ----------

function buscarIdProducto($nombreProducto) {
    $conexion = conectarBD();

    // Evitar inyecciones SQL usando prepared statements
    $nombreProducto = $conexion->real_escape_string($nombreProducto);

    $sql = "SELECT id_Producto FROM producto WHERE Nombre = '$nombreProducto' LIMIT 1";
    $resultado = $conexion->query($sql);

    if ($resultado && $fila = $resultado->fetch_assoc()) {
        return $fila['id_Producto'];
    } else {
        // No se encontró el producto, podés loguear o manejar el error
        return null; // o -1
    }
}


// ---------- AGREGAR PEDIDO ----------

function agregarPedido($idMesa, $id_Producto, $cantPorProducto, $estadoPedido, $precioPorProducto) {
    $conexion = conectarBD();

    // Verificar si ya existe un pedido activo para esta mesa
    $sql = "SELECT id_Pedido FROM pedidos WHERE id_Mesa = $idMesa AND EstadoPedido = 1 LIMIT 1";
    $resultado = $conexion->query($sql);

    if ($fila = $resultado->fetch_assoc()) {
        $idPedido = $fila['id_Pedido'];
    } else {
        // Crear un nuevo pedido
        $sqlInsertPedido = "INSERT INTO pedidos (id_Mesa, EstadoPedido) VALUES ($idMesa, $estadoPedido)";
        if ($conexion->query($sqlInsertPedido) === TRUE) {
            $idPedido = $conexion->insert_id;
        } else {
            echo json_encode(["success" => false, "error" => "No se pudo crear el pedido: " . $conexion->error]);
            return;
        }
    }

    // Verificar si el producto ya existe en el detalle del pedido
    $sqlCheck = "SELECT CantPorProducto FROM detalle_pedido 
                 WHERE id_Pedido = $idPedido AND id_Producto = $id_Producto";
    $resultadoCheck = $conexion->query($sqlCheck);

    if ($filaDetalle = $resultadoCheck->fetch_assoc()) {
        // Si existe, actualizar sumando la cantidad
        $nuevaCantidad = $filaDetalle['CantPorProducto'] + $cantPorProducto;
        $sqlUpdate = "UPDATE detalle_pedido 
                      SET CantPorProducto = $nuevaCantidad 
                      WHERE id_Pedido = $idPedido AND id_Producto = $id_Producto";
        if ($conexion->query($sqlUpdate) !== TRUE) {
            echo json_encode(["success" => false, "error" => "Error al actualizar cantidad: " . $conexion->error]);
        }
    } else {
        // Si no existe, insertar el producto en el detalle del pedido
        $sqlDetalle = "INSERT INTO detalle_pedido (id_Pedido, id_Producto, CantPorProducto, PrecioPorProducto)
                       VALUES ($idPedido, $id_Producto, $cantPorProducto, $precioPorProducto)";
        if ($conexion->query($sqlDetalle) !== TRUE) {
            echo json_encode(["success" => false, "error" => "Error al insertar detalle: " . $conexion->error]);
        }
    }
}

// ---------- VER FECHA Y HORA DEL PEDIDO ----------
    function obtenerFechaYHoraDelPedido($idMesa) {
    $conexion = conectarBD();

    $sql = "SELECT Fecha FROM pedidos WHERE id_Mesa = $idMesa";
    $fecha = $conexion->query($sql);

    if ($fecha === TRUE) {
        echo json_encode(["success" => true, "message" => "Fecha y hora devuelta correctamente"]);
    } else {
        echo json_encode(["success" => false, "error" => $conexion->error]);
    }

    echo json_encode($fecha, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
}


/*
// ---------- AGREGAR PEDIDO REPITIENDO----------

function agregarPedido($idMesa, $id_Producto, $cantPorProducto, $estadoPedido, $precioPorProducto) {
    $conexion = conectarBD();

    // Verificar si ya existe un pedido activo para esta mesa
    $sql = "SELECT id_Pedido FROM pedidos WHERE id_Mesa = $idMesa AND EstadoPedido = 1 LIMIT 1";
    $resultado = $conexion->query($sql);

    if ($fila = $resultado->fetch_assoc()) {
        $idPedido = $fila['id_Pedido'];
    } else {
        // Crear un nuevo pedido
        $sqlInsertPedido = "INSERT INTO pedidos (id_Mesa, EstadoPedido) VALUES ($idMesa, $estadoPedido)";
        if ($conexion->query($sqlInsertPedido) === TRUE) {
            $idPedido = $conexion->insert_id;
        } else {
            echo json_encode(["success" => false, "error" => "No se pudo crear el pedido: " . $conexion->error]);
            return;
        }
    }

    // Insertar el producto en el detalle del pedido
    $sqlDetalle = "INSERT INTO detalle_pedido (id_Pedido, id_Producto, CantPorProducto, PrecioPorProducto)
                   VALUES ($idPedido, $id_Producto, $cantPorProducto, $precioPorProducto)";
    if ($conexion->query($sqlDetalle) !== TRUE) {
        echo json_encode(["success" => false, "error" => "Error al insertar detalle: " . $conexion->error]);
    }
}*/

// ---------- VER PEDIDO ----------

function verPedido($idMesa) {
    $conexion = conectarBD();

    $productos = [];

    $sql = "SELECT p.id_Producto, p.Nombre, p.Descripcion, p.Imagen, p.Precio, detP.CantPorProducto
            FROM pedidos AS ped
            JOIN detalle_pedido AS detP ON ped.id_Pedido = detP.id_Pedido
            JOIN producto AS p ON detP.id_Producto = p.id_Producto
            WHERE ped.id_Mesa = $idMesa AND ped.EstadoPedido = 1";


    $resultado = $conexion->query($sql);

    while ($producto = $resultado->fetch_assoc()) {
        $idProducto = $producto['id_Producto'];

        $sqlIng = "SELECT i.NombreIngrediente, iep.Cantidad 
                   FROM IngredientesEnProducto iep
                   JOIN Ingrediente i ON iep.id_Ingrediente = i.id_Ingrediente
                   WHERE iep.id_Producto = $idProducto";

        $resIng = $conexion->query($sqlIng);

        $ingredientes = [];
        while ($filaIng = $resIng->fetch_assoc()) {
            $ingredientes[$filaIng['NombreIngrediente']] = (int)$filaIng['Cantidad'];
        }

        if (empty($ingredientes)) {
            $ingredientes = new stdClass();
        }

        $productos[] = [
            "nombre_Producto" => $producto["Nombre"],
            "imagen" => $producto["Imagen"],
            "descripcion" => $producto["Descripcion"],
            "precio_unitario" => (float)$producto["Precio"],
            "cantidad_seleccionada" => (int)$producto["CantPorProducto"],
            "ingredientes" => $ingredientes
        ];
    }
    
    echo json_encode($productos, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
}

// ---------- MODIFICAR ESTADO DE MESA ----------

function finalizarPedido($idMesa, $estadoNuevo) {
    $conexion = conectarBD();

    $sql = "UPDATE pedidos SET EstadoPedido = $estadoNuevo WHERE id_Mesa = $idMesa";
    $resultado = $conexion->query($sql);

    return $resultado === TRUE;
}

// ---------- PONER PRECIO FINAL ----------

function cargarPrecioFinal($idMesa, $precioFinal) {
    $conexion = conectarBD();

    $sql = "UPDATE pedidos SET PrecioTotal = $precioFinal WHERE id_Mesa = $idMesa AND EstadoPedido = 1";
    $resultado = $conexion->query($sql);

    if ($resultado === TRUE) {
        echo json_encode(["success" => true, "message" => "Estado actualizado correctamente"]);
    } else {
        echo json_encode(["success" => false, "error" => $conexion->error]);
    }
}

// ---------- REALIZAR CAMBIO DE MESA ----------

function realizarCambioDeMesa($idMesaActual, $idMesaNueva) {
    $conexion = conectarBD();

    // Iniciar la transacción
    $conexion->begin_transaction();

    header('Content-Type: application/json; charset=utf-8');

    try {
        // Liberar la mesa actual
        $sql = "UPDATE mesa SET EstadoPedido = 0 WHERE id_Mesa = $idMesaActual";
        if (!$conexion->query($sql)) {
            throw new Exception("Error liberando mesa actual: " . $conexion->error);
        }

        // Ocupar la mesa nueva
        $sql1 = "UPDATE mesa SET EstadoPedido = 1 WHERE id_Mesa = $idMesaNueva";
        if (!$conexion->query($sql1)) {
            throw new Exception("Error ocupando mesa nueva: " . $conexion->error);
        }

        // Pasar los pedidos de la mesa actual a la nueva
        $sql2 = "UPDATE pedidos 
                 SET id_Mesa = $idMesaNueva 
                 WHERE id_Mesa = $idMesaActual AND EstadoPedido = 1";
        if (!$conexion->query($sql2)) {
            throw new Exception("Error reasignando pedidos: " . $conexion->error);
        }

        // Confirmar cambios
        $conexion->commit();

        echo json_encode([
            "success" => true,
            "message" => "Cambio de mesa realizado correctamente"
        ]);

    } catch (Exception $e) {
        // Revertir cambios en caso de error
        $conexion->rollback();

        echo json_encode([
            "success" => false,
            "error" => $e->getMessage()
        ]);
    }
}

// ------------------------------------
// Punto de entrada: decide qué función ejecutar
// ------------------------------------
$accion = $_GET['accion'] ?? '';

switch ($accion) {
    case 'productos':
        obtenerProductos();
        break;
    case 'mesas':
        obtenerMesas();
        break;
    case 'mesaEstado':
        if (isset($_GET['id']) && isset($_GET['estado'])) {
            $id = intval($_GET['id']);
            $estado = intval($_GET['estado']);
            cambiarEstadoMesa($id, $estado);
        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
    break;
    case 'verEstadoMesa':
        if (isset($_GET['id'])) {
            $id = intval($_GET['id']);
            obtenerEstadoMesa($id);
        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
        
        break;
    case 'subirPedido':
        if (isset($_GET['listadoProductos']) && isset($_GET['mesaSeleccionada'])) {
            $mesa = json_decode($_GET['mesaSeleccionada']);
            $listadoProductos = json_decode($_GET['listadoProductos']);

            $idMesa = $mesa->id;

            for ($i=0; $i < count($listadoProductos); $i++) {

                $nombreProducto = $listadoProductos[$i]->nombreProducto;
                $cantidad = $listadoProductos[$i]->cantidadSeleccionada;
                $precio = $listadoProductos[$i]->precio;

                $idProducto = buscarIdProducto($nombreProducto);

                if ($idProducto !== null) {
                    agregarPedido($idMesa, $idProducto, $cantidad, 1, $precio);
                } else {
                    error_log("Producto no encontrado: $nombreProducto");
                }

            }
            
            echo json_encode(["success" => true, "message" => "Pedido registrado correctamente"]);
        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
    break;
    case 'verPedido':
        if (isset($_GET['idMesa'])) {
            $idMesa = $_GET['idMesa'];
            verPedido($idMesa);

        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
    break;

    case 'obtenerFechaYHoraDelPedido':
        if (isset($_GET['idMesa'])) {
            $idMesa = $_GET['idMesa'];
            obtenerFechaYHoraDelPedido($idMesa);
        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
    break;

    case 'finalizarPedido':
        if (isset($_GET['idMesa']) && isset($_GET['estadoPedido'])) {
            $idMesa = $_GET['idMesa'];
            $estadoPedido = $_GET['estadoPedido'];
            finalizarPedido($idMesa, $estadoPedido);
            cambiarEstadoMesa($idMesa, $estadoPedido);
        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
        break;

    case 'guardarPrecioFinal':
        if (isset($_GET['idMesa']) && isset($_GET['precioFinal'])) {
            $idMesa = $_GET['idMesa'];
            $precioFinal = $_GET['precioFinal'];
            cargarPrecioFinal($idMesa, $precioFinal);
        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
        break;

    case 'realizarCambioDeMesa':
        if (isset($_GET['idMesaActual']) && isset($_GET['idMesaNueva'])) {
            $idMesaActual = $_GET['idMesaActual'];
            $idMesaNueva = $_GET['idMesaNueva'];
            realizarCambioDeMesa($idMesaActual, $idMesaNueva);
        } else {
            echo json_encode(["success" => false, "error" => "Faltan parámetros"]);
        }
        break;

    default:
        echo json_encode(["error" => "Acción no válida o no especificada"]);
}
