create or replace package worker authid definer as

  -- Count the seconds (with 3 digits).
  function seconds_since(i_start_time in timestamp with time zone)
    return number;

  -- Execute the VERIFICATION_SQL corresponding to ARID.
  procedure exc(i_arid    in          integer,
                i_user    in          varchar2,
                i_indent  in          varchar2,
                o_results out nocopy  verification_result_c,
                o_details out nocopy  string_c);

  -- Execute all VERIFICATION_SQL corresponding to the list of ARID and add some user relevant information.
  function exc(
      i_arid    in  integer,
      i_user    in  varchar2)
    return verification_result_c;

  -- Return a list of non-oracle db users.
  function db_users return string_c;

end worker;
/