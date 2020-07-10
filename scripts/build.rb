require 'zip'
require 'fileutils'
require 'dotenv'

Dotenv.load

PROJECT_NAME = 'locksmith'

# https://github.com/rubyzip/rubyzip#zipping-a-directory-recursively
def write_entries(entries, path, zipfile)
  entries.each do |e|
    zipfile_path = path == '' ? e : File.join(path, e)

    if File.directory?(zipfile_path)
      zipfile.mkdir zipfile_path
      subdir = Dir.entries(zipfile_path) - %w[. ..]
      write_entries(subdir, zipfile_path, zipfile)
    else
      zipfile.add(zipfile_path, zipfile_path)
    end
  end
end

def build_zip
  entries = Dir.entries('.') - %w[. .. .git .vscode scripts Makefile .gitignore build .env]
  Zip::File.open("./build/#{PROJECT_NAME}.love", Zip::File::CREATE) do |zipfile|
    write_entries(entries, '', zipfile)
  end
end

def clean
  FileUtils.rm_rf('./build/')
  FileUtils.mkdir('./build/')
end

def copy_dependencies
  FileUtils.cp(ENV['LOVE_PATH'] + '/love.exe', './build/')
  FileUtils.cp_r(Dir.glob(ENV['LOVE_PATH'] + '/*.dll'), './build/')
  FileUtils.cp(ENV['LOVE_PATH'] + '/license.txt', './build/')
end

def fuse
  `cd ./build/`
  `cmd /c copy /b love.exe+"#{PROJECT_NAME}.love" "#{PROJECT_NAME}.exe"`
  `cd ../`
end

clean
build_zip
copy_dependencies
fuse
