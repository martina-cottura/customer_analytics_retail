# 📊 Customer Analytics | Cumbres Outdoor & Deporte

Este proyecto desarrolla un análisis integral de clientes para una empresa ficticia del sector retail deportivo. A través de un pipeline de datos end-to-end, se identifican segmentos de valor, se estima el riesgo de abandono y se generan insights accionables para la toma de decisiones estratégicas basadas en datos.

---
## 🚧 Estado del Proyecto

📌 **Proyecto en desarrollo**

Este proyecto se encuentra actualmente en fase activa de construcción y análisis. En esta etapa, se están desarrollando los principales indicadores de Customer Analytics y las herramientas de visualización necesarias para la obtención de insights estratégicos.

### 🔍 Progreso Actual

* ✅ Generación de datos sintéticos con Python.
* ✅ Limpieza y transformación de datos (EDA).
* ✅ Modelado de datos en MySQL mediante un esquema estrella.
* 🔄 Análisis de KPIs en MySQL mediante consultas SQL.
* 🔄 Desarrollo del dashboard ejecutivo en Power BI.
* ⏳ Generación de insights y conclusiones estratégicas.
* ⏳ Documentación final y optimización del proyecto.

### 🛠️ Etapa en Curso

Actualmente, el proyecto se encuentra en la fase de **Análisis de KPIs en MySQL**, que incluye:

* Generación de consultas SQL para el cálculo de métricas clave como RFM, LTV y Churn.
* Validación de resultados y preparación de tablas analíticas.
* Integración de los datos con Power BI para su visualización.

Paralelamente, se está desarrollando un **dashboard interactivo en Power BI** para:

* Visualizar el comportamiento del cliente.
* Identificar segmentos de alto valor y riesgo.
* Analizar el rendimiento por canal y categoría.
* Generar insights accionables para la toma de decisiones.

📅 **Última actualización:** Abril de 2026.


## 🏢 Descripción del Negocio

**Cumbres Outdoor & Deporte** es una empresa española especializada en la venta de equipamiento deportivo y material outdoor. Opera mediante una red de cuatro tiendas físicas ubicadas en Madrid, Barcelona, Valencia y Sevilla, complementada con un canal de ecommerce que amplía su alcance a todo el territorio nacional.

El catálogo se organiza en cuatro categorías principales:

* 🏔️ Montaña y Trekking
* 🏃 Running y Trail
* 🚴 Ciclismo
* 🎾 Pádel

---

## 🎯 Problema de Negocio

La empresa dispone de tres años de datos transaccionales (2023–2025), pero carece de una estructura analítica que permita extraer valor de la información. Como consecuencia:

* No se identifican los clientes más valiosos.
* No se detecta el riesgo de abandono (churn).
* Las inversiones en marketing se realizan sin criterios basados en datos.
* No existe visibilidad sobre el comportamiento individual de los clientes.

### ❓ Pregunta de Negocio

**¿Quiénes son los clientes más valiosos de Cumbres, cuántos están en riesgo de abandonar la marca y qué acciones comerciales pueden activarse para sostener el crecimiento?**

---

## 🎯 Objetivos del Proyecto

### 📌 Objetivo General

Construir un pipeline de análisis de datos end-to-end que permita comprender el comportamiento de los clientes y generar insights accionables para la toma de decisiones estratégicas.

### 📍 Objetivos Específicos

* Generar un dataset sintético representativo con calidad realista.
* Limpiar y transformar los datos con criterios analíticos documentados.
* Diseñar un modelo dimensional en esquema estrella.
* Calcular KPIs de Customer Analytics como RFM, LTV y Churn.
* Desarrollar un dashboard ejecutivo en Power BI.
* Garantizar la trazabilidad y reproducibilidad del análisis.

---

## 🛠️ Tecnologías Utilizadas

