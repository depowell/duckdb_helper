#!/usr/bin/env python3
import os
import re
import sys
import yaml
import logging

# Setup logging at DEBUG level for detailed output.
logging.basicConfig(level=logging.DEBUG, format="%(levelname)s: %(message)s")

# Determine the base directory (project root) based on the location of this script.
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS_FILE = os.path.join(BASE_DIR, "macros", "_docs__macros.yml")
MACROS_DIR = os.path.join(BASE_DIR, "macros")
VALIDATE_MACRO_ARGS = True

def get_documented_macros():
    """
    Load YAML documentation and return a dictionary mapping documented
    macro names to their YAML entries.
    
    Expected YAML structure:
    
    version: 2
    
    macros:
      - name: <macro name>
        description: "Macro description here"
        arguments:
          - name: <arg name>
            type: <string>
            description: <arg description>
    """
    if not os.path.exists(DOCS_FILE):
        logging.error(f"Docs file '{DOCS_FILE}' not found.")
        sys.exit(1)
    try:
        with open(DOCS_FILE, "r") as f:
            docs = yaml.safe_load(f)
    except yaml.YAMLError as e:
        logging.error(f"Failed to parse '{DOCS_FILE}': {e}")
        sys.exit(1)
    documented = {}
    for entry in docs.get("macros", []):
        name = entry.get("name")
        if name:
            documented[name] = entry
    logging.debug(f"Documented macros: {list(documented.keys())}")
    return documented

def get_project_macros():
    """
    Recursively scan MACROS_DIR and return a dictionary mapping macro names
    to their list of parameters (extracted from SQL files).

    The regex pattern supports both '{% macro' and '{%- macro' declarations,
    including multi-line parameter lists.
    """
    macros = {}
    # Pattern to capture a macro's name and its parameter list from SQL files.
    pattern = re.compile(r'{%-?\s*macro\s+(\w+)\s*\((.*?)\)', re.DOTALL)
    for root, _, files in os.walk(MACROS_DIR):
        for file in files:
            if file.lower().endswith(".sql"):
                path = os.path.join(root, file)
                logging.debug(f"Processing file: {path}")
                try:
                    with open(path, "r") as f:
                        content = f.read()
                except Exception as e:
                    logging.error(f"Could not read file {path}: {e}")
                    continue
                for match in pattern.finditer(content):
                    macro_name = match.group(1)
                    args_str = match.group(2).strip()
                    if args_str:
                        # Split by comma and remove extra whitespace.
                        args = [arg.strip() for arg in args_str.split(",") if arg.strip()]
                    else:
                        args = []
                    macros[macro_name] = args
                    logging.debug(f"Found macro: '{macro_name}' with arguments: {args}")
    logging.debug(f"Project macros detected: {macros}")
    return macros

def main():
    errors = []
    documented = get_documented_macros()
    project_macros = get_project_macros()

    # Check for macros that are defined in the SQL files but missing from the YAML docs.
    missing_docs = [macro for macro in project_macros if macro not in documented]
    if missing_docs:
        errors.append(
            f"Missing YAML documentation for macros: [{', '.join(missing_docs)}]"
        )
    
    # For macros that are documented, check that the documented arguments match the SQL signature.
    if VALIDATE_MACRO_ARGS:
        for macro, code_args in project_macros.items():
            if macro not in documented:
                # Already reported as missing documentation.
                continue
            doc_entry = documented[macro]
            if not doc_entry.get("description"):
                errors.append(f"{macro}: missing description")
            doc_args = doc_entry.get("arguments")
            if not isinstance(doc_args, list):
                errors.append(f"{macro}: 'arguments' should be a list")
                continue
            # Compare argument counts.
            if len(doc_args) != len(code_args):
                errors.append(
                    f"{macro}: expected {len(code_args)} documented arguments, found {len(doc_args)}"
                )
                continue
            # Compare argument names (order-insensitive).
            doc_arg_names = [arg.get("name") for arg in doc_args if arg.get("name")]
            if sorted(doc_arg_names) != sorted(code_args):
                errors.append(
                    f"{macro}: documented argument names {doc_arg_names} do not match expected {code_args}"
                )
    
    if errors:
        print("🚨 ERROR: Issues found with macro documentation:")
        for error in errors:
            print(f"  - {error}")
        print("\n💡 Hint: Please update your YAML docs to match the macro signatures as defined in your SQL files.")
        print("Required YAML format example:")
        print("```yaml")
        print("version: 2\n")
        print("macros:")
        print("  - name: <macro name>")
        print("    description: \"Macro description here\"")
        print("    arguments:")
        print("      - name: <arg name>")
        print("        type: <string>")
        print("        description: <arg description>")
        print("```")
        sys.exit(1)

    print("✅ Success: All project macros have corresponding documentation with proper details.")
    sys.exit(0)

if __name__ == "__main__":
    main()
