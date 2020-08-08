***********
 nt-sqlite
***********

Python, SQL and CSV files for setting up portable SQL database.

See CLI:    https://github.com/nutratech/cli

Pypi page:  https://pypi.org/project/nutra


Building the database
#########################

1. Install ``access2csv`` dependency,

.. code-block:: bash

    git submodule update --init


2. Download database and process into CSV files,

.. code-block:: bash

    cd data
    bash setup.sh
    python3 process.py

3. If you are committing database changes, add a line to :code:`nt_ver.csv` (e.g. :code:`id=3` is new),

+-----+----------+-----------------------------------+
| id  | version  | created                           |
+=====+==========+===================================+
| 1   | 0.0.0    | Wed 05 Aug 2020 07:09:35 PM EDT   |
+-----+----------+-----------------------------------+
| 2   | 0.0.1    | Wed 05 Aug 2020 08:14:52 PM EDT   |
+-----+----------+-----------------------------------+
| 3   | 0.0.2    | Thu 06 Aug 2020 09:21:39 AM EDT   |
+-----+----------+-----------------------------------+

4. Create the database with

.. code-block:: bash

    cd ../sql
    sqlite3 nutra.db

NOTE: FOLLOW STEPS 5 and 6 FROM INSIDE THE SQL SHELL

5. Create the tables, import the data, and save:

.. code-block:: sql

    .read tables.sql
    .read import.sql
    .exit

6. Verify the tables (again inside the SQL shell :code:`sqlite nutra.db`),

.. code-block:: sql

    .tables
    SELECT * FROM nutr_def WHERE id=328;
    SELECT long_desc FROM food_des WHERE id=9050;
    SELECT * FROM nt_ver;
    .exit

7. If everything looks good, compress into :code:`nutra-X.X.X.db.tar.xz` and upload to binary host.


Tables (Relational Design)
##########################

See :code:`sql/tables.sql` for details.

This is frequently updated, see :code:`docs/` for more info.

.. image:: docs/nutra.svg
