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

config.org: Emacs.org
	ln -s ./Emacs.org config.org

build: $(BUILD) config.el config.org packages.el $(ELISP)
	~/.config/emacs/bin/doom sync

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm config.el packages.el config.org
	rm -rf $(BUILD)

.PHONY: build clean
