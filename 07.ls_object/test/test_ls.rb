# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls_class'
require_relative '../get_files'
require_relative '../default_ls'
require_relative '../long_format_ls'

class LsTest < Minitest::Test
  def test_default
    expected = <<~LIST.chomp
      abc.txt    file_c.txt file_f.txt
      file_a.txt file_d.txt test_ls.rb
      file_b.txt file_e.txt
    LIST
    all = false
    reverse = false
    files = get_files(all, reverse)
    ls_content = DefaultLs.generate(files)
    assert_equal expected, ls_content
  end

  def test_all
    expected = <<~LIST.chomp
      .          file_b.txt file_e.txt
      abc.txt    file_c.txt file_f.txt
      file_a.txt file_d.txt test_ls.rb
    LIST
    all = true
    reverse = false
    files = get_files(all, reverse)
    ls_content = DefaultLs.generate(files)
    assert_equal expected, ls_content
  end

  def test_reverse
    expected = <<~LIST.chomp
      test_ls.rb file_d.txt file_a.txt
      file_f.txt file_c.txt abc.txt
      file_e.txt file_b.txt
    LIST
    all = false
    reverse = true
    files = get_files(all, reverse)
    ls_content = DefaultLs.generate(files)
    assert_equal expected, ls_content
  end

  def test_list
    file = My::File.new('test_ls.rb')
    expected = <<~LIST.chomp
      total 20
      -rw-r--r-- 1 s-tone s-tone 3001 Dec 03 14:54 abc.txt
      -rw-r--r-- 1 s-tone s-tone   16 Dec 03 14:57 file_a.txt
      -rw-r--r-- 1 s-tone s-tone   50 Dec 03 14:57 file_b.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_c.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_d.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_e.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_f.txt
      -rw-r--r-- 1 s-tone s-tone #{file.size} #{file.mtime} test_ls.rb
    LIST
    all = false
    reverse = false
    files = get_files(all, reverse)
    ls_content = LongFormatLs.generate(files)
    assert_equal expected, ls_content
  end

  def test_all_reverse
    expected = <<~LIST.chomp
      test_ls.rb file_d.txt file_a.txt
      file_f.txt file_c.txt abc.txt
      file_e.txt file_b.txt .
    LIST
    all = true
    reverse = true
    files = get_files(all, reverse)
    ls_content = DefaultLs.generate(files)
    assert_equal expected, ls_content
  end

  def test_all_list
    file = My::File.new('test_ls.rb')
    current_directory = My::File.new('.')
    expected = <<~LIST.chomp
      total 24
      drwxr-xr-x 2 s-tone s-tone #{current_directory.size} #{current_directory.mtime} .
      -rw-r--r-- 1 s-tone s-tone 3001 Dec 03 14:54 abc.txt
      -rw-r--r-- 1 s-tone s-tone   16 Dec 03 14:57 file_a.txt
      -rw-r--r-- 1 s-tone s-tone   50 Dec 03 14:57 file_b.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_c.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_d.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_e.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_f.txt
      -rw-r--r-- 1 s-tone s-tone #{file.size} #{file.mtime} test_ls.rb
    LIST
    all = true
    reverse = false
    files = get_files(all, reverse)
    ls_content = LongFormatLs.generate(files)
    assert_equal expected, ls_content
  end

  def test_reverse_list
    file = My::File.new('test_ls.rb')
    expected = <<~LIST.chomp
      total 20
      -rw-r--r-- 1 s-tone s-tone #{file.size} #{file.mtime} test_ls.rb
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_f.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_e.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_d.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_c.txt
      -rw-r--r-- 1 s-tone s-tone   50 Dec 03 14:57 file_b.txt
      -rw-r--r-- 1 s-tone s-tone   16 Dec 03 14:57 file_a.txt
      -rw-r--r-- 1 s-tone s-tone 3001 Dec 03 14:54 abc.txt
    LIST
    all = false
    reverse = true
    files = get_files(all, reverse)
    ls_content = LongFormatLs.generate(files)
    assert_equal expected, ls_content
  end

  def test_reverse_list_all
    file = My::File.new('test_ls.rb')
    current_directory = My::File.new('.')
    expected = <<~LIST.chomp
      total 24
      -rw-r--r-- 1 s-tone s-tone #{file.size} #{file.mtime} test_ls.rb
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_f.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_e.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_d.txt
      -rw-r--r-- 1 s-tone s-tone    0 Dec 03 14:56 file_c.txt
      -rw-r--r-- 1 s-tone s-tone   50 Dec 03 14:57 file_b.txt
      -rw-r--r-- 1 s-tone s-tone   16 Dec 03 14:57 file_a.txt
      -rw-r--r-- 1 s-tone s-tone 3001 Dec 03 14:54 abc.txt
      drwxr-xr-x 2 s-tone s-tone #{current_directory.size} #{current_directory.mtime} .
    LIST
    all = true
    reverse = true
    files = get_files(all, reverse)
    ls_content = LongFormatLs.generate(files)
    assert_equal expected, ls_content
  end
end
