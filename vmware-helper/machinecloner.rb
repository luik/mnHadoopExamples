#/usr/bin/env ruby

require "fileutils"

class MachineCloner

	def initialize(machine_name)
		@machine_name = machine_name
	end

	def update_descriptor_file(new_version)
		FileUtils.chmod "u=wr", "./#{@machine_name}[#{new_version}]/Ubuntu 64-bit.vmx"
		
		lines = IO.readlines("./#{@machine_name}[#{new_version}]/Ubuntu 64-bit.vmx");

		i = 0;	
		lines.each do |line|
			if line.index("displayName")
				lines[i] = "displayName = \"Ubuntu 64-bit [#{new_version}]\""
			end
			i += 1
		end	

		File.open("./#{@machine_name}[#{new_version}]/Ubuntu 64-bit.vmx", "w") do |file| 
			file.puts lines
		end	
	end

	def copy_content(new_version)
		FileUtils.cp_r "#{@machine_name}", "#{@machine_name}[#{new_version}]"
	end

	def get_image_version()
		version = 1

		entries = Dir.entries(".")
		entries.each do |file|
			if file.index("#{@machine_name}[") && file.index("]")
				new_version =  (file[(file.index("[") + 1) .. (file.index("]"))]).to_i 	
				
				if new_version > version
					version = new_version
				end
			end
		end
		return version + 1
	end
end

if __FILE__ == $0
	machine_cloner = MachineCloner.new(ARGV[0])
	
	new_version = machine_cloner.get_image_version
	machine_cloner.copy_content new_version
	machine_cloner.update_descriptor_file new_version
end
