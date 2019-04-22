# ldap2sql

What you'll need for ldap to sql:

- Perl

- Net::Ldap	#  Go to search.cpan.org and search for LDAP.

- Mime::Base64    #  Although you can just remove this line and this block of text if you don't want to base 64 anything!
		  #  foreach(@conv64) {
                  #   if($attr =~ /^${_}$/i)  { $val=encode_base64($val);chomp($val); }
                  #  }

You don't need to _install_ this script, just copy it and run it. You may need to set your PERLLIB variable to look in the directory where ldap-to-sql.pm lives though.  Also you need to know where your perl version lives.  I've assumed /usr/bin/perl.

You _do_ need to modify the config file ldap-to-sql.pm though.

* LDAPHOST * is the server and port where ldap is running from.  If it is the current server you have installed this script on, then set 127.0.0.1:389 as LDAPHOST, otherwise put it correct host.  Note:  see my port scan code on the front page to test host and port connectivity.  By default LDAP listens on port 389, but this is configurable.

* USER * this is the LDAP user (not the system user).  When you run ldapsearch, etc, you specify this user.  By default ldap generally has cn=Manager ... as the admin user.

* PW * this is the password for that user.

* BASE * is where the retrieval will start from.  It is important that you release, this starts your db base.  For example if you LDAP tree looks like this: dc=com -> dc=example -> dc=users  then your base would be dc=users,dc=example,dc=com.  The first table generated would then be users - based on def_table_name.  All subsequent branches below dc=users would have their names flattened to name_user.

* FILTER * you can specify an attribute that must exist in all entries, which will be extracted into SQL.

* ATTRS * which attribs to extract from each entry.

* DB_NAME * what name to show in the resulting sql.

* DEF_TABLE_NAME * as described above.  The bottom branch according to base, gets overwritten with this name.

* CONV64 * this will perform base64 conversion on these attribs, good for binary stuff.

* SCOPE * if to extract all branches below base.
