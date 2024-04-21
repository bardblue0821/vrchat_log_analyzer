require 'json'

class Analyzelog
    def self.analyzelog
        current_dir = File.dirname(File.expand_path(__FILE__))
        config_path = File.join(current_dir, "config.json")
        config = JSON.parse(File.read(config_path))

        log_paths = Dir.glob(File.join(config["log_path"]["dir"], config["log_path"]["file"]))
        out_path = config["out_path"]["dir"] + config["out_path"]["file"]

        lines_with_target = []
        @hash_datum = []

        log_paths.each do |log_path|
            lines_with_target << "*******************************"
            lines_with_target << "  " + log_path
            lines_with_target << "*******************************"
            File.open(log_path, "r") do |file|
                file.each_line do |line|
                    config["query"].each do |target, replace_to|
                        #puts "#{target} -> #{replace_to}" 
                        cleaned_line = line.chomp.strip
                        if cleaned_line.include?(target)
                            replaced_line = cleaned_line.gsub(target, replace_to).gsub("Log        -  ", "")
                            lines_with_target << replaced_line
                            @hash_datum << {
                                file: log_path,
                                date: replaced_line.split[0],
                                time: replaced_line.split[1],
                                type: replaced_line.split[2],
                                info: replaced_line.split[3].split(/\t|:\d+/)[0]
                            }
                        end
                    end
                end
            end
        end

        #puts lines_with_target.slice(0, 10)

        File.open(out_path, "w") do |output_file|
            lines_with_target.each do |line|
                output_file.puts line
            end
        end

        return @hash_datum
    end
end