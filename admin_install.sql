clear screen

define occ_password   = ora0CODECOPpassword
define occ_tablespace = sysaux

  /*******************************/
 /** INSTALL ora*CODECOP (OCC) **/
/*******************************/

whenever sqlerror exit failure rollback
whenever oserror exit failure rollback

set serveroutput on
set feedback on
set echo off
set heading off
set verify off

--------------------------------------------------------------------------------
prompt >>> create user

create user occ identified by "&occ_password"
                default tablespace &occ_tablespace
                quota 100m on &occ_tablespace;

grant create session,
      create table,
      create view,
      create procedure,
      create type
   to occ;

grant select_catalog_role 
   to occ 
 with admin option;

alter session set current_schema=occ;
--------------------------------------------------------------------------------
prompt >>> create objects

@ddl/table/severity_levels.tbl
@ddl/table/sqale_characteristics.tbl
@ddl/table/database_objects.tbl
@ddl/table/analyzer_rules.tbl
@ddl/view/ruleset.vw
@ddl/type/rule_result_o.tps
@ddl/type/rule_result_o.tpb
@ddl/type/rule_result_c.tps
@ddl/type/verification_result_o.tps
@ddl/type/verification_result_c.tps
@ddl/type/integer_c.tps
@ddl/type/string_c.tps
@ddl/package/api.pks
@ddl/package/worker.pks
@ddl/package/api.pkb
@ddl/package/worker.pkb

--------------------------------------------------------------------------------
prompt >>> create comments

@ddl/comment/severity_levels.tbl
@ddl/comment/sqale_characteristics.tbl
@ddl/comment/database_objects.tbl
@ddl/comment/analyzer_rules.tbl
@ddl/comment/ruleset.vw

--------------------------------------------------------------------------------
prompt >>> create data

@dml/severity_levels.tbl
@dml/sqale_characteristics.tbl
@dml/database_objects.tbl
@dml/analyzer_rules.tbl

--------------------------------------------------------------------------------
prompt >>> grant permission

@dcl/worker.pks
@dcl/public/api.pks
@dcl/public/ruleset.vw

commit;

--------------------------------------------------------------------------------
prompt >>> done <<<