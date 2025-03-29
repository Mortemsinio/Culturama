<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "culturama";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Error de conexión: " . $conn->connect_error]));
}

// Recibir datos del formulario
$negocio = $_POST['negocio'] ?? '';
$correo = $_POST['correo'] ?? '';
$telefono = $_POST['telefono'] ?? '';
$tipo = $_POST['tipo'] ?? '';  // Nuevo campo
$contrasena = $_POST['contraseña'] ?? '';

// Validar que los campos no estén vacíos
if (empty($negocio) || empty($correo) || empty($telefono) || empty($tipo) || empty($contrasena)) {
    die(json_encode(["status" => "error", "message" => "Todos los campos son obligatorios"]));
}

// Insertar en la base de datos
$sql = "INSERT INTO negocio_cultural (nombre, correo, telefono, tipo, contraseña) 
        VALUES (?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param("sssss", $negocio, $correo, $telefono, $tipo, $contrasena);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Negocio registrado correctamente"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error al registrar: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
