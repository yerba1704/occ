--> hack to avoid ORA-28702
--------------------------------------------------------------------------------
create procedure tmp authid definer is
begin
  -- Code Based Access Control (CBAC) 
  execute immediate 'grant select_catalog_role to package occ.worker';
  execute immediate 'grant apex_administrator_role to package occ.worker';
end;
/

begin tmp; end;
/

drop procedure tmp;

alter package worker compile;

alter package api compile body;