| Categoría                | Herramientas               |
| ------------------------ | -------------------------- |
| Lenguaje de Programación | Python                     |
| Análisis de Datos        | Pandas, NumPy              |
| Generación de Datos      | Faker                      |
| Bases de Datos           | MySQL                      |
| Consultas                | SQL                        |
| Visualización            | Power BI, DAX              |
| Entorno de Desarrollo    | Jupyter Notebook, Anaconda |
| Control de Versiones     | Git y GitHub               |

---

## 📂 Estructura del Proyecto

```text
customer_analytics/
│
├── data/
│   ├── raw/                # Datos sintéticos originales
│   ├── clean/              # Datos limpios
│   └── processed/          # KPIs y datasets analíticos
│
├── documentos/             # Informes y documentación del proyecto
├── power_bi/               # Dashboard en Power BI (.pbix)
├── python/                 # Scripts y notebooks en Python
├── sql/                    # Scripts de modelado y consultas SQL
│
├── requirements.txt        # Dependencias del proyecto
├── .gitignore
└── README.md
```

---

## 🔄 Metodología del Proyecto

| Fase                      | Descripción                     | Herramientas    |
| ------------------------- | ------------------------------- | --------------- |
| Generación de Datos       | Creación de datasets sintéticos | Python, Faker   |
| Limpieza y Transformación | EDA y tratamiento de datos      | Pandas, Jupyter |
| Modelado de Datos         | Diseño del esquema estrella     | MySQL, SQL      |
| Análisis de KPIs          | Cálculo de RFM, LTV y Churn     | Python, SQL     |
| Visualización             | Desarrollo del dashboard        | Power BI, DAX   |

---

## 📊 KPIs Analizados

* 📈 Segmentación RFM (Recencia, Frecuencia y Valor Monetario)
* 💰 Customer Lifetime Value (LTV)
* 🔁 Tasa de Churn
* 🛒 Ticket medio por canal
* 📦 Rendimiento por categoría de producto
* 📅 Evolución temporal de ventas

---

## 📉 Modelo de Datos

El proyecto implementa un **esquema estrella** compuesto por:

* **Tabla de hechos:** `transacciones`
* **Tablas de dimensiones:** `clientes`, `productos`, `tiendas`, `calendario`
* **Tabla analítica adicional:** `clientes_rfm`

---

## 📊 Dashboard en Power BI

El dashboard ejecutivo permite:

* Identificar clientes de alto valor.
* Analizar el riesgo de abandono.
* Evaluar el rendimiento por canal y categoría.
* Visualizar tendencias temporales de ventas.

📌 El archivo se encuentra en la carpeta `power_bi/`.

---

## 🚀 Cómo Ejecutar el Proyecto

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/TU_USUARIO/customer_analytics.git
cd customer_analytics
```

### 2️⃣ Instalar dependencias

```bash
pip install -r requirements.txt
```

### 3️⃣ Ejecutar el pipeline

1. Generar los datos sintéticos en Python.
2. Limpiar y transformar los datos.
3. Cargar la información en MySQL.
4. Conectar Power BI para visualizar los resultados.

---

## 📈 Resultados Esperados

* Identificación de clientes más valiosos.
* Detección temprana del churn.
* Optimización de estrategias de marketing.
* Mejora en la toma de decisiones basadas en datos.

---

## 🔮 Líneas Futuras de Desarrollo

* Cálculo del ratio CAC:LTV.
* Análisis de cohortes.
* Modelos predictivos de churn con Machine Learning.
* Migración a entornos cloud como AWS o Azure.

---

## 👩‍💻 Autor

**[Martina Cottura | Analista de datos**
🔗 GitHub: https://github.com/martina-cottura
🔗 LinkedIn: https://www.linkedin.com/in/martina.cottura
📧 Email: martinacottura@gmail.com

---

## 📄 Licencia

Este proyecto se distribuye bajo la **Licencia MIT**. Puedes utilizarlo con fines educativos y profesionales.
