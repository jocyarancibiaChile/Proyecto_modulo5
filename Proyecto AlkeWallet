Proyecto 5: Alke Wallet
Descripción
Alke Wallet es un sistema de gestión de transacciones financieras que permite a los usuarios enviar y recibir dinero en distintas monedas. 
El proyecto implementa un modelo entidad‑relación normalizado (3FN), sentencias DML con transacciones controladas bajo principios ACID, y 
scripts DDL para la creación de tablas en PostgreSQL.

Objetivos del proyecto
- Diseñar y crear las tablas principales: Usuario, Moneda y Transaccion.
- Aplicar restricciones de integridad referencial mediante claves primarias y foráneas.
- Implementar operaciones DML (INSERT, UPDATE, DELETE) dentro de transacciones controladas (START TRANSACTION, COMMIT, ROLLBACK).
- Modelar conceptualmente el sistema con un diagrama ERD y transformarlo en un esquema relacional normalizado.
- Generar scripts de prueba con agregaciones (COUNT, SUM, AVG) y carga masiva de datos.

Estructura de la base de datos
Tablas principales
- Usuario: almacena información de clientes (ID, nombre, correo, contraseña, saldo, fecha de creación).
- Moneda: define las divisas soportadas (ID, nombre, símbolo).
- Transaccion: registra movimientos financieros (ID, emisor, receptor, moneda, importe, fecha).
Relaciones
- Un Usuario puede enviar y recibir múltiples transacciones.
- Una Moneda puede estar asociada a múltiples transacciones.

Scripts principales
- DDL: creación de tablas con claves primarias, foráneas, índices y restricciones NOT NULL.
- DML: inserción de registros de prueba, actualización de saldos, eliminación de datos.
- Transacciones: control de operaciones con COMMIT y ROLLBACK.
- Agregaciones: consultas con COUNT, SUM, AVG, GROUP BY.
- Carga masiva: script para generar 50 transacciones aleatorias con generate_series.

Modelo entidad‑relación
El sistema se modeló mediante un diagrama ERD que identifica entidades fuertes (Usuario, Moneda) y una entidad débil (Transaccion).
- Cardinalidades:
- Usuario (1) ↔ (N) Transaccion (como emisor y receptor).
- Moneda (1) ↔ (N) Transaccion.
- El modelo fue normalizado hasta 3FN para garantizar consistencia y evitar redundancias.
(Aquí puedes insertar la captura del diagrama ERD exportado en PDF.)

Cómo ejecutar el proyecto
- Abrir pgAdmin y crear la base de datos AlkeWallet.
- Ejecutar el script DDL final (alke_wallet.sql).
- Insertar registros de prueba con los scripts DML.
- Probar consultas de agregación y transacciones controladas.
- Visualizar el modelo en el ERD 

