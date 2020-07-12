require 'zip'
require 'fileutils'
require 'dotenv'

Dotenv.load

PROJECT_NAME = 'SUPERBALL'

# https://github.com/rubyzip/rubyzip#zipping-a-directory-recursively
def write_entries(entries, path, zipfile, include_path: true)
  entries.each do |e|
    zipfile_path = path == '' ? e : File.join(path, e)

    if File.directory?(zipfile_path)
      zipfile.mkdir(zipfile_path)
      subdir = Dir.entries(zipfile_path) - %w[. ..]
      write_entries(subdir, zipfile_path, zipfile)
    else
      zipfile.add(include_path ? zipfile_path : e, zipfile_path)
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

def distribute
  entries = Dir.entries('./build/') - %w[. ..]
  version = `git describe --tags`.chomp
  dest = "./#{PROJECT_NAME}_#{version}.zip"

  FileUtils.rm(dest) if File.exist?(dest)

  Zip::File.open(dest, Zip::File::CREATE) do |zipfile|
    write_entries(entries, 'build/', zipfile, include_path: false)
  end 
end

clean
build_zip
copy_dependencies
# These aren't working, what's up? The fuse doesn't appear to work.
# fuse
# distribute

