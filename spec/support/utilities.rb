def t(key, options={})
  I18n.t(key, options)
end

def t_navbar(name, options={})
  I18n.t("navbar.navbar.#{name}", options)
end

def t_submit(name, options={})
  I18n.t("helpers.submit.#{name}", options)
end

def t_link_to(name, options={})
  I18n.t("link_to.#{name}", options)
end

def t_flash(name, options={})
  I18n.t("flash.#{name}", options)
end

def t_model_attribute_name(model_class, name)
  model_class.human_attribute_name(name)
end

def main_to_expect
  expect(find('#main'))
end