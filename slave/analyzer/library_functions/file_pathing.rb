class FilePathing
  def self.tmp_folder(curation, sub_folder="")
    $instance.tmp_path = ROOT+"/tmp_files/#{$instance.instance_id}/#{curation.folder_name}/#{sub_folder}"
    Sh::mkdirs($instance.tmp_path)
    return $instance.tmp_path.gsub(/\/+/, "/")
  end

  def self.mysqldump(model, conditional)
    `mysqldump -h #{Environment.host} -u #{Environment.username} --password='#{Environment.password}' --databases #{Environment.database} --tables #{model} --where='#{conditional}' > #{$instance.tmp_path}/#{model}.sql`
  end

  def self.push_tmp_folder(sub_dir, folder=$instance.tmp_path)
    raise "Can't navigate below Environment.storage path of #{Environment.storage_path} with sub_dir" if sub_dir.include?("..")
    folder = folder.chop if folder.split("").last == "/"
    sub_dir = sub_dir.chop if sub_dir.split("").last == "/"
    parent_dir, direct_dir = FilePathing.resolve_path_zip_name(folder)
    `cd #{parent_dir};zip -r -9 #{direct_dir} #{direct_dir}`
    final_path = "#{Environment.storage_path}/#{sub_dir}/".gsub("//", "/")
    Sh::mkdir.make_directories(sub_dir)
    FilePathing.submit_file(folder+".zip", final_path)
    FilePathing.remove_folder(parent_dir)
  end
  
  def self.submit_file(folder, final_path)
    attempts = 0
    sent = false
    exception_message = ""
    attempt = ""
    case Environment.storage_type
    when "local"
      attempt = "mv #{folder} ../../#{final_path}"
      exception_message = "mkdir for #{attempt} failed after #{attempts+1} tries."
    when "remote"
      #This check actually fails since return of rsync message is ALWAYS empty string?
      attempt = "rsync -r #{folder} #{Environment.storage_ssh}:#{final_path}"
      exception_message = "rsync for #{attempt} failed after #{attempts+1} tries."
    end
    while !sent
      result = `#{attempt}`
      sent = (result.empty? || !result.scan(/mkdir: cannot create directory `.*': File exists/).first.empty?)
      attempts+=1
      raise Exception, exception_message if attempts == ERROR_THRESHOLD
    end
  end
  
  def self.remove_folder(folder)
    `rm -r #{folder}`
    `mkdir ../tmp_files`
  end
  
  def self.resolve_path_zip_name(folder)
    if folder.split("").last == "/"
      parent_dir = folder.scan(/^.*\//).first.chop
    else
      parent_dir = folder.chop.scan(/^.*\//).first.chop
    end
    direct_dir = folder.gsub(parent_dir, "").gsub("/", "")
    return parent_dir, direct_dir
  end
  
  def self.file_init(file_name, path=$instance.tmp_path)
    `rm -r #{ROOT+path+file_name}`
  end
  
  def self.line_count(file_name, path=$instance.tmp_path)
    f = File.open(path+file_name)
    count = f.lines.count
    f.close
    return count
  end
end