SLIDR := $(abspath ../slidr)
DECKS := snow_corp_cncf hami_intro
HTMLS := $(addprefix dist/,$(addsuffix .html,$(DECKS)))

all: $(HTMLS)

dist/%.html: %.md
	@mkdir -p dist
	cd $(SLIDR) && pdm run slidr $(CURDIR)/$<

watch-%: %.md
	cd $(SLIDR) && pdm run slidr -w $(CURDIR)/$<

clean:
	rm -rf dist/

.PHONY: all clean watch-%
