[![Build Status](https://secure.travis-ci.org/singhgarima/data_sanity.png)](http://travis-ci.org/singhgarima/data_sanity)

# Data Sanity Inspector
    It is a gem with following options to check sanity of database
        # All data in all models
        # Random data in all models :
            * specify n number of random records,
            * specify criteria
    It allows you to see details in two strategies - table/csv
        # output to a model named DataInspector
            * For this you need to run migrations
            * You get an advantage of using variable from command line
        # output to a csv file in tmp folder as data_inspector.csv

# It would output result in a table/csv with following details

    +----+------------+-------------+-------------------+-----------------------+
    | id | table_name | primary_key	| primary_key_value | errors                |
    +----+------------+-------------+-------------------+-----------------------+
    | 1	 |  Person	  | person_id	| 128	            | “Fmno can’t be blank” |
    +----+------------+-------------+-------------------+-----------------------+

# HOW TO USE
    
    * adding migrations : rake data_sanity:db:migrate [for strategy table]
    * removing migrations : rake data_sanity:db:rollback [for strategy table]
    * You can add a sample criteria file using rake data_sanity:criteria
    * To Investigate your data use rake data_sanity:investigate
        - By default it runs for all data with strategy table
            : If criteria file is specifies then picks model from file and validates only those
            : Note: For any criteria mentioned except model names is ignored
        - rake data_sanity:investigate[table,random,2]
            : parameter 1: random: show you want random selection
            : parameter 2: lets you add as many random records you want to verify [default is 1]
            : Note: if you have a criteria file it works only for models in criteria file
        - rake data_sanity:investigate[csv,random,2]
   
