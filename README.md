# Data Sanity Inspector
    It is a gem with following options to check sanity of database
        # All data in all models
        # Random data in all models :
            * specify n number of random records,
            * specify criteria

# It would output result in a table with following details

    +----+------------+-------------+-------------------+-----------------------+
    | id | table_name | primary_key	| primary_key_value | errors                |
    +----+------------+-------------+-------------------+-----------------------+
    | 1	 |  Person	  | person_id	| 128	            | “Fmno can’t be blank” |
    +----+------------+-------------+-------------------+-----------------------+

# HOW TO USE
    * adding migrations : rake data_sanity:db:migrate
    * removing migrations : rake data_sanity:db:rollback
    * Use normal rake db:migrate to migrate the migration added by rake data_sanity:db:migrate
    * You can add a sample criteria file using rake data_sanity:criteria
    * To Investigate your data use rake data_sanity:investigate
        - By default it runs for all data
        - rake data_sanity:investigate[random,2]
            : parameter 1: random: show you want random selection
            : parameter 2: lets you add as many random records you want to verify [default is 1]
            : Note: if you have a criteria file it works only for models in criteria file
