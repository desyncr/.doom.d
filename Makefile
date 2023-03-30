BUILD := .elisp
SRC   := $(patsubst config/packages.org,,$(wildcard config/*.org))
ELISP := $(patsubst config/%.org,$(BUILD)/%.el,$(SRC))
TANGLE := ~/.config/emacs/bin/org-tangle

all: build

$(BUILD)/%.el: config/%.org
	$(TANGLE) $<

packages.el: config/packages.org
	$(TANGLE) $<

config.el: Emacs.org
	$(TANGLE) $<

build: $(BUILD) config.el packages.el $(ELISP)

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)

.PHONY: build clean
