create or replace package body worker as
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  c_max_bulk  constant pls_integer:=1000;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  function seconds_since(i_start_time in timestamp with time zone)
    return number
  is
    c_beg constant timestamp not null:=i_start_time;
    c_end constant timestamp not null:=current_timestamp;
  begin
    return
      round(
        extract(day    from(c_end-c_beg)) * 24 * 60 * 60 +
        extract(hour   from(c_end-c_beg))      * 60 * 60 +
        extract(minute from(c_end-c_beg))           * 60 +
        extract(second from(c_end-c_beg))
        ,3);
  end seconds_since;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  procedure exc(i_arid    in          integer,
                i_user    in          varchar2,
                i_indent  in          varchar2,
                o_results out nocopy  verification_result_c,
                o_details out nocopy  string_c)
  is
    c_time_beg  constant timestamp:=current_timestamp;
    c_arid      constant analyzer_rules.arid%type not null := i_arid;
    c_user_name constant dbms_id_30 not null := i_user;
    c_indent    constant dbms_id_30 null:=i_indent;
    l_stmt      analyzer_rules.verification_sql%type;
    l_rule_cfg  analyzer_rules%rowtype;
    l_cur       sys_refcursor;
    l_rule_out  rule_result_c;
  begin
    select * into l_rule_cfg from analyzer_rules where arid=c_arid;
    l_stmt:=l_rule_cfg.verification_sql;

    -- open cursor with or without bind variable
    case regexp_count(upper(l_stmt),':OWNER')
      when 1 then open l_cur for l_stmt using i_user;
      when 2 then open l_cur for l_stmt using i_user, i_user;
      when 3 then open l_cur for l_stmt using i_user, i_user, i_user;
      when 4 then open l_cur for l_stmt using i_user, i_user, i_user, i_user;
      when 5 then open l_cur for l_stmt using i_user, i_user, i_user, i_user, i_user;
      --...
      else open l_cur for l_stmt;
    end case;
      loop
        begin
          fetch l_cur bulk collect into l_rule_out limit c_max_bulk;
          exit when l_cur%notfound;
        exception
          when others then
            l_rule_out:=rule_result_c( rule_result_o('{SQL_EXECUTION_ERROR}','{INVALID_SQL}') );
            exit;
        end;
      end loop;
    close l_cur;
    
    -- collection initialization
    o_results:=verification_result_c();
    o_details:=string_c(c_indent||'OCC-'||c_arid||' '||l_rule_cfg.title||' ['||seconds_since(c_time_beg)||' sec]'
             ||case when l_rule_out.count>0 then ' (FAILED)'end);
    
    for i in 1..l_rule_out.count loop
      o_results.extend();
      o_results(o_results.count):=verification_result_o(rule_id => case when l_rule_out(i).line_number is not null 
                                                                         and sys_context('APEX$SESSION', 'APP_USER') is null
                                                                   then
                                                                    'SQLDEV:LINK:' || c_user_name || ':'
                                                                                   || l_rule_out(i).level1_type || ':'
                                                                                   || l_rule_out(i).level1_name || ':'
                                                                                   || l_rule_out(i).line_number || ':'
                                                                                   || l_rule_out(i).column_number || ':'
                                                                                   || 'OCC-'||c_arid || ':oracle.dbtools.raptor.controls.grid.DefaultDrillLink'
                                                                   else
                                                                    'OCC-'||c_arid
                                                                   end,
                                                        object_name => l_rule_out(i).level1_name,
                                                        object_type => l_rule_out(i).level1_type,
                                                        sub_object_name => l_rule_out(i).level2_name,
                                                        sub_object_type => l_rule_out(i).level2_type,
                                                        detail_name => l_rule_out(i).level3_name,
                                                        detail_type => l_rule_out(i).level3_type,
                                                        title => l_rule_cfg.title,
                                                        -- Either a human note or a executable statement like DDL, anonymous block or select statement.
                                                        fix => case when l_rule_cfg.fix_hint is not null and l_rule_cfg.fix_automation_fl=0 then
                                                                      l_rule_cfg.fix_hint
                                                                    when l_rule_cfg.fix_hint is not null and l_rule_cfg.fix_automation_fl=1 then
                                                                      replace(
                                                                        replace(
                                                                          replace(
                                                                            replace(
                                                                              replace(
                                                                                replace(
                                                                                  replace(
                                                                                    replace(
                                                                                      replace(
                                                                                        replace(l_rule_cfg.fix_hint,':owner',c_user_name),
                                                                                      ':level1_name',l_rule_out(i).level1_name),
                                                                                    ':level1_type',l_rule_out(i).level1_type),
                                                                                  ':level2_name',l_rule_out(i).level2_name),
                                                                                ':level2_type',l_rule_out(i).level2_type),
                                                                              ':level3_name',l_rule_out(i).level3_name),
                                                                            ':level3_type',l_rule_out(i).level3_type),
                                                                          ':line_number',l_rule_out(i).line_number),
                                                                        ':column_number',l_rule_out(i).column_number),
                                                                      ':fix_hint',l_rule_out(i).fix_hint)
                                                                    when l_rule_out(i).fix_hint is not null and instr(l_rule_out(i).fix_hint,':')>0 then
                                                                        replace(
                                                                          replace(
                                                                            replace(
                                                                              replace(
                                                                                replace(
                                                                                  replace(
                                                                                    replace(
                                                                                      replace(
                                                                                        replace(l_rule_out(i).fix_hint,':owner',c_user_name),
                                                                                      ':level1_name',l_rule_out(i).level1_name),
                                                                                    ':level1_type',l_rule_out(i).level1_type),
                                                                                  ':level2_name',l_rule_out(i).level2_name),
                                                                                ':level2_type',l_rule_out(i).level2_type),
                                                                              ':level3_name',l_rule_out(i).level3_name),
                                                                            ':level3_type',l_rule_out(i).level3_type),
                                                                          ':line_number',l_rule_out(i).line_number),
                                                                        ':column_number',l_rule_out(i).column_number)
                                                                    when l_rule_out(i).fix_hint is not null then
                                                                      l_rule_out(i).fix_hint
                                                              end );

      o_details.extend();
      o_details(i+1):=c_indent||'  '||l_rule_out(i).level1_name;
      o_details(i+1):=c_indent||'  '||l_rule_out(i).level1_name||
                      case when l_rule_out(i).level2_name is not null then '.'||l_rule_out(i).level2_name end||
                      case when l_rule_out(i).level3_name is not null then '('||l_rule_out(i).level3_name||')'end;
    end loop;
  exception
    when others then
      if l_cur%isopen then close l_cur; end if;
      raise;
  end exc;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  function exc(
      i_arid    in  integer,
      i_user    in  varchar2)
    return verification_result_c
  is
    c_arid      constant analyzer_rules.arid%type not null := i_arid;
    c_user_name constant dbms_id_30 not null := i_user;
    l_results verification_result_c;
    l_details string_c;
  begin
    worker.exc(i_arid => c_arid, i_user => c_user_name, i_indent => null, o_results => l_results, o_details => l_details);
    return l_results;
  end exc;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  function db_users return string_c
  is
    c_stmt constant varchar2(4000 char):=q'{
      select
        username
      from
        dba_users
      where
        profile not like 'ORA%'
        and default_tablespace not in ( 'SYSAUX', 'SYSTEM' )
        and oracle_maintained = 'N'
        and authentication_type != 'NONE'
      order by
        1
    }';
    l_cur sys_refcursor;
    l_out string_c;
  begin
    open l_cur for c_stmt;
      loop
        fetch l_cur bulk collect into l_out limit c_max_bulk;
        exit when l_cur%notfound;
      end loop;
    close l_cur;
    
    return l_out;
  end db_users;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
end worker;
/