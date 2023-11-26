create or replace type verification_result_o authid definer as object (
  rule_id         varchar2(4000 char),
  object_name     varchar2(128 char),
  object_type     varchar2(30 char),
  sub_object_name varchar2(128 char),
  sub_object_type varchar2(30 char),
  detail_name     varchar2(128 char),
  detail_type     varchar2(30 char),
  title           varchar2(255 char),
  fix             varchar2(4000 char)
);
/