
### About

This project aims to build a robust set of helper macros for `dbt-duckdb`. Please reach out if you wish to contribute.

### Using `uv` to Install and Sync Requirements

This project uses uv to manage dependancies and requirements

### **DuckDB for local testing**
   - DuckDB is an in-memory SQL engine, great for local dbt testing.
   - Install DuckDB:
   
     ```sh
     pip install duckdb
     ```
   
   - Modify `profiles.yml`:
   
     ```yaml
     duckdb_helper:
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
