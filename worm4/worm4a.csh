#!/bin/tcsh
#
set sweepdir=worm4a
set cmsvals=(`seq 0 0.2 1` `seq 2 2 10` `seq 20 20 100` `seq 200 200 1000` `seq 2000 2000 10000`)
set mktvals=(`seq 0 0.2 1` `seq 2 2 10` `seq 20 20 100` `seq 200 200 1000` `seq 2000 2000 10000`)
foreach cms ($cmsvals)
    foreach mkt ($mktvals)
        set simdir=$sweepdir/sim_"$cms"_"$mkt"
	if -f $simdir/plot_10000.png continue
	rm -rf $simdir
	mkdir $simdir
	echo $simdir
	morpheus -f worm4.xml --perf-stats --cmstrength=$cms --MKtemp=$mkt --outdir $simdir >&! $simdir/worm4.out
    end
end

