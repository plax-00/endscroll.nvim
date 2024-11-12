.PHONY: test
test: tests/deps/mini.test
	@nvim --headless --noplugin -u ./tests/scripts/minimal_init.lua -c "lua MiniTest.run()" || true

tests/deps/mini.test:
	@mkdir -p tests/deps
	@git clone --filter=blob:none https://github.com/echasnovski/mini.test $@
