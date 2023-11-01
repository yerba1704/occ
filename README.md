# ora* CODECOP

## Introduction

The always free __ora* CODECOP__ is a framework to help you define rules for your database users and verify these rules with SQL statements.

## Example usage

All existing rules and definitions are available in the `ruleset` view:  

`select * from occ.ruleset;`

To check a specific rule (singular) pass the id...

`exec occ.api.check_rule(i_rule_id_or_code => 'OCC-30010');`

... or the code:

`exec occ.api.check_rule(i_rule_id_or_code => 'DESCRIPTION_FOR_ALL_DATA_OBJECTS');`

To check a set of rules (plural) pass either a rule object...

`exec occ.api.check_rules(i_value => OCC.API.PLSQL_UNIT);`

...or a severity...

`exec occ.api.check_rules(i_value => OCC.API.MINOR);`

...or a characteristic...

`exec occ.api.check_rules(i_value => OCC.API.MAINTAINABILITY);`

..or a tag:

`exec occ.api.check_rules(i_value => 'CIO');`

All existing rules can be checked without passing any  parameter:

`exec occ.api.check_rules;`

Each procedure also exists as a table function and provide exactly the same functionality (parameters and behavior are equal). The only difference is the output of the results. The function provide output as a collection and therefore need to be executed as select statement.

`select * from occ.api.check_rules(i_value => 'MINOR');`

is similar to

`exec occ.api.check_rules(i_value => OCC.API.MINOR);`

Here is an example for a SQL statement which use the table function for several specific rules:

``````sql
select * from 
	(select rule_id from occ.ruleset where rule_id like '%-40%') several_rule_ids,
    occ.api.check_rule(i_rule_id_or_code => several_rule_ids.rule_id)
``````

The full PL/SQL Package Reference for the public API package can be found [here](doc/api.adoc).

## Predefined Ruleset

The default ruleset from the installation contains these rules for demonstration purpose.

| RULE_ID   | TITLE                                           | RULE_OBJECT     | CHARACTERISTIC  | SEVERITY | TAGS     |
| --------- | ----------------------------------------------- | --------------- | --------------- | -------- | -------- |
| OCC-30010 | All data objects must have a description.       | SQL Data Object | Maintainability | Minor    | cio      |
| OCC-40010 | IN parameters must start with Prefix P.         | PL/SQL Unit     | Maintainability | Major    |          |
| OCC-40020 | Code should not exceed 160 characters per line. | PL/SQL Unit     | Maintainability | Minor    |          |
| OCC-79010 | All tables must have a description.             | Tables          | Maintainability | Minor    |          |
| OCC-80010 | All views should have readyonly constraints.    | Views           | Security        | Major    | cio,demo |

## Custom Ruleset

Beside the [Predefined Ruleset](#predefined-ruleset) in __ora* CODECOP__ you can create your own rules by simply insert a row into the table `ANALYZER_RULES`.

It is strongly recommended to use the APEX application [occ-apex](https://github.com/yerba1704/occ-apex) for create, modify or delete rules.

## Installation

To install __ora* CODECOP__ execute the script `admin_install.sql`. This will create a new user `OCC`, grant all required privileges to that user and grant the `API` package to public.

The `OCC` user receive the following privileges:

- create session
- create table
- create view,
- create procedure
- create type

## Compatibility

Tested with:

- Oracle Database 19c [occ](https://github.com/yerba1704/occ)
- Oracle APEX 23.1.2 [occ-apex](https://github.com/yerba1704/occ-apex)
- Oracle SQL Developer 22.2.0 [occ-sqldeveloper](https://github.com/yerba1704/occ-sqldeveloper)
- utPLSQL 3.1.13 [occ-utplsql](https://github.com/yerba1704/occ-utplsql)

## Contributing to the project

If you have an interesting feature in mind, that you would like to see in __ora* CODECOP__ please create a [new issue](https://github.com/yerba1704/occ/issues).

## Related Resources

[PDF](https://anwenderkonferenz.doag.org/de/home/) from DOAG 2023 presentation.

## License

__ora* CODECOP__ is released under the [MIT license](license.md).

## Version History

November 1, 2023

- public release
