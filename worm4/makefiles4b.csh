#!/bin/tcsh
#
set basename=worm4b
set MML=$basename.xml
set tfinal="01500"
set cmsvals=(`seq 0 0.2 1` `seq 2 2 10` `seq 20 20 100` `seq 200 200 1000` `seq 2000 2000 10000`)
set mktvals=(`seq 0 0.2 1` `seq 2 2 10` `seq 20 20 100` `seq 200 200 1000` `seq 2000 2000 10000`)
set targets=()
foreach cms ($cmsvals)
    foreach mkt ($mktvals)
        set simdir=$basename/sim_"$cms"_"$mkt"
	# echo $simdir
	mkdir -p $simdir
	set targets=($targets $simdir)
	cat <<EOF >$simdir/Makefile
include Params.mk

plot_\$(TFINAL).png: ../../\$(MORPHEUSFILE)
	@-rm -f \$(BASENAME).out
	\$(MORPHEUS) -f \$< --perf-stats --cmstrength=\$(CMSTRENGTH) --MKtemp=\$(MKTEMP) --outdir . > \$(BASENAME).out

EOF
	cat <<EOF >$simdir/Params.mk
BASENAME=$basename
MORPHEUSFILE=\$(BASENAME).xml
CMSTRENGTH=$cms
MKTEMP=$mkt
TFINAL=$tfinal
MORPHEUS=morpheus
EOF
    end
end
mkdir -p $basename
cat <<EOF >$basename/Makefile
TARGETS=$targets
TFINAL=$tfinal

.PHONY: all
all: \$(TARGETS)

$basename/%::	../$MML
	\$(MAKE) -C \$(@F)

EOF
