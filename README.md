# procurement-price-prediction

An end-to-end procurement analytics and machine learning project that turns purchasing data into actionable cost optimization insights.

Built around a multi-tenant lakehouse architecture, the project uses **dbt and DuckDB** to transform raw procurement data into structured Silver and Gold layers, and **Python** to perform exploratory analysis, identify purchasing patterns, evaluate seasonal pricing opportunities, and build explainable price prediction models.

### Key capabilities

- **Data Engineering:** Bronze-to-Silver-to-Gold data transformation using dbt and DuckDB.
- **Procurement Analytics:** Analyze purchase frequency, vendor relationships, spending patterns, and seasonal trends.
- **Price Prediction:** Compare baseline and machine learning approaches to predict unit purchase prices.
- **Explainable AI:** Understand global model drivers and individual price predictions using SHAP.
- **Reproducibility:** Containerized workflows and automated pipeline execution for consistent results.

### Technology Stack

Python · Pandas · Scikit-learn · SHAP · dbt · DuckDB · Docker



## Overview

This project analyses procurement purchasing data to investigate two key questions:

1. When should customers purchase frequently bought items to obtain better prices?
2. Can historical purchasing data predict the unit price of an item before a purchase order is issued?

The solution uses **dbt with DuckDB** for data transformation and **Python** for exploratory analysis, price trend analysis, predictive modelling, and explainability.

## Project Structure

```text
.
├── data/
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│   └── warehouse.duckdb
├── dbt_project/
│   ├── models/
│   │   ├── silver/
│   │   └── gold/
│   ├── dbt_project.yml
│   └── packages.yml
├── notebooks/
│   ├── 01_data_profiling.ipynb
│   ├── 02_procurement_eda.ipynb
│   ├── 03_price_prediction.ipynb
│   └── 04_price_prediction_all.ipynb
├── outputs/
│   ├── charts/
│   ├── metrics/
│   └── executed_notebooks/
├── scripts/
│   └── export_layers.py
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── requirements.txt
└── README.md
```

## Setup and Execution

### Prerequisites

Ensure the following tools are installed:

- Python 3.10 or later
- Docker Desktop or Docker Engine with Docker Compose
- Make

### Install Dependencies

Run:

```bash
make setup
```

This builds the dbt Docker image and creates a Python virtual environment with the required dependencies.

### Run the Complete Pipeline

Run:

```bash
make all
```

The pipeline automatically:

1. Runs dbt transformations and tests.
2. Exports Silver and Gold tables.
3. Executes all four Python notebooks in sequence.
4. Generates charts, metrics, tables, and executed notebooks under `outputs/`.

No notebook cells need to be executed manually.

### Individual Commands

| Command | Description |
|---|---|
| `make setup` | Build Docker image and install Python dependencies |
| `make dbt` | Run dbt build |
| `make test` | Run dbt tests |
| `make export` | Export Silver and Gold tables |
| `make data` | Run dbt build and export |
| `make notebooks` | Execute all Python notebooks |
| `make all` | Run the complete pipeline |
| `make clean` | Remove generated warehouse, exports, and execution artefacts |

### Using a Different Dataset

The pipeline supports changing the input dataset through the `DATA_DIR` environment variable.

**Linux / macOS**

```bash
DATA_DIR=/path/to/dataset make all
```

**Windows PowerShell**

```powershell
$env:DATA_DIR="D:/path/to/dataset"
make all
```

The alternative dataset must follow the same input schema and directory structure as the original dataset.

## Analysis and Methodology

### 1. Data Profiling

**Notebook:** `01_data_profiling.ipynb`

Examines the source data, including:

- Dataset dimensions and column types.
- Missing values and duplicate records.
- Customer, vendor, and item distributions.
- Data quality issues and inconsistencies.

### 2. Procurement Exploratory Analysis

**Notebook:** `02_procurement_eda.ipynb`

Investigates purchasing behaviour and historical prices, including:

