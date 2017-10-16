=begin

Load all mackie scripts.

=end
def loadMackieScripts
    Dir["#{File.dirname(__FILE__)}/mackie_scripts/**/*.rb"].each { |f| load(f) }
end

loadMackieScripts

unless file_loaded?(__FILE__)
    menu = UI.menu('File')
    menu.add_separator()
    menu.add_item('Reload mackie scripts') {
        loadMackieScripts
    }
    file_loaded(__FILE__)
end