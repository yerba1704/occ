clear screen

  /*********************************/
 /** UNINSTALL ora*CODECOP (OCC) **/
/*********************************/

whenever sqlerror exit failure rollback
whenever oserror exit failure rollback

set serveroutput on
set feedback on
set echo off
set heading off
set verify off

--------------------------------------------------------------------------------
prompt >>> drop user

drop user occ cascade;

--------------------------------------------------------------------------------
prompt >>> done <<<