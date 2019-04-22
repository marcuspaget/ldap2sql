#!/usr/bin/perl -w

use Net::LDAP;
use MIME::Base64;

require("ldap-to-sql.pm");              # defines host, port, user, pw, search criteria

use vars qw(*ldaphost *user *pw *base *filter *attrs *def_table_name *def_key_name *db_name *conv64 *scope);

$ldap = Net::LDAP->new($ldaphost) or die "$@";  # connect to ldap host
$mesg = $ldap->bind($user,password=>"$pw");
$mesg->code && die "auth: ".$mesg->error."$!\n";        # do the search or die with error
$mesg = $ldap->search ( base => $base, scope => $scope, filter => $filter, attrs => @attrs,);
$mesg->code && die $mesg->error;        # do the search or die with error

my $max = $mesg->count;                 # max is total number of return entries

LOOP: for($i=0;$i<$max;$i++) {          # spin around all entries

        my $entry = $mesg->entry($i);   # grab a specific entry
        my $dn = $entry->dn();          # grab the dn of this entry

        next LOOP if($dn =~ /^${base}$/i); # ignore the base of the tree

        $dn=~s/,${base}$//i;             # remove the base of the tree from the dn var

        my @dn=split(",",$dn);          # split each part of the dn


        my $pkey=$dn[-1];               # extract the last record of the dn, as the key to this branch
        $pkey=~s/.*=//;                 # extract the last record of the dn, as the key to this branch

        my $table_name="$def_table_name";

        for($j=0;$j<$#dn;$j++) {
                # create the table name, by substituting each comma with an underscore
                $thisDn=$dn[$j];$thisDn=~s/.*=//;$table_name.="_$thisDn";
        }

        my $fieldNames="$def_key_name";           # var to hold sql field names
        my $fieldValues="\"$pkey\"";    # var to hold sql values


        foreach my $attr ($entry->attributes) { # spin around each attribute within this entry

                $val=$entry->get_value($attr);  # get value for this attrib

                unless($attr =~ /objectClass/i) {

                                        foreach(@conv64) {
                                                if($attr =~ /^${_}$/i)  { $val=encode_base64($val);chomp($val); }
                                        }

                    $fieldValues.=",'$val'"; # append this val to list
                    $fieldNames.=",$attr";     # append this attrib to list of fields, may be able to remove this step

                }
        }
        print("INSERT INTO $db_name.$table_name ($fieldNames) VALUES ($fieldValues);\n");
}

$mesg = $ldap->unbind;

exit(0);

__END__
