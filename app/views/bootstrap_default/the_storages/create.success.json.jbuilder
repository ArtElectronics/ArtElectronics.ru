json.keep_alerts true

json.flash do |flash|
  flash.notice "Загружен файл: #{ @new_file.attachment_file_name }"
end

json.set! :html_content, {
  append: {
    '.attached_files_list' => sortable_tree(@new_file, render_module: AttachedFilesListHelper)
  }
}
