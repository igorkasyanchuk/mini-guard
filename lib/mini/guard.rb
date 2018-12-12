require 'rake'
require 'active_support/inflector'
require 'shellany/sheller'
require 'listen'

if defined?(Pry)
  require 'pry'
end

require_relative "guard/version"

module Mini
  module Guard
    def Guard.run
      puts "Start watching files (app, views and specs) ..."
      puts "Ctrl+C to stop"

      begin
        XConfiguration.validate
        files    = XIndex.run
        listener = Listen.to('app', 'spec') do |modified, added, removed|
          new_files = XIndex.run
          XFileCommands.new(new_files - files).execute
          files = new_files
        end
        listener.start
        sleep
      rescue NotRailsAndSpecApp => ex
        puts ex.message
        puts "Exiting ..."
      rescue SystemExit, Interrupt
        puts "Exiting ..."
      end
    end

    class NotRailsAndSpecApp < StandardError
      def NotRailsAndSpecApp.error
        NotRailsAndSpecApp.new("Make sure you run this command in Rails app root folder (with rspec specs and optionally with spring gem added)")
      end
    end

    class XConfiguration
      def XConfiguration.rspec
        File.exist?("bin/rspec") ? "bin/rspec" : "rspec"
      end

      def XConfiguration.validate
        raise NotRailsAndSpecApp.error unless File.directory?("app") && File.directory?("spec")
      end
    end
    
    class XFile
      attr_reader :path, :size, :last_modified, :associations
    
      def initialize(path, code:, specs:, views:, factories:)
        @path          = path
        stat           = File.stat(path)
        @size          = stat.size
        @last_modified = stat.ctime
        @associations  = find_associations(code: code, specs: specs, views: views, factories: factories)
      end
    
      def to_s; "file: #{path} size: #{size} last modified: #{last_modified} associations: #{associations}"; end
      def hash; "#{self.path}:#{self.last_modified}".hash; end
      def eql?(xfile); self.path == xfile.path && self.last_modified == xfile.last_modified; end
    
      private
    
      def is_factory?; path =~ /^spec\/factories/; end
      def is_code?;    path =~ /^app\//; end
      def is_model?;   path =~ /^app\/models/; end
      def is_view?;    path =~ /^app\/views/; end
      def basename;    File.basename(path, ".*"); end
      def view_path;   path.split('/')[2..-2].join('/'); end
    
      def find_associations(code:, specs:, views:, factories:)
        if is_view?
          specs.select{|e| e =~ /^spec\/controllers\/#{view_path}/}
        elsif is_code?
          if is_model?
            specs.select{|e| e.split('/')[-1] =~ /#{basename}/}
          else
            specs.select{|e| e =~ /#{basename}_spec/}
          end
        else
          if is_factory?
            specs.select{|e| e =~ /spec\/models\/(#{basename}|#{basename.singularize})_spec/}
          else
            [path]
          end
        end
      end
    end
    
    class XFileCommands
      attr_reader :xassociations
    
      def initialize(xfiles)
        @xassociations = xfiles.inject([]) {|res, e| res += e.associations}
      end
    
      def execute
        if execute?
          puts "executing: #{command}"
          puts Shellany::Sheller.stdout(command)
        end
      end
    
      private
    
      def execute?; xassociations.any?; end
      def command; "#{XConfiguration.rspec} #{xassociations.join(' ')}"; end
    end
    
    class XIndex
      def XIndex.run
        code      = FileList.new('app/**/*.rb')
        specs     = FileList.new('spec/**/*_spec.rb')
        views     = FileList.new('app/views/**/*.*')
        factories = FileList.new('spec/factories/*.rb')
        (code + specs + views + factories).collect do |path|
          XFile.new(path, code: code, specs: specs, views: views, factories: factories)
        end
      end
    end
  end
end
