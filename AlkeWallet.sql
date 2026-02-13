create database alkewallet;

-- Usar la base de datos
\1 AlkeWallet;

-- Crear tabla Usuario
CREATE TABLE Usuario (
    user_id SERIAL PRIMARY KEY, -- Identificador único
    nombre VARCHAR(100) NOT NULL,-- Nombre del usuario
    correo_electronico VARCHAR(100) UNIQUE NOT NULL, -- Correo único
    contraseña VARCHAR(100) NOT NULL,-- Contraseña (en producción debe 
	--ir en hash)
    saldo DECIMAL(10,2) DEFAULT 0.00 -- Saldo inicial
);
-- Índice para optimizar búsquedas por correo
CREATE INDEX idx_usuario_correo ON Usuario(correo_electronico);


-- Crear tabla Moneda
CREATE TABLE Moneda (
    currency_id SERIAL PRIMARY KEY, -- Identificador único
    currency_name VARCHAR(50) NOT NULL, -- Nombre de la moneda
    currency_symbol VARCHAR(10) NOT NULL -- Símbolo de la moneda
);
-- Índice para búsquedas rápidas por símbolo
CREATE INDEX idx_moneda_symbol ON Moneda(currency_symbol);

-- Crear tabla Transacción
CREATE TABLE Transaccion (
    transaction_id SERIAL PRIMARY KEY, -- Identificador único
    sender_user_id INT REFERENCES Usuario(user_id), -- Usuario emisor
    receiver_user_id INT REFERENCES Usuario(user_id), -- Usuario receptor
    currency_id INT NOT NULL,
	importe NUMERIC(12,2) NOT NULL,           -- Monto de la transacción
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

   -- Claves foráneas
    CONSTRAINT fk_sender FOREIGN KEY (sender_user_id) REFERENCES Usuario(user_id),
    CONSTRAINT fk_receiver FOREIGN KEY (receiver_user_id) REFERENCES Usuario(user_id),
    CONSTRAINT fk_currency FOREIGN KEY (currency_id) REFERENCES Moneda(currency_id)
);

-- Índice compuesto para optimizar búsquedas por emisor y receptor
CREATE INDEX idx_transaccion_users ON Transaccion(sender_user_id, receiver_user_id);

drop table transaccion;

INSERT INTO Usuario (nombre, correo_electronico, contraseña, saldo) VALUES
('Ana Pérez', 'ana.perez@email.com', 'clave123', 150000.00),
('Carlos Soto', 'carlos.soto@email.com', 'clave456', 250000.00),
('María López', 'maria.lopez@email.com', 'clave789', 50000.00),
('José Ramírez', 'jose.ramirez@email.com', 'clave321', 300000.00),
('Camila Torres', 'camila.torres@email.com', 'clave654', 120000.00),
('Felipe Díaz', 'felipe.diaz@email.com', 'clave987', 80000.00),
('Valentina Rojas', 'valentina.rojas@email.com', 'clave111', 220000.00),
('Diego Herrera', 'diego.herrera@email.com', 'clave222', 95000.00),
('Francisca Morales', 'francisca.morales@email.com', 'clave333', 400000.00),
('Sebastián Vargas', 'sebastian.vargas@email.com', 'clave444', 60000.00);

INSERT INTO Moneda (currency_name, currency_symbol) VALUES
('Peso Chileno', 'CLP'),
('Dólar Estadounidense', 'USD'),
('Euro', 'EUR'),
('Bitcoin', 'BTC'),
('Ethereum', 'ETH');

INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, transaction_date) VALUES
(1, 2, 200.00, '2026-02-01 10:30:00'),
(3, 4, 150.00, '2026-02-02 14:15:00'),
(5, 6, 300.00, '2026-02-03 09:45:00'),
(2, 7, 500.00, '2026-02-04 16:20:00'),
(8, 9, 100.00, '2026-02-05 11:10:00'),
(10, 1, 250.00, '2026-02-06 18:00:00'),
(4, 5, 400.00, '2026-02-07 12:00:00'),
(6, 3, 350.00, '2026-02-08 20:30:00');

