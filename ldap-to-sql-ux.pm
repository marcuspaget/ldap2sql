# -*- perl -*-

# ldap-to-sql.pm

$ldaphost='10.x.x.x:389';
$user='cn=Manager,dc=xxx,dc=xxx';
$pw='xxx';
$base='dc=xxx,dc=xxx';
$filter='(objectClass=*)';
#$filter='(objectClass=person)';
@attrs=["*"];
#@attrs=["sn","cn"];
$db_name='ldap';
$def_table_name='user';
$def_key_name='id';   # used as primary key in db
@conv64=("userPassword");
$scope='sub';

__END__
