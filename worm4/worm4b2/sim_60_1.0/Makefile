include Params.mk

plot_$(TFINAL).png: ../../$(MORPHEUSFILE)
	@-rm -f $(BASENAME).out
	$(MORPHEUS) -f $< --perf-stats --cmstrength=$(CMSTRENGTH) --MKtemp=$(MKTEMP) --outdir . > $(BASENAME).out

