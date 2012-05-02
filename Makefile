name := iso
version := $(shell cat VERSION)
out := ${name}-${version}.love
relpath := dev/love/
url = http://minornine.com/${relpath}${out}
scp = m:web/${relpath}

build: ${out}

upload: build
	scp ${out} ${scp}
	@echo ${url} | pbcopy
	@echo Copied to clipboard: ${url}

${out}: *.lua
	makelove $@
