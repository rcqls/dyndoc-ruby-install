#!/usr/bin/env ruby

module DyndocMsys2

  def DyndocMsys2.root_path
    return ENV["DYNDOC_MSYS2_ROOT"] if ENV["DYNDOC_MSYS2_ROOT"]
    pa=ENV["WD"].split("\\")
    pa[0]=pa[0][0,1]
    pa.unshift("")[0...-2].join(File::Separator)
  end

  def DyndocMsys2.global_mingw_path(pa)
    if (["C","c","D","d","E","e","Z","z"].include? pa[0,1]) and pa[1,1]==":" and pa[2,1]=="\\" and File.directory? File::Separator+pa[0,1]
      # global mingw path
      sep='\\'
      return pa[2..-1].split(sep).insert(1,pa[0,1]).join(File::Separator)
    else
      nil
    end
  end

  def DyndocMsys2.global_path(pa)
    root_pa=DyndocMsys2.root_path
    return root_path unless pa
    if pa[0,1]==File::Separator
      # from inside root of msys2 system (i.e. /<nodrive-rep>/...)
      return File.join(root_pa,pa)
    elsif (gpa=DyndocMsys2.global_mingw_path(pa))
      return gpa
    else
      # relative path
      File.join(root_pa,pa.gsub("\\",File::Separator))
    end
  end

  def DyndocMsys2.home_path(pa=nil)
    File.join(DyndocMsys2.root_path,["home",ENV["USERNAME"],pa].compact)
  end

  def DyndocMsys2.atom_path
    atom=`which atom`.strip
    if File.exist?(atom)
      if atom =~  /\/(app-[^\/]*)\//
        # atom is here the binary certainly put in Windows %PATH%
        return atom.split(File::Separator)[0...-1].join(File::Separator)
      else
        # this is the default atom which does not work with Msys2 and here is a way to fix it
        File.read(atom).strip =~ /\/(app-[^\/]*)\//
        return (File.dirname(atom).split(File::Separator)[0...-1].push($1)).join(File::Separator)
      end
    else
      return nil
    end
  end
end

case ARGV[0]
when "home"
  puts DyndocMsys2.home_path ARGV[1]
when "global"
  puts DyndocMsys2.global_path ARGV[1]
when "atom"
  puts DyndocMsys2.atom_path
end