-- Consulta básica: mostrar todos los usuarios
SELECT * FROM Usuario;

-- Consulta con filtro: usuarios con saldo mayor a 100000
SELECT * FROM Usuario
WHERE saldo > 100000;

-- Consulta con operador lógico: usuarios con saldo entre 500 y 2000
SELECT * FROM Usuario
WHERE saldo >= 50000 AND saldo <= 200000;

-- Mostrar transacciones con nombre del emisor y receptor
SELECT 
  t.transaction_id,
  u1.nombre AS emisor,
  u2.nombre AS receptor,
  t.importe,
  t.transaction_date
FROM Transaccion t
INNER JOIN Usuario u1 ON T.sender_user_id = u1.user_id
INNER JOIN Usuario u2 ON T.receiver_user_id = u2.user_id;

-- Total enviado por cada usuario
SELECT 
  nombre,
  (SELECT COUNT(*) FROM Transaccion WHERE sender_user_id = u.user_id) 
  AS total_enviadas,
  (SELECT SUM(importe) FROM Transaccion WHERE sender_user_id = u.user_id) 
  AS monto_total
FROM Usuario u;

-- Crear vista
CREATE VIEW Top5UsuariosSaldo AS
SELECT * FROM Usuario
ORDER BY saldo DESC
LIMIT 5;

-- Consultar la vista
SELECT * FROM Top5UsuariosSaldo;

-- Contar cuántos usuarios hay en la tabla
SELECT COUNT(*) AS total_usuarios
FROM Usuario;

-- Contar cuántas transacciones se han registrado
SELECT COUNT(*) AS total_transacciones
FROM Transaccion;

-- Calcular el saldo total de todos los usuarios
SELECT SUM(saldo) AS saldo_total_sistema
FROM Usuario;

-- Calcular el importe total transferido en todas las transacciones
SELECT SUM(importe) AS total_transferido
FROM Transaccion;

-- Usuario 1 envía 25000 CLP a Usuario 2
UPDATE Usuario
SET saldo = saldo - 25000
WHERE user_id = 1;

UPDATE Usuario
SET saldo = saldo + 25000
WHERE user_id = 2;

SELECT * FROM Usuario;

START TRANSACTION;

-- Restar saldo al emisor
UPDATE Usuario
SET saldo = saldo - 250
WHERE user_id = 1;

-- Sumar saldo al receptor
UPDATE Usuario
SET saldo = saldo + 250
WHERE user_id = 2;

-- Registrar la transacción
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, transaction_date)
VALUES (1, 2, 250.00, CURRENT_TIMESTAMP);

COMMIT;

--Si ocurre un error en alguna sentencia, se puede usar:
ROLLBACK;

START TRANSACTION;

-- Intentar insertar una transacción con un usuario inexistente
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, transaction_date)
VALUES (99, 2, 500.00, CURRENT_TIMESTAMP);

-- Esto generará error porque el usuario 99 no existe
ROLLBACK;


-- Insertar 50 transacciones aleatorias con usuarios del 1 al 10
INSERT INTO Transaccion (sender_user_id, receiver_user_id, importe, 
transaction_date)
SELECT
  FLOOR(RANDOM() * 10 + 1),   -- emisor aleatorio entre 1 y 10
  FLOOR(RANDOM() * 10 + 1),   -- receptor aleatorio entre 1 y 10
  FLOOR(RANDOM() * 100000 + 1), -- importe aleatorio entre 1 y 100000
  CURRENT_TIMESTAMP - (RANDOM() * 30 || ' days')::interval -- fecha 
  --aleatoria últimos 30 días
FROM generate_series(1,50);

SELECT * FROM Transaccion;

--  Tarea Plus: Modificar tabla Usuario para añadir fecha de creación
ALTER TABLE Usuario
ADD COLUMN fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

