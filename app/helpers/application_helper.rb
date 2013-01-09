module ApplicationHelper

  def js_void
    "javascript: xvoid();"
  end

  def form_type(obj)
    if(obj.new_record?)
      "new-form new-#{obj.class.name.downcase}"
    else
      "edit-form edit-#{obj.class.name.downcase}"
    end
  end

  def form_id(obj)
    if(obj.new_record?)
      "new-spouse"
    else
      "edit-spouse"
    end
  end

  def backbone_attr(name)
    "<%= #{name} %>"
  end
end
