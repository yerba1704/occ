create or replace type rule_result_o authid definer as object (
  level1_name   varchar2(128 char),
  level1_type   varchar2(30 char),
  level2_name   varchar2(128 char),
  level2_type   varchar2(30 char),
  level3_name   varchar2(128 char),
  level3_type   varchar2(30 char),
  line_number   integer,
  column_number integer,
  constructor function rule_result_o (
      self          in out nocopy rule_result_o,
      i_level1_name in varchar2,
      i_level1_type in varchar2)
    return self as result,
  constructor function rule_result_o (
      self            in out nocopy rule_result_o,
      i_level1_name   in varchar2,
      i_level1_type   in varchar2,
      i_line_number   in integer,
      i_column_number in integer)
    return self as result,
  constructor function rule_result_o (
      self          in out nocopy rule_result_o,
      i_level1_name in varchar2,
      i_level1_type in varchar2,
      i_level2_name in varchar2,
      i_level2_type in varchar2)
    return self as result,
  constructor function rule_result_o (
      self            in out nocopy rule_result_o,
      i_level1_name   in varchar2,
      i_level1_type   in varchar2,
      i_level2_name   in varchar2,
      i_level2_type   in varchar2,
      i_line_number   in integer,
      i_column_number in integer)
    return self as result,
  constructor function rule_result_o (
      self          in out nocopy rule_result_o,
      i_level1_name in varchar2,
      i_level1_type in varchar2,
      i_level2_name in varchar2,
      i_level2_type in varchar2,
      i_level3_name in varchar2,
      i_level3_type in varchar2)
    return self as result
--TODO member function sqldev link
);
/