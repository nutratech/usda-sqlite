************
 nt-sqlite3
************

Python, SQL and CSV files for setting up portable SQL database.

See CLI:    https://github.com/nutratech/cli

Pypi page:  https://pypi.org/project/nutra

Building the database
#########################

1. Install ``access2csv`` dependency, :code:`git submodule update --init`


2. Download database and process into CSV files,

.. code-block:: bash

    cd data
    bash setup.sh
    python3 process.py

3. Create the database with

.. code-block:: bash

    cd ../sql
    sqlite3 nutra.db

NOTE: FOLLOW STEP 4 FROM INSIDE THE SQL SHELL

4. Create the tables, import the data, and save:

.. code-block:: bash

    .read tables.sql
    .read import.sql
    .exit

Tables (Relational Design)
##########################

See :code:`data/tables.sql` for details.

This is frequently updated, see :code:`docs/` for more info.

.. image:: docs/nutra.svg
