
# One entrypoint for everything. DATA_DIR selects the dataset; all analysis outputs go to outputs/.
DATA_DIR ?= $(CURDIR)/data
export DATA_DIR

PROJECT_ROOT := $(CURDIR)
VENV := $(PROJECT_ROOT)/.venv
NOTEBOOK_DIR := $(PROJECT_ROOT)/notebooks
EXECUTED_DIR := $(PROJECT_ROOT)/outputs/executed_notebooks

ifeq ($(OS),Windows_NT)
    PY := $(VENV)/Scripts/python.exe
    DBT := $(VENV)/Scripts/dbt.exe
    VENV_CREATE := py -3.11-64 -m venv
else
    PY := $(VENV)/bin/python
    DBT := $(VENV)/bin/dbt
    VENV_CREATE := python3 -m venv
endif

DC := docker compose
RUN := $(DC) run --rm

.PHONY: setup image venv dbt deps test export data clean all package release dbt-local test-local export-local data-local notebooks notebook-01 notebook-02 notebook-03 notebook-04

# ---- Environment setup ----------------------------------------------------------------------
setup: image venv

image:
	$(DC) build

venv:
	@if not exist "$(PY)" ($(VENV_CREATE) $(VENV))
	$(PY) -m pip install -q --upgrade pip
	$(PY) -m pip install -q -r requirements.txt

# ---- dbt in Docker --------------------------------------------------------------------------
dbt:
	$(RUN) dbt build

deps:
	$(RUN) dbt deps

test:
	$(RUN) dbt test

export:
	$(RUN) --entrypoint python dbt /app/scripts/export_layers.py

data: dbt export

# ---- dbt from the venv ----------------------------------------------------------------------
dbt-local:
	cd dbt_project && $(DBT) build

test-local:
	cd dbt_project && $(DBT) test

export-local:
	$(PY) scripts/export_layers.py

data-local: dbt-local export-local



# ---- Python notebook execution ---------------------------------------------------------------
NOTEBOOK_DIR := $(CURDIR)/notebooks
EXECUTED_DIR := $(CURDIR)/outputs/executed_notebooks

.PHONY: notebooks notebook-01 notebook-02 notebook-03 notebook-04

notebook-01:
	$(PY) -c "from pathlib import Path; Path(r'$(EXECUTED_DIR)').mkdir(parents=True, exist_ok=True)"
	$(PY) -m jupyter nbconvert --to notebook --execute "$(NOTEBOOK_DIR)/01_data_profiling.ipynb" --output 01_data_profiling.ipynb --output-dir "$(EXECUTED_DIR)" --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.kernel_name=python3

notebook-02: notebook-01
	$(PY) -m jupyter nbconvert --to notebook --execute "$(NOTEBOOK_DIR)/02_procurement_eda.ipynb" --output 02_procurement_eda.ipynb --output-dir "$(EXECUTED_DIR)" --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.kernel_name=python3

notebook-03: notebook-02
	$(PY) -m jupyter nbconvert --to notebook --execute "$(NOTEBOOK_DIR)/03_price_prediction.ipynb" --output 03_price_prediction.ipynb --output-dir "$(EXECUTED_DIR)" --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.kernel_name=python3

notebook-04: notebook-03
	$(PY) -m jupyter nbconvert --to notebook --execute "$(NOTEBOOK_DIR)/04_price_prediction_all.ipynb" --output 04_price_prediction_all.ipynb --output-dir "$(EXECUTED_DIR)" --ExecutePreprocessor.timeout=-1 --ExecutePreprocessor.kernel_name=python3

notebooks: notebook-04


# ---- Complete pipeline -----------------------------------------------------------------------

all: data notebooks


# ---- Cleanup --------------------------------------------------------------------------------
clean:
	$(PY) -c "import shutil; from pathlib import Path; [shutil.rmtree(p, ignore_errors=True) for p in [Path('dbt_project/target'), Path('dbt_project/logs'), Path('$(DATA_DIR)/silver'), Path('$(DATA_DIR)/gold'), Path('$(EXECUTED_DIR)')]]; [p.unlink(missing_ok=True) for p in [Path('$(DATA_DIR)/warehouse.duckdb'), Path('$(DATA_DIR)/warehouse.duckdb.wal')]]"

# ---- Packaging ------------------------------------------------------------------------------
PACKAGE := dsci_take_home_v7.zip

package:
	rm -f $(PACKAGE)
	zip -qr $(PACKAGE) . -x 'internal/*' '.venv/*' '*/__pycache__/*' \
	    '*.duckdb' '*.duckdb.wal' 'dbt_project/target/*' \
	    'dbt_project/logs/*' '.git/*' '*.DS_Store' 'PLAN.md' '$(PACKAGE)'
	@if unzip -l $(PACKAGE) | grep -qE ' internal/| \.DS_Store| PLAN\.md|warehouse\.duckdb'; then echo "PACKAGE CONTAINS INTERNAL FILES"; unzip -l $(PACKAGE) | grep -E 'internal/|DS_Store|PLAN|duckdb'; rm -f $(PACKAGE); exit 1; fi
	@echo "packaged $(PACKAGE): $$(unzip -l $(PACKAGE) | tail -1)"

release:
	$(PY) internal/build_release.py
