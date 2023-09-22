#!/usr/bin/perl

my $fil = shift || die "Use: $0 .css";

my @lines = `cat $fil`;

my $st = 0; # 0 / 1 root / 2 after root
my %V = (); # vars

sub subp($){
    my $var = shift;
    my $avar =  $V{$var};
    if (!$avar) {
        die "SUBP No avar for $var\n";
    }
#    print "SUBP: $var -> $avar\n";
    return $avar;
}

foreach my $l (@lines){
    chomp $l;
    AGAIN:

    next if ($l =~ m/^\s*$/ );

    if ( $l =~ m/(.*)\/\*/ ){
        my $pre = $1;
        #print "COMMENT $l : PRE : $pre\n";
        $l = $pre; goto AGAIN;
    }

    if ($st == 0 && $l =~ m/root/){ $st = 1; goto CONT;}
    if ($st == 1 && $l =~ m/\}/){ $st = 2; }

    if ($st == 1) { # capture vars

        if ($l =~ m/calc/ && $l =~ m/(.*)\:(.*);\s*$/) {
            # set val. goto CONT1
            my ($p1, $p2) = ($1, $2); $p1=S($p1); $p2=S($p2);
#            print "CALC: $p1 as $p2\n";

            if ($p2 =~ m/calc\((.*)\)/) {
                my $c1 = $1;
#                print "CALCP2: $c1\n";
                $c1 =~ s/var\((.*?)\)/subp($1)/smge;
#                print "EXPANDED: $c1\n";
                my $pe = ($c1 =~ m/#/ || $c1 =~ m/[a-z]/) ? $c1 : eval $c1;

                if ($pe =~ m/rem/) {
                    $pe =~ s/rem//g;    
                    $pe = eval $pe;
                    $pe = Round($pe, 4) . "rem";
                }
#                print "SET '$p1' as ($pe)\n";
                $V{$p1} = $pe;
                goto CONT1;
            } else {
                die "Bad calc $p1 as $p2\n";
            }
        }

        if ($l =~ m/var/ && $l =~ m/(.*)\:(.*);\s*$/) {
            #print "VAR: $l\n";
            my ($p1, $p2) = ($1, $2); $p1=S($p1); $p2=S($p2);
            my $vval = "";
#            print "P2: $p2\n";
            if ($p2 =~ m/var\((.*)\)/) {
                my $vnam = $1;
                #print "LOOKING for '$vnam'\n";
                #print Dumper( \%V );
                $vval = $V{ $vnam };
                die "Can't find '$vnam'" if (!$vval);
            }
#            print "SET '$p1' as '$vval'\n";
            $V{$p1} = $vval;
            goto CONT1;
        }

        if ($l =~ m/(.*)\:(.*);\s*$/){
#            print "LLL: $l\n";
            my ($p1, $p2) = ($1, $2); $p1=S($p1); $p2=S($p2);
            my $pe = ($p2 =~ m/#/ || $p2 =~ m/[a-z]/) ? $p2 : eval $p2;
            #print "SET '$p1' as '$p2' ($pe)\n";
            $V{$p1} = $pe;
            goto CONT1;
        }

        die "Bad: $l in mode $st\n";
       
        CONT1:
#        print "$l\n";
#        print Dumper( \%V );
    }

    if ($st == 2) { # insert fallbacks
        #print Dumper( \%V ); exit;
        goto CONT if ($l =~ m/calc/);

        if ($l =~ m/var/) {
            #print "$l\n";
            my $fl = $l;
            $fl =~ s/var\((.*?)\)/subp($1)/smge;
            #print "EXPANDED: $l\n";
            print "$fl\n";
        }  
    }
 
CONT:
    #print "$st: $l\n";
    print "$l\n";
}

sub S{
    my $v = shift;
    $v =~ s/^\s+//g; $v =~ s/\s+$//g; return $v;
}

sub Round {
    my $bid = shift;
    my $prc = shift;
    my $ret =  sprintf("%.0" . $prc . "f", $bid);
    return $ret;
}
