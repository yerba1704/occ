create or replace package body api as
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  c_all_rules constant dbms_id_30:='All existing rules';
  c_indent varchar2(2 char):='  ';
  type t_sbyn is table of varchar2(4000 char) index by pls_integer;
  g_exception_messages_c t_sbyn;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  function verification_result(
      i_rule_id_or_code in string)
    return verification_result_c
  is
    c_rule_id_or_code constant ruleset.rule_id%type not null := i_rule_id_or_code;
    c_parameter_is_id constant boolean:=substr(c_rule_id_or_code,1,4)='OCC-';
    l_arid analyzer_rules.arid%type;
  begin
    -- verify parameter
    if c_parameter_is_id then
      select to_number ( substr(rule_id, - 5) ) into l_arid from occ.ruleset where rule_id = c_rule_id_or_code;
    else
      select to_number ( substr(rule_id, - 5) ) into l_arid from occ.ruleset where code = c_rule_id_or_code;
    end if;
    -- do the work
    return worker.exc(i_arid => l_arid, i_user => user);

  exception
    when no_data_found then
      if c_parameter_is_id 
        then raise_application_error(c_invalid_rule_id, sys.utl_lms.format_message(g_exception_messages_c(c_invalid_rule_id), c_rule_id_or_code) );
        else raise_application_error(c_invalid_code,    sys.utl_lms.format_message(g_exception_messages_c(c_invalid_code),    c_rule_id_or_code) );
      end if;
    when others then
      raise;
  end verification_result;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure check_rule(
      i_rule_id_or_code in string,
      i_verbose_mode    in boolean,
      i_raise_if_fail   in boolean)
  is
    c_rule_id_or_code constant ruleset.rule_id%type not null := i_rule_id_or_code;
    c_verbose_mode constant boolean := i_verbose_mode;
    c_raise_if_fail constant boolean := i_raise_if_fail;
    c_parameter_is_id constant boolean:=substr(c_rule_id_or_code,1,4)='OCC-';
    l_arid analyzer_rules.arid%type;
    l_results   verification_result_c;
    l_details   string_c;
  begin
    -- verify parameter
    if c_parameter_is_id then
      select to_number ( substr(rule_id, - 5) ) into l_arid from occ.ruleset where rule_id = c_rule_id_or_code;
    else
      select to_number ( substr(rule_id, - 5) ) into l_arid from occ.ruleset where code = c_rule_id_or_code;
    end if;
    -- do the work
    worker.exc(i_arid => l_arid, i_user => user, i_indent => null, o_results => l_results, o_details => l_details);
    -- raise due to configuration
    if c_raise_if_fail and l_results.count>0 then raise e_rule_failed; end if;
      -- print details
      dbms_output.put_line(l_details(1));
      if c_verbose_mode then for i in 2..l_details.count loop dbms_output.put_line( l_details(i) ); end loop; end if;
  exception
    when e_rule_failed then
      raise_application_error(c_rule_failed,      sys.utl_lms.format_message(g_exception_messages_c(c_rule_failed),     l_details(1)) );
    when no_data_found then
      raise_application_error(c_invalid_rule_id,  sys.utl_lms.format_message(g_exception_messages_c(c_invalid_rule_id), c_rule_id_or_code) );
    when others then
      raise;
  end check_rule;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  function check_rule(
      i_rule_id_or_code in string,
      i_verbose_mode    in bool,
      i_raise_if_fail   in bool)
    return string_c
  is
    c_rule_id_or_code constant ruleset.rule_id%type not null := i_rule_id_or_code;
    c_verbose_mode constant boolean := i_verbose_mode=1;
    c_raise_if_fail constant boolean := i_raise_if_fail=1;
    c_parameter_is_id constant boolean:=substr(c_rule_id_or_code,1,4)='OCC-';
    l_arid analyzer_rules.arid%type;
    l_results   verification_result_c;
    l_details   string_c;
    l_out       string_c:=string_c();
  begin
    -- verify parameter
    if c_parameter_is_id then
      select to_number ( substr(rule_id, - 5) ) into l_arid from occ.ruleset where rule_id = c_rule_id_or_code;
    else
      select to_number ( substr(rule_id, - 5) ) into l_arid from occ.ruleset where code = c_rule_id_or_code;
    end if;
    -- do the work
    worker.exc(i_arid => l_arid, i_user => user, i_indent => null, o_results => l_results, o_details => l_details);
    -- raise due to configuration
    if c_raise_if_fail and l_results.count>0 then raise e_rule_failed; end if;
      -- return details
      l_out:=l_out multiset union case when c_verbose_mode then l_details else string_c(l_details(1)) end;
    
    return l_out;
  exception
    when e_rule_failed then
      raise_application_error(c_rule_failed,      sys.utl_lms.format_message(g_exception_messages_c(c_rule_failed),     l_details(1)) );
    when no_data_found then
      raise_application_error(c_invalid_rule_id,  sys.utl_lms.format_message(g_exception_messages_c(c_invalid_rule_id), c_rule_id_or_code) );
    when others then
      raise;
  end check_rule;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure check_rules(
      i_value         in string, 
      i_verbose_mode  in boolean,
      i_raise_if_fail in boolean)
  is
    c_value constant ruleset.tags%type null := i_value;
    c_verbose_mode constant boolean := i_verbose_mode;
    c_raise_if_fail constant boolean := i_raise_if_fail;
    l_arid_c    integer_c;
    l_results   verification_result_c;
    l_details   string_c;
    l_time_beg  timestamp;
    l_fail_cnt  simple_integer:=0;
  begin
    -- build collection with matched rule_id
    if c_value is not null then
      case 
        -- rule_objects?
        when c_value in (PLSQL_UNIT, SQL_DATA_OBJECT, DATABASE_OBJECT) then
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where upper(replace(replace(rule_object,' ','_'),'/')) = c_value;
        -- severity?
        when c_value in (BLOCKER, CRITICAL, MAJOR, MINOR, INFO) then
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where upper(severity) = c_value;
        -- characteristic?
        when c_value in (CHANGEABILITY , EFFICIENCY, MAINTAINABILITY, PORTABILITY, RELIABILITY, REUSABILITY, SECURITY, TESTABILITY) then
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where upper(characteristic) = c_value;
        -- tag?
        else
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where instr(tags,lower(c_value))>0;
          if l_arid_c.count=0 then raise e_invalid_value; end if;
      end case;
    else
      select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset;
    end if;
    -- execute collection with rule_ids
    l_time_beg:=current_timestamp;
    for i in 1..l_arid_c.count loop
      -- rule set header
      if i=1 then dbms_output.put_line(nvl(c_value,c_all_rules)); end if;
      -- do the work
      worker.exc(i_arid => l_arid_c(i), i_user => user, i_indent => c_indent, o_results => l_results, o_details => l_details);
      -- raise due to configuration
      if c_raise_if_fail and l_results.count>0 then raise e_rule_failed; end if;
        -- print details
        dbms_output.put_line(l_details(1));
        if instr(l_details(1),'FAILED')>0 then l_fail_cnt:=l_fail_cnt+1; end if;
        if c_verbose_mode then for i in 2..l_details.count loop dbms_output.put_line( l_details(i) ); end loop; end if;
    end loop;
    dbms_output.new_line;
    dbms_output.put_line('Finished in '||worker.seconds_since(l_time_beg)||' seconds.');
    dbms_output.put_line(l_arid_c.count||' checks, '||l_fail_cnt||' failed.');
  exception
    when e_rule_failed then
      raise_application_error(c_rule_failed,   sys.utl_lms.format_message(g_exception_messages_c(c_rule_failed),   trim( l_details(1) )) );
    when e_invalid_value then
      raise_application_error(c_invalid_value, sys.utl_lms.format_message(g_exception_messages_c(c_invalid_value), c_value) );
    when others then
      raise;
  end check_rules;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  function check_rules(
      i_value         in string, 
      i_verbose_mode  in bool,
      i_raise_if_fail in bool)
    return string_c
  is
    c_value constant ruleset.tags%type null := i_value;
    c_verbose_mode constant boolean := i_verbose_mode=1;
    c_raise_if_fail constant boolean := i_raise_if_fail=1;
    l_arid_c    integer_c;
    l_results   verification_result_c;
    l_details   string_c;
    l_out       string_c:=string_c();
    l_time_beg  timestamp;
    l_fail_cnt  simple_integer:=0;
  begin
    -- build collection with matched rule_id
    if c_value is not null then
      case 
        -- rule_objects?
        when c_value in (PLSQL_UNIT, SQL_DATA_OBJECT, DATABASE_OBJECT) then
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where upper(replace(replace(rule_object,' ','_'),'/')) = c_value;
        -- severity?
        when c_value in (BLOCKER, CRITICAL, MAJOR, MINOR, INFO) then
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where upper(severity) = c_value;
        -- characteristic?
        when c_value in (CHANGEABILITY , EFFICIENCY, MAINTAINABILITY, PORTABILITY, RELIABILITY, REUSABILITY, SECURITY, TESTABILITY) then
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where upper(characteristic) = c_value;
        -- tag?
        else
          select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset 
           where instr(tags,lower(c_value))>0;
          if l_arid_c.count=0 then raise e_invalid_value; end if;
      end case;
    else
      select to_number ( substr(rule_id, - 5) ) bulk collect into l_arid_c from occ.ruleset;
    end if;
    -- execute collection with rule_ids
    l_time_beg:=current_timestamp;
    for i in 1..l_arid_c.count loop
      -- rule set header
      if i=1 then l_out.extend; l_out(1):=c_all_rules; end if;
      -- do the work
      worker.exc(i_arid => l_arid_c(i), i_user => user, i_indent => c_indent, o_results => l_results, o_details => l_details);
      -- raise due to configuration
      if c_raise_if_fail and l_results.count>0 then raise e_rule_failed; end if;
        if instr(l_details(1),'FAILED')>0 then l_fail_cnt:=l_fail_cnt+1; end if;
        -- return details
        l_out:=l_out multiset union case when c_verbose_mode then l_details else string_c(l_details(1)) end;
    end loop;
    l_out.extend(3);
    l_out(l_out.count-2):='----';
    l_out(l_out.count-1):='Finished in '||worker.seconds_since(l_time_beg)||' seconds.';
    l_out(l_out.count):=l_arid_c.count||' checks, '||l_fail_cnt||' failed.';

    return l_out;
  exception
    when e_rule_failed then
      raise_application_error(c_rule_failed,   sys.utl_lms.format_message(g_exception_messages_c(c_rule_failed),   trim( l_details(1) )) );
    when e_invalid_value then
      raise_application_error(c_invalid_value, sys.utl_lms.format_message(g_exception_messages_c(c_invalid_value), c_value) );
    when others then
      raise;
  end check_rules;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
begin
  g_exception_messages_c(c_invalid_rule_id):='%s not exist.';
  g_exception_messages_c(c_rule_failed):='%s';
  g_exception_messages_c(c_invalid_value):='Value %s is not a valid rule object, severity, characteristic or tag.';
end api;
/