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

module Sanitas
  # Detects Mercurial repositories
  class MercurialRepository < Repository 
    def initialize(path)
      super(path)
      @name = "Mercurial"
      @friendly_name = "hg"
    end

    def detect?
      if !is_path_clean?
        return false
      end

      # FIXME: This won't work on non UNIX-like systems
      output = `hg status #{@path} 2>&1`
      if output[0,5] == "abort"
	return false
      else
        @repo_path = @path
        return true
      end
    end
  end

  Sanitas::Factory.register(Sanitas::MercurialRepository)
end
