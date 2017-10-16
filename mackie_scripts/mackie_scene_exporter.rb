=begin

This script is designed to be put directly in the root of the Sketchup plugins folder.

Use something like Automator on mac to slurp up the output and generate a PDF if so desired.

Credit to Rick Wilson for the script this one was based on.

=end
require 'sketchup.rb'

module SceneExporter
	:Jpeg
	:JpegHires
	:PngHires

	def self.doExportImage(format, stem, view)
		pn = ""
		if format==:Jpeg
			pn = stem + ".jpg"
			keys = {
				:filename => pn,
				:width => view.vpwidth,
				:height => view.vpheight,
				:antialias => true,
				:compression => 0.95,
				:transparent => false
			}
		elsif format==:JpegHires
			pn = stem + ".jpg"
			keys = {
				:filename => pn,
				:width => view.vpwidth * 2,
				:height => view.vpheight * 2,
				:antialias => true,
				:compression => 1.0,
				:transparent => false
			}				
		elsif format==:PngHires
			pn = stem + ".png"
			keys = {
				:filename => pn,
				:width => view.vpwidth * 2,
				:height => view.vpheight * 2,
				:antialias => true,
				:compression => 1.0,
				:transparent => true
			}				
		end
		view.write_image(keys)
	end

	def self.deleteOldExports(path)
		oldFiles = Dir.glob(path + "*.{jpg,png,gif}");			
		if oldFiles.length>0
			if UI.messagebox("Delete old exported images?", 
								MB_YESNO,"ExportScenesToImages")
				oldFiles.each { |file| File.delete(file)} == IDYES
			end
		end
	end

	def self.exportImage(format = :Jpeg)
		model = Sketchup.active_model
		pages = model.pages
		view = model.active_view
		original_page = pages.selected_page
		
		begin
			model.start_operation "ExportScenesToImages"

			# base path for exported images.
			path = (model.path.sub(/.skp/," - Export"))

			self.deleteOldExports path
			
			# ask to prompt.
			prompt = UI.messagebox("Prompt for each scene?\nAnswer \"Yes\" if you have screen text\n" +
				"that appears on several scenes", MB_YESNO,"ExportScenesToImages")

			# disable transitions between scenes for export - will restore later.
			showtransitions = model.options["PageOptions"]["ShowTransition"]
			model.options["PageOptions"]["ShowTransition"] = false

			# loop over pages and export
			n = 0
			pages.each do |page|
				if page.name==page.label
					stem = path + ((n+1).to_s.rjust(2, "0")) + " " + (page.name.to_s)
					pages.selected_page = page

					# Status
					UI.messagebox("Exporting #{page.name}") if prompt==IDYES
					Sketchup.set_status_text("Writing #{page.name}...")
					view.refresh
					sleep(0.1) ### change step time here

					self.doExportImage format, stem, view
					
					n = n + 1
				end #if
			end #do

			# restore and summarise
			pages.selected_page = original_page
			model.options["PageOptions"]["ShowTransition"] = showtransitions
			UI.messagebox("Finished export of #{n} files like #{path}")			
		ensure
			model.abort_operation
		end
	end

	unless file_loaded?(__FILE__)
		menu = UI.menu('File')
		menu.add_separator()
		menu.add_item('Export scenes to JPG') {
		   self.exportImage :Jpeg
		}
		menu.add_item('Export scenes to JPG (hires)') {
			self.exportImage :JpegHires
		}
		menu.add_item('Export scenes to PNG (hires)') {
			self.exportImage :PngHires
		}
		file_loaded(__FILE__)
	end

end # module SceneExporter