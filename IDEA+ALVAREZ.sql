-- Crear base de datos
CREATE DATABASE gestion_turnos;
USE gestion_turnos;

-- Tabla de especialidades
CREATE TABLE especialidad (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de médicos
CREATE TABLE medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    id_especialidad INT NOT NULL,
    telefono VARCHAR(15),
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad)
);

-- Tabla de pacientes
CREATE TABLE paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni VARCHAR(15) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    fecha_nacimiento DATE,
    direccion VARCHAR(100)
);

-- Tabla de turnos
CREATE TABLE turno (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado ENUM('pendiente','atendido','cancelado') DEFAULT 'pendiente',
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico),
    UNIQUE (id_medico, fecha, hora) -- (Evita doble asignación del mismo turno)
);

-- Especialidades
INSERT INTO especialidad (nombre) VALUES
('Cardiología'),
('Pediatría'),
('Dermatología');

-- Médicos
INSERT INTO medico (nombre, apellido, matricula, id_especialidad, telefono) VALUES
('Juan', 'Pérez', 'MAT123', 1, '1123456789'),
('María', 'Gómez', 'MAT456', 2, '1134567890');

-- Pacientes
INSERT INTO paciente (nombre, apellido, dni, telefono, fecha_nacimiento, direccion) VALUES
('Carlos', 'Ramírez', '30123456', '1156789012', '1985-04-15', 'Calle Falsa 123'),
('Lucía', 'Martínez', '40234567', '1167890123', '1990-07-20', 'Av. Siempre Viva 742');

-- Turnos
INSERT INTO turno (id_paciente, id_medico, fecha, hora, estado) VALUES
(1, 1, '2025-08-15', '10:00:00', 'pendiente'),
(2, 2, '2025-08-15', '11:00:00', 'pendiente');

-- Buscar pacientes cuyos nombres comienzen con C
SELECT * FROM paciente
WHERE nombre LIKE 'C%';

-- Cuántos turnos hay por fecha
SELECT fecha, COUNT(*) AS cantidad_turnos
FROM turno
GROUP BY fecha
ORDER BY fecha;

-- Calcular la edad de cada paciente actualmente
SELECT nombre, apellido, fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM paciente;

-- Listado de médicos con la cantidad de turnos asignados
SELECT m.nombre, m.apellido, COUNT(t.id_turno) AS turnos_asignados
FROM medico m
LEFT JOIN turno t ON m.id_medico = t.id_medico
GROUP BY m.id_medico
ORDER BY turnos_asignados DESC;

-- Obtener el paciente más joven
SELECT nombre, apellido, fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE()) AS edad
FROM paciente
ORDER BY fecha_nacimiento DESC
LIMIT 1;

-- Apellidos que contienen "ez"
SELECT *
FROM paciente
WHERE apellido REGEXP 'ez';






