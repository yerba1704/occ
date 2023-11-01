create or replace package api authid current_user as

  e_rule_failed exception;
  c_rule_failed constant integer:=-20001;
	pragma exception_init(e_rule_failed, c_rule_failed);

  e_invalid_rule_id exception;
  c_invalid_rule_id constant integer:=-20002;
	pragma exception_init(e_invalid_rule_id,c_invalid_rule_id);

  e_invalid_code exception;
  c_invalid_code constant integer:=-20003;
	pragma exception_init(e_invalid_code,c_invalid_code);

  e_invalid_value exception;
  c_invalid_value constant integer:=-20004;
	pragma exception_init(e_invalid_value,c_invalid_value);

  subtype small_string is string(20 char) not null;
  subtype bool is naturaln range 0..1 not null;
  
  -- (distinct) type_classifcation
  PLSQL_UNIT      constant small_string := 'PLSQL_UNIT';
  SQL_DATA_OBJECT constant small_string := 'SQL_DATA_OBJECT';
  DATABASE_OBJECT constant small_string := 'DATABASE_OBJECT';
  -- severity level
  BLOCKER         constant small_string := 'BLOCKER';
  CRITICAL        constant small_string := 'CRITICAL';
  MAJOR           constant small_string := 'MAJOR';
  MINOR           constant small_string := 'MINOR';
  INFO            constant small_string := 'INFO';
  -- sqale characteristic
  CHANGEABILITY   constant small_string := 'CHANGEABILITY';
  EFFICIENCY      constant small_string := 'EFFICIENCY';
  MAINTAINABILITY constant small_string := 'MAINTAINABILITY';
  PORTABILITY     constant small_string := 'PORTABILITY';
  RELIABILITY     constant small_string := 'RELIABILITY';
  REUSABILITY     constant small_string := 'REUSABILITY';
  SECURITY        constant small_string := 'SECURITY';
  TESTABILITY     constant small_string := 'TESTABILITY';

  -- Execute the sql statement from RULE_ID or CODE in RULESET.
  -- @A valid RULE_ID or CODE from RULESET.
  -- If not valid exception e_invalid_rule_id or e_invalid_code is raised.
  /*
  select * from occ.api.verification_result(i_rule_id_or_code => 'PARAMETER_NAMING_RULE');
  */
  function verification_result(
      i_rule_id_or_code in string)
    return verification_result_c;

  -- Verify the rule according to the RULE_ID or CODE in RULESET.
  -- @A valid RULE_ID or CODE from RULESET.
  -- If not valid exception e_invalid_rule_id or e_invalid_code is raised.
  -- @Adjust the amount of details.
  -- @Raise an exception if a rule is failed.
  /*
  exec occ.api.check_rule(i_rule_id_or_code => 'OCC-30010');
  */
  procedure check_rule(
      i_rule_id_or_code in string,
      i_verbose_mode    in boolean default true,
      i_raise_if_fail   in boolean default false);
  function check_rule(
      i_rule_id_or_code in string,
      i_verbose_mode    in bool    default 1,
      i_raise_if_fail   in bool    default 0)
    return string_c;

  -- Verify all rules that belongs to one of the associated dimension (rule_object, characteristic, severity), a tag or to all defined rules.
  -- @One of the following rule_objects, severities, characteristics:
  --    PLSQL_UNIT, SQL_DATA_OBJECT, DATABASE_OBJECT 
  --    INFO, MINOR, MAJOR, CRITICAL, BLOCKER
  --    CHANGEABILITY, EFFICIENCY, MAINTAINABILITY,  PORTABILITY,  RELIABILITY,  REUSABILITY,  SECURITY, TESTABILITY
  -- or one of the defined TAGS (case insensitive).
  -- If a severity keyword is chosen, all severity levels greater or equal are used.
  -- If parameter is not valid exception e_invalid_value is raised.
  -- If parameter is NULL all available rules will verified.
  -- @Adjust the amount of details.
  -- @Raise an exception if a rule is failed.
  /*
  exec occ.api.check_rules(i_value => OCC.API.MAINTAINABILITY);
  */
  procedure check_rules(
      i_value         in string  default null, 
      i_verbose_mode  in boolean default true,
      i_raise_if_fail in boolean default false);
  function check_rules(
      i_value         in string  default null,  
      i_verbose_mode  in bool    default 1,
      i_raise_if_fail in bool    default 0)
    return string_c;

end api;
/
