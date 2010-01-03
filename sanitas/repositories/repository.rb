# Copyright (c) 2009 Mario Carrion <mario@carrion.mx>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "repositories", "factory")

module Sanitas

  class Repository
    # Notice :repo_path might be different to path, for example in git
    # repositories :repo_path will be the path containing the '/path/.git/' folder
    # and :path will be something under '/path/'
    attr_accessor :repo_path, :path, :name, :friendly_name, :branch

    def initialize(path)
      @path = path
      @repo_path = nil
      @name = nil
      @friendly_name = nil
      @branch = nil
    end

    def detect?
      return false
    end

    # - '/path/file' -> '/path'
    # - '/path/' -> '/path'
    def is_path_clean?
      if @path == nil
        return false
      elsif !File.exists?(@path)
        return false
      end

      if @path[-1].chr == "/"
        @path = @path[0, @path.length - 1]
      end

      if !File.directory?(@path)
        dirname = File.dirname(@path)
        if !File.exists?(dirname)
	  return false
	elsif !File.directory?(dirname)
	  return false
	else
	  @path = dirname
	  return true
	end
      else
        return true
      end
    end
  end
 
end
