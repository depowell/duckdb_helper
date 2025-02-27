Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


## **1. Project Structure**
Follow a **modular** structure similar to `dbt-utils`, but optimized for your use case:

```
my_dbt_package/
│── docs/
│   ├── decisions/  # Architecture & design decisions (optional but useful)
│── integration_tests/
│   ├── data/  # Sample test datasets (CSV files)
│   ├── macros/  # Test macros in isolation
│   ├── models/  # dbt models for integration tests
│   ├── tests/  # Schema & data tests
│   ├── dbt_project.yml  # Separate dbt project for testing
│── macros/  # Your main package macros
│── models/  # Optional (if your package includes models)
│── tests/  # Unit tests for macros (if not in integration_tests)
│── dbt_project.yml  # Root-level dbt package config
│── README.md
```

---

## **2. dbt Versioning & Compatibility**
Add the `require-dbt-version` constraint inside your `dbt_project.yml`:

```yaml
require-dbt-version: [">=1.3.0", "<2.0.0"]
```

This prevents compatibility issues with older or newer versions.

---

## **3. Testing Approach**
Since you don’t have an unlimited budget, testing should be **layered** to minimize costs while ensuring reliability.

### **(a) Local Unit Tests (Zero Cost)**
- Use **Jinja macros** and `pytest` with `dbt-templater` for fast, local tests.
- Structure macro tests using `pytest` & `dbt-unit-testing`:
  
  ```sh
  pip install dbt-unit-testing pytest
  ```
  
  Example test (`tests/test_my_macro.sql`):

  ```sql
  {% macro test_uppercase_macro() %}
    {% set result = my_macro('test_string') %}
    {% if result != 'TEST_STRING' %}
      {{ exceptions.raise_compiler_error("Macro failed") }}
    {% endif %}
  {% endmacro %}
  ```

  Then run:

  ```sh
  pytest tests/
  ```

---

### **(b) Integration Testing with a Free Snowflake Account**
- Use a **Snowflake free trial** (90 days) or **BigQuery free tier** for running actual dbt integration tests.
- Create a **separate** dbt project inside `integration_tests/` and configure `profiles.yml` with trial account credentials.
- Run full dbt tests only occasionally (e.g., before a major release).

  Example `integration_tests/dbt_project.yml`:
  
  ```yaml
  name: "integration_tests"
  version: "1.0"
  profile: "integration_tests"
  ```

  Example `integration_tests/profiles.yml` (use a free-tier database):

  ```yaml
  integration_tests:
    target: dev
    outputs:
      dev:
        type: snowflake
        account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
        user: "{{ env_var('SNOWFLAKE_USER') }}"
        password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
        role: "{{ env_var('SNOWFLAKE_ROLE') }}"
        database: "FREE_TIER_DB"
        warehouse: "FREE_WH"
        schema: "PUBLIC"
  ```

  Then run:

  ```sh
  dbt run --profiles-dir integration_tests/
  ```

---

### **(c) Mock Databases for Local Integration**
Since you can’t afford full SaaS setups:
1. **DuckDB for local testing**
   - DuckDB is an in-memory SQL engine, great for local dbt testing.
   - Install DuckDB:
   
     ```sh
     pip install duckdb
     ```
   
   - Modify `profiles.yml`:
   
     ```yaml
     my_dbt_package:
       target: dev
       outputs:
         dev:
           type: duckdb
           path: ":memory:"
     ```

   - Run dbt locally:

     ```sh
     dbt run
     dbt test
     ```

2. **SQLite for basic integration**
   - Use SQLite for simple SQL transformation tests.

---

## **4. Types of Tests**
### **Unit Tests**
- Use `pytest` & `dbt-unit-testing` for testing macros in isolation.

### **Integration Tests**
- Use **DuckDB** locally.
- Use **Snowflake free trial** or **BigQuery free tier** before releases.

### **End-to-End (E2E) Tests**
- Run full dbt projects using `dbt build` on your trial Snowflake setup.

---

## **5. Deployment & CI/CD**
Since you’re solo, **GitHub Actions** is the easiest free CI/CD option.

1. **Add a `.github/workflows/dbt.yml` file**:

```yaml
name: dbt Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v3
        with:
          python-version: '3.9'

      - name: Install dbt & dependencies
        run: |
          pip install dbt-core dbt-duckdb pytest dbt-unit-testing

      - name: Run unit tests
        run: pytest tests/

      - name: Run dbt integration tests (DuckDB)
        run: |
          cd integration_tests/
          dbt run
          dbt test
```

2. **Optional: Run on Snowflake (only for releases)**
   - Add Snowflake secrets (`SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, etc.).
   - Modify the workflow to run integration tests on Snowflake only when pushing to `main`.

---

## **6. Managing Custom Apps (Snowflake + PySpark)**
- Use **separate sub-packages** for `snowflake-specific` and `pyspark-specific` macros/models.
- Define compatibility via:

  ```yaml
  require-dbt-version: [">=1.3.0", "<2.0.0"]
  dependencies:
    - package: dbt-labs/dbt-utils
      version: [">=1.0.0", "<2.0.0"]
  ```

- Use **feature flags** inside macros to conditionally execute code based on the adapter:

  ```jinja
  {% if target.type == 'snowflake' %}
    -- Snowflake-specific SQL
  {% elif target.type == 'spark' %}
    -- PySpark-specific logic
  {% else %}
    {{ exceptions.raise_compiler_error("Unsupported adapter") }}
  {% endif %}
  ```

---

## **Summary**
### ✅ **Project Setup**
- Follow a modular structure.
- Define dbt version constraints.

### ✅ **Testing Strategy**
- **Unit tests**: Run macros locally with `pytest` & `dbt-unit-testing`.
- **Integration tests**: Use DuckDB & a free Snowflake trial.
- **End-to-end tests**: Run before major releases on Snowflake.

### ✅ **CI/CD**
- Use **GitHub Actions** for automated testing.
- Store **Snowflake credentials** as GitHub secrets.

### ✅ **Handling Snowflake & PySpark**
- Use **sub-packages** and **adapter-specific macros**.

---

### **Next Steps**
1. **Set up DuckDB locally & write unit tests**.
2. **Create a Snowflake free trial for integration tests**.
3. **Implement GitHub Actions for CI/CD**.
4. **Publish the package to dbt Hub once stable**.

Would you like a **starter template repo** with these configurations? 🚀