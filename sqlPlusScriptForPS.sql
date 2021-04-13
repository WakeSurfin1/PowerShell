set NewPage none
set heading off
set feedback off
set pagesize o

select username, user_id, created from sys.all_users order by username;

exit