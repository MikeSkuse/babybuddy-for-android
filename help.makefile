.PHONY: all info refresh-flaticon-token stringsxml clean

define convert_command =
	convert $(1) -crop "+0+170" -crop "-0-135" $(2)
endef

TARGET_PATH := app/src/main/res/drawable
SOURCE_PATH := resources/help_images

help_image_list := $(shell ls $(SOURCE_PATH)/direct/ $(SOURCE_PATH)/screenshots/ | grep -E '\.png$$')
target_image_list := $(foreach x,$(help_image_list),$(TARGET_PATH)/$(x))

HELP_POSTFIXES := \
	-nl \
	-de-rDE \

xml_files := app/src/main/res/values/help_strings.xml $(foreach x,$(HELP_POSTFIXES),app/src/main/res/values$(x)/help_strings.xml)

all: $(target_image_list) stringsxml

stringsxml: $(xml_files)

app/src/main/res/values/help_strings.xml: $(SOURCE_PATH)/help.md $(SOURCE_PATH)/process_markdown.py
	mkdir -p "$(dir $@)"
	cd $(SOURCE_PATH) \
	&& pipenv install --skip-lock -r requirements.txt \
	&& pipenv run python process_markdown.py $(abspath $<) $(abspath $@)

app/src/main/res/values-nl/help_strings.xml: $(SOURCE_PATH)/help-nl.md $(SOURCE_PATH)/process_markdown.py
	mkdir -p "$(dir $@)"
	cd $(SOURCE_PATH) \
	&& pipenv install --skip-lock -r requirements.txt \
	&& pipenv run python process_markdown.py $(abspath $<) $(abspath $@)

app/src/main/res/values-de-rDE/help_strings.xml: $(SOURCE_PATH)/help-de-rDE.md $(SOURCE_PATH)/process_markdown.py
	mkdir -p "$(dir $@)"
	cd $(SOURCE_PATH) \
	&& pipenv install --skip-lock -r requirements.txt \
	&& pipenv run python process_markdown.py $(abspath $<) $(abspath $@)

$(TARGET_PATH)/%.png: $(SOURCE_PATH)/screenshots/%.png
	$(call convert_command,$<,$@)

$(TARGET_PATH)/%.png: $(SOURCE_PATH)/direct/%.png
	cp $< $@

define clean_file =
	rm -f $(1)

endef

clean:
	$(foreach x,$(target_image_list),$(call clean_file,$(x)))
	rm -f app/src/main/res/values/help_strings.xml $(foreach x,$(HELP_POSTFIXES),app/src/main/res/values$(x)/help_strings.xml)
