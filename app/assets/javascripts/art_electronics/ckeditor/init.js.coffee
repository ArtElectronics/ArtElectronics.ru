$ ->
  CKEDITOR.basePath = "/javascripts/ckeditor/";
  CKEDITOR.plugins.basePath = "/javascripts/ckeditor/plugins/";

  CKEDITOR.replace 'post[raw_intro]'
  CKEDITOR.replace 'post[raw_content]'