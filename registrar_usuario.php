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
$nombre = $_POST['nombre'] ?? '';
$correo = $_POST['correo'] ?? '';
$contrasena = $_POST['contraseña'] ?? '';
$tipo_usuario = "normal";  // Valor por defecto para usuario normal

// Validar que los campos no estén vacíos
if (empty($nombre) || empty($correo) || empty($contrasena)) {
    die(json_encode(["status" => "error", "message" => "Todos los campos son obligatorios"]));
}

// Insertar en la base de datos
$sql = "INSERT INTO usuario (nombre, correo, contraseña, tipo_usuario) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssss", $nombre, $correo, $contrasena, $tipo_usuario);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Usuario registrado correctamente"]);
} else {
    echo json_encode(["status" => "error", "message" => "Error al registrar: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>