- Frequently purchased items, based on distinct purchase orders.
- Monthly price variations.
- Vendor-level price comparisons.
- Item and vendor purchasing patterns.
- Cheapest vendor and month combinations.
- Historical pricing trends and seasonal effects.

### 3. Price Prediction

**Notebook:** `03_price_prediction.ipynb`

Develops and evaluates price prediction models for the selected customer.

**Prediction target:** `unit_price_paid`

The approaches include:

| Model | Description |
|---|---|
| Historical Pricing Baseline | Uses historical pricing information as a benchmark |
| Ridge Regression | Linear regression with L2 regularisation |
| Random Forest | Tree-based ensemble model |
| XGBoost | Gradient-boosted decision tree model |

#### Model Evaluation

Models are evaluated using a holdout test dataset, with the following metrics:

| Metric | Description |
|---|---|
| MAE | Mean Absolute Error |
| RMSE | Root Mean Squared Error |
| MAPE | Mean Absolute Percentage Error |

Historical pricing features are constructed using information available before the relevant purchase date to avoid future-data leakage.

### 4. Price Prediction Across Customers

**Notebook:** `04_price_prediction_all.ipynb`

Extends the predictive modelling analysis across the available customer dataset and compares model performance.

## Explainability

SHAP (SHapley Additive exPlanations) is used to explain the Random Forest model.

Two levels of explanation are provided:

| Explanation | Purpose |
|---|---|
| Global explanation | Identifies the features that have the greatest influence on predictions across the evaluated records. |
| Local explanation | Explains an individual purchase order line, showing how its features contribute to the predicted unit price. |

Negative SHAP values indicate downward contributions relative to the model's expected prediction, not necessarily negative prices.

## Data Transformation

The dbt project uses a layered data architecture:

| Layer | Description |
|---|---|
| Bronze | Raw source CSV extracts. |
| Silver | Typed and conformed source tables. |
| Gold | Analytical models, including purchase order line facts and supporting dimensions. |

Customer mismatches between purchase order headers and lines are identified separately from validated purchase order records.

Gold models are used as the foundation for downstream procurement analysis.

## Key Assumptions and Decisions

### Frequently Purchased Items

Items are ranked by the number of distinct purchase orders containing the item, rather than the number of individual line records.

This provides a more representative measure of purchasing frequency.

### Price Comparison

Historical prices are compared at item level to avoid misleading comparisons between different products.

Vendor and monthly comparisons are also performed to identify potentially advantageous purchasing combinations.

### Prediction Target

The model predicts the actual `unit_price_paid`, rather than the vendor's listed price.

This reflects the price customers actually paid in historical transactions.

### Model Evaluation

A holdout dataset is used to evaluate how well the models predict prices for unseen purchase records.

Historical pricing features represent information available at prediction time, helping prevent future-data leakage.

### Price Seasonality

Monthly average prices are used to investigate potential seasonal patterns.

These patterns should be interpreted cautiously where transaction volumes are limited or purchasing behaviour differs between vendors.

### Explainability

SHAP values explain the contribution of individual features to model predictions.

Negative SHAP values indicate downward contributions relative to the model's expected prediction, not necessarily negative prices.

## Outputs

All generated analytical artefacts are stored under `outputs/`.

| Directory | Contents |
|---|---|
| `outputs/charts/` | Exploratory analysis, pricing comparisons, and SHAP visualisations |
| `outputs/metrics/` | Model evaluation metrics and analytical summary tables |
| `outputs/executed_notebooks/` | Executed versions of the four notebooks, including their outputs |

The notebooks in `notebooks/` contain the analysis and executable code.

The executed copies are generated automatically by `make all`.

## Reproducibility

The complete workflow is designed to run from a clean project setup using:

```bash
make setup
make all
```

The pipeline:

- Does not depend on manually executed notebook cells.
- Avoids machine-specific absolute paths.
- Uses dependencies specified in `requirements.txt`.
- Runs dbt transformations through the provided Docker configuration.
- Regenerates all analytical outputs as part of the pipeline.

This ensures the analysis can be reproduced consistently from the project setup.
