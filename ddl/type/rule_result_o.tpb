create or replace type body rule_result_o as
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  constructor function rule_result_o(
     self          in out nocopy rule_result_o,
      i_level1_name in varchar2,
      i_level1_type in varchar2)
    return self as result
  is
    c_level1_name constant dbms_id_128 not null:=i_level1_name;
    c_level1_type constant dbms_id_30 not null:=i_level1_type;
  begin
    self.level1_name:=c_level1_name;
    self.level1_type:=c_level1_type;
    return;
  end rule_result_o;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  constructor function rule_result_o(
      self            in out nocopy rule_result_o,
      i_level1_name   in varchar2,
      i_level1_type   in varchar2,
      i_line_number   in integer,
      i_column_number in integer)
    return self as result
  is
    c_level1_name constant dbms_id_128 not null:=i_level1_name;
    c_level1_type constant dbms_id_30 not null:=i_level1_type;
    c_line_number   constant pls_integer not null:=i_line_number;
    c_column_number constant pls_integer not null:=i_column_number;
  begin
    self.level1_name:=c_level1_name;
    self.level1_type:=c_level1_type;
    self.line_number:=c_line_number;
    self.column_number:=c_column_number;
    return;
  end rule_result_o;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  constructor function rule_result_o(
      self          in out nocopy rule_result_o,
      i_level1_name in varchar2,
      i_level1_type in varchar2,
      i_level2_name in varchar2,
      i_level2_type in varchar2)
    return self as result
  is
    c_level1_name constant dbms_id_128 not null:=i_level1_name;
    c_level1_type constant dbms_id_30 not null:=i_level1_type;
    c_level2_name constant dbms_id_128 null:=i_level2_name;
    c_level2_type constant dbms_id_30 null:=i_level2_type;
  begin
    self.level1_name:=c_level1_name;
    self.level1_type:=c_level1_type;
    self.level2_name:=c_level2_name;
    self.level2_type:=c_level2_type;
    return;
  end rule_result_o;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  constructor function rule_result_o(
      self            in out nocopy rule_result_o,
      i_level1_name   in varchar2,
      i_level1_type   in varchar2,
      i_level2_name   in varchar2,
      i_level2_type   in varchar2,
      i_line_number   in integer,
      i_column_number in integer)
    return self as result
  is
    c_level1_name constant dbms_id_128 not null:=i_level1_name;
    c_level1_type constant dbms_id_30 not null:=i_level1_type;
    c_level2_name constant dbms_id_128 null:=i_level2_name;
    c_level2_type constant dbms_id_30 null:=i_level2_type;
    c_line_number   constant pls_integer not null:=i_line_number;
    c_column_number constant pls_integer not null:=i_column_number;
  begin
    self.level1_name:=c_level1_name;
    self.level1_type:=c_level1_type;
    self.level2_name:=c_level2_name;
    self.level2_type:=c_level2_type;
    self.line_number:=c_line_number;
    self.column_number:=c_column_number;
    return;
  end rule_result_o;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  constructor function rule_result_o(
      self          in out nocopy rule_result_o,
      i_level1_name in varchar2,
      i_level1_type in varchar2,
      i_level2_name in varchar2,
      i_level2_type in varchar2,
      i_level3_name in varchar2,
      i_level3_type in varchar2)
    return self as result
  is
    c_level1_name constant dbms_id_128 not null:=i_level1_name;
    c_level1_type constant dbms_id_30 not null:=i_level1_type;
    c_level2_name constant dbms_id_128 null:=i_level2_name;
    c_level2_type constant dbms_id_30 null:=i_level2_type;
    c_level3_name constant dbms_id_128 null:=i_level3_name;
    c_level3_type constant dbms_id_30 null:=i_level3_type;
  begin
    self.level1_name:=c_level1_name;
    self.level1_type:=c_level1_type;
    self.level2_name:=c_level2_name;
    self.level2_type:=c_level2_type;
    self.level3_name:=c_level3_name;
    self.level3_type:=c_level3_type;
    return;
  end rule_result_o;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
end;
/