-- paste last column on http://magjac.com/graphviz-visual-editor/
select trim(ifnull(src.value:objectName::string, '')
    || '.' || ifnull(src.value:columnName::string, ''), '.') as source,
    trim(ifnull(om.value:objectName::string, '')
    || '.' || ifnull(col.value:columnName::string, ''), '.') as target,
    '"' || source || '" -> "' || target || '' as link
from snowflake.account_usage.access_history ah
   left join snowflake.account_usage.query_history qh
   on ah.query_id = qh.query_id,
   lateral flatten(input => objects_modified) om,
   lateral flatten(input => om.value:"columns", outer => true) col,
   lateral flatten(input => col.value:directSources, outer => true) src
where source is not null and source <> ''
    and target is not null and target <> '';

-- wait for the db changes to propagate
select qh.query_text,
   trim(ifnull(src.value:objectName::string, '')
      || '.' || ifnull(src.value:columnName::string, ''), '.') as source,
   trim(ifnull(om.value:objectName::string, '')
      || '.' || ifnull(col.value:columnName::string, ''), '.') as target,
   ah.objects_modified
from snowflake.account_usage.access_history ah
   left join snowflake.account_usage.query_history qh
   on ah.query_id = qh.query_id,
   lateral flatten(input => objects_modified) om,
   lateral flatten(input => om.value:"columns", outer => true) col,
   lateral flatten(input => col.value:directSources, outer => true) src
where ifnull(src.value:objectName::string, '') like 'LINEAGE_DB%'
   or ifnull(om.value:objectName::string, '') like 'LINEAGE_DB%'
order by ah.query_start_time;
