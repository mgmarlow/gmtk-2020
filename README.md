# Love2D starter

## Distribution (Windows)

Requires [Make](http://gnuwin32.sourceforge.net/packages/make.htm) and [Ruby 2.4+](https://www.ruby-lang.org/en/). Ensure that the following gems are installed on your system:

```sh
# https://github.com/rubyzip/rubyzip
gem install rubyzip
# https://github.com/bkeepers/dotenv
gem install dotenv
```

Add a `.env` file to the root of your project directory. It needs to contain a value for `LOVE_PATH` set to the directory where Love is installed.

```
# Example .env
LOVE_PATH=C:/Program Files/LOVE
```

Now run `make build`.
