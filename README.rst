**********
 nutra-db
**********

.. image:: https://api.travis-ci.com/gamesguru/ntdb.svg?branch=master
    :target: https://travis-ci.com/gamesguru/ntdb

Python, SQL and CSV files for setting up portable SQL database.

See CLI:    https://github.com/nutratech/cli

Pypi page:  https://pypi.org/project/nutra

Building the database
#########################

1. Inside ``/data`` folder, run :code:`bash setup.sh`

2. Now run :code:`python3 process.py`

3. Create the database with :code:`sqlite3 nutra.db`

4. Create the tables, import the data, and save:

.. code-block:: bash

    .read tables.sql
    .read import.sql
    .exit

Tables (Relational Design)
##########################

See :code:`sql/tables.sql` for details.

This is frequently updated, see :code:`docs/` for more info.

.. image:: docs/nutra.svg
