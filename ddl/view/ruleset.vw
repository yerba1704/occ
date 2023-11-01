create or replace view ruleset 
as
  select 'OCC-'||r.arid as rule_id,
         r.code,
         r.title,
         coalesce(o.documentation_name, o.type_classification, o.schema_scope) as rule_object,
         c.characteristic,
         s.severity,
         r.tags,
         r.motivation,
         r.fix_automation_fl,
         r.fix_hint,
         --...
         r.verification_sql,
         r.created_on,
         r.created_by,
         r.modified_on,
         r.modified_by
    from analyzer_rules r
    join database_objects o using (doid)
    join severity_levels s using (slid)
    join sqale_characteristics c using (scid)
order by 1;