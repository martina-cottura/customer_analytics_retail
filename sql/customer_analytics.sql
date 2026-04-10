-- ============================================================
--  SCRIPT 1 — Crear base de datos y tablas staging
--  Ejecutar primero, antes de cualquier carga de datos
-- ============================================================

CREATE DATABASE IF NOT EXISTS customer_analytics
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE customer_analytics;


CREATE TABLE stg_tiendas (
    store_id    VARCHAR(50),
    nombre      VARCHAR(100),
    ciudad      VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE stg_clientes (
    customer_id       VARCHAR(50),
    nombre            VARCHAR(100),
    email             VARCHAR(100),
    ciudad            VARCHAR(100),
    canal_adquisicion VARCHAR(50),
    fecha_alta        VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE stg_productos (
    product_id  VARCHAR(50),
    nombre      VARCHAR(100),
    categoria   VARCHAR(50),
    precio_base VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE stg_transacciones (
    transaction_id VARCHAR(50),
    customer_id    VARCHAR(50),
    product_id     VARCHAR(50),
    store_id       VARCHAR(50),
    cantidad       VARCHAR(10),
    importe        VARCHAR(20),
    fecha          VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Verificación: deben aparecer las 4 tablas stg_*
SELECT table_name, table_rows
FROM information_schema.tables
WHERE table_schema = 'customer_analytics'
  AND table_name LIKE 'stg_%';
-- ============================================================
--  SCRIPT 2 — Carga de CSV a tablas staging
--  Ruta segura confirmada: C:\ProgramData\MySQL\MySQL Server 9.4\Uploads\
-- ============================================================

USE customer_analytics;

-- Vaciar staging por si se re-ejecuta
TRUNCATE TABLE stg_tiendas;
TRUNCATE TABLE stg_clientes;
TRUNCATE TABLE stg_productos;
TRUNCATE TABLE stg_transacciones;

-- ------------------------------------------------------------
--  PASO PREVIO: copia los 4 CSV a esta carpeta:
--  C:\ProgramData\MySQL\MySQL Server 9.4\Uploads\
-- ------------------------------------------------------------

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/tiendas_clean.csv'
INTO TABLE stg_tiendas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(store_id, nombre, ciudad);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/clientes_clean.csv'
INTO TABLE stg_clientes
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, nombre, email, ciudad, canal_adquisicion, fecha_alta);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/productos_clean.csv'
INTO TABLE stg_productos
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(product_id, nombre, categoria, precio_base);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/transacciones_clean.csv'
INTO TABLE stg_transacciones
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(transaction_id, customer_id, product_id, store_id, cantidad, importe, fecha);

-- ------------------------------------------------------------
--  Verificación — esperado:
--  stg_tiendas=5, stg_clientes=1000, stg_productos=48, stg_transacciones=8000
-- ------------------------------------------------------------
SELECT 'stg_tiendas'      AS tabla, COUNT(*) AS filas FROM stg_tiendas
UNION ALL
SELECT 'stg_clientes',      COUNT(*) FROM stg_clientes
UNION ALL
SELECT 'stg_productos',     COUNT(*) FROM stg_productos
UNION ALL
SELECT 'stg_transacciones', COUNT(*) FROM stg_transacciones;

-- ============================================================
--  SCRIPT 3 — Crear tablas finales con PK, FK e índices
--  Ejecutar después de verificar que staging tiene datos
-- ============================================================

USE customer_analytics;

-- Eliminación en orden inverso a las FK
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS transacciones;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS tiendas;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
--  Dimensiones
-- ------------------------------------------------------------

CREATE TABLE tiendas (
    store_id    VARCHAR(3)   NOT NULL,
    nombre      VARCHAR(20)  NOT NULL,
    ciudad      VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_tiendas PRIMARY KEY (store_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE clientes (
    customer_id       VARCHAR(5)   NOT NULL,
    nombre            VARCHAR(30)  NOT NULL,
    email             VARCHAR(40)      NULL,  -- ~4% nulos, ruido aleatorio documentado
    ciudad            VARCHAR(20)      NULL,  -- ~5% nulos, ruido aleatorio documentado
    canal_adquisicion VARCHAR(10)  NOT NULL,
    fecha_alta        DATE         NOT NULL,
    CONSTRAINT pk_clientes PRIMARY KEY (customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE productos (
    product_id  VARCHAR(4)    NOT NULL,
    nombre      VARCHAR(25)   NOT NULL,
    categoria   VARCHAR(15)   NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_productos PRIMARY KEY (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ------------------------------------------------------------
--  Tabla de hechos
-- ------------------------------------------------------------

CREATE TABLE transacciones (
    transaction_id VARCHAR(7)    NOT NULL,
    customer_id    VARCHAR(5)    NOT NULL,
    product_id     VARCHAR(4)    NOT NULL,
    store_id       VARCHAR(3)    NOT NULL,
    cantidad       TINYINT       NOT NULL,
    importe        DECIMAL(10,2) NOT NULL,  -- negativos = devoluciones documentadas
    fecha          DATE          NOT NULL,
    CONSTRAINT pk_transacciones  PRIMARY KEY (transaction_id),
    CONSTRAINT fk_trans_cliente  FOREIGN KEY (customer_id) REFERENCES clientes(customer_id),
    CONSTRAINT fk_trans_producto FOREIGN KEY (product_id)  REFERENCES productos(product_id),
    CONSTRAINT fk_trans_tienda   FOREIGN KEY (store_id)    REFERENCES tiendas(store_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ------------------------------------------------------------
--  Índices analíticos
-- ------------------------------------------------------------
CREATE INDEX idx_trans_fecha    ON transacciones (fecha);
CREATE INDEX idx_trans_store    ON transacciones (store_id);
CREATE INDEX idx_cli_canal      ON clientes (canal_adquisicion);
CREATE INDEX idx_prod_categoria ON productos (categoria);


-- ------------------------------------------------------------
--  Verificación — las 4 tablas finales deben aparecer vacías
-- ------------------------------------------------------------





-- ============================================================
--  SCRIPT 4 — INSERT SELECT de staging a tablas finales
--  Ejecutar después del Script 3
--  Aquí se aplican: conversión de tipos, nulos y validaciones
-- ============================================================

USE customer_analytics;

-- ------------------------------------------------------------
--  Orden obligatorio: dimensiones antes que la tabla de hechos
-- ------------------------------------------------------------

-- 4.1 tiendas
INSERT INTO tiendas (store_id, nombre, ciudad)
SELECT
    TRIM(store_id),
    TRIM(nombre),
    TRIM(ciudad)
FROM stg_tiendas
WHERE store_id IS NOT NULL
  AND store_id <> '';


-- 4.2 clientes
--     email y ciudad: cadena vacía → NULL
INSERT INTO clientes (customer_id, nombre, email, ciudad, canal_adquisicion, fecha_alta)
SELECT
    TRIM(customer_id),
    TRIM(nombre),
    NULLIF(TRIM(email),  ''),
    NULLIF(TRIM(ciudad), ''),
    TRIM(canal_adquisicion),
    STR_TO_DATE(TRIM(fecha_alta), '%Y-%m-%d')
FROM stg_clientes
WHERE customer_id IS NOT NULL
  AND customer_id <> '';


-- 4.3 productos
--     precio_base: VARCHAR → DECIMAL
INSERT INTO productos (product_id, nombre, categoria, precio_base)
SELECT
    TRIM(product_id),
    TRIM(nombre),
    TRIM(categoria),
    CAST(REPLACE(TRIM(precio_base), ',', '.') AS DECIMAL(10,2))
FROM stg_productos
WHERE product_id IS NOT NULL
  AND product_id <> '';


-- 4.4 transacciones — última, depende de las tres FK anteriores
--     cantidad: VARCHAR → TINYINT
--     importe:  VARCHAR → DECIMAL (negativos = devoluciones, se conservan)
--     fecha:    VARCHAR → DATE
INSERT INTO transacciones (transaction_id, customer_id, product_id, store_id, cantidad, importe, fecha)
SELECT
    TRIM(transaction_id),
    TRIM(customer_id),
    TRIM(product_id),
    TRIM(store_id),
    CAST(TRIM(cantidad) AS SIGNED),
    CAST(REPLACE(TRIM(importe), ',', '.') AS DECIMAL(10,2)),
    STR_TO_DATE(TRIM(fecha), '%Y-%m-%d')
FROM stg_transacciones
WHERE transaction_id IS NOT NULL
  AND transaction_id <> '';


-- ------------------------------------------------------------
--  Verificación de filas
--  Esperado: tiendas=5, clientes=1000, productos=48, transacciones=8000
-- ------------------------------------------------------------
SELECT 'tiendas'      AS tabla, COUNT(*) AS filas FROM tiendas
UNION ALL
SELECT 'clientes',      COUNT(*) FROM clientes
UNION ALL
SELECT 'productos',     COUNT(*) FROM productos
UNION ALL
SELECT 'transacciones', COUNT(*) FROM transacciones;


-- ------------------------------------------------------------
--  Verificación de integridad referencial — todas deben dar 0
-- ------------------------------------------------------------
SELECT 'FK cliente sin match'  AS check_fk, COUNT(*) AS n
FROM transacciones t
LEFT JOIN clientes c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT 'FK producto sin match', COUNT(*)
FROM transacciones t
LEFT JOIN productos p ON t.product_id = p.product_id
WHERE p.product_id IS NULL
UNION ALL
SELECT 'FK tienda sin match', COUNT(*)
FROM transacciones t
LEFT JOIN tiendas s ON t.store_id = s.store_id
WHERE s.store_id IS NULL;


-- ------------------------------------------------------------
--  Limpieza: eliminar tablas staging una vez validado todo
--  Descomenta cuando estés segura de que la carga es correcta
-- ------------------------------------------------------------
-- DROP TABLE IF EXISTS stg_transacciones;
-- DROP TABLE IF EXISTS stg_clientes;
-- DROP TABLE IF EXISTS stg_productos;
-- DROP TABLE IF EXISTS stg_tiendas;


-- =============================================================
--  TABLA ANALÍTICA DERIVADA: clientes_rfm
--  Resultado del modelo RFM calculado en Python
--  Origen: clientes_rfm.csv exportado desde Jupyter
-- =============================================================

DROP TABLE IF EXISTS clientes_rfm;

CREATE TABLE clientes_rfm (
    customer_id     VARCHAR(5)     NOT NULL,
    recencia        INT            NOT NULL,
    frecuencia      INT            NOT NULL,
    monetario       DECIMAL(10,2)  NOT NULL,
    segmento_rfm    VARCHAR(20)    NOT NULL,
    churn_riesgo    TINYINT        NOT NULL COMMENT '0 = activo | 1 = en riesgo',
    fecha_calculo   DATE           NOT NULL,
    CONSTRAINT pk_rfm PRIMARY KEY (customer_id),
    CONSTRAINT fk_rfm_cliente FOREIGN KEY (customer_id) 
        REFERENCES clientes(customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================
--  CARGA DESDE CSV
-- =============================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/clientes_rfm.csv'
INTO TABLE clientes_rfm
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, recencia, frecuencia, monetario, segmento_rfm, churn_riesgo, fecha_calculo);

-- =============================================================
--  VERIFICACIÓN
-- =============================================================

SELECT 
    COUNT(*)            AS total_clientes_rfm,
    SUM(churn_riesgo)   AS total_en_riesgo,
    MAX(fecha_calculo)  AS ultima_actualizacion
FROM clientes_rfm;